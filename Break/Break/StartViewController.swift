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
         
    }
}