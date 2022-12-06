//
//  FullSizeViewController.swift
//  SearchApp
//
//  Created by Анастасия on 06.12.2022.
//

import UIKit
import SafariServices

class FullSizeViewController: UIViewController {
    
    private let imageManager = ImageManager()
    
    var imageModel = Image(thumbnail: "", fullSize: "", sourceLink: "", position: 0, title: "")
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "hourglass")
        imageView.tintColor = .white
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 21)
        return label
    }()
    
    let sourceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Visit site", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        
        imageManager.loadImage(url: imageModel.fullSize) { [weak self] image in
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
            }
        }
    }
    
    func setLayout() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(sourceButton)
        
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: view.frame.size.height / 3).isActive = true
        
        
        titleLabel.text = imageModel.title
        titleLabel.numberOfLines = 0
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
        
        sourceButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        sourceButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        sourceButton.addTarget(self, action: #selector(sourceButtonPressed), for: .touchUpInside)
        
    }
    
    @objc func sourceButtonPressed() {
        guard let url = URL(string: imageModel.sourceLink) else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
}
