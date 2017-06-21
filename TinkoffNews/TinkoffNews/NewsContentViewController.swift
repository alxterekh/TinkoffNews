//
//  NewsContentViewController.swift
//  TinkoffNews
//
//  Created by Alexander on 18/06/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit
import CoreData

class NewsContentViewController: UIViewController {
    
    @IBOutlet var newsContent: UIWebView!
    
    fileprivate let newsLoaderService = ServiceAssembly.newsLoaderService
    
    var newsIdentifier: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNewsContent()
    }
    
    fileprivate func fetchNewsContent() {
        guard let context = ServiceAssembly.coreDataStack.mainContext else {
            print("No context!")
            abort()
        }
        
        guard let identifier = newsIdentifier else {
            print("No news identifier!")
            abort()
        }
        
        if let news = News.performNewsFetchRequest(identifier: identifier, in: context),
            let content = news.content {
            self.newsContent.loadHTMLString(content, baseURL: nil)
        }
        else {
            loadNewsContent(for: identifier)
        }
    }
    
    fileprivate func loadNewsContent(for identifier: String) {
        newsLoaderService.loadNewsContent(newsIdentifier: identifier) {
            if let error = $1 {
                print(error)
            }
            else {
                self.newsContent.loadHTMLString($0!, baseURL: nil)

            }
        }
    }
}
