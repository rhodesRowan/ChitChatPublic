//
//  DiffCalculator+Helpers.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import Foundation


struct ReloadableSection<N: Equatable>: Equatable {
    var key: String
    var value: [ReloadableCell<N>]
    var index: Int
    
    static func ==(lhs: ReloadableSection, rhs: ReloadableSection) -> Bool {
        return lhs.key == rhs.key && lhs.value == rhs.value
    }
}

struct ReloadableCell<N: Equatable>: Equatable {
    var key: String
    var value: N
    var index: Int
    
    static func ==(lhs: ReloadableCell, rhs: ReloadableCell) -> Bool {
        return lhs.key == rhs.key && lhs.value == rhs.value
    }
}

struct ReloadableSectionData<N: Equatable> {
    var items = [ReloadableSection<N>]()
    
    subscript(key: String) -> ReloadableSection<N>? {
        get {
            return items.filter {$0.key == key}.first
        }
    }
    
    subscript(index: Int) -> ReloadableSection<N>? {
        get {
            return items.filter {$0.index == index}.first
        }
    }
}

struct ReloadableCellData<N: Equatable> {
    var items = [ReloadableCell<N>]()
    
    subscript(key: String) -> ReloadableCell<N>? {
        get {
            return items.filter {$0.key == key}.first
        }
    }
    
    subscript(index: Int) -> ReloadableCell<N>? {
        get {
            return items.filter {$0.index == index}.first
        }
    }
}
