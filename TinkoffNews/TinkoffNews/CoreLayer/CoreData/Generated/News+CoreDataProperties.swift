//
//  News+CoreDataProperties.swift
//  TinkoffNews
//
//  Created by Alexander on 20/06/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import CoreData


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var id: String?
    @NSManaged public var text: String?
    @NSManaged public var orderIndex: Int64
    @NSManaged public var content: String?
    @NSManaged public var viewsCount: Int16

}
