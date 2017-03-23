//
//  FaceView.swift
//  FaceIt
//
//  Created by Andrij Trubchanin on 1/4/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    
    @IBInspectable
    var scale: CGFloat = 0.9 { didSet { setNeedsDisplay() } }           // scale face to fit bounds
    @IBInspectable
    var mouthCurvature: Double = 1.0  { didSet { setNeedsDisplay() } }   // 1 - full smile, -1 - full frown
    @IBInspectable
    var eyesOpen: Bool = false { didSet { setNeedsDisplay() } }
    @IBInspectable
    var eyeBrowTilt: Double = 0.5 { didSet { setNeedsDisplay() } }     // -1 full furrow, 1 - full relaxed
    @IBInspectable
    var color: UIColor = .red { didSet { setNeedsDisplay() } }
    @IBInspectable
    var lineWidth: CGFloat = 10.0 { didSet { setNeedsDisplay() } }
    
    func changeScale(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            scale *= recognizer.scale
            recognizer.scale  = 1.0
        default: break
        }
    }
    
    private var skullRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    private var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private struct Ratios {
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffset: CGFloat = 3
        static let SkullRadiusToBrowOffset: CGFloat = 5
    }
    
    private enum Eye {
        case left
        case right
    }
    
    private func pathForCircle(atPoint midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: midPoint, radius: radius, startAngle: 0.0, endAngle: 2*CGFloat.pi, clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    
    private func getEyeCenter(_ eye: Eye) -> CGPoint {
        let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        eyeCenter.x += (eye == .left ? -1 : 1) * eyeOffset
        return eyeCenter
    }

    private func pathForEye(_ eye: Eye) -> UIBezierPath {
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let eyeCenter = getEyeCenter(eye)
        if eyesOpen {
            return pathForCircle(atPoint: eyeCenter, withRadius: eyeRadius)
        } else {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
            path.lineWidth = lineWidth
            return path
        }
    }
    
    private func pathForBrow(_ eye: Eye) -> UIBezierPath {
        var tilt = eyeBrowTilt
        switch eye {
        case .left: tilt *= -1.0
        case .right: break
        }
        var browCenter = getEyeCenter(eye)
        browCenter.y -= skullRadius / Ratios.SkullRadiusToBrowOffset
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let tiltOffset = CGFloat(max(-1, min(1, tilt))) * eyeRadius / 2
        let browStart = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
        let browEnd = CGPoint(x: browCenter.x + eyeRadius, y: browCenter.y + tiltOffset)
        let path = UIBezierPath()
        path.move(to: browStart)
        path.addLine(to: browEnd)
        path.lineWidth = lineWidth
        return path
    }
    
    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth/2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        let smileOffset = CGFloat(max(-1,min(1,mouthCurvature))) * mouthHeight
        
        // start, end
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)

        // control points
        let cp1 = CGPoint(x: mouthRect.minX + mouthWidth/3, y: mouthRect.midY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthWidth/3, y: mouthRect.midY + smileOffset)
        
        // Bezier curve
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    override func draw(_ rect: CGRect) {
        color.set()
        pathForCircle(atPoint: skullCenter, withRadius: skullRadius).stroke()
        pathForEye(.left).stroke()
        pathForEye(.right).stroke()
        pathForMouth().stroke()
        pathForBrow(.left).stroke()
        pathForBrow(.right).stroke()
    }
}
