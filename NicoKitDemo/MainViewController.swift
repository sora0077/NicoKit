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
    weak var playlistViewController: PlaylistViewController!

    
    @IBOutlet weak var playerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var playerViewBottom: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.playerViewController.playlistViewController = self.playlistViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.destinationViewController {
        case let vc as PlayerViewController:
            self.playerViewController = vc
            vc.delegate = self
        case let vc as PlaylistViewController:
            self.playlistViewController = vc
        default:
            break
        }
    }
    
    func playVideo(v: Search.Video) {
        
        self.playerViewController.playVideo(v)
    }
    
    func playVideo(v: GetRanking.Video) {
        
        self.playerViewController.playVideo(v)
    }
    
    private var translation: CGFloat = 0
    
    private enum State {
        case FullScreen
        case SmallScreen
    }
    
    private var state: State = .SmallScreen
}

extension MainViewController: PlayerViewControllerDelegate {
    
    func playerView(vc: PlayerViewController, willPlay flv: Flv) {
    
        self.animateFullScreen()
    }
    
    func playerViewQueueingItemIsEmpty(vc: PlayerViewController) {
        
        
        playerViewHeight.constant = 150
        playerViewBottom.constant = -150
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.playlistViewController.view.alpha = 0
        })
        
        state = .SmallScreen
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    
    @IBAction func dragAction(sender: UIPanGestureRecognizer) {
        
        let p = sender.translationInView(playerViewController.view)
        let b = playerViewBottom
        let h = playerViewHeight
        
        let l = UIScreen.mainScreen().bounds.size
        let plh = l.width * 3 / 4
        let psh = 150 as CGFloat
        
        let ratio = (l.width - 200) / (l.height - psh)
        
        
        if b.constant >= 0 {
            
            if b.constant == 0 && p.y > 0 {
                
            } else {
                let t = 1 - playlistViewController.view.bounds.width / l.width
                playlistViewController.view.alpha = 1 - t * t
                h.constant -= p.y * ratio
                b.constant -= p.y
            }
        } else {
            h.constant = 150
            b.constant = 0
        }
        
        sender.setTranslation(CGPointZero, inView: playerViewController.view)
    
        if sender.state == .Began {
            translation = 0
        }
        
        translation += p.y
        
        Logging.d(translation)
    
        if sender.state == .Ended {
            
            if abs(translation) > 190 {
                switch state {
                case .FullScreen:
                    self.animateSmallScreen()
                case .SmallScreen:
                    self.animateFullScreen()
                }
            } else {
                switch state {
                case .FullScreen:
                    self.animateFullScreen()
                case .SmallScreen:
                    self.animateSmallScreen()
                }
            }
        }
    }
    
    private func animateFullScreen() {
        
        let l = UIScreen.mainScreen().bounds.size
        let plh = l.width * 3 / 4
        
        playerViewHeight.constant = plh
        playerViewBottom.constant = l.height - plh
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.playlistViewController.view.alpha = 1
        })
        
        state = .FullScreen
    }
    
    private func animateSmallScreen() {
        
        playerViewHeight.constant = 150
        playerViewBottom.constant = 0
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.playlistViewController.view.alpha = 0
        })
        
        state = .SmallScreen
    }
}
