//
//  FileBrowserViewController.swift
//  StampAll
//
//  Created by Дмитро  on 09.08.2022.
//

import UIKit

class FileBrowserViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true 
    }
}

extension FileBrowserViewController: UICollectionViewDelegate {
}

extension FileBrowserViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileItemCollectionViewCell.reuseID, for: indexPath) as! FileItemCollectionViewCell
        cell.configure(fileName: "hello")
        return cell
    }
}
