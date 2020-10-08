//
//  String.swift
//  LCFramework
//
//  Created by owee on 08/10/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation

// MARK: - Randoms

extension String {
    
    static func random(Size:Int?=nil, Pattern:String) -> String {
        let size = Size ?? Int.random(in: 1...20)
        return String((1...size).compactMap({_ in Pattern.randomElement()}))
    }
    
    static func randomU(Size:Int?=nil, Pattern:String) -> String {
        var pat = Pattern
        let size = Size ?? Int.random(in: 1...pat.count)
        return String((1...size).compactMap({_ in
            let c = pat.randomElement()
            pat.removeAll(where: {$0 == c})
            return c
        }))
    }
    
    static func randomWord(Size:Int?=nil) -> String {
        return String.random(Size: Size, Pattern: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
    }
    
    static func randomNoun(Size:Int?=nil) -> String {
        return randomWord(Size: Size).lowercased()
    }
    
    static func randomName(Size:Int?=nil) -> String {
        
        let size = Size ?? Int.random(in: 4...10)
        
        let vowel = "aeiouy"
        let cons = "bcdfghjklmnpqrstvwxz"
        
        var newVowel : String {
            let percent = Int.random(in: 1...100)
            switch percent {
            case 1...5: return randomU(Size: 2, Pattern: vowel)
            case 6...9: return "y"
            case 10...20: return "o"
            case 21...30: return "u"
            case 31...40: return "i"
            default: return randomU(Size: 1, Pattern: "ae")
            }
        }
        
        /// 6% tripleU, 10% double, 48% doubleU, 30% one
        var newCons : String {
            let percent = Int.random(in: 1...100)
            let limited = "bcdflmnprst"
            switch percent {
            case 1: return "z"
            case 2: return "w"
            case 3: return "q"
            case 4: return "x"
            case 5: return "g"
            case 6: return "h"
            case 7: return "j"
            case 8: return "k"
            case 9: return "v"
            case 15...30: return random(Size: 2, Pattern: "mslpn")
            case 31...69: return randomU(Size: 2, Pattern: limited)
            case 70...100: return random(Size: 1, Pattern: limited)
            default: return randomU(Pattern: limited)
            }
        }
        
        var v = ""
        var c = ""
        
        if Int.random(in: 0...1) == 0 {
            v = random(Size: 1, Pattern: vowel)
        } else {
            c = random(Size: 1, Pattern: cons)
        }
        
        var name = ""

        for _ in 0..<size {
            
            if c.isEmpty && v.isEmpty {
                v = newVowel
                c = newCons
            }
            
            if let c = v.popLast() {
                name += "\(c)"
            }
            else if let c = c.popLast() {
                name += "\(c)"
            }
            
        }
        
        return name.capitalized
    }
}
