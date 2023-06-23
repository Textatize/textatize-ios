
//
//  FileDownloader.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/22/23.
//

import Foundation

class FileDownloader {
    static let shared = FileDownloader()
    
    private init() { }
    
    func loadFileAsync(url: URL, completion: @escaping (String?, Error?) -> Void) {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filename:String = url.lastPathComponent.replaceFirst(of: ".jpg", with: ".mp3")
        let destinationUrl = documentsUrl.appendingPathComponent(filename)
        loadFileAsync(url: url, destinationUrl: destinationUrl, completion: completion)
    }
    
    private func loadFileAsync(url: URL, destinationUrl: URL, completion: @escaping (String?, Error?) -> Void) {
        
        if FileManager().fileExists(atPath: destinationUrl.path) {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil)
        } else {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler:
                                            {
                data, response, error in
                if error == nil
                {
                    if let response = response as? HTTPURLResponse
                    {
                        if response.statusCode == 200
                        {
                            if let data = data
                            {
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                {
                                    completion(destinationUrl.path, error)
                                }
                                else
                                {
                                    completion(destinationUrl.path, error)
                                }
                            }
                            else
                            {
                                completion(destinationUrl.path, error)
                            }
                        }
                    }
                }
                else
                {
                    completion(destinationUrl.path, error)
                }
            })
            task.resume()
        }
    }
}

extension String {
    public func replaceFirst(of pattern:String,
                             with replacement:String) -> String {
      if let range = self.range(of: pattern){
        return self.replacingCharacters(in: range, with: replacement)
      }else{
        return self
      }
    }
}
