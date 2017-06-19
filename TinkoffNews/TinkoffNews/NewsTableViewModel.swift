//
//  NewsTableViewModel.swift
//  TinkoffNews
//
//  Created by Alexander on 18/06/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NewsTableViewModel : NSObject {

    fileprivate let newsCellId = "newsCell"
    fileprivate let tableView: UITableView
    //fileprivate var fetchResultslControllerDelegate: FetchResultslControllerDelegate?
    //fileprivate let fetchResultsController: NSFetchedResultsController<News>
    
    let newsLoaderService: NewsLoaderService
    
    init(with tableView: UITableView) {
        self.tableView = tableView
        self.newsLoaderService = NewsLoaderService()
        
//        let fetchRequest: NSFetchRequest<News> = News.fetchRequest()
//        let textSortDescriptor = NSSortDescriptor(key:#keyPath(News.text), ascending: false)
//        fetchRequest.sortDescriptors = [textSortDescriptor]
//        guard let context = ServiceAssembly.coreDataStack.mainContext else {
//            print("No cotext for frc!")
//            abort()
//        }
//        
//        self.fetchResultsController = NSFetchedResultsController<News>(fetchRequest: fetchRequest,
//                                                                               managedObjectContext: context,
//                                                                               sectionNameKeyPath:nil,
//                                                                               cacheName: nil)
        super.init()
        self.tableView.dataSource = self
        self.tableView.delegate = self
//        self.fetchResultslControllerDelegate = FetchResultslControllerDelegate(with: self.tableView)
//        self.fetchResultsController.delegate = fetchResultslControllerDelegate
//        performFetch()
    }
    
//    fileprivate func performFetch() {
//        do {
//            try self.fetchResultsController.performFetch()
//        } catch {
//            print("Error fetching: \(error)")
//        }
//    }
}

extension NewsTableViewModel: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // передать id и запрос -> service
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //guard  let sectionsCount = fetchResultsController.sections?.count else { return 0 }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(inSection: section)
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        //guard let sections = fetchResultsController.sections?[section] else { return 0 }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:newsCellId, for:indexPath) as! NewsCell
        //let news = fetchResultsController.object(at: indexPath)
        //cell.configure(with: conversation)
        cell.selectionStyle = .none
        
        
        return cell
    }
}
