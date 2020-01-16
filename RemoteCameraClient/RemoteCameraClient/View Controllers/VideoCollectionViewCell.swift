//
//  VideoCollectionViewCell.swift
//  RemoteCameraClient
//
//  Created by Daniel Greenheck on 1/15/20.
//  Copyright © 2020 Daniel Greenheck. All rights reserved.
//

import UIKit

@IBDesignable class VideoCollectionViewCell: UICollectionViewCell {
    var filename: String?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressWheel: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
