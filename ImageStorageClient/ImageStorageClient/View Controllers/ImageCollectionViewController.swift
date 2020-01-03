//
//  ImageCollectionController.swift
//  ImageStorageClient
//
//  Created by Daniel Greenheck on 1/2/20.
//  Copyright © 2020 Daniel Greenheck. All rights reserved.
//

import UIKit

private let reuseIdentifier = "imageCell"

class ImageCollectionViewController: UICollectionViewController {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        // Configure the cell
        if let cell = cell as? ImageCollectionViewCell {

        }
    
        return cell
    }
}

// MARK: UICollectionViewFlowLayoutDelegate

extension ImageCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // The collection view should be four images wide
        var imageSize: Int
        if UIDevice.current.orientation == .portrait {
            imageSize = Int(floor((self.view.frame.width - 32) / 3.0))
        }
        else {
            imageSize = Int(floor((self.view.frame.width - 48) / 5.0))
        }
        
        return CGSize(width: imageSize, height: imageSize)
    }
}
