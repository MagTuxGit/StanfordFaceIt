//
//  FaceViewController.swift
//  FaceIt
//
//  Created by Andrij Trubchanin on 1/4/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    var expression = FacialExpression(eyes: .open, eyeBrows: .normal, mouth: .smile) {
        didSet {
            // called every time expression changes, but not iitializes
            updateUI()
        }
    }
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            // called only once when iOS hooks up this outlet to it's view
            
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: faceView,
                action: #selector(FaceView.changeScale)
            ))
            
//            faceView.addGestureRecognizer(UITapGestureRecognizer(
//                target: self,
//                action: #selector(toggleEyes(_:))
//            ))

            let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
            swipeUpGestureRecognizer.direction = .up
            faceView.addGestureRecognizer(swipeUpGestureRecognizer)
            
            let swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
            swipeDownGestureRecognizer.direction = .down
            faceView.addGestureRecognizer(swipeDownGestureRecognizer)

            updateUI()
        }
    }
    
    func respondToSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
//        if gesture.direction.contains(.up) {}
//        if gesture.direction.contains(.down) {}

        switch gesture.direction {
        case [.right]: break
            //print("Swiped right")
        case [.down]:
            expression = expression.sadder
            //print("Swiped down")
        case [.left]: break
            //print("Swiped left")
        case [.up]:
            expression = expression.happier
            //print("Swiped up")
        default: break
        }
    }
    
    @IBAction func toggleEyes(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            switch expression.eyes {
            case .closed:
                expression.eyes = .open
            case .open:
                expression.eyes = .closed
            case .squinting:
                break
            }
        }
    }
    
    private let mouthCurvatures = [FacialExpression.Mouth.frown: -1.0, .smirk: -0.5, .neutral: 0.0, .grin: 0.5, .smile: 1.0]
    private let browTilts = [FacialExpression.EyeBrows.furrowed: -0.5, .normal: 0.0, .relaxed: 0.5]
    
    private func updateUI() {
        // faceView can be nil when the outlet is not hooked up yet
        if faceView == nil { return }
        
        switch expression.eyes {
        case .open: faceView.eyesOpen = true
        case .closed: faceView.eyesOpen = false
        case .squinting: faceView.eyesOpen = false
        }
        
        faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
        faceView.eyeBrowTilt = browTilts[expression.eyeBrows] ?? 0.0
    }
}
