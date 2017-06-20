//
//  NewsCell.swift
//  TinkoffNews
//
//  Created by Alexander on 18/06/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation
import UIKit

class NewsCell : UITableViewCell, UIWebViewDelegate {
    
    @IBOutlet fileprivate weak var newsHeader: UIWebView!
    @IBOutlet fileprivate weak var viewsCountLabel: UILabel!
    @IBOutlet weak var trailingViewsCountLabelToSuperview: NSLayoutConstraint!
    
    var identifier: String?
    
    fileprivate var viewsCount = 0
    fileprivate var content = ""
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    fileprivate var news: News?
    
    func configure(with news: News) {
        guard let text = news.text else {
            print("no text")
            return
        }
        self.news = news
        content = text
        identifier = news.id
        viewsCountLabel.text = "\(news.viewsCount)"
    }
    
    func markAsViewed() {
        viewsCount += 1
        viewsCountLabel.text = "\(viewsCount)"
        
//        if let saveContext = ServiceAssembly.coreDataStack.saveContext,
//        let newsOnSaveContext = saveContext.object(with: news!.objectID) as? News {
//            
//            //newsOnSaveContext
//            ServiceAssembly.coreDataStack.performSave(context: saveContext) {
//                _, _ in
//            }
    }
    
    
    func webView(_ webView: UIWebView,
                 shouldStartLoadWith request: URLRequest,
                 navigationType: UIWebViewNavigationType) -> Bool {
        return navigationType != .linkClicked
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let runLoop = RunLoop.current.getCFRunLoop()  
        CFRunLoopStop(runLoop)
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let webViewFrame = CGRect(x: 0, y: 0, width: webViewWidth(targetSize.width), height: 1)
        
        let webView = UIWebView(frame: webViewFrame)
        webView.delegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isUserInteractionEnabled = false
        webView.loadHTMLString(content, baseURL: nil)
        CFRunLoopRunInMode(.defaultMode, 1, false)
        let result = webView.stringByEvaluatingJavaScript(from: "Math.max( document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight );")
        var fittingSize = targetSize
        if let result = result {
            fittingSize.height = totalCellHeight(with: CGFloat((result as NSString).doubleValue))
            newsHeader.removeFromSuperview()
            newsHeader = webView
            newsHeader.backgroundColor = UIColor.clear
            newsHeader.isOpaque = false
            
            self.addSubview(newsHeader)
            self.addConstraint(NSLayoutConstraint(item: newsHeader, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 8))
            self.addConstraint(NSLayoutConstraint(item: newsHeader, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 8))
        }
        
        return fittingSize
    }
    
    fileprivate func webViewWidth(_ cellWidth: CGFloat) -> CGFloat {
        return cellWidth - viewsCountLabel.frame.size.width - trailingViewsCountLabelToSuperview.constant
    }
    
    fileprivate func totalCellHeight(with newsHeaderWebViewHeight: CGFloat)  -> CGFloat{
        return newsHeaderWebViewHeight + 16
    }
}




