//
//  SearchCollectionViewCell.swift
//  SearchApp
//
//  Created by Анастасия on 05.12.2022.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
    
    static func nib() -> UINib {
        UINib(nibName: "SearchCollectionViewCell", bundle: nil)
    }

}
