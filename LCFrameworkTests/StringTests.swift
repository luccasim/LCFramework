//
//  StringTests.swift
//  LCFrameworkTests
//
//  Created by owee on 08/10/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import XCTest
@testable import LCFramework

class StringTests: XCTestCase {

    func testRandom() throws {
        
        for i in 1...10 {
            print("\(i). : \(String.random(Pattern:"qwertyuiopalskdjfhgmznxbcv"))")
        }
        
    }
    
    func testRandomU() {
        for i in 1...10 {
            print("\(i). : \(String.randomU(Pattern:"qwertyuiopalskdjfhgmznxbcv"))")
        }
    }
    
    func testRandomWord() throws {
        
        for i in 1...10 {
            print("\(i). : \(String.randomWord())")
        }

    }
    
    func testRandomNoun() {
        
        for i in 1...10 {
            print("\(i). : \(String.randomNoun())")
        }
    }
    
    func testRandomName() {
    
        for i in 0...100 {
            print("\(i). : \(String.randomName())")
        }
        
    }
    
}
