//
//  TextatizeAPI.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/19/23.
//

import Alamofire
import SwiftUI

class TextatizeAPI {
    
    static var API_URL: String = "https://devapi.textatizeapp.com/"
    static let shared: TextatizeAPI = TextatizeAPI()
    
    var sessionToken: String? {
            get {
                return UserDefaults.standard.string(forKey: "sessionToken")
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "sessionToken")
            }
        }

    fileprivate func handleLogin(_ userResponse: UserResponse, _ api: TextatizeAPI, completionHandler: @escaping (ServerError?, UserResponse?) -> Void) {
        if let user = userResponse.user {
            //            if let user = userResponse.user {
            //                loggly(LogType.Debug, text: "Successful login: \(user.username)")
            //            }
            //userResponse.cache()
            if let sessionToken = userResponse.sessionToken {
                api.sessionToken = sessionToken
                TextatizeLoginManager.shared.loggedInUser = user
                completionHandler(nil, userResponse)
                
            } else {
                completionHandler(ServerError.defaultError, nil)
            }
            
        }
    }
    
    func register(first_name: String, last_name: String, username: String, email: String, phone: String, password: String, completion: @escaping (ServerError?, UserResponse?) -> Void) {
        
        var parameters: Parameters = [:]
        parameters["first_name"] = first_name.trimmingCharacters(in: .whitespacesAndNewlines)
        parameters["last_name"] = last_name.trimmingCharacters(in: .whitespacesAndNewlines)
        parameters["username"] = username.trimmingCharacters(in: .whitespacesAndNewlines)
        parameters["email"] = email.trimmingCharacters(in: .whitespacesAndNewlines)
        parameters["phone"] = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        parameters["password"] = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        AF.request(TextatizeAPI.API_URL + "auth/register", method: .post, parameters: parameters).validate().responseJSON { [weak self] response in
                      
            
            if let api = self {
                switch response.result {
                    
                case .success:
                    
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        let userResponse: UserResponse = UserResponse(JSONString: utf8Text)!
                                                
                        if let error = userResponse.error {
                            completion(ServerError(WithMessage: error), nil)
                            return
                        }
                        
                        TextatizeLoginManager.shared.storeUsername(username: username)
                        TextatizeLoginManager.shared.storePassword(password: password)
                        
                        completion(nil, userResponse)
                    }
                   
                case .failure(let error):
                    completion(ServerError(WithMessage: error.localizedDescription), nil)
                }
            }
        }
        
        
    }
    
    func login(username: String?, password: String?, completionHandler: @escaping (ServerError?, UserResponse?) -> Void) {
        
        var parameters: Parameters = [:]
        
        if let username = username {
            parameters["username"] = username.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if let password = password {
            parameters["password"] = password.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        AF.request(TextatizeAPI.API_URL + "auth/login", method: .get, parameters: parameters).validate().responseJSON { [weak self] response  in
            if let api = self {
                 
                switch response.result {
                    
                case .success:
                                                            
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        if let userResponse: UserResponse = UserResponse(JSONString: utf8Text) {
                            if let error = userResponse.error {
                                completionHandler(ServerError(WithMessage: error), nil)
                                return
                            }
                            
                            if let username = username {
                                TextatizeLoginManager.shared.storeUsername(username: username)
                            }
                            
                            if let password = password {
                                TextatizeLoginManager.shared.storePassword(password: password)
                            }
                            
                            api.handleLogin(userResponse, api, completionHandler: completionHandler)
                        }
                        
                    }
                    
                case .failure(let error):
                    print("Failed to login! Error is: \(error.localizedDescription). Detailed info: \((error as NSError).userInfo.description)")
                    completionHandler(ServerError(WithMessage: error.localizedDescription), nil)
                    
                }
                
                
            }
        }
        
    }
    
    func createEvent(name: String, orientation: Orientation, camera: Camera, watermarkPosition: WatermarkPosition, location: String, watermarkImage: UIImage?, watermarkTransparency: String, completion: @escaping (ServerError?, EventResponse?) -> Void) {
        
        guard let sessionToken = sessionToken else { return }
        
        AF.upload(multipartFormData: { multipartFormData in
            if let nameData = name.data(using: .utf8) {
                multipartFormData.append(nameData, withName: "name")
            }
            if let orientationData = orientation.rawValue.data(using: .utf8) {
                multipartFormData.append(orientationData, withName: "orientation")
            }
            if let cameraData = camera.rawValue.data(using: .utf8) {
                multipartFormData.append(cameraData, withName: "camera")
            }
            if let watermarkPositionData = watermarkPosition.rawValue.data(using: .utf8) {
                multipartFormData.append(watermarkPositionData, withName: "watermarkPosition")
            }
            if let locationData = location.data(using: .utf8) {
                multipartFormData.append(locationData, withName: "location")
            }
            
            if let watermarkImage = watermarkImage {
                if let imageData = watermarkImage.jpegData(compressionQuality: 0.5) {
                    multipartFormData.append(imageData, withName: "watermarkUrl", fileName: "watermarkUrl.jpg", mimeType: "image/jpeg")
                }
            }
            
            if let watermarkTransparencyData = watermarkTransparency.data(using: .utf8) {
                multipartFormData.append(watermarkTransparencyData, withName: "watermarkTransparency")
            }
        }, to: "\(TextatizeAPI.API_URL)/event",
                  method: .post,
                  headers: ["authorization": "Bearer \(sessionToken)"]).validate().responseJSON { response in
            
            print("Response: \(response)")
            
        }

    }
    
    func retrieveEvents(status: EventStatus?, page: String?, completionHandler: @escaping (ServerError?, EventsResponse?) -> Void) {
        if let sessionToken = sessionToken {
            
            var parameters: Parameters = [:]
            if let status = status {
                parameters["status"] = status.rawValue
            }
            
            if let page = page {
                parameters["page"] = page
            }
            
            print(sessionToken)
            
            AF.request(TextatizeAPI.API_URL + "event/my", method: .get, parameters: parameters, headers: ["authorization": "Bearer \(sessionToken)"]).validate().responseJSON { [weak self] response in
                if let api = self {
                    print("Retrieve Events Response: \(response)")
                    switch response.result {
                    case .success:
                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            let eventResponse = EventsResponse(JSONString: utf8Text)
                            completionHandler(nil, eventResponse)
                            
                        } else {
                            completionHandler(ServerError.defaultError, nil)
                        }
                        
                    case .failure(_):
                        completionHandler(ServerError.defaultError, nil)
                    }
                    
                }
            }
            
        }
    }
    
}
