//
//  FacialExpression.swift
//  FaceIt
//
//  Created by Andrij Trubchanin on 3/21/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

import Foundation

struct FacialExpression {
    enum Eyes: Int {
        case open
        case closed
        case squinting
    }
    
    enum EyeBrows: Int {
        case relaxed
        case normal
        case furrowed
        
        func moreRelaxed() -> EyeBrows {
            return EyeBrows(rawValue: rawValue - 1) ?? .relaxed
        }

        func moreFurrowed() -> EyeBrows {
            return EyeBrows(rawValue: rawValue + 1) ?? .furrowed
        }
    }
    
    enum Mouth: Int {
        case frown
        case smirk
        case neutral
        case grin
        case smile
        
        //func sadderMouth() -> Mouth {
        var sadder: Mouth {
            return Mouth(rawValue: rawValue - 1) ?? .frown
        }
        //func happierMouth() -> Mouth {
        var happier: Mouth {
            return Mouth(rawValue: rawValue + 1) ?? .smile
        }
    }
    
    var sadder: FacialExpression {
        return FacialExpression(eyes: self.eyes, eyeBrows: self.eyeBrows.moreRelaxed(), mouth: self.mouth.sadder)
    }
    
    var happier: FacialExpression {
        return FacialExpression(eyes: self.eyes, eyeBrows: self.eyeBrows.moreFurrowed(), mouth: self.mouth.happier)
    }

    var eyes: Eyes
    var eyeBrows: EyeBrows
    var mouth: Mouth
}
