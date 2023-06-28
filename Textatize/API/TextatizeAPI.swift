//
//  TextatizeAPI.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/19/23.
//

import Alamofire
import SwiftUI
import Network

class TextatizeAPI: NSObject, NetworkSpeedProviderDelegate {
    
    static let shared: TextatizeAPI = TextatizeAPI()
    private var API_URL: String = "https://devapi.textatizeapp.com/"
    
    let monitor = NWPathMonitor()
    
    var sessionToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "sessionToken")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "sessionToken")
        }
    }
    
    var hasInternet = false
    let test = NetworkSpeedTest()
    var speedTestTimer:Timer? = nil
    var speed:NetworkStatus = .good
    
    private override init() {
        super.init()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("@@MONITOR Connected")
                self.hasInternet = true
            } else {
                print("@@MONITOR Disconnected")
                self.hasInternet = false
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 300
        let targetName = Bundle.main.infoDictionary?["CFBundleName"] as! String
        if targetName == "Textatize" {
            API_URL = "https://devapi.textatizeapp.com/"
        }
        test.delegate = self
        //AppUtility.getOfflineOption() // set initial option to on
        
        // self.test.networkSpeedTestStop()
        // self.test.networkSpeedTestStart(UrlForTestSpeed: "https://prodapi.revospin.com/revospin-server-1.0/api/unauth/ping")
        
        
        /*
         self.speedTestTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { timer in
         print("@@TIMER")
         self.test.networkSpeedTestStop()
         self.test.networkSpeedTestStart(UrlForTestSpeed: "https://yahoo.com")
         }*/
        
    }
    
    func callWhileSpeedChange(networkStatus: NetworkStatus) {
        self.speed = networkStatus
        switch networkStatus {
        case .poor:
            print("NetworkStatus: Poor")
        case .good:
            print("NetworkStatus: Good")
        case .disConnected:
            print("NetworkStatus: Disconnected")
        }
    }
    
    fileprivate func handleLogin(_ userResponse: UserResponse, _ api: TextatizeAPI, completion: @escaping (ServerError?, UserResponse?) -> Void) {
        if let user = userResponse.user {
            //            if let user = userResponse.user {
            //                loggly(LogType.Debug, text: "Successful login: \(user.username)")
            //            }
            //userResponse.cache()
            if let sessionToken = userResponse.sessionToken {
                api.sessionToken = sessionToken
                TextatizeLoginManager.shared.loggedInUser = user
                completion(nil, userResponse)
                
            } else {
                completion(ServerError.defaultError, nil)
            }
            
        }
    }
    
    func register(first_name: String, last_name: String, username: String, email: String, phone: String, password: String, completion: @escaping (ServerError?, UserResponse?) -> Void) {
        
        guard hasInternet else { return completion(ServerError.noInternet, nil) }
        
        var parameters: Parameters = [:]
        parameters["first_name"] = first_name.trimmingCharacters(in: .whitespacesAndNewlines)
        parameters["last_name"] = last_name.trimmingCharacters(in: .whitespacesAndNewlines)
        parameters["username"] = username.trimmingCharacters(in: .whitespacesAndNewlines)
        parameters["email"] = email.trimmingCharacters(in: .whitespacesAndNewlines)
        parameters["phone"] = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        parameters["password"] = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        AF.request(API_URL + "auth/register",
                   method: .post,
                   parameters: parameters)
        .validate().responseJSON { [weak self] response in
            
            
            if let api = self {
                switch response.result {
                    
                case .success:
                    
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        let userResponse: UserResponse = UserResponse(JSONString: utf8Text)!
                        
                        if let error = userResponse.error {
                            completion(ServerError(WithMessage: error), nil)
                            return
                        }
                        
                        TextatizeLoginManager.shared.is_logged_in = true
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
    
    func login(username: String?, password: String?, completion: @escaping (ServerError?, UserResponse?) -> Void) {
        
        guard hasInternet else { return completion(ServerError.noInternet, nil) }
        
        
        var parameters: Parameters = [:]
        
        if let username = username {
            parameters["username"] = username.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if let password = password {
            parameters["password"] = password.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        AF.request(API_URL + "auth/login",
                   method: .get,
                   parameters: parameters)
        .validate().responseJSON { [weak self] response  in
            print("User Response: \(response)")
            if let api = self {
                
                switch response.result {
                    
                case .success:
                    
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        if let userResponse: UserResponse = UserResponse(JSONString: utf8Text) {
                            if let error = userResponse.error {
                                completion(ServerError(WithMessage: error), nil)
                                return
                            }
                            
                            if let username = username {
                                TextatizeLoginManager.shared.storeUsername(username: username)
                            }
                            
                            if let password = password {
                                TextatizeLoginManager.shared.storePassword(password: password)
                            }
                            
                            TextatizeLoginManager.shared.is_logged_in = true
                            if let user = userResponse.user {
                                TextatizeLoginManager.shared.loggedInUser = user
                            }
                            api.handleLogin(userResponse, api, completion: completion)
                        }
                        
                    }
                    
                case .failure(let error):
                    print("Failed to login! Error is: \(error.localizedDescription). Detailed info: \((error as NSError).userInfo.description)")
                    completion(ServerError(WithMessage: error.localizedDescription), nil)
                    
                }
            }
        }
        
    }
    
    func updateEvent(eventID: String, name: String, date: String?, orientation: Orientation, camera: Camera, watermarkPosition: WatermarkPosition, location: String, watermarkImage: UIImage?, watermarkTransparency: String, frame: Frame?, useFrame: String, completion: @escaping (ServerError?, EventResponse?) -> Void) {
        guard hasInternet else { return completion(ServerError.noInternet, nil) }
        
        guard let sessionToken = sessionToken else { return }
        
        AF.upload(multipartFormData: { multipartFormData in
            
            if let eventIDData = eventID.data(using: .utf8) {
                multipartFormData.append(eventIDData, withName: "eventId")
            }
            if let nameData = name.data(using: .utf8) {
                multipartFormData.append(nameData, withName: "name")
            }
            if let date = date {
                if let dateData = date.data(using: .utf8) {
                    multipartFormData.append(dateData, withName: "date")
                }
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
            
            if let frame = frame {
                if let frameID = frame.unique_id {
                    if let frameData = frameID.data(using: .utf8) {
                        multipartFormData.append(frameData, withName: "frameId")
                    }
                }
            }
            if let useFrameData = useFrame.data(using: .utf8) {
                multipartFormData.append(useFrameData, withName: "useFrame")
            }
        }, to: "\(API_URL)/event",
                  method: .put,
                  headers: ["authorization": "Bearer \(sessionToken)"]
        ).validate().responseJSON { response in
            //print("Update Event: \(response)")
            switch response.result {
            case .success(let success):
                if let data = response.data, let utf8String = String(data: data, encoding: .utf8) {
                    if let eventResponse = EventResponse(JSONString: utf8String) {
                        eventResponse.cache()
                        completion(nil, eventResponse)
                    }
                }
            case .failure(let error):
                completion(ServerError(WithMessage: error.localizedDescription), nil)

            }
            
        }
    }

    func createEvent(name: String, date: String?, orientation: Orientation, camera: Camera, watermarkPosition: WatermarkPosition, location: String, watermarkImage: UIImage?, watermarkTransparency: String, frame: Frame?, useFrame: String, completion: @escaping (ServerError?, EventResponse?) -> Void) {
        
        guard hasInternet else { return completion(ServerError.noInternet, nil) }
        
        guard let sessionToken = sessionToken else { return }
        
        AF.upload(multipartFormData: { multipartFormData in
            if let nameData = name.data(using: .utf8) {
                multipartFormData.append(nameData, withName: "name")
            }
            if let date = date {
                if let dateData = date.data(using: .utf8) {
                    multipartFormData.append(dateData, withName: "date")
                }
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
            
            if let frame = frame {
                if let frameID = frame.unique_id {
                    if let frameData = frameID.data(using: .utf8) {
                        multipartFormData.append(frameData, withName: "frameId")
                    }
                }
            }
            if let useFrameData = useFrame.data(using: .utf8) {
                multipartFormData.append(useFrameData, withName: "useFrame")
            }
            
            
        }, to: "\(API_URL)/event",
                  method: .post,
                  headers: ["authorization": "Bearer \(sessionToken)"]).validate().responseJSON { response in
            //print("Response: \(response)")
            
            switch response.result {
            case .success:
                if let data = response.data, let utf8String = String(data: data, encoding: .utf8) {
                    if let eventResponse = EventResponse(JSONString: utf8String) {
                        eventResponse.cache()
                        completion(nil, eventResponse)
                    }
                }
            case .failure(let error):
                completion(ServerError(WithMessage: error.localizedDescription), nil)

            }
            
        }
        
    }
    
    func deleteEvent(eventID: String, completion: @escaping (ServerError?, Bool) -> Void) {
        guard hasInternet else { return completion(ServerError.noInternet, false) }
        
        guard let sessionToken = sessionToken else { return }
        
        
        
        AF.request(API_URL + "event/\(eventID)",
                   method: .delete,
                   headers: ["authorization": "Bearer \(sessionToken)"]
        ).validate().responseJSON { response in
            //print("Delete Event Response: \(response)")
            
            switch response.result {
            case .success:
                if let data = response.data, let utf8String = String(data: data, encoding: .utf8) {
                    if let eventResponse = EventResponse(JSONString: utf8String) {
                        completion(nil, true)
                    }
                }
                
        case .failure(let error):
                completion(ServerError(WithMessage: error.localizedDescription), false)

            }
        }
    }
    
    func completeEvent(eventID: String, completion: @escaping (ServerError?, Bool) -> Void) {
        guard hasInternet else { return completion(ServerError.noInternet, false) }
        
        guard let sessionToken = sessionToken else { return }
        
        AF.request(API_URL + "event/\(eventID)/complete",
                   method: .put,
                   headers: ["authorization": "Bearer \(sessionToken)"]
        ).validate().responseJSON { response in
            //print("Complete Event Response: \(response)")
            
            switch response.result {
            case .success:
                if let data = response.data, let utf8String = String(data: data, encoding: .utf8) {
                    if let eventResponse = EventResponse(JSONString: utf8String) {
                        eventResponse.cache()
                        completion(nil, true)
                    }
                }
                
        case .failure(let error):
                completion(ServerError(WithMessage: error.localizedDescription), false)

            }
        }
    }
    
    func addMedia(eventID: String, imageData: Data?, completion: @escaping (ServerError?, MediaResponse?) -> Void) {
        print("=================== ADD MEDIA")
        guard hasInternet else { return completion(ServerError.noInternet, nil) }
        
        guard let sessionToken = sessionToken else { return }
        
        guard let imageData = imageData, let image = UIImage(data: imageData) else { return }
        
        AF.upload(multipartFormData: { multipartFormData in
            if let compressedImage = image.jpegData(compressionQuality: 0.5) {
                multipartFormData.append(compressedImage, withName: "imageTaken", fileName: "imageTaken.jpg", mimeType: "image/jpeg")
            }
            
        }, to: "\(API_URL)/media/\(eventID)",
                  method: .post,
                  headers: ["authorization": "Bearer \(sessionToken)"]).validate().responseJSON { response in
            
            //print("Add Media Response: \(response)")
            
            
            switch response.result {
            case .success:
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    let mediaResponse = MediaResponse(JSONString: utf8Text)
                    UserDefaults.standard.setValue(mediaResponse?.media?.unique_id, forKey: "mediaID")
                    completion(nil, mediaResponse)
                }
            case .failure(let error):
                completion(ServerError(WithMessage: error.localizedDescription), nil)
                
            }
            
            
        }
    }
    
    func shareMedia(phoneNumber: String?, mediaID: String, completion: @escaping (ServerError?, Bool?) -> Void) {
        print("=================== SHARE MEDIA")
        guard hasInternet else { return completion(ServerError.noInternet, nil) }
        
        guard let sessionToken = sessionToken else { return }
        
        var parameters: Parameters = [:]
        if let phoneNumber = phoneNumber {
            parameters["phone"] = phoneNumber
        }
        
        AF.request(API_URL + "media/share/\(mediaID)",
                   method: .get,
                   parameters: parameters,
                   headers: ["authorization": "Bearer \(sessionToken)"])
        .validate().responseJSON { response in
            print("Share Media Response: \(response)")
            switch response.result {
            case .success:
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    if let mediaResponse = MediaResponse(JSONString: utf8Text) {
                        if let mediaError = mediaResponse.error {
                            completion(ServerError(WithMessage: mediaError), nil)
                        } else {
                            completion(nil, true)
                        }
                    } else {
                        completion(ServerError(WithMessage: "No Media Response"), nil)
                    }
                } else {
                    completion(ServerError(WithMessage: "No Data Found"), nil)
                }
            case .failure(let error):
                completion(ServerError(WithMessage: error.localizedDescription), nil)
                
            }
        }
    }
    
    func retrieveMedia(page: String?, eventID: String, completion: @escaping (ServerError?, MediasResponse?) -> Void) {
        guard hasInternet else { return completion(ServerError.noInternet, nil) }
        
        guard let sessionToken = sessionToken else { return }
         
        var parameters: Parameters = [:]
        
        if let page = page {
            parameters["page"] = page
        }
        
        AF.request(API_URL + "media/\(eventID)",
                   method: .get,
                   parameters: parameters,
                   headers: ["authorization": "Bearer \(sessionToken)"])
        .validate().responseJSON { response in
            //print("Retrieve Media Response \(eventID): \(response)")
            
            switch response.result {
            case .success:
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    let mediasResponse = MediasResponse(JSONString: utf8Text)
                    completion(nil, mediasResponse)
                }
            case .failure(let error):
                completion(ServerError(WithMessage: error.localizedDescription), nil)
                
            }
            
        }
    }
    
    func retrieveEvents(status: EventStatus?, page: String?, completion: @escaping (ServerError?, EventsResponse?) -> Void) {
        
        guard hasInternet else { return completion(ServerError.noInternet, nil) }
        
        if let sessionToken = sessionToken {
            
            //print(sessionToken)
            
            var parameters: Parameters = [:]
            if let status = status {
                parameters["status"] = status.rawValue
            }
            
            if let page = page {
                parameters["page"] = page
            }
            
            AF.request(API_URL + "event/my",
                       method: .get,
                       parameters: parameters,
                       headers: ["authorization": "Bearer \(sessionToken)"])
            .validate().responseJSON { [weak self] response in
                if let api = self {
                    //print("Retrieve Events Response: \(response)")
                    switch response.result {
                    case .success:
                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            if let eventResponse = EventsResponse(JSONString: utf8Text) {
                                eventResponse.cache()
                                completion(nil, eventResponse)
                            }
                            
                        } else {
                            completion(ServerError.defaultError, nil)
                        }
                        
                    case .failure(let error):
                        completion(ServerError(WithMessage: error.localizedDescription), nil)
                    }
                    
                }
            }
            
        }
    }
    
    func retrieveUser(completion: @escaping (ServerError?, UserResponse?) -> Void) {
        
        guard hasInternet else { return completion(ServerError.noInternet, nil) }
        
        guard let sessionToken = sessionToken else { return }
        
        AF.request(API_URL + "user/me",
                   method: .get,
                   headers: ["authorization": "Bearer \(sessionToken)"])
        .validate().responseJSON { [weak self] response in
            guard let self = `self` else { return }
            print("Retrieve User Response: \(response)")
            
            switch response.result {
            case .success:
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    let userResponse = UserResponse(JSONString: utf8Text)
                    completion(nil, userResponse)
                } else {
                    completion(ServerError(WithMessage: "Cannot Convert Response into User Response"), nil)
                }
            case .failure(let error):
                completion(ServerError(WithMessage: error.localizedDescription), nil)
            }
        }
    }
    
    func verifyUser(code: String, completion: @escaping (ServerError?, UserResponse?) -> Void) {
        
        guard hasInternet else { return completion(ServerError.noInternet, nil) }
        
        
        guard let sessionToken = sessionToken else { return }
        
        var parameters: Parameters = [:]
        parameters["code"] = code
        
        AF.request(API_URL + "user/verify",
                   method: .get,
                   parameters: parameters,
                   headers: ["authorization": "Bearer \(sessionToken)"])
        .validate().responseJSON { [weak self] response in
            guard let self = `self` else { return }
            print("Verify User Response: \(response)")
            
            switch response.result {
            case .success:
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    let userResponse = UserResponse(JSONString: utf8Text)
                    completion(nil, userResponse)
                }
            case .failure(let error):
                completion(ServerError(WithMessage: error.localizedDescription), nil)
            }
            
        }
    }
    
    func resendVerificationCode(completion: @escaping (ServerError?, UserResponse?) -> Void) {
        
        guard hasInternet else { return completion(ServerError.noInternet, nil) }

        guard let sessionToken = sessionToken else { return }
        
        AF.request(API_URL + "user/resendVerify",
                   method: .get,
                   headers: ["authorization": "Bearer \(sessionToken)"])
        .validate().responseJSON { [weak self] response in
            guard let self = `self` else { return }
            print("Reverify User Response: \(response)")
            
            switch response.result {
            case .success:
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    let userResponse = UserResponse(JSONString: utf8Text)
                    completion(nil, userResponse)
                }
            case .failure(let error):
                completion(ServerError(WithMessage: error.localizedDescription), nil)
            }
            
        }
    }
    
    func retrieveFrames(orientation: Orientation?, completion: @escaping (ServerError?, FramesResponse?) -> Void) {
        guard hasInternet else { return completion(ServerError.noInternet, nil) }
        
        guard let sessionToken = sessionToken else { return }
        
        var parameters: Parameters = [:]
        if let orientation = orientation {
            parameters["orientation"] = orientation.rawValue
        }
        
        AF.request(API_URL + "frame/templates",
                   method: .get,
                   parameters: parameters,
                   headers: ["authorization": "Bearer \(sessionToken)"])
        .validate().responseJSON { [weak self] response in
            guard let self = `self` else { return }
            //print("Retrieve Frames Response: \(response)")
            
            switch response.result {
            case .success(let success):
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    let framesResponse = FramesResponse(JSONString: utf8Text)
                    completion(nil, framesResponse)
                }
            case .failure(let error):
                completion(ServerError(WithMessage: error.localizedDescription), nil)

            }
            
        }
    }
    
    func retrieveMyFrames(orientation: Orientation?, page: String?, completion: @escaping (ServerError?, FramesResponse?) -> Void) {
        guard hasInternet else { return completion(ServerError.noInternet, nil) }
        
        guard let sessionToken = sessionToken else { return }
        
        var parameters: Parameters = [:]
        if let orientation = orientation {
            parameters["orientation"] = orientation.rawValue
        }
        if let page = page {
            parameters["page"] = page
        }
        
        AF.request(API_URL + "frame/my",
                   method: .get,
                   parameters: parameters,
                   headers: ["authorization": "Bearer \(sessionToken)"])
        .validate().responseJSON { [weak self] response in
            guard let self = `self` else { return }
            //print("Retrieve My Frames Response: \(response)")
            
            switch response.result {
            case .success(let success):
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    let framesResponse = FramesResponse(JSONString: utf8Text)
                    completion(nil, framesResponse)
                }
            case .failure(let error):
                completion(ServerError(WithMessage: error.localizedDescription), nil)

            }
            
        }
    }
    
    func purchase(appleReceipt: String, points: String, completion: @escaping (ServerError?, UserResponse?) -> Void) {
        guard hasInternet else { return completion(ServerError.noInternet, nil) }
        
        guard let sessionToken = sessionToken else { return }
        
        var parameters: Parameters = [:]
        
        parameters["appleReceipt"] = appleReceipt
        parameters["points"] = points
        
        AF.request(
            API_URL + "purchase",
            method: .post,
            parameters: parameters,
            headers: ["authorization": "Bearer \(sessionToken)"]
        ).validate().responseJSON { [weak self] response in
            print("Purchase Response: \(response)")
            
            switch response.result {
            case .success:
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    let userResponse = UserResponse(JSONString: utf8Text)
                    completion(nil, userResponse)
                }
            case .failure(let error):
                completion(ServerError(WithMessage: error.localizedDescription), nil)
            }
        }
        
    }
    
    func changePassword(oldPassword: String, newPassword: String, completion: @escaping (ServerError?, UserResponse?) -> Void) {
        guard hasInternet else { return completion(ServerError.noInternet, nil) }
        
        guard let sessionToken = sessionToken else { return }
        
        var parameters: Parameters = [:]
        
        parameters["oldpassword"] = oldPassword
        parameters["newpassword"] = newPassword
        
        AF.request(
            API_URL + "user/changePassword",
            method: .post,
            parameters: parameters,
            headers: ["authorization": "Bearer \(sessionToken)"]
        ).validate().responseJSON { [weak self] response in
            print("Change Password Response: \(response)")
            
            switch response.result {
            case .success:
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    if let userResponse = UserResponse(JSONString: utf8Text) {
                        if let error = userResponse.error {
                            completion(ServerError(WithMessage: error), nil)
                        } else {
                            TextatizeLoginManager.shared.loggedInUser = userResponse.user
                            completion(nil, userResponse)
                        }
                    }
                }
            case .failure(let error):
                completion(ServerError(WithMessage: error.localizedDescription), nil)
            }
            
        }
    }
}
