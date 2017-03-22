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
            updateUI()
        }
    }
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: faceView,
                action: #selector(FaceView.changeScale)
            ))
            
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            happierSwipeGestureRecognizer.direction = .up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            
            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            sadderSwipeGestureRecognizer.direction = .down
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)

            updateUI()
        }
    }
    
    func respondToSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
//        if gesture.direction.contains(.up) {}
//        if gesture.direction.contains(.down) {}

        switch gesture.direction {
        case [.right]:
            print("Swiped right")
        case [.down]:
            expression.mouth = expression.mouth.sadderMouth()
            print("Swiped down")
        case [.left]:
            print("Swiped left")
        case [.up]:
            expression.mouth = expression.mouth.happierMouth()
            print("Swiped up")
        default:
            break
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
    
    private var mouthCurvatures = [FacialExpression.Mouth.frown: -1.0, .smirk: -0.5, .neutral: 0.0, .grin: 0.5, .smile: 1.0]
    private var browTilts = [FacialExpression.EyeBrows.furrowed: -0.5, .normal: 0.0, .relaxed: 0.5]
    
    private func updateUI() {
        switch expression.eyes {
        case .open: faceView.eyesOpen = true
        case .closed: faceView.eyesOpen = false
        case .squinting: faceView.eyesOpen = false
        }
        
        faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
        faceView.eyeBrowTilt = browTilts[expression.eyeBrows] ?? 0.0
    }
}

