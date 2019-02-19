//
//  ViewController.swift
//  BrickGame
//
//  Created by Rupika Sompalli on 18/02/19.
//  Copyright © 2019 Venkata. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    
    @IBOutlet weak var ball : UIImageView!
    @IBOutlet weak var sword : UIImageView!
    @IBOutlet weak var scoreLbl : UILabel!
    @IBOutlet weak var gameStatus : UILabel!
    var updateScoreLabel = false
    
    var score: Int = 0 {
        didSet{
            scoreLbl.text = "Score: \(oldValue)"
        }
    }
    var swordCenter : CGPoint!
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var ballBehaviour : UIDynamicItemBehavior!
    var swordBehaviour : UIDynamicItemBehavior!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gameStatus.isHidden = true
        
        
        ball.frame = CGRect(x: 304, y: 50, width: 60, height: 60)
        animator = UIDynamicAnimator(referenceView: view)
        
        collision = UICollisionBehavior(items: [ball])
        collision.collisionDelegate = self
        collision.collisionMode = .everything
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.addBoundary(withIdentifier: "sword" as NSCopying, for: UIBezierPath(rect: sword.frame))
        collision.addBoundary(withIdentifier: "topSide" as NSCopying, for: UIBezierPath(rect: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 5)))
        collision.addBoundary(withIdentifier: "leftSide" as NSCopying, for: UIBezierPath(rect: CGRect(x: 0, y: 0, width: 5, height: view.frame.size.height)))
        collision.addBoundary(withIdentifier: "rightSide" as NSCopying, for: UIBezierPath(rect: CGRect(x: view.frame.size.width-5, y: 0, width: 5, height: view.frame.size.height)))
        
        animator.addBehavior(collision)
        
        ballBehaviour = UIDynamicItemBehavior(items: [ball])
        ballBehaviour.allowsRotation = false
        ballBehaviour.elasticity = 1.0
        ballBehaviour.friction = 0.0
        ballBehaviour.resistance = 0.0
        
        animator.addBehavior(ballBehaviour)
        
        swordBehaviour = UIDynamicItemBehavior(items: [sword])
        swordBehaviour.density = 1000.0
        swordBehaviour.allowsRotation = false
        animator.addBehavior(swordBehaviour)
        
        let push = UIPushBehavior(items: [ball], mode: .instantaneous)
        push.active = true
        push.pushDirection = CGVector(dx: 0.5, dy: 1.0)
        animator.addBehavior(push)
        
        print(sword)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        swordCenter = sword.center
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let location = touch.location(in: view)
        let yPoint = self.swordCenter.y
        let paddleCenter = CGPoint(x:location.x, y:yPoint)
        
        view.layoutIfNeeded()
        
        DispatchQueue.main.async {
            self.collision.removeBoundary(withIdentifier: "sword" as NSCopying)
            
            self.sword.center = paddleCenter
            self.collision.addBoundary(withIdentifier: "sword" as NSCopying, for: UIBezierPath(rect: self.sword.frame))
            self.animator.updateItem(usingCurrentState: self.sword)
        }
        
    }

    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        print("Boundary contact occurred start - \(String(describing: identifier))")
        if identifier == nil{
            gameStatus.isHidden = false
        }else{
            if let identifier = identifier{
                if identifier as! String == "sword"{
                   updateScoreLabel = true
                }
            }
            
        }
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        print("Boundary contact occurred end - \(String(describing: identifier))")
        
        if identifier == nil{
            gameStatus.isHidden = false
            score = 0
            animator.removeAllBehaviors()
        }else{
            if let identifier = identifier{
                if identifier as! String == "sword"{
                    if updateScoreLabel == true{
                        updateScoreLabel = false
                         score += 1
                    }
                   
                }
            }
            
        }
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item1: UIDynamicItem, with item2: UIDynamicItem) {
         print("touched sword end")
    }

}

