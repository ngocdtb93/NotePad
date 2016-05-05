//
//  ViewController.swift
//  NotePad
//
//  Created by Ngoc Do on 4/29/16.
//  Copyright © 2016 com.appable. All rights reserved.
//

import UIKit
import CoreGraphics

class MainController: UIViewController {
    
    //MARK: - Local variables
    var lastPoint = CGPoint.zero
    var brushWidth: CGFloat = 2.0
    var opacity: CGFloat = 1.0
    var swiped = false
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    let colors: [(CGFloat, CGFloat, CGFloat)] = [
        (0, 0, 0),
        (105.0 / 255.0, 105.0 / 255.0, 105.0 / 255.0),
        (1.0, 0, 0),
        (0, 0, 1.0),
        (51.0 / 255.0, 204.0 / 255.0, 1.0),
        (102.0 / 255.0, 204.0 / 255.0, 0),
        (102.0 / 255.0, 1.0, 0),
        (160.0 / 255.0, 82.0 / 255.0, 45.0 / 255.0),
        (1.0, 102.0 / 255.0, 0),
        (1.0, 1.0, 0),
        (1.0, 1.0, 1.0),
        ]
    
    var choseIndex:Int = 0
    //MARK: -Outlet
    
    @IBOutlet weak var tempImage: UIImageView!
    @IBOutlet var colorfulPencil : [UIButton]!
    
    @IBOutlet var bottomPencil : [NSLayoutConstraint]!
    
    //MARK: -Action
    
    
    @IBAction func share(sender: AnyObject) {
        UIGraphicsBeginImageContext(tempImage.bounds.size)
        tempImage.image?.drawInRect(CGRect(x: 0, y: 0,
            width: tempImage.frame.size.width, height: tempImage.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        presentViewController(activity, animated: true, completion: nil)
    }
    
    @IBAction func pencilPressed(sender: AnyObject) {
                // pencil
        brushWidth = 2.0
        var index = sender.tag ?? 0
        //make pencil up
        if index != choseIndex {
            bottomPencil[index].constant = 0
            bottomPencil[choseIndex].constant = -20
            choseIndex = index
            
        }
        
        if index < 0 || index >= colors.count {
            index = 0
        }
        
        // color
        (red, green, blue) = colors[index]
        
        // easer
        if index == colors.count - 1 {
            opacity = 1.0
            brushWidth = 20.0
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

extension MainController{
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = false
        if let touch = touches.first{
            lastPoint = touch.locationInView(view)
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = true
        if let touch = touches.first{
            let currentPoint = touch.locationInView(view)
            drawLine(lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !swiped {
            drawLine(lastPoint, toPoint: lastPoint)
        }
        
    }
    
    
    func drawLine(fromPoint:CGPoint , toPoint:CGPoint) {
        // set up draw in temp Image view
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImage.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        // line from last point to current point
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        // set line properties
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, brushWidth)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        // draw the context
        CGContextStrokePath(context)
        
        // wrap up the drawing context to render the new line into the temporary image view
        tempImage.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImage.alpha = opacity
        UIGraphicsEndImageContext()
    }
}

