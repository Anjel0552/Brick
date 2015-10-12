//
//  StartViewController.swift
//  Break
//
//  Created by Anjel Villafranco on 10/8/15.
//  Copyright © 2015 Anjel Villafranco. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBAction func play(sender: AnyObject) {
        
        let gameVC = GameViewController()
        
        navigationController?.viewControllers = [gameVC]
        
//        let topScoreLable.text = "\(score)"
//        
//         topScoreLable = UILabel(frame: CGRectMake(0, 0, 100, 50))
//        
//        topScoreLable.text = "0"
//       // topScoreLable.frame.origin.x = frame.width - 100
//        topScoreLable.textColor = UIColor.cyanColor()
//        topScoreLable.textAlignment = .Right
    }
}