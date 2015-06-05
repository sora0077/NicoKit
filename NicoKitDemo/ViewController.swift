//
//  ViewController.swift
//  NicoKitDemo
//
//  Created by 林達也 on 2015/06/05.
//  Copyright (c) 2015年 林達也. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.controller = TableController(responder: self)
        
        let row1 = UITableView.StyleDefaultRow(text: "検索")
        row1.didSelectAction = { [weak self] in
            
            let vc = from_storyboard(SearchResultViewController.self)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.tableView.controller.sections.first?.append(row1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

