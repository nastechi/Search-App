//
//  ImageData.swift
//  SearchApp
//
//  Created by Анастасия on 05.12.2022.
//

import Foundation

struct ImageData: Decodable {
    let images_results: [ImagesResults]
}

struct ImagesResults: Decodable {
    let position: Int
    let thumbnail: String
    let original: String
    let link: String
    let title: String
}
