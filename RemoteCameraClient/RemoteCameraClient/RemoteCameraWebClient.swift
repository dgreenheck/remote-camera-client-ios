//
//  RemoteCameraWebClient.swift
//  RemoteCameraClient
//
//  Created by Daniel Greenheck on 1/14/20.
//  Copyright © 2020 Daniel Greenheck. All rights reserved.
//

import Foundation
import UIKit

enum HTTPStatusCodes: Int {
    case success = 200
    case noContent = 204
    case partialContent = 206
    case notModified = 304
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case conflict = 409
    case internalServerError = 500
}

enum RemoteCameraWebClientError: Error {
    case miscellaneous(message: String)
    case noData
}

protocol RemoteCameraWebClientDelegate: class {
    func downloaded(filenames: [String]?)
    func downloaded(preview: UIImage?)
    func error(err: RemoteCameraWebClientError)
}

class RemoteCameraWebClient {
    let serverURL = "http://192.168.0.200"
    weak var delegate: RemoteCameraWebClientDelegate?
    
    func getVideo() {
    }
    
    func getVideoPreview(filename: String, completionHandler: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: serverURL + "/recordings?preview=\(filename).jpg") else { return }
        
        // Create a GET request object
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) {
            (data,response,error) in
            
            // Handle errors
            if let error = error {
                self.delegate?.error(err: .miscellaneous(message: error.localizedDescription))
            }
            else if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case HTTPStatusCodes.success.rawValue:
                    if let data = data {
                        completionHandler(UIImage(data: data))
                    }
                default:
                    self.delegate?.error(err: .noData)
                }
            }
        }
        task.resume()
    }
    
    // Returns a list of the videos stored on the server
    func getVideoFilenames() {
        guard let url = URL(string: serverURL + "/recordings") else { return }
        
        // Create a GET request object
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {
            (data,response,error) in
            
            // Handle errors
            if let error = error {
                self.delegate?.error(err: .miscellaneous(message: error.localizedDescription))
            }
            else if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case HTTPStatusCodes.success.rawValue:
                    if let data = data {
                        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String]
                        self.delegate?.downloaded(filenames: json)
                    }
                default:
                    self.delegate?.error(err: .noData)
                }
            }
        }
        task.resume()
    }
}
