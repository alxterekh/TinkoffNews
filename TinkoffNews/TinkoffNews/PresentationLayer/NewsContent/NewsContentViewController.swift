//
//  NewsContentViewController.swift
//  TinkoffNews
//
//  Created by Alexander on 18/06/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import UIKit
import CoreData
import PKHUD

class NewsContentViewController: UIViewController {
    
    @IBOutlet var newsContent: UIWebView!
    
    fileprivate let newsLoaderService = ServiceAssembly.newsLoaderService
    
    var newsIdentifier: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNewsContent()
    }
    
    fileprivate func showNewsContent() {
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
        HUD.show(.progress, onView: self.view)
        newsLoaderService.loadNewsContent(newsIdentifier: identifier) {
            if let error = $1 {
                DispatchQueue.main.async {
                    HUD.hide(animated: true)
                    self.showError(with: error)
                }
            }
            else if let content = $0 {
                DispatchQueue.main.async {
                    self.newsContent.loadHTMLString(content, baseURL: nil)
                    HUD.hide(animated: true)
                }
            }
        }
    }
    
    fileprivate func showError(with message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
