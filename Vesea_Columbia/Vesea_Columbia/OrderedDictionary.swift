//
//  MutableDictionary.swift
//  MutableDictionary
//
//  Created by Lahav Lipson on 7/9/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import Foundation

class OrderedDictionary<valueType>: NSObject {
    
    var mainDictionary = NSMutableDictionary()
    var mainArray = Array<ObjectTuple<NSString,valueType>>()
    
    var count: Int {
        return mainArray.count
    }
    
    func insert(value: valueType, forKey key: NSString, atIndex index: Int){
        mainDictionary.setValue(ObjectTuple(first: index, second: value) as AnyObject, forKey: String(key))
        mainArray.insert(ObjectTuple(first: key, second: value), atIndex: index)
    }
    
    func get(index: Int) -> ObjectTuple<NSString, valueType>?{
        return mainArray[index]
    }
    
    func get(key: String) -> valueType?{
        if let obj = mainDictionary[key] {
            let tuple = obj as! ObjectTuple<Int,valueType>
            return tuple.b
        }
        return nil
    }
    
    func removeAll(){
        mainArray.removeAll()
        mainDictionary.removeAllObjects()
    }
    
}

class ObjectTuple<type1, type2>: NSObject {
    
    override var description: String {
        return "(" + String(a!) + ", " + String(b!) + ")"
    }
    
    var a : type1?
    var b : type2?
    
    init(first: type1? = nil, second: type2? = nil) {
        super.init()
        a = first
        b = second
    }
    
    func bothNotNil() -> Bool{
        return a != nil && b != nil
    }
}







