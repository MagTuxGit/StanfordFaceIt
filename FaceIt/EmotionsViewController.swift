//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by Andrij Trubchanin on 4/4/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

import UIKit

class EmotionsViewController: VCLLoggingViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if let navigationViewController = destinationViewController as? UINavigationController {
            destinationViewController = navigationViewController.visibleViewController ?? destinationViewController
        }
        if let faceViewController = destinationViewController as? FaceViewController,
            let identifier = segue.identifier,
            let facialExpression = emotionalFaces[identifier] {
                faceViewController.expression = facialExpression
                faceViewController.navigationItem.title = (sender as? UIButton)?.currentTitle
        }
    }
    
    private let emotionalFaces: Dictionary<String, FacialExpression> = [
        "happy" : FacialExpression(eyes: .open, eyeBrows: .normal, mouth: .smile),
        "sad" : FacialExpression(eyes: .closed, eyeBrows: .relaxed, mouth: .frown),
        "worried" : FacialExpression(eyes: .open, eyeBrows: .relaxed, mouth: .smirk)
    ]
}
