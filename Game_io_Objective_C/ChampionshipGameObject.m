//
//  containedChampionsArrayOfDictionary.m
//  Game_io_Objective_C
//
//  Created by Mohammad Zulqurnain on 24/10/2016.
//  Copyright © 2016 Mohammad Zulqurnain. All rights reserved.
//

#import "ChampionshipGameObject.h"

@implementation ChampionshipGameObject
@synthesize championShip,game;
-(id) init{
    self = [super init];
    if(self){//always use this pattern in a constructor.
       championShip = nil;
       game = nil;
    }
    return self;
}
-(void)initWithDict:(ChampionShip*)championShipParameter withGames:(NSMutableArray*)gameParameter{

   // NSLog(@"championShipParameter : %@ and gameParameter : %@", championShipParameter, gameParameter);
    championShip = championShipParameter;
    game = gameParameter;

}
@end
