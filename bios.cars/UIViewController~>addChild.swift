//
//  UIViewController~>addChild.swift
//  bios.cars
//
//  Created by iOS Developer on 22/07/2017.
//  Copyright © 2017 fdapps. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    public func addChildController(_ controller: UIViewController, sourceView view: UIView) {
        
        addChildViewController(controller)
        view.addSubview(controller.view)
        
        controller.beginAppearanceTransition(true, animated: false)
        controller.endAppearanceTransition()
        
        controller.didMove(toParentViewController: self)
        
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller.view.frame = view.bounds
    }
}

