//
//  CarManager.swift
//  bios.cars
//
//  Created by iOS Developer on 22/07/2017.
//  Copyright © 2017 fdapps. All rights reserved.
//

import UIKit

public class CarManager: UIViewController {
    
    internal var _carView: CarView?
    internal var _socket: Socket?
    internal var _car: Car?
    
    public var car: Car? {
        
        get {
            
            return _car
        }
    }
    
    public init(car: Car) {
        super.init(nibName: nil, bundle: nil)
        
        _car = car
        _carView = CarView()
        
        if let address = Config.value(forKey: "address") as? String,
            let token = Config.value(forKey: "token") as? Int {
            
            _socket = Socket(hostAddress: address, userToken: token)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        super.loadView()
        
        view.addSubview(_carView!)
        
        _carView?.translatesAutoresizingMaskIntoConstraints = false
        
        let carViewHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[carView]|",
            options: [],
            metrics: nil,
            views: ["carView": _carView!])
        
        let carViewVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[carView]|",
            options: [],
            metrics: nil,
            views: ["carView": _carView!])
        
        var constraints = [NSLayoutConstraint]()
        
        constraints += carViewHorizontalConstraints
        constraints += carViewVerticalConstraints
        
        view.addConstraints(constraints)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        _carView?.buttonTouchBlock = {
            [unowned self] willStart in
            
            if willStart {
                
                self._socket?.send(method: .start, withPayload: ["Name": self._car!.name!])
                
            } else {
                
                self._socket?.send(method: .stop)
                self._carView?.currentSpeed = 0
            }
        }
        
        self._carView?.name = self._car?.name
        self._carView?.brand = self._car?.brand
        self._carView?.cv = self._car?.cv
        self._carView?.speedMax = self._car?.speedMax
        self._carView?.currentSpeed = 0
        
        _socket?.delegate = self
        _socket?.connect()
    }
    
    deinit {
        
        _socket?.disconnect()
    }
}

//Mark: delegate methods called after socket connection
extension CarManager: SocketDelegate {
    
    public func socketStatusChanged(_ socket: Socket, isConnected: Bool) {
        
    }
    
    public func socket(_ socket: Socket, didReceive content: Any) {
        
        if let value = content as? [String: Any] {
            
            if let currentSpeed = value["CurrentSpeed"] as? Int {
                
                _carView?.currentSpeed = currentSpeed
            }
        }
    }
}
