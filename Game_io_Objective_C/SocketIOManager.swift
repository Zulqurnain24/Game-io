//
//  SocketIOManager.swift
//  SocketChat
//
//  Created by Gabriel Theodoropoulos on 1/31/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    
    var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: "http://192.168.1.XXX:3000")!)
    
    
    override init() {
        super.init()
    }
    
    
    func establishConnection() {
        socket.connect()
    }
    
    
    func closeConnection() {
        socket.disconnect()
    }
    
    
    func connectToServerWithNickname(_ nickname: String, completionHandler: @escaping (_ userList: [[String: AnyObject]]?) -> Void) {
//        socket.emit("connectUser", nickname as AnyObject)
//        
//        socket.on("userList") { ( dataArray, ack) -> Void in
//            completionHandler(dataArray[0] as! [[String: AnyObject]])
//        }
        
        listenForOtherMessages()
    }
    
    
    func exitChatWithNickname(_ nickname: String, completionHandler: () -> Void) {
//        socket.emit("exitUser", nickname as AnyObject)
        completionHandler()
    }
    
    
    func sendMessage(_ message: String, withNickname nickname: String) {
//        socket.emit("chatMessage", nickname as AnyObject, message as AnyObject)
    }
    
    
    func getChatMessage(_ completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void) {
        socket.on("newChatMessage") { (dataArray, socketAck) -> Void in
            var messageDictionary = [String: AnyObject]()
            messageDictionary["nickname"] = dataArray[0] as! String as AnyObject?
            messageDictionary["message"] = dataArray[1] as! String as AnyObject?
            messageDictionary["date"] = dataArray[2] as! String as AnyObject?
            
            completionHandler(messageDictionary)
        }
    }
    
    
    fileprivate func listenForOtherMessages() {
        socket.on("userConnectUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "userWasConnectedNotification"), object: dataArray[0] as! [String: AnyObject])
        }
        
        socket.on("userExitUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "userWasDisconnectedNotification"), object: dataArray[0] as! String)
        }
        
        socket.on("userTypingUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "userTypingNotification"), object: dataArray[0] as? [String: AnyObject])
        }
    }
    
    
    func sendStartTypingMessage(_ nickname: String) {
//        socket.emit("startType", nickname as AnyObject)
    }
    
    
    func sendStopTypingMessage(_ nickname: String) {
//        socket.emit("stopType", nickname as AnyObject)
    }
}
