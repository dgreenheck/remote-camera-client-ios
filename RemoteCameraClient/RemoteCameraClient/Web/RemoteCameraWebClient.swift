//
//  RemoteCameraWebClient.swift
//  RemoteCameraClient
//
//  Created by Daniel Greenheck on 1/14/20.
//  Copyright © 2020 Daniel Greenheck. All rights reserved.
//

import Foundation
import UIKit
import AVKit

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
    case invalidURL
}

class RemoteCameraWebClient {
    var serverURL = "http://192.168.0.200"
    var filenameCache: Set<String>
    var imageCache: Dictionary<String,UIImage?>
    
    init() {
        filenameCache = []
        imageCache = [:]
    }
    
    func getVideo(filename: String) -> AVPlayer? {
        guard let url = URL(string: serverURL + "/recordings?video=\(filename).mp4") else { return nil }
        return AVPlayer(url: url)
    }
    
    func getVideoPreview(filename: String, completionHandler: @escaping (UIImage?, RemoteCameraWebClientError?) -> Void) {
        guard let url = URL(string: serverURL + "/recordings?preview=\(filename).jpg") else {
            completionHandler(nil,.invalidURL)
            return
        }
        
        // Check if item already exists in the cache
        if let image = imageCache[filename] {
            completionHandler(image,nil)
            return
        }
        
        // Create a GET request object
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) {
            (data,response,requestError) in
            
            var image: UIImage?
            var error: RemoteCameraWebClientError?
            
            // Handle errors
            if let requestError = requestError {
                error = .miscellaneous(message: requestError.localizedDescription)
            }
            else if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case HTTPStatusCodes.success.rawValue:
                    if let data = data {
                        image = UIImage(data: data)
                        // Add the image to the cache
                        self.imageCache[filename] = image
                    }
                default:
                    error = .noData
                }
            }
            
            completionHandler(image,error)
        }
        task.resume()
    }
    
    // Returns a list of the videos stored on the server
    func getVideoFilenames(checkCache: Bool, completionHandler: @escaping ([String]?, RemoteCameraWebClientError?) -> Void) {
        guard let url = URL(string: serverURL + "/recordings") else {
            completionHandler(nil,.invalidURL)
            return
        }
        
        // Check to see if filenames already exist in cache
        if checkCache && filenameCache.count > 0 {
            completionHandler(Array(filenameCache),nil)
            return
        }
        
        // Create a GET request object
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {
            (data,response,requestError) in
            
            // Handle errors
            var filenames: [String]?
            var error: RemoteCameraWebClientError?
            
            if let requestError = requestError {
                error = .miscellaneous(message: requestError.localizedDescription)
            }
            else if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case HTTPStatusCodes.success.rawValue:
                    if let data = data {
                        filenames = try? JSONSerialization.jsonObject(with: data, options: []) as? [String]
                        // Update the filename cache
                        if let filenames = filenames {
                            self.filenameCache = Set(filenames)
                        }
                    }
                default:
                    error = .noData
                }
            }
            
            completionHandler(filenames,error)
        }
        task.resume()
    }
}
