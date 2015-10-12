//
//  TopBarView.swift
//  Break
//
//  Created by Anjel Villafranco on 10/8/15.
//  Copyright © 2015 Anjel Villafranco. All rights reserved.
//

import UIKit

class TopBarView: UIView {
    
    var lives: Int = 0 {
        
        didSet {
            
            // remove current circles
            for circle in lifeView.subviews {
            
                circle.removeFromSuperview()
            
            }
            
            // add circles based on life count
            
            for l in 0..<lives {
                
                let circleTotal = lives * 10 + (lives - 1) * 5
            
                let circle = UIView(frame: CGRect(x: l * 15 - (circleTotal / 2), y: Int(lifeView.center.y) - 5, width: 10, height: 10))
                
                circle.layer.cornerRadius = 5
                circle.backgroundColor = UIColor.whiteColor()
                    
                lifeView.addSubview(circle)
                
                
                
            }
        }
    }
    
    var score: Int = 0 {
        
        didSet {
            
            scoreLable.text = "\(score)"
        }
    }
    
    private let titleLable = UILabel(frame: CGRectMake(10, 0, 100, 50))
    private let scoreLable = UILabel(frame: CGRectMake(0, 0, 100, 50))
    private let lifeView = UIView(frame: CGRectMake(0, 0, 0, 50))
    
    override func didMoveToSuperview() {
        
        titleLable.text = "Break"
        titleLable.textColor = UIColor.cyanColor()
        
        score = 0 
        lives = 16
        
        scoreLable.text = "0"
        scoreLable.frame.origin.x = frame.width - 100
        scoreLable.textColor = UIColor.cyanColor()
        scoreLable.textAlignment = .Right
        
        lifeView.center.x = center.x
        
        addSubview(titleLable)
        addSubview(scoreLable)
        addSubview(lifeView)
        
        
        
    }
}


