//
//  SearchViewController.swift
//  SearchApp
//
//  Created by Анастасия on 05.12.2022.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageManager = ImageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(SearchCollectionViewCell.nib(), forCellWithReuseIdentifier: K.cellIdentifier)
        searchTextField.delegate = self
        imageManager.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        if let query = searchTextField.text {
            searchTextField.resignFirstResponder()
            imageManager.fetchImages(query: query)
        }
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let query = searchTextField.text {
            searchTextField.resignFirstResponder()
            imageManager.fetchImages(query: query)
        }
        return true
    }
}

extension SearchViewController: ImageManagerDelegate {
    
    func didUpdateImages(_ imageManager: ImageManager, images: [Image]) {
        collectionView.reloadData()
    }
    
    func didFailWithError(_ error: Error) {
        print(error.localizedDescription)
    }
}

extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let index = indexPath.row
        let selectedImage = imageManager.images[index]
        print("selected \(selectedImage.thumbnail)")
    }
}

extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageManager.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.cellIdentifier, for: indexPath) as! SearchCollectionViewCell
        loadImage(url: imageManager.images[indexPath.row].thumbnail) { image in
            cell.configure(with: image)
        }
        return cell
    }
    
    func loadImage(url urlString: String, complition: @escaping (UIImage) -> Void) {
        guard let imageUrl = URL(string: urlString) else {
            return
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: imageUrl) { data, response, error in
            guard error == nil, let data = data else { return }
            if let image = UIImage(data: data) {
                complition(image)
            }
        }
        task.resume()
    }
    
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 3 - 1, height: collectionView.frame.width / 3 - 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        1.0
    }
}
