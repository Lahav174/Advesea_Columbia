//
//  MutableDictionary.swift
//  MutableDictionary
//
//  Created by Lahav Lipson on 7/9/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import Foundation

class OrderedDictionary<keyType: NSObject, valueType>: NSObject {
    
    var mutableArray = NSMutableArray()
    
    var count: Int {
        return mutableArray.count
    }
    
    var keySet: Set<keyType> {
        var set = Set<keyType>()
        for e in mutableArray{
            let o = e as! ObjectTuple<keyType, Any>
            set.insert(o.a!)
        }
        return set
    }
    
    func insert(value: valueType, forKey key: keyType, atIndex index: Int){
        mutableArray.insertObject(ObjectTuple(first: key, second: value) as AnyObject, atIndex: index)
    }
    
    func add(value: valueType, forKey key: keyType){
        self.insert(value, forKey: key, atIndex: mutableArray.count)
    }
    
    func get(index: Int) -> ObjectTuple<keyType, valueType>{
        return mutableArray[index] as! ObjectTuple<keyType, valueType>
    }
    
    func get(key: keyType) -> valueType?{
        for e in mutableArray{
            let pair = e as! ObjectTuple<keyType, valueType>
            if pair.a!.isEqual(key){
                return pair.b
            }
        }
        return nil
    }
    
    func removeAll(){
        mutableArray.removeAllObjects()
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







