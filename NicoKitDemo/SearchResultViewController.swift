//
//  SearchResultViewController.swift
//  NicoKitDemo
//
//  Created by 林達也 on 2015/06/05.
//  Copyright (c) 2015年 林達也. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    deinit {
        Logging.d("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.controller = TableController(responder: self)
        
        let query = Search.Query(type: .Tag("Sims4"))
        
        let search = Search(query: query)
        
        NicoAPI.request(search)
            .onSuccess { [weak self] videos, status in
                if let section = self?.tableView.controller.sections.first {
                    let rows = videos.map {
                        UITableView.StyleDefaultRow(text: $0.title)
                    }
                    section.extend(rows)
                }
            }
            .onFailure {
                println($0)
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchResultViewController: Storyboardable {
    
    static var storyboardIdentifier: String {
        return "SearchResultViewController"
    }
    static var storyboardName: String {
        return "Main"
    }
}

