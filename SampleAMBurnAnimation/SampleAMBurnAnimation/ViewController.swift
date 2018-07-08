//
//  ViewController.swift
//  SampleAMBurnAnimation
//
//  Created by am10 on 2018/07/08.
//  Copyright © 2018年 am10. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var targetView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tappedBurnButton(_ button: UIButton) {
        
        targetView.isHidden = false
        targetView.burnAnimation(duration: 3.0,
                                 completion: {[weak self] in
                                    guard let weakSelf = self else { return }
                                    weakSelf.targetView.isHidden = true
                                    
        })
    }
}

