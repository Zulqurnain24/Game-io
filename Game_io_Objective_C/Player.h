//
//  Player.h
//  Game_io_Objective_C
//
//  Created by Mohammad Zulqurnain on 24/10/2016.
//  Copyright © 2016 Mohammad Zulqurnain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject
@property (strong, nonatomic) NSString* p_id;
@property (strong, nonatomic) NSString* m_id;
@property (strong, nonatomic) NSString* t_id;
@property (strong, nonatomic) NSString* score;
@property (strong, nonatomic) NSString* foul;
@property (strong, nonatomic) NSString* number;
@property (strong, nonatomic) NSString* picture;
@property (strong, nonatomic) NSString* player;
@property (strong, nonatomic) NSString* position;
@property (strong, nonatomic) NSString* short_name;
@property (strong, nonatomic) NSString* team;
-(id) init;
-(void)initWithDict:(NSDictionary*)dict;
@end

