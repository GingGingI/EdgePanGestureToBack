//
//  ViewController.swift
//  EdgePanGestureToBack
//
//  Created by 깅징이 on 28/01/2019.
//  Copyright © 2019 깅징이. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var edgePanGesture: UIScreenEdgePanGestureRecognizer!

//    BackPressdindicatorView
    @IBOutlet weak var IndicatorView: UIView!
//    BackPressdConstraint
    @IBOutlet weak var BackIndicator: NSLayoutConstraint!
    
//    ImpactGenerator
    private let impact = UIImpactFeedbackGenerator()
//    MAX Value
    private var MAX: CGFloat = 150.0
//    Check is BackPressing
    private var onBackProgressing: Bool = false
    private var AgainBlocker: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    
        edgePanGesture.edges = .left
        edgePanGesture.delegate = self as? UIGestureRecognizerDelegate
    }
    
    @IBAction func edgePanGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .began { AgainBlocker = false }
        if sender.state == .ended && !onBackProgressing{
            onBackProgressing = true
            
            UIView.animate(withDuration: 0.3, animations: {
//                slide out
//                self.BackIndicator.constant = CGFloat(-150.0)
                self.IndicatorView.alpha = 0.0
                
                self.view.layoutIfNeeded()
            }, completion: {(finished: Bool) in
                self.onBackProgressing = false
                
//                    use when using Fade out
                self.BackIndicator.constant = CGFloat(-150.0)
            })
        }
        
        if !onBackProgressing && !AgainBlocker {
            let Percent: Float = getPercent(max: MAX, value: sender.translation(in: self.view).x)
        
            if (Percent >= 1.0 && !onBackProgressing) {
//                print("DDing!")
                IndicatorView.alpha = CGFloat(0.5)
                
                onBackProgressing = true
                impact.impactOccurred()
                
                UIView.animate(withDuration: 1.2, animations: {
//                    Slide out
//                    self.BackIndicator.constant = CGFloat(-150.0)
//                    Fade out
                    self.IndicatorView.alpha = 0.0
                    self.view.layoutIfNeeded()
                }, completion: {(finished: Bool) in
                    self.AgainBlocker = true
                    self.onBackProgressing = false
                    
//                    use when using Fade out
                    self.BackIndicator.constant = CGFloat(-150.0)
                })
            } else {
                UIView.animate(withDuration: 0.05, animations: {
                    self.IndicatorView.alpha = self.adInterPolator(value: Percent, mag: 0.5)
                    self.BackIndicator.constant = CGFloat(-150.0 + (150 * Percent))
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func getPercent(max: CGFloat, value: CGFloat) -> Float {
        return Float(value / max)
    }
    
    func adInterPolator(value: Float, mag: Float) -> CGFloat {
        return CGFloat(Float(cos(Double.pi * Double(value+1)) / 2 + 0.5) * mag)
    }
}
