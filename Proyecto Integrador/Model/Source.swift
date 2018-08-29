//
//  Source.swift
//  Proyecto Integrador
//
//  Created by VictorCh on 23/05/2018.
//  Copyright © 2018 Digital House. All rights reserved.
//

import Foundation

class Source: Decodable {
    
    private var id: String
    private var name: String
    private var description: String
    private var category : String
    var isSaved: Bool = false
    
    public init(id: String, name: String, description: String, category : String) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
    }
    
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String ?? "noSourceId"
        self.name = dictionary["name"] as? String ?? "noSourceName"
        self.description = dictionary["description"] as? String ?? "noDescription"
        self.category = dictionary["category"] as? String ?? "noCategory"
    }
    
    func getName() -> String{
        return name
    }
    func getId() -> String{
        return id
    }
    
    func getDescription() -> String {
        return description
    }
    
    func getCategory() -> String {
        return category
    }
    
    func toDictionary () -> [String:AnyObject]{
        var sourse : [String:AnyObject] = [:]
        
        sourse["name"] = self.name as AnyObject
        sourse["id"] = self.id as AnyObject
        sourse["description"] = self.description as AnyObject
        sourse["isSaved"] = self.isSaved as AnyObject
        sourse["category"] = self.category as AnyObject
        
        return sourse
    }
    
}
