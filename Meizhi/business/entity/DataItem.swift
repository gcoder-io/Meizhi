//
//  DataItem.swift
//  Meizhi
//
//  Created by snowleft on 15/9/17.
//  Copyright (c) 2015年 ancode. All rights reserved.
//

import UIKit

public class DataItem{
    var createdAt : String!
    var desc : String!
    var objectId : String!
    var publishedAt : String!
    var type : String!
    var updatedAt : String!
    var url : String!
    var used : Bool!
    var who : String!
    
    var cellHeight:CGFloat?
    
    /**
    * Instantiate the instance using the passed dictionary values to set the properties values
    */
    init(fromDictionary dictionary: NSDictionary){
        createdAt = dictionary["createdAt"] as? String
        desc = dictionary["desc"] as? String
        objectId = dictionary["objectId"] as? String
        publishedAt = dictionary["publishedAt"] as? String
        type = dictionary["type"] as? String
        updatedAt = dictionary["updatedAt"] as? String
        url = dictionary["url"] as? String
        used = dictionary["used"] as? Bool
        who = dictionary["who"] as? String
    }
    
    /**
    * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
    */
    func toDictionary() -> NSDictionary
    {
        var dictionary = NSMutableDictionary()
        if createdAt != nil{
            dictionary["createdAt"] = createdAt
        }
        if desc != nil{
            dictionary["desc"] = desc
        }
        if objectId != nil{
            dictionary["objectId"] = objectId
        }
        if publishedAt != nil{
            dictionary["publishedAt"] = publishedAt
        }
        if type != nil{
            dictionary["type"] = type
        }
        if updatedAt != nil{
            dictionary["updatedAt"] = updatedAt
        }
        if url != nil{
            dictionary["url"] = url
        }
        if used != nil{
            dictionary["used"] = used
        }
        if who != nil{
            dictionary["who"] = who
        }
        return dictionary
    }

}