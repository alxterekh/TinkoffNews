//
//  ServiceAssembly.swift
//  TinkoffNews
//
//  Created by Alexander on 18/06/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import UIKit

class ServiceAssembly {
    
    static let coreDataStack = CoreDataStack()
    
    static var newsLoaderService = { () -> NewsLoader in
        let requestSender = RequestSender()
        
        return NewsLoaderService(requestSender: requestSender)
    }()
        
}
