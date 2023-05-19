//
//  ServerError.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 5/19/23.
//

import UIKit

class ServerError: NSObject {

    static let defaultError: ServerError = ServerError(WithMessage: "Sorry, an error occurred. Please, try again.")
    static let noInternet: ServerError = ServerError(WithMessage: "Please check your network and try again.")
    
    fileprivate var message: String?
    
    // MARK: Public functions
    
    init(WithMessage message: String) {
        self.message = message
    }
    
    func getMessage() -> String? {
        return message
    }

}
