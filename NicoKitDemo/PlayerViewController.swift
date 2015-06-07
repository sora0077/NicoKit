//
//  PlayerViewController.swift
//  NicoKit
//
//  Created by 林達也 on 2015/06/06.
//  Copyright (c) 2015年 林達也. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

protocol PlayerViewControllerDelegate: NSObjectProtocol {
    
    func playerView(vc: PlayerViewController, willPlay flv: Flv)
    
    func playerViewQueueingItemIsEmpty(vc: PlayerViewController)
}

class PlayerViewController: AVPlayerViewController {
    
    weak var delegate: PlayerViewControllerDelegate?
    weak var playlistViewController: PlaylistViewController!
    
    private var queuePlayer = AVQueuePlayer(items: [])

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.player = self.queuePlayer
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "didEndPlay",
            name: AVPlayerItemDidPlayToEndTimeNotification,
            object: nil
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playVideo(v: Search.Video) {
        
        self._playVideo(v.cmsid, title: v.title)
    }
    
    func playVideo(v: GetRanking.Video) {
        
        self._playVideo(v.id, title: v.title)
    }
    
    private func _playVideo(id: String, title: String) {
        let watchVideo = WatchVideo(id: id)
        NicoAPI.request(watchVideo)
            .map {
                GetFlv(id: $0 ??  id)
            }
            .flatMap {
                NicoAPI.request($0)
            }
            .onSuccess { [weak self] flv in
                Queue.main.async {
                    if let strong = self {
                        strong.insertQueue(flv)
                        strong.playlistViewController.insertList(title)
                    }
                }
            }
            .onFailure {
                Logging.e($0)
            }
    }

    private func insertQueue(flv: Flv) {
        if self.player.rate < 1 {
            self.delegate?.playerView(self, willPlay: flv)
        }
        let item = AVPlayerItem(URL: NSURL(string: flv.url))
        
        self.queuePlayer.insertItem(item, afterItem: nil)
    }
    
    @objc
    private func didEndPlay() {
        
        self.playlistViewController.didEndPlay()
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
