//
//  CacheManager.swift
//  Textatize
//
//  Created by Tornelius Broadwater, Jr on 6/22/23.
//

import UIKit

class CacheManager: NSObject {
    static let shared = CacheManager()
    let cache:NSMutableDictionary = NSMutableDictionary()
    
    
    func removeObjectForKey(aKey: AnyObject) {
        self.cache.removeObject(forKey: aKey)
    }
    
    func setObject(anObject: AnyObject, forKey aKey: String) {
        self.cache[aKey] = anObject
    }
    
    func objectForKey(aKey: String) -> AnyObject {
        let item = (self.cache[aKey])
        return item! as AnyObject
    }
    
    func containsKey(aKey: String) -> Bool {
        return self.cache[aKey] != nil;
    }
}
