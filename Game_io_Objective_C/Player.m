//
//  Player.m
//  Game_io_Objective_C
//
//  Created by Mohammad Zulqurnain on 24/10/2016.
//  Copyright © 2016 Mohammad Zulqurnain. All rights reserved.
//

#import "Player.h"

@implementation Player
@synthesize p_id, m_id,t_id,score,foul,number,picture,player,position,short_name,team;
-(id) init{
    self = [super init];
    if(self){//always use this pattern in a constructor.
        p_id = @"";
        m_id = @"";
        t_id = @"";
        score = @"";
        foul = @"";
        number = @"";
        picture = @"";
        player = @"";
        position = @"";
        short_name = @"";
        team = @"";
    }
    return self;
}
-(void)initWithDict:(NSDictionary*)dict{

  //  NSLog(@"Player_dict%@", dict);
    
    if ((NSString*)[dict objectForKey:@"p_id"] != nil){
    p_id  = (NSString*)[dict objectForKey:@"p_id"];
    }else{
    p_id = @"";
    }
    if ((NSString*)[dict objectForKey:@"m_id"] != nil){
    m_id = (NSString*)[dict objectForKey:@"m_id"];
    }else{
        m_id = @"";
    }
    if ((NSString*)[dict objectForKey:@"t_id"] != nil){
    t_id  = (NSString*)[dict objectForKey:@"t_id"];
    }else{
        t_id = @"";
    }
    if ((NSString*)[dict objectForKey:@"score"] != nil){
    score  = (NSString*)[dict objectForKey:@"score"];
    }else{
        score = @"";
    }
    if ((NSString*)[dict objectForKey:@"foul"] != nil){
    foul  = (NSString*)[dict objectForKey:@"foul"];
    }else{
        foul = @"";
    }
    if ((NSString*)[dict objectForKey:@"number"] != nil){
    number  = (NSString*)[dict objectForKey:@"number"];
    }else{
        number = @"";
    }
    if ((NSString*)[dict objectForKey:@"picture"] != nil){
    picture  = (NSString*)[dict objectForKey:@"picture"];
    }else{
        picture = @"";
    }
    if ((NSString*)[dict objectForKey:@"player"] != nil){
    player  = (NSString*)[dict objectForKey:@"player"];
    }else{
        player = @"";
    }
    if ((NSString*)[dict objectForKey:@"position"] != nil){
    position  = (NSString*)[dict objectForKey:@"position"];
    }else{
        position = @"";
    }
    if ((NSString*)[dict objectForKey:@"short_name"] != nil){
    short_name  = (NSString*)[dict objectForKey:@"short_name"];
    }else{
        short_name = @"";
    }
    if ((NSString*)[dict objectForKey:@"team"] != nil){
    team  = (NSString*)[dict objectForKey:@"team"];
    }else{
        team = @"";
    }

}
@end
