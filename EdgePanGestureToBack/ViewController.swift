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

//    BackPressdConstraint
    @IBOutlet weak var BackIndicator: NSLayoutConstraint!
    
//    ImpactGenerator
    private let impact = UIImpactFeedbackGenerator()
//    MAX Value
    private var MAX: CGFloat = 150.0
//    Check is BackPressing
    private var onBackProgressing: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    
        edgePanGesture.edges = .left
        edgePanGesture.delegate = self as? UIGestureRecognizerDelegate
    }
    
    @IBAction func edgePanGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        if !onBackProgressing {
            let Percent: Float = getPercent(max: MAX, value: sender.translation(in: self.view).x)
        
            if (Percent >= 1.0) {
//                print("DDing!")
                onBackProgressing = true
                impact.impactOccurred()
                
                UIView.animate(withDuration: 1.2, animations: {
                    self.BackIndicator.constant = -150
                    self.view.layoutIfNeeded()
                }, completion: {(finished: Bool) in
                    self.onBackProgressing = false
                })
            } else {
//                print("panGesture : ", sender.translation(in: self.view).x)
//                print("percent : ", Percent)
                UIView.animate(withDuration: 0.05, animations: {
                    self.BackIndicator.constant = CGFloat(-125.0 + (125 * Percent))
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func getPercent(max: CGFloat, value: CGFloat) -> Float {
        return Float(value / max)
    }
    
}
