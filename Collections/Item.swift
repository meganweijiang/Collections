//
//  Item.swift
//  Collections
//
//  Created by Megan Weijiang on 2/23/17.
//  Copyright © 2017 Megan Weijiang. All rights reserved.
//

import UIKit
import os.log

class Item {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var description: String?
    var favorite: Bool
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let description = "description"
        static let favorite = "favorite"
    }
    
    
    //MARK: Initialization
    
    init?(name: String, photo: UIImage?, description: String?,
        favorite: Bool) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // Stored properties
        self.name = name
        self.photo = photo
        self.description = description
        self.favorite = favorite
    }
    
}
