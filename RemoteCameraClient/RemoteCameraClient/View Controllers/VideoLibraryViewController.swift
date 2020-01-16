//
//  ViewController.swift
//  RemoteCameraClient
//
//  Created by Daniel Greenheck on 1/14/20.
//  Copyright © 2020 Daniel Greenheck. All rights reserved.
//

import UIKit
import AVKit

class VideoLibraryViewController: UIViewController {
    // MARK: - Private Members
    private var webClient = RemoteCameraWebClient()
    private var filenames = [String]()
    private let reuseIdentifier = "videoCell"
    
    // MARK: - Outlets
    @IBOutlet weak var videoCollectionView: UICollectionView!
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the collection view cell xib
        self.videoCollectionView.register(UINib(nibName: "VideoCollectionViewCell", bundle: nil),
                                          forCellWithReuseIdentifier: reuseIdentifier)
        
        videoCollectionView.delegate = self
        videoCollectionView.dataSource = self
        
        // Get the filesnames of the videos
        webClient.getVideoFilenames(checkCache: true) {
            (filenames,error) in
            // Error occurred, display error message
            guard error == nil, let filenames = filenames else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error",
                                                  message: "Failed to load videos.",
                                                  preferredStyle: .alert)
                    alert.addAction(.init(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
                return
            }
            self.filenames = filenames
            DispatchQueue.main.async {
                self.videoCollectionView.reloadData()
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.videoCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate

extension VideoLibraryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? VideoCollectionViewCell else { return }
        guard let filename = cell.filename else { return }
        
        // Retrieve the video and play it
        if let player = webClient.getVideo(filename: filename) {
            let av = AVPlayerViewController()
            av.player = player
            self.present(av, animated: true)
        }
        else {
            let alert = UIAlertController(title: "Error",
                                          message: "Error occurred while attempting to play video.",
                                          preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension VideoLibraryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return filenames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! VideoCollectionViewCell
        
        // Set the filename for the cell
        cell.filename = self.filenames[indexPath.row]
        // Clear the existing image from the reusable cell
        cell.imageView.image = nil
        
        // Load the image preview if a filename exists
        if let filename = cell.filename {
            cell.progressWheel.startAnimating()
            webClient.getVideoPreview(filename: filename) {
                (image,error) in
                DispatchQueue.main.async {
                    cell.progressWheel.stopAnimating()
                    // If error or image not found, show the "No Image" image
                    guard error == nil, let image = image else {
                        cell.imageView.image = UIImage(named: "no_video")
                        cell.imageView.tintColor = .gray
                        return
                    }
                    cell.imageView.image = image
                }
            }
        }
        
        return cell
    }
}

// MARK: - UICollectionViewFlowDelegate

extension VideoLibraryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 8.0)/3.0
        let height = (480.0*width)/640.0
        return CGSize(width: width, height: height)
    }
}
