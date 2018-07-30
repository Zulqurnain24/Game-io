//
//  Game.m
//  Game_io_Objective_C
//
//  Created by Mohammad Zulqurnain on 24/10/2016.
//  Copyright © 2016 Mohammad Zulqurnain. All rights reserved.
//

#import "Game.h"

@implementation Game
@synthesize  m_id,c_id,c_name,r_id,t_a_id,team_a,t_b_id,team_b,venue,match_date,match_time,result,team_a_result,team_b_result,team_a_q1,team_b_q1,team_a_q2,team_b_q2,team_a_q3,team_b_q3,team_a_q4,team_b_q4,team_a_ot,team_b_ot,published_date,feed,feed_fiba,feed_now,fiba_stats,women,push,active_q,stop_min,stop_sec,q_is_started/*,players*/,Q_Time,country_id, ot_count, is_running;
-(id) init{
    self = [super init];
    if(self){//always use this pattern in a constructor.
        m_id = @"";
        c_id = @"";
        c_name = @"";
        r_id = @"";
        t_a_id = @"";
        team_a = @"";
        t_b_id = @"";
        team_b = @"";
        venue = @"";
        match_date = @"";
        match_time = @"";
        result = @"";
        team_a_result = @"";
        team_b_result = @"";
        team_a_q1 = @"";
        team_b_q1 = @"";
        team_a_q2 = @"";
        team_b_q2 = @"";
        team_a_q3 = @"";
        team_b_q3 = @"";
        team_a_q4 = @"";
        team_b_q4 = @"";
        team_a_ot = @"";
        team_b_ot = @"";
        published_date = @"";
        feed = @"";
        feed_fiba = @"";
         feed_now = @"";
        fiba_stats = @"";
         women = @"";
        push = @"";
        active_q = @"";
        stop_min = @"";
        stop_sec = @"";
        Q_Time = @"";
        q_is_started = false;
        country_id = @"";
        ot_count = @"";
        is_running = false;
    }
    return self;
}

-(id)initWithParams:(NSString*)p_m_id withC_id:(NSString*)p_c_id withChampionshipName:(NSString*)p_c_name withR_id:(NSString*)p_r_id withTeam_a_name:(NSString*)p_a_name  withTeam_b_name:(NSString*)p_b_name withTeam_a_result:(NSString*)p_team_a_result withTeam_b_result:(NSString*)p_team_b_result  withStop_min:(NSString*)p_stop_min withStop_sec:(NSString*)p_stop_sec withCountry_id:(NSString*)p_country_id withQ_Active:(NSString*)p_active_q withVenue:(NSString*)p_venue withOT_count:(NSString*)pot_count withIsRunning:(NSNumber*)Pis_running{
    
    if (pot_count != nil){
        ot_count = pot_count;
    }else{
        ot_count = @"";
    }
    
    if (p_m_id != nil){
        m_id = p_m_id;
    }else{
        m_id = @"";
    }
    
    if (p_c_id != nil){
        c_id = p_c_id;
    }else{
        c_id = @"";
    }
    
    if (p_c_name != nil){
        c_name = p_c_name;
    }else{
        c_name = @"";
    }
    if (p_r_id != nil){
        r_id  = p_r_id;
    }else{
        r_id = @"";
    }
    if (p_a_name != nil){
        team_a  = p_a_name;
    }else{
        team_a = @"";
    }
    if (p_b_name != nil){
        team_b  = p_b_name;
    }else{
        team_b = @"";
    }

    if (p_team_a_result != nil){
        team_a_result  = p_team_a_result;
    }else{
        team_a_result = @"";
    }
    if (p_team_b_result != nil){
        team_b_result  = p_team_b_result;
    }else{
        team_b_result = @"";
    }
    if (p_stop_min != nil){
        stop_min  = p_stop_min;
    }else{
        stop_min = @"";
    }
    
    if (p_stop_sec != nil){
        stop_sec  = p_stop_sec;
    }else{
        stop_sec = @"";
    }
    if (p_country_id != nil){
        country_id   = p_country_id;
    }else{
        country_id = @"";
    }
    if (p_active_q != nil){
        active_q   = p_active_q;
    }else{
        active_q = @"";
    }
    if (p_venue != nil){
        venue   = p_venue;
    }else{
        venue = @"";
    }
    if (p_stop_sec != nil){
        Q_Time  = [NSString stringWithFormat:@"%@ : %@", stop_min, stop_sec];
    }else{
        Q_Time = @"";
    }
    
    if ([NSNumber numberWithBool:Pis_running] != nil){
        is_running  = Pis_running;
    }else{
        is_running = false;
    }
    
    return self;
}


-(void)initWithDict:(NSDictionary*)dict{

    NSLog(@"Game_dict%@", dict);
    
     if ((NSString*)[dict objectForKey:@"m_id"] != nil){
    m_id = (NSString*)[dict objectForKey:@"m_id"];
     }else{
     m_id = @"";
     }
    
    if ((NSString*)[dict objectForKey:@"c_id"] != nil){
    c_id = (NSString*)[dict objectForKey:@"c_id"];
    }else{
        c_id = @"";
    }
    
    if ((NSString*)[dict objectForKey:@"ot_count"] != nil){
        ot_count = (NSString*)[NSString stringWithFormat:@"%ld", [[dict objectForKey:@"ot_count"] integerValue] + 1] ;
    }else{
        ot_count = @"";
    }
    
    if ((NSString*)[dict objectForKey:@"championship_name"] != nil){
    c_name = (NSString*)[dict objectForKey:@"championship_name"];
    }else{
        c_name = @"";
    }
    if ((NSString*)[dict objectForKey:@"r_id"] != nil){
    r_id  =(NSString*)[dict objectForKey:@"r_id"];
    }else{
        r_id = @"";
    }
    if ((NSString*)[dict objectForKey:@"t_a_id"] != nil){
    t_a_id  = (NSString*)[dict objectForKey:@"t_a_id"];
    }else{
        t_a_id = @"";
    }
    if ((NSString*)[dict objectForKey:@"team_a"] != nil){
    team_a  = (NSString*)[dict objectForKey:@"team_a"];
     }else{
         team_a = @"";
     }
    if ((NSString*)[dict objectForKey:@"t_b_id"] != nil){
    t_b_id  = (NSString*)[dict objectForKey:@"t_b_id"];
    }else{
        t_b_id = @"";
    }
    if ((NSString*)[dict objectForKey:@"team_b"] != nil){
    team_b  = (NSString*)[dict objectForKey:@"team_b"];
    }else{
        team_b = @"";
    }
     if ((NSString*)[dict objectForKey:@"venue"] != nil){
    venue  = (NSString*)[dict objectForKey:@"venue"];
     }else{
         venue = @"";
     }
     if ((NSString*)[dict objectForKey:@"match_date"] != nil){
    match_date  = (NSString*)[dict objectForKey:@"match_date"];
     }else{
         match_date = @"";
     }
    if ((NSString*)[dict objectForKey:@"match_time"] != nil){
    match_time  = (NSString*)[dict objectForKey:@"match_time"];
    }else{
        match_time = @"";
    }
     if ((NSString*)[dict objectForKey:@"result"] != nil){
    result  = (NSString*)[dict objectForKey:@"result"];
     }else{
         result = @"";
     }
     if ((NSString*)[dict objectForKey:@"team_a_result"] != nil){
    team_a_result  = (NSString*)[dict objectForKey:@"team_a_result"];
     }else{
         team_a_result = @"";
     }
    if ((NSString*)[dict objectForKey:@"team_b_result"] != nil){
    team_b_result  = (NSString*)[dict objectForKey:@"team_b_result"];
    }else{
        team_b_result = @"";
    }
    if ((NSString*)[dict objectForKey:@"team_a_q1"] != nil){
    team_a_q1  = (NSString*)[dict objectForKey:@"team_a_q1"];
    }else{
        team_a_q1 = @"";
    }
    if ((NSString*)[dict objectForKey:@"team_b_q1"] != nil){
    team_b_q1  = (NSString*)[dict objectForKey:@"team_b_q1"];
    }else{
        team_b_q1 = @"";
    }
    if ((NSString*)[dict objectForKey:@"team_a_q2"] != nil){
    team_a_q2  = (NSString*)[dict objectForKey:@"team_a_q2"];
    }else{
        team_a_q2 = @"";
    }
    if ((NSString*)[dict objectForKey:@"team_b_q2"] != nil){
    team_b_q2  = (NSString*)[dict objectForKey:@"team_b_q2"];
    }else{
        team_b_q2 = @"";
    }
    if ((NSString*)[dict objectForKey:@"team_a_q3"] != nil){
    team_a_q3  = (NSString*)[dict objectForKey:@"team_a_q3"];
    }else{
        team_a_q3 = @"";
    }
    if ((NSString*)[dict objectForKey:@"team_b_q3"] != nil){
    team_b_q3  = (NSString*)[dict objectForKey:@"team_b_q3"];
    }else{
          team_b_q3 = @"";
    }
    if ((NSString*)[dict objectForKey:@"team_a_q4"] != nil){
         team_a_q4  = (NSString*)[dict objectForKey:@"team_a_q4"];
     }else{
             team_a_q4 = @"";
    }
     if ((NSString*)[dict objectForKey:@"team_b_q4"] != nil){
    team_b_q4  = (NSString*)[dict objectForKey:@"team_b_q4"];
     }else{
         team_b_q4 = @"";
     }
     if ((NSString*)[dict objectForKey:@"team_a_ot"] != nil){
    team_a_ot  = (NSString*)[dict objectForKey:@"team_a_ot"];
     }else{
         team_a_ot = @"";
     }
    if ((NSString*)[dict objectForKey:@"team_b_ot"] != nil){
    team_b_ot = (NSString*)[dict objectForKey:@"team_b_ot"];
    }else{
        team_b_ot = @"";
    }
     if ((NSString*)[dict objectForKey:@"published_date"] != nil){
    published_date = (NSString*)[dict objectForKey:@"published_date"];
     }else{
         team_a = @"";
     }
    if ((NSString*)[dict objectForKey:@"feed"] != nil){
    feed  = (NSString*)[dict objectForKey:@"feed"];
    }else{
        feed = @"";
    }
    if ((NSString*)[dict objectForKey:@"feed_fiba"] != nil){
    feed_fiba  = (NSString*)[dict objectForKey:@"feed_fiba"];
    }else{
        feed_fiba = @"";
    }
    if ((NSString*)[dict objectForKey:@"feed_now"] != nil){
    feed_now  = (NSString*)[dict objectForKey:@"feed_now"];
    }else{
        team_a = @"";
    }
    if ((NSString*)[dict objectForKey:@"fiba_stats"] != nil){
    fiba_stats  = (NSString*)[dict objectForKey:@"fiba_stats"];
    }else{
        fiba_stats = @"";
    }
    if ((NSString*)[dict objectForKey:@"women"] != nil){
    women = (NSString*)[dict objectForKey:@"women"];
    }else{
        women = @"";
    }
    if ((NSString*)[dict objectForKey:@"push"] != nil){
    push = (NSString*)[dict objectForKey:@"push"];
    }else{
        push = @"";
    }
    if ((NSString*)[dict objectForKey:@"active_q"] != nil){
    active_q  = (NSString*)[dict objectForKey:@"active_q"];
    }else{
        active_q = @"";
    }
    if ((NSString*)[dict objectForKey:@"stop_min"] != nil){
    stop_min  = (NSString*)[dict objectForKey:@"stop_min"];
  
     }else{
         stop_min = @"";
     }
    if ((NSString*)[dict objectForKey:@"stop_sec"] != nil){
    stop_sec  = (NSString*)[dict objectForKey:@"stop_sec"];

    }else{
        stop_sec = @"";
    }
    if ((NSString*)[dict objectForKey:@"stop_sec"] != nil){
        Q_Time  = [NSString stringWithFormat:@"%02d :%02d", [stop_min intValue], [stop_sec intValue]];
        
    }else{
        Q_Time = @"";
    }
     if ((NSString*)[dict objectForKey:@"q_is_started"] != nil){
    q_is_started   = (Boolean)[dict objectForKey:@"q_is_started"];
     }else{
         q_is_started = false;
     }

    if ((NSString*)[dict objectForKey:@"country_id"] != nil){
        country_id   = (NSString*)[dict objectForKey:@"country_id"];
    }else{
        country_id = @"";
    }
    
    if ((NSString*)[dict objectForKey:@"is_running"] != nil){
        is_running   = (NSNumber*)[dict objectForKey:@"is_running"];
    }
}
@end
