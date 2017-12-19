//
//  IntroView1.swift
//  MarkSheet
//
//  Created by _ xenop on 2017/11/05.
//  Copyright © 2017年 xenop. All rights reserved.
//

import UIKit

class IntroView: UIView {
    @IBOutlet var titleLabel:UILabel?
    @IBOutlet var descriptionLabel:UILabel?
    @IBOutlet var playButton:UIButton?
    @IBOutlet var closeButton:UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel!.text = NSLocalizedString("intro_page_title", comment: "")
        descriptionLabel!.text = NSLocalizedString("intro_page_description", comment: "")
        playButton!.setTitle(NSLocalizedString("intro_page_play_button", comment: ""), for: .normal)
        closeButton!.setTitle(NSLocalizedString("intro_page_close_button", comment: ""), for: .normal)
    }
    
    @IBAction func didPushPlayButton(sender: Any) {
        print("play")
    }
    
    @IBAction func didPushCloseButton(sender: Any) {
        print("close")
    }
}
