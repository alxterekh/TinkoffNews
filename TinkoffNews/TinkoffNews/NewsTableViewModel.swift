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

protocol NewsListModel: class {
    weak var delegate: NewsTableViewModelDelegate? { get set }
    func fetchNewsList()
}

protocol NewsTableViewModelDelegate: class {
    func show(error message: String)
    func hideProgressHud()
    func showProgressHud()
}

class NewsTableViewModel : NSObject, NewsListModel {
    fileprivate let newsCellId = "newsCell"
    fileprivate let tableView: UITableView
    fileprivate var fetchResultslControllerDelegate: FetchResultslControllerDelegate?
    fileprivate let fetchResultsController: NSFetchedResultsController<News>
    fileprivate let newsLoaderService: NewsLoader
    
    weak var delegate: NewsTableViewModelDelegate?
    
    init(with tableView: UITableView) {
        self.tableView = tableView
        self.newsLoaderService = ServiceAssembly.newsLoaderService
        let fetchRequest: NSFetchRequest<News> = News.fetchRequest()
        let textSortDescriptor = NSSortDescriptor(key:#keyPath(News.orderIndex), ascending: true)
        fetchRequest.sortDescriptors = [textSortDescriptor]
        guard let context = ServiceAssembly.coreDataStack.mainContext else {
            print("No cotext for frc!")
            abort()
        }
        
        self.fetchResultsController = NSFetchedResultsController<News>(fetchRequest: fetchRequest,
                                                                               managedObjectContext: context,
                                                                               sectionNameKeyPath:nil,
                                                                               cacheName: nil)
        super.init()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.fetchResultslControllerDelegate = FetchResultslControllerDelegate(with: self.tableView)
        self.fetchResultsController.delegate = fetchResultslControllerDelegate
        performFetch()
    }
    
    fileprivate func performFetch() {
        do {
            try self.fetchResultsController.performFetch()
        } catch {
            print("Error fetching: \(error)")
        }
    }
    
    // MARK: - Fetching news
    
    fileprivate var first = 0
    fileprivate let batchSize = 20
    fileprivate var dataIsLodaing = false
        
    func fetchNewsList() {
        if !dataIsLodaing {
            dataIsLodaing = true
            delegate?.showProgressHud()
            newsLoaderService.loadNewsHeaderList(first: first, last: first + batchSize) {
                if let error = $0 {
                    self.delegate?.show(error: error)
                }
                else {
                    self.delegate?.hideProgressHud()
                    self.first += self.batchSize
                }
                self.dataIsLodaing = false
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollViewDidScrollToBottom(scrollView) {
            fetchNewsList()
        }
    }
    
    fileprivate func scrollViewDidScrollToBottom(_ scrollView: UIScrollView) -> Bool {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        return bottomEdge >= scrollView.contentSize.height
//        let diff = roundf(Float(scrollView.contentSize.height-scrollView.frame.size.height))
//        return scrollView.contentOffset.y == CGFloat(diff) 
    }
}

extension NewsTableViewModel: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sectionsCount = fetchResultsController.sections?.count else { return 0 }
        return sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(inSection: section)
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        guard let sections = fetchResultsController.sections?[section] else { return 0 }
        return sections.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:newsCellId, for:indexPath) as! NewsCell
        let news = fetchResultsController.object(at: indexPath)
        cell.configure(with: news)
        cell.selectionStyle = .none
        
        return cell
    }
}
