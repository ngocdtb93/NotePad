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
    //MARK: -Outlet
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var tempImage: UIImageView!
    
    //MARK: -Action
    
    @IBAction func reset(sender: AnyObject) {
    }
    
    @IBAction func share(sender: AnyObject) {
    }
    
    @IBAction func pencilPressed(sender: AnyObject) {
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
        CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        // draw the context
        CGContextStrokePath(context)
        
        // wrap up the drawing context to render the new line into the temporary image view
        tempImage.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImage.alpha = opacity
        UIGraphicsEndImageContext()
    }
}

