//
//  AppDelegate.h
//  Game_io_Objective_C
//
//  Created by Mohammad Zulqurnain on 23/10/2016.
//  Copyright © 2016 Mohammad Zulqurnain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Game_io_Objective_C-Swift.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;
//Socket object for the app for games menu view controller
@property (strong, nonatomic)SocketIOClient* socketIOClient_For_Games_Menu;
//Socket object for the app for games menu view controller
@property (strong, nonatomic)SocketIOClient* socketIOClient_For_Game_Animation;
//object for storing json of game data for LiveGameView
@property (strong, nonatomic)NSDictionary<NSString*, NSString*>* socketAPI;
//object for storing json of game events for LiveGameView
@property (strong, nonatomic)NSDictionary<NSString*, NSString*>* eventsAPI;
//object for storing json of championship games view
@property (strong, nonatomic) NSArray* gamesForChampionshipArray;
//UUID
@property (nonatomic) NSUUID* socketUUID;
- (void)saveContext;


@end

