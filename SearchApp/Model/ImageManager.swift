//
//  ImageManager.swift
//  SearchApp
//
//  Created by Анастасия on 05.12.2022.
//

import Foundation

protocol ImageManagerDelegate {
    func didUpdateImages(_ imageManager: ImageManager, images: [Image])
    func didFailWithError(_ error: Error)
}

struct ImageManager {
    
    let imagesUrl = "https://serpapi.com/search.json?tbm=isch&ijn=0&q="
    var delegate: ImageManagerDelegate?
    
    func fetchImages(query: String) {
        let urlString = imagesUrl + query
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
            guard let images = parseJSON(with: data) else { return }
            self.delegate?.didUpdateImages(self, images: images)
        }
        task.resume()
    }
    
    func parseJSON(with imageData: Data) -> [Image]? {
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
                
                let image = Image(thumbnail: thumbNail, fullSize: fullSize, sourceLink: sourceLink, position: position)
                images.append(image)
            }
            
            return images
            
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
}
