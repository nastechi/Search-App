//
//  ViewController.swift
//  SearchApp
//
//  Created by Анастасия on 05.12.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        if let query = searchTextField.text {
            searchTextField.resignFirstResponder()
            print(query)
        }
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print(searchTextField.text ?? "no value")
        return true
    }
}

