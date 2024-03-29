//
//  SharedProperty.swift
//
//
//  Created by Cool Dude on 9/23/19.
//

import Foundation

// MARK: - SharedProperty
public class SharedProperty<T> {
    public var value: T!
    public var key: String!
    
    private init (key: String, value: T) {
        self.value = value
        self.key = key
    }
    
    public static func share<T>(key: String, value: T) -> SharedProperty<T> {
        if let property: SharedProperty<T> = SharedPropertyVault.shared().getProperty(key: key) {
            return property
        }
        
        let property = SharedProperty<T>(key: key, value: value)
        SharedPropertyVault.shared().registerProperty(key: property.key, property: property)
        return property
    }
    
    public func removeFromMemory() -> T? {
        return SharedPropertyVault.shared().removeProperty(property: self)?.value
    }
    
//    deinit {
//        print("SharedProperty deinit key:\(self.key)")
//    }

}

// MARK: - Operators overloading



// MARK: - Numeric operators
extension SharedProperty where T : Numeric {
    public static func +(property: SharedProperty<T>, num: T) -> T {
        return property.value + num
    }
    
    public static func +(property1: SharedProperty<T>, property2: SharedProperty<T>) -> T {
        return property1.value + property2.value
    }
    
    public static func -(property: SharedProperty<T>, num: T) -> T {
        return property.value - num
    }

    public static func -(property1: SharedProperty<T>, property2: SharedProperty<T>) -> T {
        return property1.value - property2.value
    }
    
    public static func *(property: SharedProperty<T>, num: T) -> T {
        return property.value * num
    }

    public static func *(property1: SharedProperty<T>, property2: SharedProperty<T>) -> T {
        return property1.value * property2.value
    }
}

// MARK: - Comparable operators
extension SharedProperty where T: Comparable {
    public static func == (property: SharedProperty<T>, compare: T) -> Bool {
        return property.value == compare
    }
    
    public static func == (property1: SharedProperty<T>, property2: SharedProperty<T>) -> Bool {
        return property1.value == property2.value
    }
    
    public static func != (property: SharedProperty<T>, compare: T) -> Bool {
        return property.value != compare
    }
    
    public static func != (property1: SharedProperty<T>, property2: SharedProperty<T>) -> Bool {
        return property1.value != property2.value
    }
    
    public static func > (property: SharedProperty<T>, compare: T) -> Bool {
        return property.value > compare
    }

    public static func > (property1: SharedProperty<T>, property2: SharedProperty<T>) -> Bool {
        return property1.value > property2.value
    }
    
    public static func >= (property: SharedProperty<T>, compare: T) -> Bool {
        return property.value >= compare
    }

    public static func >= (property1: SharedProperty<T>, property2: SharedProperty<T>) -> Bool {
        return property1.value >= property2.value
    }
    
    public static func < (property: SharedProperty<T>, compare: T) -> Bool {
        return property.value < compare
    }

    public static func < (property1: SharedProperty<T>, property2: SharedProperty<T>) -> Bool {
        return property1.value < property2.value
    }

    public static func <= (property: SharedProperty<T>, compare: T) -> Bool {
        return property.value <= compare
    }

    public static func <= (property1: SharedProperty<T>, property2: SharedProperty<T>) -> Bool {
        return property1.value <= property2.value
    }
}

// MARK: - Equal and assign
extension SharedProperty where T:Any {
    public static func << (property: SharedProperty<T>, compare: T) {
        property.value = compare
    }

    public static func <<(property1: SharedProperty<T>, property2: SharedProperty<T>) {
        property1.value = property2.value
    }
    
}

// MARK: - SharedPropertyHolder
public class SharedPropertyHolder {
    var sharedProperties = [String]()
    
    public init(){
    }
    
    public func addSharedProperty(propertyKey: String) {
        self.sharedProperties.append(propertyKey)
    }
    
    deinit {
        print("Deinit called for SharedPropertyHolder")
        for key in sharedProperties {
            _ = SharedPropertyVault.shared().removeProperty(key: key)
        }
    }
}

// MARK: - SharePropertyVault
fileprivate class SharedPropertyVault {
    
    // MARK: - TODO
    // 1. Improve the logs

    // MARK: - Singleton implementation
    private static var sharedSharedPropertyVault: SharedPropertyVault = {
        let sharedPropertyVault = SharedPropertyVault()
        return sharedPropertyVault
    }()

    private init() {
    
    }
    
    class func shared() -> SharedPropertyVault {
        return sharedSharedPropertyVault
    }
    
    
    // MARK: - Properties
    let shouldLog = true
    var sharedProperties : [String: Any] = [String: Any]()
    
    
    // MARK: - Functions
    func registerProperty (key: String, property: Any) {
        if (self.sharedProperties[key] == nil) {
            self.sharedProperties[key] = property
            if (shouldLog) {
                print("Property: \(key) added to vault")
            }
        } else {
            if (shouldLog) {
                print("Property: \(key) already declared please don't overwrite")
            }
        }
    }
    
    func removeProperty<T> (property: SharedProperty<T>) -> SharedProperty<T>? {
        guard let key = property.key else {
            return nil
        }
        if (self.sharedProperties[key] == nil) {
            if (shouldLog) {
                print("Property: \(key) not found in vault")
            }
            return nil
        } else {
            if (shouldLog) {
                print("Property: \(key) removed from vault")
            }
            return self.sharedProperties.removeValue(forKey: key) as? SharedProperty<T>
        }
    }
    
    func removeProperty(key: String) -> Any? {
        if (self.sharedProperties[key] == nil) {
            if (shouldLog) {
                print("Property: \(key) not found in vault")
            }
            return nil
        } else {
            if (shouldLog) {
                print("Property: \(key) removed from vault")
            }
            return self.sharedProperties.removeValue(forKey: key)
        }
    }
    
    func getProperty<T> (key: String) -> SharedProperty<T>? {
        if (self.sharedProperties[key] == nil) {
            if (shouldLog) {
                print("(getProperty) Property: \(key) not found in vault")
                print(self.sharedProperties.count)
                print(key)
            }
            return nil
        } else {
            if (shouldLog) {
                print("(getProperty) Property: \(key) get from vault")
            }
            return self.sharedProperties[key] as? SharedProperty<T>
        }
    }
}
