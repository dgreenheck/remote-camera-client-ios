//
//  ViewController.swift
//  RemoteCameraClient
//
//  Created by Daniel Greenheck on 1/14/20.
//  Copyright © 2020 Daniel Greenheck. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Private Members
    private var webClient = RemoteCameraWebClient()
    private var filenames = [String]()
    
    // MARK: - Outlets
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        webClient.delegate = self
        webClient.getVideoFilenames()
    }
}

// MARK: - RemoteCameraWebClientDelegate
extension ViewController: RemoteCameraWebClientDelegate {
    func downloaded(filenames: [String]?) {
        guard let filenames = filenames else { return }
        self.filenames = filenames
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func downloaded(preview: UIImage?) {
        guard let image = preview else { return }
        DispatchQueue.main.async {
            self.imagePreview.image = image
        }
    }
    
    func error(err: RemoteCameraWebClientError) {
        print(err)
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        guard let filename = cell.textLabel?.text else { return }
        webClient.getVideoPreview(filename: filename) {
            (image) in
            DispatchQueue.main.async {
                self.imagePreview.image = image
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filenames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.filenames[indexPath.row]
        return cell
    }
}
