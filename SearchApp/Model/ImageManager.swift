//
//  ImageManager.swift
//  SearchApp
//
//  Created by Анастасия on 05.12.2022.
//

import UIKit

protocol ImageManagerDelegate {
    func didUpdateImages(_ imageManager: ImageManager, images: [Image])
    func didFailWithError(_ error: Error)
}

class ImageManager {
    
    let imagesUrl = "https://serpapi.com/search.json?tbm=isch&ijn=0&api_key=\(Keys.apiKey)&q="
    var delegate: ImageManagerDelegate?
    var images = [Image]()
    var imageCache = NSCache<NSString, UIImage>()
    
    func fetchImages(query: String) {
        let clearQuery = query.replacingOccurrences(of: " ", with: "%20")
        let urlString = imagesUrl + clearQuery
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                self.delegate?.didFailWithError(error!)
                return
            }
            
            guard let data = data else { return }
            self.parseJSON(with: data)
        }
        task.resume()
    }
    
    func parseJSON(with imageData: Data) {
        var images = [Image]()
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ImageData.self, from: imageData)
            let data = decodedData.images_results
            for i in 0..<data.count {
                
                let position = data[i].position
                let thumbNail = data[i].thumbnail
                let fullSize = data[i].original
                let sourceLink = data[i].link
                let title = data[i].title
                
                let image = Image(thumbnail: thumbNail, fullSize: fullSize, sourceLink: sourceLink, position: position, title: title)
                images.append(image)
            }
            DispatchQueue.main.async {
                self.images = images
                self.delegate?.didUpdateImages(self, images: images)
            }
            
        } catch {
            delegate?.didFailWithError(error)
            return
        }
    }
    
    func loadImage(url urlString: String, complition: @escaping (UIImage) -> Void) {
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            complition(cachedImage)
        } else {
            guard let imageUrl = URL(string: urlString) else { return }
            
            let request = URLRequest(url: imageUrl, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 15)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil, let data = data else { return }
                
                guard let image = UIImage(data: data) else { return }
                self.imageCache.setObject(image, forKey: urlString as NSString)
                complition(image)
            }
            task.resume()
        }
    }
}
