//
//  containedChampionsArrayOfDictionary.h
//  Game_io_Objective_C
//
//  Created by Mohammad Zulqurnain on 24/10/2016.
//  Copyright © 2016 Mohammad Zulqurnain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChampionShip.h"
#import "Game.h"
@interface ChampionshipGameObject : NSObject
@property (strong, nonatomic) ChampionShip* championShip;
@property (strong, nonatomic) NSArray* game;
-(id) init;
-(void)initWithDict:(ChampionShip*)championShipParameter withGames:(NSArray*)gameParameter;
@end
