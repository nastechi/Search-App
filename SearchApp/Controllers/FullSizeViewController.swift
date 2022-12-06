//
//  FullSizeViewController.swift
//  SearchApp
//
//  Created by Анастасия on 06.12.2022.
//

import UIKit

class FullSizeViewController: UIViewController {
    
    private let imageManager = ImageManager()
    
    var imageModel = Image(thumbnail: "", fullSize: "", sourceLink: "", position: 0, title: "")
    var images = [Image]()
    var imageIndex = 0
    
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
    
    let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left.circle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.right.circle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageModel = images[imageIndex]
        
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
        view.addSubview(previousButton)
        view.addSubview(nextButton)
        
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
        
        previousButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 3).isActive = true
        previousButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        previousButton.widthAnchor.constraint(equalToConstant: view.frame.size.width / 10).isActive = true
        previousButton.heightAnchor.constraint(equalToConstant: view.frame.size.width / 10).isActive = true
        previousButton.addTarget(self, action: #selector(previousButtonPressed), for: .touchUpInside)
        
        nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -3).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        
        if imageIndex == 0 {
            previousButton.isHidden = true
        } else if imageIndex == images.count - 1 {
            nextButton.isHidden = true
        }
    }
    
    func updateUI() {
        
        if imageIndex == 0 {
            previousButton.isHidden = true
        } else if imageIndex == images.count - 1 {
            nextButton.isHidden = true
        } else {
            previousButton.isHidden = false
            nextButton.isHidden = false
        }
        
        titleLabel.text = imageModel.title
        imageView.image = UIImage(systemName: "hourglass")
        imageManager.loadImage(url: imageModel.fullSize) { [weak self] image in
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
            }
        }
    }
    
    @objc func sourceButtonPressed() {
        let webViewController = WebViewController(urlString: imageModel.sourceLink)
        show(webViewController, sender: self)
    }
    
    @objc func previousButtonPressed() {
        if imageIndex > 0 {
            imageIndex -= 1
            imageModel = images[imageIndex]
            updateUI()
        }
    }
    
    @objc func nextButtonPressed() {
        if imageIndex < images.count - 1 {
            imageIndex += 1
            imageModel = images[imageIndex]
            updateUI()
        }
    }
}
