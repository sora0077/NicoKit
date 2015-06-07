//
//  SearchTableViewController.swift
//  NicoKit
//
//  Created by 林達也 on 2015/06/07.
//  Copyright (c) 2015年 林達也. All rights reserved.
//

import UIKit

extension Search.Query.SortBy {
    
    func title(order: Search.Query.Order) -> String {
        switch self {
        case .LastCommentTime:
            switch order {
            case .Desc:
                return "コメントが新しい順"
            case .Asc:
                return "コメントが古い順"
            }
        case .ViewCounter:
            switch order {
            case .Desc:
                return "再生が多い順"
            case .Asc:
                return "再生が少ない順"
            }
        case .StartTime:
            switch order {
            case .Desc:
                return "投稿が新しい順"
            case .Asc:
                return "投稿が古い順"
            }
        case .MylistCounter:
            switch order {
            case .Desc:
                return "マイリストが多い順"
            case .Asc:
                return "マイリストが少ない順"
            }
        case .CommentCounter:
            switch order {
            case .Desc:
                return "コメントが多い順"
            case .Asc:
                return "コメントが少ない順"
            }
        case .LengthSeconds:
            switch order {
            case .Desc:
                return "再生時間が長い順"
            case .Asc:
                return "再生時間が短い順"
            }
        }
    }
}

class SearchTableViewController: UITableViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    
    var keyword: String = ""
    var searchTarget: Int = 0
    var sort: Search.Query.SortBy = .LastCommentTime
    var order: Search.Query.Order = .Desc
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func switchTargetAction(sender: UISegmentedControl) {
        
        self.searchTarget = sender.selectedSegmentIndex
    }
    
    @IBAction func selectSortAction(sender: UIButton) {
        
        let picker = UIAlertController(title: "", message: "", preferredStyle: .ActionSheet)
        
        for s in Search.Query.SortBy.allValues {
            
            picker.addAction(UIAlertAction(title: s.title(.Desc), style: .Default, handler: { [weak self] _ in
                sender.setTitle(s.title(.Desc), forState: .Normal)
                self?.sort = s
                self?.order = .Desc
            }))
            picker.addAction(UIAlertAction(title: s.title(.Asc), style: .Default, handler: { [weak self] _ in
                sender.setTitle(s.title(.Asc), forState: .Normal)
                self?.sort = s
                self?.order = .Asc
            }))
        }
        picker.addAction(UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil))
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func searchAction(sender: AnyObject) {
        
        self.keyword = self.textField.text
        
        let type: Search.Query.SearchType
        if self.searchTarget == 0 {
            type = Search.Query.SearchType.Keyword(self.keyword)
        } else {
            type = Search.Query.SearchType.Tag(self.keyword)
        }
        
        var query = Search.Query(type: type)
        query.sort_by = self.sort
        query.order = self.order
        
        let vc = from_storyboard(SearchResultViewController.self)
        vc.query = query
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension SearchTableViewController: Storyboardable {
    
    static var storyboardIdentifier: String {
        return "SearchTableViewController"
    }
    static var storyboardName: String {
        return "Main"
    }
}
