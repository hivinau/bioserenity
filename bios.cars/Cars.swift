//
//  Cars.swift
//  bios.cars
//
//  Created by iOS Developer on 20/07/2017.
//  Copyright © 2017 fdapps. All rights reserved.
//

import UIKit

public class Cars: UIViewController {
    
    private var container: UIView?
    
    internal var socket: Socket?
    internal var pageControl: UIPageControl?
    internal lazy var carsDisplayer: CarsDisplayer = {
        
        return CarsDisplayer()
    }()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        
        container = UIView()
        pageControl = UIPageControl()
        
        if let address = Config.value(forKey: "address") as? String,
            let token = Config.value(forKey: "token") as? Int {
            
            socket = Socket(hostAddress: address, userToken: token)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        super.loadView()
        
        view.addSubview(container!)
        view.insertSubview(pageControl!, aboveSubview: container!)
        
        container?.translatesAutoresizingMaskIntoConstraints = false
        pageControl?.translatesAutoresizingMaskIntoConstraints = false
        
        let containerHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[container]|",
            options: [],
            metrics: nil,
            views: ["container": container!])
        
        let containerTopConstraint = NSLayoutConstraint(item: container!,
                                                        attribute: .top,
                                                        relatedBy: .equal,
                                                        toItem: topLayoutGuide,
                                                        attribute: .bottom,
                                                        multiplier: 1.0,
                                                        constant: 0)
        
        let containerBottomConstraint = NSLayoutConstraint(item: bottomLayoutGuide,
                                                        attribute: .top,
                                                        relatedBy: .equal,
                                                        toItem: container!,
                                                        attribute: .bottom,
                                                        multiplier: 1.0,
                                                        constant: 0)
        
        let pageControlBottomConstraint = NSLayoutConstraint(item: pageControl!,
                                                           attribute: .bottom,
                                                           relatedBy: .equal,
                                                           toItem: container!,
                                                           attribute: .bottom,
                                                           multiplier: 1.0,
                                                           constant: 0)
        
        let pageControlCenterXConstraint = NSLayoutConstraint(item: pageControl!,
                                                             attribute: .centerX,
                                                             relatedBy: .equal,
                                                             toItem: view,
                                                             attribute: .centerX,
                                                             multiplier: 1.0,
                                                             constant: 0)
        
        let pageControlHeightConstraint = NSLayoutConstraint(item: pageControl!,
                                                              attribute: .height,
                                                              relatedBy: .equal,
                                                              toItem: nil,
                                                              attribute: .notAnAttribute,
                                                              multiplier: 1.0,
                                                              constant: 20.0)
        
        var constraints = [NSLayoutConstraint]()
        
        constraints += containerHorizontalConstraints
        constraints.append(containerTopConstraint)
        constraints.append(containerBottomConstraint)
        constraints.append(pageControlBottomConstraint)
        constraints.append(pageControlCenterXConstraint)
        constraints.append(pageControlHeightConstraint)
        
        view.addConstraints(constraints)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addChildController(carsDisplayer, sourceView: container!)
        
        pageControl?.pageIndicatorTintColor = .gray
        pageControl?.currentPageIndicatorTintColor = .green
        pageControl?.numberOfPages = 0
        pageControl?.currentPage = 0
        
        carsDisplayer.carsDisplayerDelegate = self
        socket?.delegate = self
        
        socket?.connect()
    }
    
    deinit {
        
        socket?.disconnect()
    }
}

//Mark: notify position of car currently displayed
extension Cars: CarsDisplayerDelegate {
    
    public func carsDisplayer(_ carsDisplayer: CarsDisplayer, showCarAt indexPath: IndexPath) {
        
        pageControl?.currentPage = indexPath.row
    }
}

//Mark: delegate methods called after socket connection
extension Cars: SocketDelegate {
    
    public func socketStatusChanged(_ socket: Socket, isConnected: Bool) {
        
        if !isConnected {
            
            carsDisplayer.removeAll()
            pageControl?.currentPage = 0
        } else {
            
            //load cars
            socket.send()
        }
    }
    
    public func socket(_ socket: Socket, didReceive content: Any) {
        
        if let values = content as? [[String: Any]],
            values.count > 0 {
            
            var cars = [Car]()
            
            values.forEach({
                value in
                
                let car = Car(brand: value["Brand"] as? String,
                              name: value["Name"] as? String,
                              speedMax: value["SpeedMax"] as? Int,
                              cv: value["Cv"] as? Int,
                              currentSpeed: value["CurrentSpeed"] as? Int)
                
                cars.append(car)
            })
            
            pageControl?.numberOfPages = cars.count
            pageControl?.currentPage = 0
            
            cars.forEach({
                car in
                
                carsDisplayer.add(car: car)
            })
        }
    }
}
