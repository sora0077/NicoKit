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
        
        let definitions: [(String, () -> Void)] = [
            ("検索", { [weak self] in
                self?.push(SearchResultViewController.self)
            }),
            ("ログイン", { [weak self] in
                self?.push(LoginViewController.self)
            })
        ]
        
        let rows = definitions.map { text, action -> TableRowBase in
            let row = UITableView.StyleDefaultRow(text: text)
            row.didSelectAction = action
            return row
        }
        
        self.tableView.controller.sections.first?.extend(rows)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    private func push<T: UIViewController where T: Storyboardable>(clazz: T.Type) {
        
        let vc = from_storyboard(clazz)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

