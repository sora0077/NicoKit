//
//  PlaylistViewController.swift
//  NicoKit
//
//  Created by 林達也 on 2015/06/07.
//  Copyright (c) 2015年 林達也. All rights reserved.
//

import UIKit

class PlaylistViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.controller = TableController(responder: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertList(name: String) {
        
        let row = UITableView.StyleDefaultRow(text: name)
        self.tableView.controller.sections.first?.append(row)
    }
    
    func didEndPlay() {
        if let row = self.tableView.controller.sections.first?.rows.first {
            self.tableView.controller.sections.first?.remove(row)
        }
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
