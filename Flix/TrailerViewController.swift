//
//  TrailerViewController.swift
//  Flix
//
//  Created by Esther Max-Onakpoya on 10/2/20.
//

import UIKit
import youtube_ios_player_helper

class TrailerViewController: UIViewController, YTPlayerViewDelegate {
    
    @IBOutlet var playerView: YTPlayerView!
    var videoId = "M7lc1UVf-VE"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerView.delegate = self
        self.playerView.load(withVideoId: videoId)
        self.playerView.playVideo()
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
