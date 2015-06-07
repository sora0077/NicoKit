//
//  RankingSelectViewController.swift
//  NicoKit
//
//  Created by 林達也 on 2015/06/07.
//  Copyright (c) 2015年 林達也. All rights reserved.
//

import UIKit

extension GetRanking.Category {

    var title: String {
        switch self {
        case .All:
            return "カテゴリ合算"
        case .Music:
            return "音楽"
        case .Ent:
            return "エンターテイメント"
        case .Anime:
            return "アニメ"
        case .Game:
            return "ゲーム"
        case .Animal:
            return "動物"
        case .Science:
            return "科学"
        case .Other:
            return "その他"
            
        }
    }
    
    static var allValues: [GetRanking.Category] {
        return [
            .All,
            .Ent,
            .Music,
            .Anime,
            .Game,
            .Animal,
            .Science,
            .Other
        ]
    }
}

class RankingSelectViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var periodControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.titleView = self.periodControl
        
        self.tableView.controller = TableController(responder: self)
        
        let rows = GetRanking.Category.allValues.map { [weak self] c -> TableRowBase in
            let row = UITableView.StyleDefaultRow(text: c.title)
            row.didSelectAction = {
                self?.push(c)
            }
            return row
        }
        
        self.tableView.controller.sections.first?.extend(rows)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func push(category: GetRanking.Category) {
        
        let period: GetRanking.Period
        switch periodControl.selectedSegmentIndex {
        case 0:
            period = .Hourly
        case 1:
            period = .Daily
        case 2:
            period = .Weekly
        case 3:
            period = .Monthly
        default:
            period = .Hourly
        }
        
        let vc = from_storyboard(RankingResultViewController.self)
        vc.category = category
        vc.period = period
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension RankingSelectViewController: Storyboardable {
    
    static var storyboardIdentifier: String {
        return "RankingSelectViewController"
    }
    static var storyboardName: String {
        return "Main"
    }
}

