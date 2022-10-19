//
//  UIViewController + Extension.swift
//  News Feed
//
//  Created by Shahzaib Mumtaz on 22/06/2022.
//

import UIKit

extension UIViewController {
    
    class func instantiateFromStoryboard(_ name : String = "Main" ) -> Self {
        return instantiateFromStoryboardHelper(name)
    }
    
    fileprivate class func instantiateFromStoryboardHelper<T>(_ name: String) ->T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "\(Self.self)") as! T
        return controller
    }
}
