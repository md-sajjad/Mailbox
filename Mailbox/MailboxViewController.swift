//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Muddassar Sajjad on 9/29/15.
//  Copyright (c) 2015 com.training.codepath. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var message: UIImageView!
    
    @IBOutlet weak var feed: UIImageView!
    
    @IBOutlet weak var archive: UIImageView!
    
    @IBOutlet weak var later: UIImageView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var reschedule: UIImageView!
    
    var messageOriginalCenter: CGPoint!

    var laterOriginalCenter: CGPoint!

    var messageOriginalBackgroundColor: UIColor!
    
    @IBAction func onPanMessage(sender: UIPanGestureRecognizer) {
        //let point = sender.locationInView(view)
        
        //let velocity = sender.velocityInView(view)
        
        let translation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began
        {
            //let imageView = sender.view as! UIImageView
            
            
            messageOriginalCenter = message.center
            laterOriginalCenter = later.center
            
            print("messageOriginalCenter = \(messageOriginalCenter) \n", terminator: "")
        } else if sender.state == UIGestureRecognizerState.Changed
        {
            print("translation = \(translation) \n", terminator: "")
            
            message.center = CGPoint(x: messageOriginalCenter.x + translation.x, y: messageOriginalCenter.y)
            
            if translation.x < -40 {
                later.alpha = 1
            } else {
                later.alpha = 0.4
            }
            
            if translation.x < -60 {
                backgroundView.backgroundColor =
                    UIColor(hex: 0xF3C636)
                print("laterOriginalCenter.x: \(laterOriginalCenter.x), later.center.x: \(later.center.x), translation: \(translation) \n", terminator: "")
                later.center.x = laterOriginalCenter.x + translation.x + 60
            } else {
                backgroundView.backgroundColor = messageOriginalBackgroundColor
            }
            
            
            
            print("After message.center = \(message.center) \n", terminator: "")
            
        } else if sender.state == UIGestureRecognizerState.Ended
        {
            if translation.x >= -60 {
                UIView.animateWithDuration(0.7, animations: { () -> Void in
                    self.message.center = self.messageOriginalCenter
                    self.later.alpha = 0.4
                    self.archive.alpha = 0.4
                    self.backgroundView.backgroundColor = self.messageOriginalBackgroundColor
                })
            } else {
                UIView.animateWithDuration(0.7, animations: { () -> Void in
                    self.later.alpha = 0.05
                    self.archive.alpha = 0.05
                    self.message.center.x = self.messageOriginalCenter.x - 320
                    self.reschedule.alpha = 0.2
                    }, completion: { (completed1) -> Void in
                        UIView.animateWithDuration(0.7, animations: { () -> Void in
                            self.reschedule.alpha = 0.95
                            }, completion: { (completed2) -> Void in
                                // Do what next
                        })
                })
            }
            
        }
        
    }
    
    var backgroundViewHidden = false
    
    @IBAction func onTapRescheduleOrList(sender: AnyObject) {
        print("onTap")
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.reschedule.alpha = 0
            }) { (completed) -> Void in
                UIView.animateWithDuration(0.8, animations: { () -> Void in
                    self.feed.center.y -= 85
                    }, completion: { (completed2) -> Void in
                        // What Next
                })
        }
        backgroundViewHidden = true
    }
    
    @IBAction func onTapFeed(sender: AnyObject) {
        if backgroundViewHidden
        {
            UIView.animateWithDuration(0.7, animations: { () -> Void in
                self.backgroundView.backgroundColor = self.messageOriginalBackgroundColor
                self.later.alpha = 0.4
                self.archive.alpha = 0.4
                self.message.center.x = self.messageOriginalCenter.x
                self.feed.center.y += 85
                }, completion: { (completed) -> Void in
                    // DO WHAT IF COMPLETE
            })
            backgroundViewHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        scrollView.contentSize = CGSize(width: 320, height: 1365)
        
        scrollView.delegate = self
        
        messageOriginalBackgroundColor = backgroundView.backgroundColor
        
        later.alpha = 0.4
        archive.alpha = 0.4
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIColor {
    
    convenience init(hex: Int) {
        
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
        
    }
    
}
