//
//  Requestable.swift
//  TinkoffNews
//
//  Created by Alexander on 18/06/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation

protocol Requestable {
    var urlRequest: URLRequest? { get }
}
