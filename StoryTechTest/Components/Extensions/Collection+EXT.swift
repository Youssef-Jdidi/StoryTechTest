//
//  Collection+EXT.swift
//  StoryTechTest
//
//  Created by Youssef JDIDI on 21/05/2025.
//

extension MutableCollection {
    public subscript(safe index: Index) -> Element? {
        get {
            indices.contains(index) ? self[index] : nil
        }
        set {
            guard indices.contains(index), let newValue else { return }
            self[index] = newValue
        }
    }
}
