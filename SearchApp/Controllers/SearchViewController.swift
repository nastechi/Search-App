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
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private let imageManager = ImageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView.isHidden = true
        collectionView.register(SearchCollectionViewCell.nib(), forCellWithReuseIdentifier: K.cellIdentifier)
        searchTextField.delegate = self
        imageManager.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        if let query = searchTextField.text {
            activityIndicatorView.startAnimating()
            collectionView.isHidden = true
            activityIndicatorView.isHidden = false
            searchTextField.resignFirstResponder()
            imageManager.fetchImages(query: query)
        }
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let query = searchTextField.text {
            activityIndicatorView.startAnimating()
            collectionView.isHidden = true
            activityIndicatorView.isHidden = false
            searchTextField.resignFirstResponder()
            imageManager.fetchImages(query: query)
        }
        return true
    }
}

extension SearchViewController: ImageManagerDelegate {
    
    func didUpdateImages(_ imageManager: ImageManager, images: [Image]) {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
        collectionView.reloadData()
        collectionView.isHidden = false
    }
    
    func didFailWithError(_ error: Error) {
        print(error.localizedDescription)
    }
}

extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.fullSizeSegue, sender: self)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.fullSizeSegue {
            guard let indexPath = collectionView.indexPathsForSelectedItems?[0] else { return }
            (segue.destination as! FullSizeViewController).images = imageManager.images
            (segue.destination as! FullSizeViewController).imageIndex = indexPath.row
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageManager.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.cellIdentifier, for: indexPath) as! SearchCollectionViewCell
            imageManager.loadImage(url: imageManager.images[indexPath.row].thumbnail) { image in
            cell.configure(with: image)
        }
        return cell
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
