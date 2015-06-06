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

    
    @IBOutlet weak var playerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var playerViewBottom: NSLayoutConstraint!
    
    
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
        
        playerViewController?.queuePlayer.insertItem(item, afterItem: nil)
        
        self.animateFullScreen()
    }
    
    private var translation: CGFloat = 0
    
    private enum State {
        case FullScreen
        case SmallScreen
    }
    
    private var state: State = .SmallScreen
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
        })
        
        state = .FullScreen
    }
    
    private func animateSmallScreen() {
        
        playerViewHeight.constant = 150
        playerViewBottom.constant = 0
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        
        state = .SmallScreen
    }
}
