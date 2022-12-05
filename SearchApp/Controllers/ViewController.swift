//
//  ViewController.swift
//  SearchApp
//
//  Created by Анастасия on 05.12.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    
    var imageManager = ImageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        imageManager.delegate = self
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        if let query = searchTextField.text {
            searchTextField.resignFirstResponder()
            print(query)
            imageManager.fetchImages(query: query)
        }
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let query = searchTextField.text {
            searchTextField.resignFirstResponder()
            print(query)
            imageManager.fetchImages(query: query)
        }
        return true
    }
}

extension ViewController: ImageManagerDelegate {
    
    func didUpdateImages(_ imageManager: ImageManager, images: [Image]) {
        DispatchQueue.main.async {
            print(images[0].sourceLink)
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error.localizedDescription)
    }
}

