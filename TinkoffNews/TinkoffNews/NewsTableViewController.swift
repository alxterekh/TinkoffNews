//
//  ViewController.swift
//  TinkoffNews
//
//  Created by Alexander on 17/06/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit
import PKHUD

class NewsTableViewController: UIViewController, NewsTableViewModelDelegate {
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    fileprivate var newsTableViewModel: NewsTableViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        HUD.show(.progress, onView: self.view)
    }
    
    fileprivate let estimatedConversationCellRowHeight: CGFloat = 44
    
    fileprivate func setup() {
        tableView.estimatedRowHeight = estimatedConversationCellRowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        newsTableViewModel = NewsTableViewModel(with: tableView)
        newsTableViewModel?.delegate = self
        newsTableViewModel?.fetchNewsList()
    }
    
    func handleSuccessfulFetchingNews() {
        DispatchQueue.main.async {
            HUD.flash(.success, onView: self.view)
        }
    }
    
    func show(error message: String) {
        DispatchQueue.main.async {
            HUD.flash(.labeledError(title: message, subtitle: nil), onView: self.view)
        }
    }
}

