//
//  MainViewController.swift
//  NicoKit
//
//  Created by 林達也 on 2015/06/06.
//  Copyright (c) 2015年 林達也. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    weak var playerViewController: PlayerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.destinationViewController {
        case let vc as PlayerViewController:
            self.playerViewController = vc
        default:
            break
        }
    }
    
    func playVideo(id: String) {
        
        let watchVideo = WatchVideo(id: id)
        let getFlv = GetFlv(id: id)
        NicoAPI.request(watchVideo)
            .flatMap {
                NicoAPI.request(getFlv)
            }
            .onSuccess { [weak self] flv in
                Queue.main.async {
                    self?.showPlayerView(flv)
                }
            }
            .onFailure {
                Logging.e($0)
            }
        
    }
    
    private func showPlayerView(flv: Flv) {
        
        let item = AVPlayerItem(URL: NSURL(string: flv.url))
        
        self.playerViewController?.queuePlayer.insertItem(item, afterItem: nil)
    }
}
