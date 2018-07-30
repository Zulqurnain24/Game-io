//
//  ChampionShip.h
//  Game_io_Objective_C
//
//  Created by Mohammad Zulqurnain on 24/10/2016.
//  Copyright © 2016 Mohammad Zulqurnain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChampionShip : NSObject

@property (strong, nonatomic) NSString* c_id;
@property (strong, nonatomic) NSString* c_name;

-(id) init;
-(id)initWithParam:(NSString*) paramC_id withChampionshipName:(NSString*) paramC_name;

@end
