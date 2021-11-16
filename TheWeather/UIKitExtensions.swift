//
//  UIKitExtensions.swift
//
//  Created by Matthew Carroll on 9/5/16.
//  Copyright © 2016 Matthew Carroll. All rights reserved.
//

import UIKit

extension NSLayoutDimension {
    
    func constrain(to: CGFloat) {
        constraint(equalToConstant: to).isActive = true
    }
    
    func constrain(to: NSLayoutDimension, multiplier: CGFloat = 1) {
        constraint(equalTo: to, multiplier: multiplier).isActive = true 
    }
}

extension NSLayoutAnchor {
    
    @objc func constrain(equalTo anchor: NSLayoutAnchor<AnchorType>, constant c: CGFloat) {
        constraint(equalTo: anchor, constant: c).isActive = true
    }

}

extension UIAlertController {

    convenience init(title: String?, ok: ((UIAlertAction) -> ())?) {
        self.init(title: title, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: ok)
        addAction(okAction)
    }
    
    convenience init(title: String?, ok: ((UIAlertAction) -> ())?, cancel: ((UIAlertAction) -> ())?) {
        self.init(title: title, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: ok)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancel)
        addAction(okAction)
        addAction(cancelAction)
    }
    
    static func show(from: UIViewController, title: String?, ok: ((UIAlertAction) -> ())?) {
        let alert = UIAlertController(title: title, ok: ok)
        OperationQueue.main.addOperation { from.present(alert, animated: true, completion: nil) }
    }
}

