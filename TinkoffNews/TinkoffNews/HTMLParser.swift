//
//  HTMLParser.swift
//  TinkoffNews
//
//  Created by Alexander on 21/06/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import UIKit

class HTMLParser {
    static func parseHTMLStringToString(_ encodedString: String) -> String? {
        guard let encodedData = encodedString.data(using:.utf8) else {
            print("HTML string can't be parsed!")
            return nil
        }
        
        var decodedString: String?
        
        let attributedOptions: [String : Any] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSNumber(value: String.Encoding.utf8.rawValue)
        ]
        
        do {
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            decodedString = attributedString.string

        } catch  {
            print(error.localizedDescription)
        }
        
        return decodedString
    }
}


