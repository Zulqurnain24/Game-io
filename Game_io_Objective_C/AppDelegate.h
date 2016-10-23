//
//  AppDelegate.h
//  Game_io_Objective_C
//
//  Created by Mohammad Zulqurnain on 23/10/2016.
//  Copyright © 2016 Mohammad Zulqurnain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

