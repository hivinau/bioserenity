//
//  CarsDisplayer.swift
//  bios.cars
//
//  Created by iOS Developer on 22/07/2017.
//  Copyright © 2017 fdapps. All rights reserved.
//

import UIKit

public protocol CarsDisplayerDelegate: class {
    
    func carsDisplayer(_ carsDisplayer: CarsDisplayer, showCarAt indexPath: IndexPath)
}

public class CarsDisplayer: UIPageViewController {
    
    internal var controllers: [UIViewController]?
    internal let locker = NSLock()
    
    public var carsDisplayerDelegate: CarsDisplayerDelegate?
    
    public init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        controllers = [UIViewController]()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        let views = view.subviews.filter({
            view in
            
            return view is UIScrollView
        })
        
        if views.count == 1,
            let scrollView = views.first as? UIScrollView {
            
            scrollView.isScrollEnabled = true
            scrollView.delegate = self
        }
    }
}

//Mark: manage controllers displaying while user scrolls left/right
extension CarsDisplayer: UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let current = controllers!.index(of: viewController) else {
            
            return nil
        }
        
        let previous = current - 1
        
        guard previous >= 0 else {
            
            //return controllers.last //uncomment for infinite loop
            return nil
        }
        
        guard controllers!.count > previous else {
            
            return nil
        }
        
        return controllers![previous]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let current = controllers!.index(of: viewController) else {
            
            return nil
        }
        
        let next = current + 1
        
        guard controllers!.count != next else {
            
            //return controllers.first //uncomment for infinite loop
            return nil
        }
        
        guard controllers!.count > next else {
            
            return nil
        }
        
        return controllers![next]
    }

}

//Mark: manage cars displayed
extension CarsDisplayer {
    
    /**
     Add car to displayer, user can see datas related to this car.
     
     - Parameter car: car object to add. Note: This has no effect on the display of cars.
     */
    public func add(car: Car) {
        
        locker.lock() ; defer { locker.unlock() }
        
        let carManager = CarManager(car: car)
        
        controllers?.append(carManager)
        
        if let controllers = viewControllers,
            let controller = controllers.last {
            
            setViewControllers([controller], direction: .forward, animated: false, completion: nil)
        } else {
            
            setViewControllers([controllers!.first!], direction: .forward, animated: false, completion: nil)
        }
    }
    
    /**
     Remove car from displayer.
     
     - Parameter car: car object to remove. Note: This has no effect on the display of cars.
     */
    public func remove(car: Car) {
        
        locker.lock() ; defer { locker.unlock() }
        
        controllers?.forEach({
            controller in
            
            if let carManager = controller as? CarManager,
                let compared = carManager.car {
                
                if car == compared {
                    
                    if let index = controllers!.index(of: carManager) {
                        
                        controllers?.remove(at: index)
                    }
                }
            }
        })
    }
    
    public func removeAll() {
        
        locker.lock() ; defer { locker.unlock() }
        
        controllers?.removeAll()
    }
}

extension CarsDisplayer: UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if finished && completed {
            
            notify()
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        notify()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
            
            scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        scrollViewDidEndDecelerating(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        notify()
    }

    private func notify() {
        
        if let controllers = viewControllers,
            let controller = controllers.last {
            
            if let index = self.controllers!.index(of: controller) {
                
                carsDisplayerDelegate?.carsDisplayer(self, showCarAt: IndexPath(row: index, section: 0))
            }
        }
    }

}
