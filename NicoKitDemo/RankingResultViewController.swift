//
//  RankingResultViewController.swift
//  NicoKit
//
//  Created by 林達也 on 2015/06/07.
//  Copyright (c) 2015年 林達也. All rights reserved.
//

import UIKit

class RankingResultViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var category: GetRanking.Category!
    var period: GetRanking.Period!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.controller = TableController(responder: self)
        
        let ranking = GetRanking(period: period, category: category)
        
        
        NicoAPI.request(ranking)
            .onSuccess { [weak self] videos in
                if let section = self?.tableView.controller.sections.first {
                    let rows = videos.map { v -> TableRowBase in
                        let row = UITableView.StyleDefaultRow(text: v.title)
                        row.didSelectAction = {
                            App().playVideo(v)
                        }
                        return row
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

extension RankingResultViewController: Storyboardable {
    
    static var storyboardIdentifier: String {
        return "RankingResultViewController"
    }
    static var storyboardName: String {
        return "Main"
    }
}
