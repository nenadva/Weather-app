//
//  StoryboardInstance.swift
//
//  Created by Matthew Carroll on 12/21/16.
//  Copyright © 2016 Third Cup lc. All rights reserved.
//

import UIKit


protocol StoryboardInstance: NSObjectProtocol {
    
    static var controllerID: String { get }
    static var storyboardName: String { get }
    static var storyboardInstance: Self { get }
}


extension StoryboardInstance {
    
    static var storyboardName: String { return "Main" }
    
    static var storyboardInstance: Self {
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: controllerID) as! Self
    }
}
