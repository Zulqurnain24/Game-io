//
//  ChampionShip.m
//  Game_io_Objective_C
//
//  Created by Mohammad Zulqurnain on 24/10/2016.
//  Copyright © 2016 Mohammad Zulqurnain. All rights reserved.
//

#import "ChampionShip.h"

@implementation ChampionShip
@synthesize c_id, c_name;
-(id) init{
    self = [super init];
    if(self){//always use this pattern in a constructor.
        c_id = @"";
        c_name = @"";

    }
    return self;
}
-(id)initWithParam:(NSString*) paramC_id withChampionshipName:(NSString*) paramC_name{

   // NSLog(@"c_id : %@,c_name : %@", paramC_id,paramC_name);
    
    if ((NSString*)paramC_id != nil){
    c_id = (NSString*)paramC_id;
    }else{
        c_id = @" ";
    }
    if ((NSString*)paramC_name != nil){
    c_name = (NSString*)paramC_name;
    }else{
        c_name = @" ";
    }
   return self;
}

@end
