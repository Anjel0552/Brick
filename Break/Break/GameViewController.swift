//
//  GameViewController.swift
//  Break
//
//  Created by Anjel Villafranco on 10/8/15.
//  Copyright © 2015 Anjel Villafranco. All rights reserved.
//

import UIKit

import AVFoundation
import AVKit

enum BoundaryType : String {
    
    case Floor, LeftWall, RightWall, Ceiling
    
}

class GameViewController: UIViewController, UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate   {
    
    var animator: UIDynamicAnimator!
    
    let ballBehavior = UIDynamicItemBehavior()
    let brickBehavior = UIDynamicItemBehavior()
    let paddleBehavior = UIDynamicItemBehavior()
    
    var attachment: UIAttachmentBehavior?
    
    let gravity = UIGravityBehavior()
    let collision = UICollisionBehavior()
    
    
    let topBar = TopBarView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
    
    
    
    let paddle = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 10))
    
    var players = [AVAudioPlayer]()
    
    // MARK: - All Methods 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playSound("KnightRider1")
        // MARK: - Background💩
        
        
        let bg = UIImageView(image: UIImage(named: "background"))
        bg.frame = view.frame
        view.addSubview(bg)
        
        // topbar
        topBar.frame.size.width = view.frame.width
        view.addSubview(topBar)
        
        setupBehavior()
        
        // run create game run elements
        createPaddle()
        createBall()
        createBricks()
        
    } // end viewDidLoad()
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint) {
        
        for brick in brickBehavior.items as! [UIView] {
            
            if brick === item1 as! UIView || brick == item2 as! UIView {
                playSound("ping")
                
                brickBehavior.removeItem(brick)
                collision.removeItem(brick)
                brick.removeFromSuperview()
                
                topBar.score += 100
                
            } // i love you hun
            
        }// check brick count
        playSound("BEEP")
        
        if brickBehavior.items.count == 0 {
            
            // you win
            endGame()
            
        }
        
    } // end 2 item contact
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        
        BoundaryType.Floor
        
        if let idString = identifier as? String, let boundaryName = BoundaryType (rawValue: idString) {
            
            
            switch boundaryName {
                
            case .Ceiling : print("High as a Kite")
                
            case .Floor :
                
                if let ball = item as? UIView {
                    
                    ballBehavior.removeItem(ball)
                    collision.removeItem(ball)
                    ball.removeFromSuperview()
                }
                
                if topBar.lives == 0 {
                    
                    // game over
                    endGame()
                    
                } else {
                    
                    topBar.lives--
                    
                    createBall()
                }
            case .LeftWall : print("Uh Huh, You lefty!")
                
            case .RightWall : print("Correct")
                
            }
        } // end item & bondary collision
        
    } // MARK: - Touch Methods 
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first {
            
            let point = touch.locationInView(view)
            attachment?.anchorPoint.x = point.x
            
        }
        
        touchesMoved(touches, withEvent: event)
        
        
    } // end touches began
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first {
            
            let point = touch.locationInView(view)
            attachment?.anchorPoint.x = point.x
        }
        
        
    } // end touches moved
    
    func createBricks () {
        
        let cols = 5
        let rows = 3
        
        let brickH = 30
        let brickSpacing = 2
        
        let totalSpacing = (cols + 1) * brickSpacing
        let brickW = (Int(view.frame.width) - totalSpacing) / cols
        
        for c in 0..<cols {
            
            for r in 0..<rows {
                
                let x = c * (brickW + brickSpacing) + brickSpacing
                let y = r * (brickH + brickSpacing) + brickSpacing + 60
                
                let brick = UIView(frame: CGRect(x: x, y: y, width: brickW, height: brickH))
                brick.backgroundColor = UIColor.blackColor()
                brick.layer.cornerRadius = 5
                
                view.addSubview(brick)
                
                collision.addItem(brick)
                brickBehavior.addItem(brick)
                
                // wrap view in boundary
                //                collision.translatesReferenceBoundsIntoBoundary = true
                
            }
        }
    }
    
    func createBall() {
        
        let ball = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        ball.layer.cornerRadius = 10
        ball.backgroundColor = UIColor.cyanColor()
        view.addSubview(ball)
        
        ball.center.x = paddle.center.x
        ball.center.y = paddle.center.y - 20
        
        ballBehavior.addItem(ball)
        collision.addItem(ball)
        
        //push
        
        let push = UIPushBehavior(items: [ball], mode: UIPushBehaviorMode.Instantaneous)
        push.pushDirection = CGVector(dx: 0.1, dy: -0.1)
        animator.addBehavior(push)
        
        print(animator.behaviors.count)
    }
    
    func createPaddle() {
        
        paddle.backgroundColor = UIColor.darkGrayColor()
        paddle.layer.cornerRadius = 5
        
        paddle.center = CGPoint(x: view.center.x, y: view.frame.height - 40)
        
        view.addSubview(paddle)
        
        paddleBehavior.addItem(paddle)
        collision.addItem(paddle)
        
        attachment = UIAttachmentBehavior(item: paddle, attachedToAnchor: paddle.center)
        
        animator.addBehavior(attachment!)
        
    }
    
    // MARK: - Setup World 🌍
    func setupBehavior() {
        
        animator = UIDynamicAnimator(referenceView: view)
        
        animator.delegate = self
        
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
        animator.addBehavior(ballBehavior)
        animator.addBehavior(brickBehavior)
        animator.addBehavior(paddleBehavior)
        
        
        collision.collisionDelegate = self
        
        // setup ball behavior
        
        ballBehavior.friction = 0
        ballBehavior.resistance = 0
        ballBehavior.elasticity = 1
        ballBehavior.allowsRotation = false
        
        // setup brick behavior
        
        brickBehavior.anchored = true
        
        // setup paddle behavior
        paddleBehavior.allowsRotation = false
        
        //        paddleBehavior.anchored = true
        
        // wrap view in boundary
        collision.translatesReferenceBoundsIntoBoundary = true
        
        collision.addBoundaryWithIdentifier(BoundaryType.Ceiling.rawValue, fromPoint: CGPoint(x: 0, y: 50), toPoint: CGPoint(x: view.frame.width, y: 50))
        
        collision.addBoundaryWithIdentifier(BoundaryType.Floor.rawValue, fromPoint: CGPoint(x: 0, y: view.frame.height - 10), toPoint: CGPoint(x: view.frame.width, y: view.frame.height - 10))
        
    }
    
    func endGame() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let startVC =
        storyboard.instantiateViewControllerWithIdentifier("StartVC")
        
        navigationController?.viewControllers = [startVC]
        
    }
    
    func playSound(named: String) {
        
        if let fileData = NSDataAsset(name: named) {
            
            let data = fileData.data
            
            do {
                
                let player = try AVAudioPlayer(data: data)
                
                player.play()
                players.append(player)
                print(players.count)
                
            } catch {
                
                print(error)
                
            }
            
        }
        
    }
    
    //audio 
    
    
} // end class
