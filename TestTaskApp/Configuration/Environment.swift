//
//  Environment.swift
//  TestTaskApp
//
//  Created by Djordje Ljubinkovic on 8/31/19.
//  Copyright © 2019 Djordje Ljubinkovic. All rights reserved.
//

import Foundation

enum PlistKey {
    case serverUrlDomainName
    case apiKey
    case sharedSecret
    
    var value: String {
        switch self {
        case .serverUrlDomainName:
            return "LAST_FM_BASE_URL_HOST"
        case .apiKey:
            return "LAST_FM_API_KEY"
        case .sharedSecret:
            return "LAST_FM_SHARED_SECRET"
        }
    }
}

struct Environment {
    fileprivate var infoDict: [String: Any] {
        if let dict = Bundle.main.infoDictionary {
            return dict
        } else {
            fatalError("Plist file not found")
        }
    }
    
    func infoDictValueFor(key: String) -> String {
        if let infoDict = infoDict[key] as? String {
            return infoDict
        }
        return ""
    }
    
    func configuration(_ key: PlistKey) -> String {
        return infoDictValueFor(key: key.value)
    }
}
