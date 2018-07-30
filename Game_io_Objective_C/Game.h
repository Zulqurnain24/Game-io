//
//  Game.h
//  Game_io_Objective_C
//
//  Created by Mohammad Zulqurnain on 24/10/2016.
//  Copyright © 2016 Mohammad Zulqurnain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
@interface Game : NSObject
@property (strong, nonatomic) NSString* m_id;
@property (strong, nonatomic) NSString* c_id;
@property (strong, nonatomic) NSString* c_name;
@property (strong, nonatomic) NSString* r_id;
@property (strong, nonatomic) NSString* t_a_id;
@property (strong, nonatomic) NSString* team_a;
@property (strong, nonatomic) NSString* t_b_id;
@property (strong, nonatomic) NSString* team_b;
@property (strong, nonatomic) NSString* venue;
@property (strong, nonatomic) NSString* match_date;
@property (strong, nonatomic) NSString* match_time;
@property (strong, nonatomic) NSString* result;
@property (strong, nonatomic) NSString* team_a_result;
@property (strong, nonatomic) NSString* team_b_result;
@property (strong, nonatomic) NSString* team_a_q1;
@property (strong, nonatomic) NSString* team_b_q1;
@property (strong, nonatomic) NSString* team_a_q2;
@property (strong, nonatomic) NSString* team_b_q2;
@property (strong, nonatomic) NSString* team_a_q3;
@property (strong, nonatomic) NSString* team_b_q3;
@property (strong, nonatomic) NSString* team_a_q4;
@property (strong, nonatomic) NSString* team_b_q4;
@property (strong, nonatomic) NSString* team_a_ot;
@property (strong, nonatomic) NSString* team_b_ot;
@property (strong, nonatomic) NSString* published_date;
@property (strong, nonatomic) NSString* feed;
@property (strong, nonatomic) NSString* feed_fiba;
@property (strong, nonatomic) NSString* feed_now;
@property (strong, nonatomic) NSString* fiba_stats;
@property (strong, nonatomic) NSString* women;
@property (strong, nonatomic) NSString* push;
@property (strong, nonatomic) NSString* active_q;
@property (strong, nonatomic) NSString* stop_min;
@property (strong, nonatomic) NSString* stop_sec;
@property (strong, nonatomic) NSString* Q_Time;
@property (strong, nonatomic) NSString* country_id;
@property (strong, nonatomic) NSString* ot_count;
@property (nonatomic) Boolean q_is_started;
@property (nonatomic) NSNumber* is_running;
//country_id
//@property (strong, nonatomic) NSArray* players;
-(id) init;
-(void)initWithDict:(NSDictionary*)dict;
-(id)initWithParams:(NSString*)p_m_id withC_id:(NSString*)p_c_id withChampionshipName:(NSString*)p_c_name withR_id:(NSString*)p_r_id withTeam_a_name:(NSString*)p_a_name  withTeam_b_name:(NSString*)p_b_name withTeam_a_result:(NSString*)p_team_a_result withTeam_b_result:(NSString*)p_team_b_result  withStop_min:(NSString*)p_stop_min withStop_sec:(NSString*)p_stop_sec withCountry_id:(NSString*)p_country_id withQ_Active:(NSString*)p_active_q withVenue:(NSString*)p_venue withOT_count:(NSString*)pot_count withIsRunning:(NSNumber*)Pis_running;
@end
