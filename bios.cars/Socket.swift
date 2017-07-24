//
//  Socket.swift
//  bios.cars
//
//  Created by iOS Developer on 23/07/2017.
//  Copyright © 2017 fdapps. All rights reserved.
//

import Foundation
import Starscream

@objc public protocol SocketDelegate: class {
    
    func socketStatusChanged(_ socket: Socket, isConnected: Bool)
    func socket(_ socket: Socket, didReceive content: Any)
    @objc optional func socketErrorOccured(_ socket: Socket)
}

public class Socket: NSObject {
    
    public var _method = Method.infos
    public var _userToken: Int!
    private var _socket: WebSocket!
    
    public var delegate: SocketDelegate?
    public var method: Method {
        
        get {
            
            return _method
        }
    }
    
    public var isConnected: Bool {
        
        get {
            
            return _socket.isConnected
        }
    }
    
    public init(hostAddress: String, userToken: Int) {
        super.init()
    
        _userToken = userToken
        
        if let url = URL(string: hostAddress) {
            
            _socket = WebSocket(url: url)
            _socket.delegate = self
        }
    }
    
    public func connect() {
        
        _socket.connect()
    }
    
    public func disconnect() {
        
        _socket.disconnect()
    }
    
    public func send(method: Method = .infos, withPayload payload: [String: Any]? = nil) {
        
        var json: [String: Any] = ["Type": method.rawValue,
                                   "UserToken": _userToken]
        
        if let payload = payload {
            
            json["Payload"] = payload
        }
        
        guard _socket != nil && _socket.isConnected else {
            
            delegate?.socketErrorOccured?(self)
            return
        }
        
        do {
            
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            _socket.write(data: data)
            
        } catch {
            
            delegate?.socketErrorOccured?(self)
        }
    }
}

extension Socket: WebSocketDelegate {
    
    public func websocketDidConnect(socket: WebSocket) {
        
        DispatchQueue.main.async(execute: {
            [unowned self] _ in
            
            self.delegate?.socketStatusChanged(self, isConnected: true)
        })
        
    }
    
    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        
        DispatchQueue.main.async(execute: {
            [unowned self] _ in
            
            self.delegate?.socketStatusChanged(self, isConnected: false)
        })
    }
    
    public func websocketDidReceiveData(socket: WebSocket, data: Data) {
        
        DispatchQueue.main.async(execute: {
            [unowned self] _ in
            
            do {
                
                let content = try JSONSerialization.jsonObject(with: data, options: [])
                
                self.delegate?.socket(self, didReceive: content)
                
            } catch {
                
                self.delegate?.socketErrorOccured?(self)
            }
        })
    }
    
    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        
        if let data = text.data(using: .utf8, allowLossyConversion: false) {
            
            websocketDidReceiveData(socket: socket, data: data)
        }
    }
}
