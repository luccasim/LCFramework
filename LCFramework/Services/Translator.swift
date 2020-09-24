//
//  Translator.swift
//  Pokedex
//
//  Created by owee on 14/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import Foundation

protocol TranslatorInterface {
    
    var langs : [String] {get}
    
    func register(NewLang:String)
    func select(Lang:String)
    
    func translate(Key:String) -> String?
    func translate(Lang:String, Key:String) -> String?

    func set(Key:String, NewText:String, ForLang:String)
    func removeAll()
    
}

public final class Translator : TranslatorInterface {
    
    typealias Text = [String:String]
    typealias Lang = [String:Text]
    
    init() {
        self.translator["en"] = [:]
        self.selectedLang = "en"
    }
    
    public static let shared = Translator()
    
    private var translator : Lang = [:]
    private var selectedLang = ""

}

public extension Translator {
    
    private func getKeys(Lang:String) -> [String] {
        return self.translator[Lang]?.keys.map({$0}) ?? []
    }
    
    var langs : [String] {
        return translator.keys.map({$0})
    }
    
    func register(NewLang:String) {
        self.translator[NewLang] = [:]
    }
    
    func select(Lang:String) {
        if self.langs.contains(Lang) {
            self.selectedLang = Lang
        }
    }
    
    func set(Key:String, NewText:String, ForLang:String) {
        
        if nil == self.translator[ForLang] {
            self.register(NewLang: ForLang)
        }
        
        self.translator[ForLang]?[Key] = NewText
    }
    
    func translate(Key:String) -> String? {
        return self.translator[self.selectedLang]?[Key]
    }
    
    func translate(Lang:String, Key:String) -> String? {
        return self.translator[Lang]?[Key]
    }
    
    func removeAll() {
        self.translator = [:]
    }
}

public extension String {
    
    var translate : String {
        return Translator.shared.translate(Key: self) ?? self
    }
    
}
