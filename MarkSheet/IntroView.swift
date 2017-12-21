//
//  IntroView1.swift
//  MarkSheet
//
//  Created by _ xenop on 2017/11/05.
//  Copyright © 2017年 xenop. All rights reserved.
//

import UIKit

protocol IntroViewDelegate {
    func play(sender: IntroView)
    func close(sender: IntroView)
}

class IntroView: UIView {
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var descriptionLabel:UILabel!
    @IBOutlet weak var playButton:UIButton!
    @IBOutlet weak var closeButton:UIButton!
    var delegate:IntroViewDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = NSLocalizedString("intro_page_title", comment: "")
        descriptionLabel.text = NSLocalizedString("intro_page_description", comment: "")
        closeButton.setTitle(NSLocalizedString("intro_page_close_button", comment: ""), for: .normal)
    }
    
    @IBAction func didPushPlayButton(sender: Any) {
        self.delegate?.play(sender: self)
    }
    
    @IBAction func didPushCloseButton(sender: Any) {
        self.delegate?.close(sender: self)
    }
}
