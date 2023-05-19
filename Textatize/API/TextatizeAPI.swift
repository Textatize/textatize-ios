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
                        let userResponse: UserResponse = UserResponse(JSONString: utf8Text)!
                        
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
                    
                case .failure(let error):
                    print("Failed to login! Error is: \(error.localizedDescription). Detailed info: \((error as NSError).userInfo.description)")
                    completionHandler(ServerError(WithMessage: error.localizedDescription), nil)
                    
                }
                
                
            }
        }
        
    }
    
    func getEvent(completionHandler: @escaping (ServerError?, EventResponse?) -> Void) {
        if let sessionToken = sessionToken {
            
            let parameters: Parameters = [:]
            
            AF.request(TextatizeAPI.API_URL + "event/my", method: .get, parameters: parameters, headers: ["authorization": "Bearer \(sessionToken)"]).validate().responseJSON { [weak self] response in
                if let api = self {
                    
                    switch response.result {
                    case .success:
                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            let eventResponse = EventResponse(JSONString: utf8Text)
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
