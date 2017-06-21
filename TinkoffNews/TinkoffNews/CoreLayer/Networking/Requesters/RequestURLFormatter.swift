//
//  RequestURLFormatter.swift
//  TinkoffNews
//
//  Created by Alexander on 18/06/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation

class RequestURLFormatter {
    
    static func formatURLString(_ urlString: String) -> URLRequest? {
        var request: URLRequest?
        if let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlString) {
            request = URLRequest(url: url)
        }
        
        return request
    }
}
