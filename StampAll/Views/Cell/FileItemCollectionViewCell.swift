//
//  FileItemCollectionViewCell.swift
//  StampAll
//
//  Created by Дмитро  on 09.08.2022.
//

import Foundation
import UIKit

class FileItemCollectionViewCell: UICollectionViewCell {
    static let reuseID = "FileItemCollectionViewCell"
    
    
    @IBOutlet private weak var fileThumbnailImageView: UIImageView!
    @IBOutlet private weak var fileNameLabel: UILabel!
    
    
    func configure(fileName: String) {
        fileNameLabel.text = fileName
        
    }
}
