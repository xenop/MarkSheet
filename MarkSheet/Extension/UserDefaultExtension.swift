//
//  UserDefaultExtension.swift
//  
//
//  Created by _ xenop on 2017/11/09.
//

import Foundation

protocol KeyNamespaceable {
    func namespaced<T: RawRepresentable>(_ key: T) -> String
}

extension KeyNamespaceable {

    func namespaced<T: RawRepresentable>(_ key: T) -> String {
        return "\(Self.self).\(key.rawValue)"
    }
}

protocol StringDefaultSettable: KeyNamespaceable {
    associatedtype StringKey: RawRepresentable
}

extension StringDefaultSettable where StringKey.RawValue == String {

    func set(_ value: Bool, forKey key: StringKey) {
        let key = namespaced(key)
        UserDefaults.standard.set(value, forKey: key)
    }

    @discardableResult
    func bool(forKey key: StringKey) -> Bool {
        let key = namespaced(key)
        return UserDefaults.standard.bool(forKey: key)
    }
}

extension UserDefaults: StringDefaultSettable {
    enum StringKey: String {
        case introDidShow
    }
}
