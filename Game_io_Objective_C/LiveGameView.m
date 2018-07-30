//
//  LiveGameView.m
//  Game_io_Objective_C
//
//  Created by Mohammad Zulqurnain on 23/10/2016.
//  Copyright © 2016 Mohammad Zulqurnain. All rights reserved.
//

#define IS_IPHONE ( [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"] )
#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
#define IS_IPHONE_5 ( IS_IPHONE && IS_HEIGHT_GTE_568 )

#import "LiveGameView.h"
#import "Reachability.h"

@interface LiveGameView ()

@end

@implementation LiveGameView
@synthesize socketURL, team_A, team_B, venue, teamB_totalScore, teamA_totalScore,quarterInformation, counter,socketID, tableViewForGameScore, basketBallCourt, time_out_View, SecondTeam_Label, FirstTeam_Label, team_B_Timeout_Clock, team_A_Timeout_Clock, timeoutTeam, time_out_Imageview, possessionTeam, ballPossessionImageview, FirstTeamScore_Label, SecondTeamScore_Label, Quarter_And_Time_Label,vsLabel, foul_Team_Name_Label, A_Out_Foul_ImageView, B_Out_Foul_ImageView,timeInformation, A_In_Foul_ImageView, B_In_Foul_ImageView, foulsParentView, possessionView, ballImageView, eventsArray,time_ForBTeam_ImageView,time_ForATeam_ImageView,time_out_line_imageview,time_out_parent_view,freeThrough_line_view, freeThrough_TeamA_Dot, freeThrough_TeamB_Dot,free_Throw_Label,free_Throwing_player_label, freeThrowParentView, possession_Team_Name_label, playerAPI, totalFoulByPlayer, totalScoreByPlayer, time_out_team_label, activityIndicator, countryID, matchID, timingEventsView, matchStateLabel, labelForFoul;

AppDelegate* appdelegateForGameio;

 //socket url
  NSString *urlString = @"https://liveadmin.herokuapp.com";
  //+2 pts shot distance
  NSInteger horizontalDistanceFor2PTS = 635;
 //+3 pts shot distance
  NSInteger horizontalDistanceFor3PTS = 250;
 //+free throw shot distance
  NSInteger horizontalDistanceForFreeThrow = 250;
 //y position of ball
  CGFloat yPosition;
 //x position of ball
 CGFloat xPositionForA;
 CGFloat xPositionForB;
 //mean position of ball
 CGFloat ballCenterPosition;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appdelegateForGameio = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    tableViewForGameScore.delegate = self;
    tableViewForGameScore.dataSource = self;

    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
       https://liveadmin.herokuapp.com/api/countries/match/1/1
        //call api to populate the main game data
        [self getSocket_Info_From_API:[NSString stringWithFormat:@"https://liveadmin.herokuapp.com/api/countries/match/%@/%@", countryID, matchID]];
        
    
    });
    
    xPositionForA = basketBallCourt.frame.size.width * 0.25 + (ballImageView.frame.size.width/2);
    xPositionForB = basketBallCourt.frame.size.width * 0.75 + (ballImageView.frame.size.width/2);
    yPosition = ballImageView.center.y * 5;
    ballCenterPosition =  ballImageView.frame.origin.x + (ballImageView.frame.size.width/3);
    horizontalDistanceFor2PTS = basketBallCourt.frame.size.width * 1.65;
    horizontalDistanceFor3PTS =  basketBallCourt.frame.size.width  * 0.70;
    
    if(IS_IPHONE_5)
    {
        NSLog(@"i am an iPhone 5!");
        ballImageView.frame = CGRectMake(ballImageView.frame.origin.x, ballImageView.frame.origin.y * 0.85, ballImageView.frame.size.width, ballImageView.frame.size.height);
        yPosition = ballImageView.center.y * 0.95;
        xPositionForA = 0.95 * xPositionForA;
        xPositionForB = 0.95 * xPositionForB;
    }
    else
    {
        NSLog(@"This is not an iPhone 5");

    }

}

//-(void)timerFired
//{
//   
//    NSLog(@"socket status %ld", (long)appdelegateForGameio.socketIOClient_For_Game_Animation.status);
//}
//
//- (void)socket_reconnect_handler
//{
//    NSLog(@"socket reconnected!");
//    
//}

- (void)getSocket_Info_From_API:(NSString*)urlString
{
    Reachability *_reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus remoteHostStatus = [_reachability currentReachabilityStatus];
    if (remoteHostStatus == NotReachable) {
        // not reachable
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please connect to Internet." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (remoteHostStatus == ReachableViaWiFi || remoteHostStatus == ReachableViaWWAN) {
        // reachable via WWAN

        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if ([data length] > 0)
            {
                // handle response
                id jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                appdelegateForGameio.socketAPI = jsonArray;
                NSLog(@"appdelegateForGameio.socketAPI : %@",  appdelegateForGameio.socketAPI );

                //call for populating the score events tableview(making sure that the socketapi gets filled then we call the events array populate event)
                [self getEvents_For_Match_API:[NSString stringWithFormat:@"https://liveadmin.herokuapp.com/api/games/event/%@",   appdelegateForGameio.socketAPI[@"m_id"] ]];

                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                   team_A =  [NSString stringWithFormat:@"%@",  appdelegateForGameio.socketAPI[@"team_a"]];
                   team_B = [NSString stringWithFormat:@"%@",  appdelegateForGameio.socketAPI[@"team_b"] ];
                    
                    teamA_totalScore =  [ appdelegateForGameio.socketAPI[@"team_a_result"] integerValue];
                    teamB_totalScore =  [ appdelegateForGameio.socketAPI[@"team_b_result"] integerValue];
                    
                   venue = [NSString stringWithFormat:@"%@",  appdelegateForGameio.socketAPI[@"venue"]];
                   
                    if (![[NSString stringWithFormat:@"Q%@",  appdelegateForGameio.socketAPI[@"active_q"] ]  isEqual: @"QOT"]){
                    
                        quarterInformation = [NSString stringWithFormat:@"Q%@",  appdelegateForGameio.socketAPI[@"active_q"] ];
                    
                    }else{
                        quarterInformation = [NSString stringWithFormat:@"OT%ld",  ([appdelegateForGameio.socketAPI[@"ot_count"] integerValue] + 1) ];
                    }
                    
                    if(([appdelegateForGameio.socketAPI[@"stop_min"] integerValue]  == 0) && ([appdelegateForGameio.socketAPI[@"stop_sec"] integerValue]  == 0) && ([appdelegateForGameio.socketAPI[@"q_is_started"] integerValue]  == 0)){
                        
                        if (![[NSString stringWithFormat:@"Q%@",  appdelegateForGameio.socketAPI[@"active_q"] ]  isEqual: @"QOT"]){
                        timeInformation = [NSString stringWithFormat:@"10 : 00"];
                        }else{
                            timeInformation = [NSString stringWithFormat:@"05 : 00"];
                        }
                    }else{
                        timeInformation = [NSString stringWithFormat:@"%02ld : %02ld",  [appdelegateForGameio.socketAPI[@"stop_min"] integerValue] ,  [appdelegateForGameio.socketAPI[@"stop_sec"] integerValue] ];
                    }

                   
                    counter = [appdelegateForGameio.socketAPI[@"match_time"] integerValue];
                    socketID =  [NSString stringWithFormat:@"%@",  appdelegateForGameio.socketAPI[@"m_id"] ];
                   
                    FirstTeam_Label.text = (NSString*)team_A ;
                    SecondTeam_Label.text = (NSString*)team_B ;
                    
                    possessionTeam.text = @"non";
                    
                    vsLabel.text = (NSString*)[NSString stringWithFormat:@"%@ VS %@", (NSString*)team_A , (NSString*)team_B ] ;
                    
                    FirstTeamScore_Label.text = [NSString stringWithFormat:@"%ld", (long)teamA_totalScore] ;
                    SecondTeamScore_Label.text = [NSString stringWithFormat:@"%ld", (long)teamB_totalScore] ;
                    
                    if([appdelegateForGameio.socketAPI[@"is_running"] integerValue] == 1){
                        
                    Quarter_And_Time_Label.text  = [NSString stringWithFormat:@"%@ - %@", quarterInformation, timeInformation ];
                        
                    }else{
                    
                        Quarter_And_Time_Label.text  = @"Match finished";
                        
                    }

                    //reloading the table data after populating the events data array
                    [tableViewForGameScore reloadData];
   
                });

            }
            
        }] resume];
    }
}




-(void)viewWillAppear:(BOOL)animated{
    
    //[self socketLogicAndEvents];
    
    FirstTeam_Label.text = team_A;
    SecondTeam_Label.text = team_B;
    
    FirstTeamScore_Label.text = [NSString stringWithFormat:@"%ld", (long)teamA_totalScore];
    SecondTeamScore_Label.text = [NSString stringWithFormat:@"%ld", (long)teamB_totalScore];
    Quarter_And_Time_Label.text =  [NSString stringWithFormat:@" %@ - %@ ", quarterInformation, timeInformation];
    
    _individual_player_event_view.hidden = false;
}


-(void)viewWillDisappear:(BOOL)animated{
    NSString *valueToSave = self.timeInformation;
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"lastTime"];
    NSString *last_m_id = [self matchID];
    [[NSUserDefaults standardUserDefaults] setObject:last_m_id forKey:@"lastM_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)viewDidDisppear:(BOOL)animated{

  [appdelegateForGameio.socketIOClient_For_Game_Animation on:@"leaveRoom" callback:^(NSArray* data, SocketAckEmitter* ack) {
  }];
  [appdelegateForGameio.socketIOClient_For_Game_Animation disconnect];
    
  NSLog(@"socket connection closed in live game viewDidDisppear");
}

//method for populating the score events

- (void)getEvents_For_Match_API:(NSString*)urlString
{
    Reachability *_reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus remoteHostStatus = [_reachability currentReachabilityStatus];
    if (remoteHostStatus == NotReachable) {
        // not reachable
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please connect to Internet." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (remoteHostStatus == ReachableViaWiFi || remoteHostStatus == ReachableViaWWAN) {
        // reachable via WWAN
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [activityIndicator setHidden:false];
            [activityIndicator startAnimating];
            self.view.alpha = 0.6;
        });
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:[NSURL URLWithString:urlString]
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    if ([data length] > 0)
                    {
                        // handle response
                        id jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                        
                        NSLog(@"game events jsonArray : %@", jsonArray);
                        
                        appdelegateForGameio.eventsAPI = jsonArray;
                        eventsArray = [[NSMutableArray alloc] init];
                        NSString* previousValue = @"";
                        
                        for (id dict in appdelegateForGameio.eventsAPI) {
                            if (([[dict objectForKey:@"message"] rangeOfString:@"scoring team"].location == NSNotFound) && !([[dict objectForKey:@"message"]  isEqual: @"start of Q1"]) && ([dict objectForKey:@"message"] != previousValue)) {
                                
                                NSString *message = [dict objectForKey:@"message"];
                                
                                if(([[dict objectForKey:@"message"] rangeOfString:@"Possesion"].location == NSNotFound) && ([[dict objectForKey:@"message"] rangeOfString:@"TimeOut"].location == NSNotFound)){
                               
                                [eventsArray addObject:(NSString*)message];
                               
                                }else{
                                    
                                    if ([message  isEqual: @"Team A TimeOut"]){
                                        [eventsArray addObject:[NSString stringWithFormat:@"%@ TimeOut", team_A]];
                                    }else if ([message  isEqual: @"Team B TimeOut"]){
                                        [eventsArray addObject:[NSString stringWithFormat:@"%@ TimeOut", team_B]];
                                    }
                                    
                                    if ([message  isEqual: @"Team A Possesion"]){
                                     [eventsArray addObject:[NSString stringWithFormat:@"%@ Possesion", team_A]];
                                    }else  if ([message  isEqual: @"Team B Possesion"]){
                                    [eventsArray addObject:[NSString stringWithFormat:@"%@ Possesion", team_B]];
                                    }
                                }
                                
                                NSLog(@"message : %@", message);
                                previousValue = message;
                            }
                        }

                        //connect socket
                        [self socketLogicAndEvents];

                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                             NSLog(@"eventsAPI ... loading done!");
                            [tableViewForGameScore reloadData];
             
                        });
 
                    }
                    
                }] resume];
    }
    
}


-(void) socketLogicAndEvents{
    
    socketURL = urlString;
    NSURL* url = [[NSURL alloc] initWithString:urlString];
    
    appdelegateForGameio.socketIOClient_For_Game_Animation = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @NO, @"forcePolling": @YES}];

    [appdelegateForGameio.socketIOClient_For_Game_Animation on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"***-socket connected-***");

        [self refreshView ];
        
        appdelegateForGameio.socketIOClient_For_Game_Animation.reconnects = true;
        
        Reachability *_reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus remoteHostStatus = [_reachability currentReachabilityStatus];
        if (remoteHostStatus == NotReachable) {
            // not reachable
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please connect to Internet." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        } else if (remoteHostStatus == ReachableViaWiFi || remoteHostStatus == ReachableViaWWAN) {
            // reachable via WWAN
            
       // NSString*stringForSockets = [NSString stringWithFormat:@"game%@", socketID];
        NSLog(@"socketID : %@", socketID);

        [appdelegateForGameio.socketIOClient_For_Game_Animation emit:@"joinRoom" with:@[[NSString stringWithFormat:@"game%@", socketID] ]];

        }
    }];
    
   
    [self navigationController].title = @"<Live Game Inplay>";
    
    [appdelegateForGameio.socketIOClient_For_Game_Animation connect];

    
    /****socket events being listened******/
    
    /****scoreUpdated event******/
    
    [appdelegateForGameio.socketIOClient_For_Game_Animation on:@"scoreUpdated" callback:^(NSArray* data, SocketAckEmitter* ack) {
        Reachability *_reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus remoteHostStatus = [_reachability currentReachabilityStatus];
        if (remoteHostStatus == NotReachable) {
            // not reachable
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please connect to Internet." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        } else if (remoteHostStatus == ReachableViaWiFi || remoteHostStatus == ReachableViaWWAN) {
            // reachable via WWAN
            
        NSDictionary* scoreData = (NSDictionary*)data[0];
      
        
            
        if(([self.free_Throw_Label.text rangeOfString:@"FT made"].location == NSNotFound)){
        possession_Team_Name_label.text = @"";
        free_Throw_Label.text = @"";
        }
        
        self.time_out_parent_view.hidden = true;
        
        NSLog(@"scoreUpdated : %@", scoreData);

        if ([scoreData valueForKey:@"currentScore"] != nil && [[scoreData valueForKey:@"currentScore"] integerValue] >= 1 ){
            
            NSString *s = [scoreData valueForKey:@"message"];
            NSRange r1 = [s rangeOfString:@"PTS"];
            NSString* endString = (NSString*)[[scoreData valueForKey:@"player"] valueForKey:@"team"];
            NSLog(@"endString : %@", endString);
            NSRange r2 = [s rangeOfString:endString];
            NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
            NSString *sub = [s substringWithRange:rSub];
     
            self.rightFacingArrow.hidden = true;
            self.leftFacingArrow.hidden = true;
            self.foulsParentView.hidden = true;
            self.possessionView.hidden = true;
            self.time_out_parent_view.hidden = true;
            freeThrough_TeamA_Dot.hidden = true;
            freeThrough_TeamB_Dot.hidden = true;
            self.timingEventsView.hidden = true;
            self.quarterInformation = [NSString stringWithFormat:@"Q%@",[scoreData valueForKey:@"q"] ];
            self.timeInformation = [NSString stringWithFormat:@"%@",[scoreData valueForKey:@"time"] ];
            self.Quarter_And_Time_Label.text =  [NSString stringWithFormat:@"%@ - %@",quarterInformation, timeInformation];
            self.ballImageView.hidden = false;
            self.basketBallCourt.image = [UIImage  imageNamed:@"basketBallCourt.png"];
            self.freeThrowParentView.hidden = false;

            
            if ([(NSString*)scoreData[@"team"]  isEqual: @"Team B"])
            {
              //  /***----->*/ NSLog(@"i am inside Team B");
                
                self.rightFacingArrow.hidden = true;
                self.leftFacingArrow.hidden = false;
                
                NSArray<UIImage*>* imageNamesArrayForTeamB = [NSArray arrayWithObjects:[UIImage imageNamed:@"red_bar_with_line_bottom"],[UIImage imageNamed:@"bar_with_line_left.png"],nil];
                
                [self.ballPossessionImageview stopAnimating];
                self.ballPossessionImageview.image = [UIImage imageNamed: @"bar_with_line_left.png"];
                self.ballPossessionImageview.animationImages = imageNamesArrayForTeamB;
                self.ballPossessionImageview.animationDuration = 1.5;
                [self.ballPossessionImageview startAnimating];
                
                NSInteger B_Score = (NSInteger)[scoreData[@"score"] integerValue];
                self.SecondTeamScore_Label.text = [NSString stringWithFormat:@"%ld", (long)B_Score];
                
                NSInteger current_Score = (NSInteger)[scoreData[@"currentScore"] integerValue];
                
                if (current_Score == 1){

                    // self.free_Throw_Label.text = @"+2 Pts";
                   // self.free_Throw_Label.text =  [NSString stringWithFormat:@"Free Throw"];
                    
                  //  [eventsArray addObject: [NSString stringWithFormat:@"+1Pts #%@ %@ (%@ Points)",[[scoreData valueForKey:@"player"] valueForKey:@"number"] , [[scoreData valueForKey:@"player"] valueForKey:@"player"], [[scoreData valueForKey:@"player"] valueForKey:@"score"]]];
                    
                    
                }else if (current_Score == 2){
                   // /***----->*/ NSLog(@"i am inside +2");
                    self.leftFacingArrow.hidden = false;
                    self.rightFacingArrow.hidden = true;
                    self.basketBallCourt.image = [UIImage  imageNamed:@"basketBallCourt.png"];
                    //self.teamB_totalScore = [[scoreData valueForKey:@"score"] integerValue];
                    [self moveImage:self.ballImageView withMoveX:horizontalDistanceFor2PTS withMoveY:0  withTeam:(NSString*)scoreData[@"team"] withBool:false];
                    
                   // self.free_Throw_Label.text = @"+2 Pts";
                   self.free_Throw_Label.text =  [NSString stringWithFormat:@"+2Pts made"];
                   self.possession_Team_Name_label.text = sub;
                    
                    
                    
                    [eventsArray addObject: [NSString stringWithFormat:@"+2Pts #%@ %@ (%@ Points)",[[scoreData valueForKey:@"player"] valueForKey:@"number"] , [[scoreData valueForKey:@"player"] valueForKey:@"short_name"], [[scoreData valueForKey:@"player"] valueForKey:@"score"]]];
                   
                   
                }else  if (current_Score == 3){
                   // /***----->*/ NSLog(@"i am inside +3");
                    self.leftFacingArrow.hidden = false;
                    self.rightFacingArrow.hidden = true;
                    self.basketBallCourt.image = [UIImage  imageNamed:@"basketBallCourt_Left_highlighted.png"];
                    [self moveImage:self.ballImageView withMoveX:horizontalDistanceFor3PTS withMoveY:0  withTeam:(NSString*)scoreData[@"team"] withBool:true];
                    
                    self.free_Throw_Label.text =  [NSString stringWithFormat:@"+3Pts made"];
                    self.possession_Team_Name_label.text = sub;

                    [eventsArray addObject: [NSString stringWithFormat:@"+3Pts #%@ %@ (%@ Points)",[[scoreData valueForKey:@"player"] valueForKey:@"number"] , [[scoreData valueForKey:@"player"] valueForKey:@"short_name"], [[scoreData valueForKey:@"player"] valueForKey:@"score"]]];
           
                }
                
                self.teamB_totalScore = B_Score;
                self.SecondTeamScore_Label.text = [NSString stringWithFormat:@"%ld",(long)self.teamB_totalScore];
               

            }
            
            if ([(NSString*)scoreData[@"team"]   isEqual: @"Team A"])
            {
                self.rightFacingArrow.hidden = false;
                self.leftFacingArrow.hidden = true;
               // NSLog(@"i am inside A");
                
                NSInteger A_Score = (NSInteger)[scoreData[@"score"] integerValue];
                self.FirstTeamScore_Label.text = [NSString stringWithFormat:@"%ld", (long)A_Score];
                
                NSArray<UIImage*>* imageNamesArrayForTeamA = [NSArray arrayWithObjects:[UIImage imageNamed:@"blue_bar_with_line_bottom"],[UIImage imageNamed:@"bar_with_line_right.png"],nil];
                
                [self.ballPossessionImageview stopAnimating];
                self.ballPossessionImageview.image = [UIImage imageNamed: @"bar_with_line_right.png"];
                self.ballPossessionImageview.animationImages = imageNamesArrayForTeamA;
                self.ballPossessionImageview.animationDuration = 1.5;
                [self.ballPossessionImageview startAnimating];

                NSInteger current_Score = (NSInteger)[scoreData[@"currentScore"] integerValue];
                
                if (current_Score == 1){
                    
                    // self.free_Throw_Label.text = @"+2 Pts";
                  // self.free_Throw_Label.text =  [NSString stringWithFormat:@"Free Throw"];
                    
                  // [eventsArray addObject: [NSString stringWithFormat:@"+1Pts #%@ %@ (%@ Points)",[[scoreData valueForKey:@"player"] valueForKey:@"number"] , [[scoreData valueForKey:@"player"] valueForKey:@"player"], [[scoreData valueForKey:@"player"] valueForKey:@"score"]]];
                    
                    
                }else if (current_Score == 2){

                    self.FirstTeamScore_Label.text = [NSString stringWithFormat:@"%ld",(long)self.teamA_totalScore ];
                    self.rightFacingArrow.hidden = false;
                    self.leftFacingArrow.hidden = true;
                    self.basketBallCourt.image = [UIImage  imageNamed:@"basketBallCourt.png"];
                    self.teamA_totalScore = [[scoreData valueForKey:@"score"] integerValue];
                    
                      [self moveImage:self.ballImageView withMoveX:horizontalDistanceFor2PTS withMoveY:0  withTeam:(NSString*)scoreData[@"team"] withBool:false];

                     self.free_Throw_Label.text =  [NSString stringWithFormat:@"+2Pts made"];
                     self.possession_Team_Name_label.text = sub;
                    
                      [eventsArray addObject: [NSString stringWithFormat:@"+2Pts #%@ %@ (%@ Points)",[[scoreData valueForKey:@"player"] valueForKey:@"number"] , [[scoreData valueForKey:@"player"] valueForKey:@"short_name"], [[scoreData valueForKey:@"player"] valueForKey:@"score"]]];
                    
                }else if (current_Score == 3){

                    
                    self.teamA_totalScore = [[scoreData valueForKey:@"score"] integerValue];
                    self.rightFacingArrow.hidden = false;
                    self.leftFacingArrow.hidden = true;
                    self.basketBallCourt.image = [UIImage  imageNamed:@"basketBallCourt_Right_highlighted.png"];
                    self.FirstTeamScore_Label.text = [NSString stringWithFormat:@"%ld",(long)self.teamA_totalScore ];
                   
                    [self moveImage:self.ballImageView withMoveX:horizontalDistanceFor3PTS withMoveY:0  withTeam:(NSString*)scoreData[@"team"] withBool:true];

                    self.free_Throw_Label.text =  [NSString stringWithFormat:@"+3Pts made"];
                    self.possession_Team_Name_label.text = sub;
                    
                    
                    [eventsArray addObject: [NSString stringWithFormat:@"+3Pts #%@ %@ (%@ Points)",[[scoreData valueForKey:@"player"] valueForKey:@"number"] , [[scoreData valueForKey:@"player"] valueForKey:@"short_name"], [[scoreData valueForKey:@"player"] valueForKey:@"score"]]];
                }
                self.teamA_totalScore = A_Score;
                self.FirstTeamScore_Label.text = [NSString stringWithFormat:@"%ld",(long)self.teamA_totalScore];
                
            
              
            }

            if ([[scoreData valueForKey:@"team"] isEqual: @"Team B"] )
            {

                self.possessionTeam.text = [NSString stringWithFormat:@"%@ Possession",team_B];


            }else {
                
                self.possessionTeam.text = [NSString stringWithFormat:@"%@ Possession",team_A];
                
            }

            
        }else{
        
             NSLog(@"Score changed!");
            if ([[scoreData valueForKey:@"team"]  isEqual: @"team_b_result"] )
            {
                NSInteger B_Score = (NSInteger)[scoreData[@"score"] integerValue];
                self.SecondTeamScore_Label.text = [NSString stringWithFormat:@"%ld", (long)B_Score];
                
            }else if([[scoreData valueForKey:@"team"]  isEqual: @"team_a_result"] ){
                NSInteger A_Score = (NSInteger)[scoreData[@"score"] integerValue];
                self.FirstTeamScore_Label.text = [NSString stringWithFormat:@"%ld", (long)A_Score];
            }

            
        }
            
        [self refreshView];
            
        }

        
    }];
    

     /****ballPosition event******/
 
    [appdelegateForGameio.socketIOClient_For_Game_Animation on:@"ballPosition" callback:^(NSArray* data, SocketAckEmitter* ack) {
        Reachability *_reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus remoteHostStatus = [_reachability currentReachabilityStatus];
        if (remoteHostStatus == NotReachable) {
            // not reachable
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please connect to Internet." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        } else if (remoteHostStatus == ReachableViaWiFi || remoteHostStatus == ReachableViaWWAN) {
           
        possession_Team_Name_label.text = @"";
        free_Throw_Label.text = @"";
        self.time_out_parent_view.hidden = true;
            
        NSLog(@"ballPosition : %@", data);
        NSDictionary* ballPositionData = (NSDictionary*)data[0];
       // NSLog(@"ballPosition : %@", ballPositionData[@"team"] );
        self.freeThrowParentView.hidden = true;
        self.foulsParentView.hidden = true;
        self.ballImageView.hidden = true;
        self.possessionView.hidden = false;
        self.time_out_parent_view.hidden = true;
        freeThrough_TeamA_Dot.hidden = true;
        freeThrough_TeamB_Dot.hidden = true;
        self.timingEventsView.hidden = true;
            
        [self.ballPossessionImageview stopAnimating];
        self.possessionTeam.text = [ballPositionData valueForKey:@"team"];
        self.basketBallCourt.image = [UIImage imageNamed:@"basketBallCourt.png"];
       // NSLog(@"possessionTeam: %@", self.possessionTeam.text);
        
        if ([self.possessionTeam.text  isEqual: @"Team B"] )
        {
           //  NSLog(@"[self.possessionTeam.text  isEqual: @B] : %d", [self.possessionTeam.text  isEqual: @"Team B"] );
            self.ballPossessionImageview.image = [UIImage imageNamed:@"bar_with_line_left.png"];
            self.leftFacingArrow.hidden = false;
            self.rightFacingArrow.hidden = true;
            possessionTeam.text = [NSString stringWithFormat:@"%@ Possession", team_B];
            
             [eventsArray addObject:[NSString stringWithFormat:@"%@ Possession", team_B]];
            
        }else if([self.possessionTeam.text  isEqual: @"Team A"] ){
           // NSLog(@"[self.possessionTeam.text  isEqual: @A] : %d", [self.possessionTeam.text  isEqual: @"Team A"] );
            
            self.ballPossessionImageview.image = [UIImage imageNamed:@"bar_with_line_right.png"];
            self.leftFacingArrow.hidden = true;
            self.rightFacingArrow.hidden = false;
            possessionTeam.text = [NSString stringWithFormat:@"%@ Possession", team_A];
            
            [eventsArray addObject:[NSString stringWithFormat:@"%@ Possession", team_A]];
        }
       
        //possession_Team_Name_label.text =  [NSString stringWithFormat:@""];
        
        [self refreshView];
        }
     }];

    /****throwMissed event******/
   
    [appdelegateForGameio.socketIOClient_For_Game_Animation on:@"throwMissed" callback:^(NSArray* data, SocketAckEmitter* ack) {
        Reachability *_reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus remoteHostStatus = [_reachability currentReachabilityStatus];
        if (remoteHostStatus == NotReachable) {
            // not reachable
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please connect to Internet." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        } else if (remoteHostStatus == ReachableViaWiFi || remoteHostStatus == ReachableViaWWAN) {
            // reachable via WWAN
   
        possession_Team_Name_label.text = @"";
        free_Throw_Label.text = @"";
        self.time_out_parent_view.hidden = true;
            
        NSDictionary* throwMissedData = (NSDictionary*)data[0];
        NSLog(@"throwMissed: %@", throwMissedData);
        
        self.freeThrowParentView.hidden = false;
        self.ballImageView.hidden = false;
        //self.rightFacingArrow.hidden = true;
        //self.leftFacingArrow.hidden = true;
        self.foulsParentView.hidden = true;
        self.possessionView.hidden = true;
        self.time_out_parent_view.hidden = true;
         self.timingEventsView.hidden = true;
        
        self.free_Throw_Label.text = [NSString stringWithFormat:@"%@ FT missed", [throwMissedData valueForKey:@"shot"] ] ;
            
        if([(NSString*)[throwMissedData valueForKey:@"team"]  isEqual: @"Team B"]){
            
            self.rightFacingArrow.hidden = true;
            self.leftFacingArrow.hidden = false;
            self.basketBallCourt.image = [UIImage  imageNamed:@"basketBallCourt.png"];

        }else if([(NSString*)[throwMissedData valueForKey:@"team"]  isEqual: @"Team A"]){
            
            self.rightFacingArrow.hidden = false;
            self.leftFacingArrow.hidden = true;
            self.basketBallCourt.image = [UIImage  imageNamed:@"basketBallCourt.png"];
        }
        
        NSString *messageString =  (NSString*)[throwMissedData valueForKey:@"message"];

        [self ballDeflected:self.ballImageView withMoveX:horizontalDistanceForFreeThrow withMoveY:0 withMessage:messageString withTeamName:(NSString*)throwMissedData[@"team"]];

        [eventsArray addObject:messageString];
            
        NSString *s = messageString;
        NSRange r1 = [s rangeOfString:@"#"];
        NSRange r2 = [s rangeOfString:@"missed"];
        NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
        NSString *sub = [s substringWithRange:rSub];
        self.possession_Team_Name_label.text = [NSString stringWithFormat:@"#%@", sub];
            
        [self refreshView];
        }
    }];
    
    /****missedPoints event******/
  
    [appdelegateForGameio.socketIOClient_For_Game_Animation on:@"missedPoints" callback:^(NSArray* data, SocketAckEmitter* ack) {

        Reachability *_reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus remoteHostStatus = [_reachability currentReachabilityStatus];
        if (remoteHostStatus == NotReachable) {
            // not reachable
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please connect to Internet." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        } else if (remoteHostStatus == ReachableViaWiFi || remoteHostStatus == ReachableViaWWAN) {
            // reachable via WWAN
        self.time_out_parent_view.hidden = true;
        possession_Team_Name_label.text = @"";
        free_Throw_Label.text = @"";
            
        NSDictionary* missedPointsData = (NSDictionary*)data[0];
        NSLog(@"missedPointsData: %@", missedPointsData);
        
        self.freeThrowParentView.hidden = false;
        self.ballImageView.hidden = false;
        self.timingEventsView.hidden = true;
        self.foulsParentView.hidden = true;
        self.possessionView.hidden = true;
        self.time_out_parent_view.hidden = true;
         self.timingEventsView.hidden = true;
            
        NSString *messageString =  (NSString*)[missedPointsData valueForKey:@"playerMessage"];
        //self.possession_Team_Name_label.text = messageString;
        [eventsArray addObject:messageString];

        NSLog(@"contain 3PTS: %d", ([messageString rangeOfString:@"Missed 3PTS"].location != NSNotFound));
            
        if(!([(NSString*)[missedPointsData valueForKey:@"message"] rangeOfString:@"Team B possession"].location == NSNotFound)){
            
            self.rightFacingArrow.hidden = true;
            self.leftFacingArrow.hidden = false;
            self.basketBallCourt.image = [UIImage  imageNamed:@"basketBallCourt.png"];
            [self ballDeflected:self.ballImageView withMoveX:horizontalDistanceForFreeThrow withMoveY:0 withMessage:messageString withTeamName:@"Team B"];
            self.possessionTeam.text = team_B;

            if ([messageString rangeOfString:@"Missed 3PTS"].location != NSNotFound) {
                self.basketBallCourt.image = [UIImage  imageNamed:@"basketBallCourt_Left_highlighted_with_red.png"];
                
                self.free_Throw_Label.text = @"3PTS missed";

            }else{
                  self.free_Throw_Label.text = @"2PTS missed";
            }
            
        }else if(!([(NSString*)[missedPointsData valueForKey:@"message"] rangeOfString:@"Team A possession"].location == NSNotFound)){
            
            self.rightFacingArrow.hidden = false;
            self.leftFacingArrow.hidden = true;
            self.basketBallCourt.image = [UIImage  imageNamed:@"basketBallCourt.png"];
            [self ballDeflected:self.ballImageView withMoveX:horizontalDistanceForFreeThrow withMoveY:0 withMessage:messageString withTeamName:@"Team A"];
            self.possessionTeam.text = team_A;
            
            if ([messageString rangeOfString:@"Missed 3PTS"].location != NSNotFound) {
                self.basketBallCourt.image = [UIImage  imageNamed:@"basketBallCourt_Right_highlighted_with_red.png"];
                
                self.free_Throw_Label.text = @"3PTS missed";
                
            }else{
                self.free_Throw_Label.text = @"2PTS missed";
            }
        }

        NSString *s = messageString;
        NSRange r1 = [s rangeOfString:@"Shot"];
        NSRange r2 = [s rangeOfString:@"("];
        NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
        NSString *sub = [s substringWithRange:rSub];
        self.possession_Team_Name_label.text = [NSString stringWithFormat:@"%@", sub];
            
        [self refreshView];
        }
    }];

    
    /****throw event******/
    [appdelegateForGameio.socketIOClient_For_Game_Animation on:@"throw" callback:^(NSArray* data, SocketAckEmitter* ack) {
        Reachability *_reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus remoteHostStatus = [_reachability currentReachabilityStatus];
        if (remoteHostStatus == NotReachable) {
            // not reachable
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please connect to Internet." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];        } else if (remoteHostStatus == ReachableViaWiFi || remoteHostStatus == ReachableViaWWAN) {

        NSDictionary* throwData = (NSDictionary*)data[0];
       
        NSLog(@"throw: %@", throwData);
        
        self.freeThrowParentView.hidden = false;
        self.ballImageView.hidden = false;
        //self.rightFacingArrow.hidden = true;
        //self.leftFacingArrow.hidden = true;
        self.foulsParentView.hidden = true;
        self.possessionView.hidden = true;
        self.time_out_parent_view.hidden = true;
        self.timingEventsView.hidden = true;
        self.possession_Team_Name_label.hidden = false;
        free_Throw_Label.hidden = false;
        self.free_Throw_Label.text =  [NSString stringWithFormat:@"%@ FT made.", [throwData valueForKey:@"shot"]];
        
        self.time_out_parent_view.hidden = true;
                
        NSString *fullstring = [NSString stringWithFormat:@"+1 for #%@ %@ made FT %@ (%@ Points)", [[throwData valueForKey:@"player"] valueForKey:@"number"], [[throwData valueForKey:@"player"] valueForKey:@"short_name"], [throwData valueForKey:@"shot"], [[throwData valueForKey:@"player"] valueForKey:@"score"] ];

        [eventsArray addObject:fullstring];

        //populate player score and foul info
        totalFoulByPlayer.text = [NSString stringWithFormat:@"%@", [[throwData valueForKey:@"player"] valueForKey:@"foul"]];
        totalScoreByPlayer.text = [NSString stringWithFormat:@"%@", [[throwData valueForKey:@"player"] valueForKey:@"score"]];
        
        if ([(NSString*)throwData[@"team"] isEqual: @"Team B"]) {
            
            self.rightFacingArrow.hidden = true;
            self.leftFacingArrow.hidden = false;
            self.basketBallCourt.image = [UIImage  imageNamed:@"basketBallCourt.png"];
            
            freeThrough_line_view.image = [UIImage imageNamed:@"bar_with_line_left.png"];
            freeThrough_TeamA_Dot.hidden = false;
            freeThrough_TeamB_Dot.hidden = true;
           // free_Throw_Label.text = (NSString*)[throwData valueForKey:@"message"];
 
            self.SecondTeamScore_Label.text = [NSString stringWithFormat:@"%ld", (teamB_totalScore + 1)];
            self.leftFacingArrow.hidden = true;
            self.rightFacingArrow.hidden = true;
            
        } else if ([(NSString*)throwData[@"team"] isEqual: @"Team A"]){
           
            self.rightFacingArrow.hidden = false;
            self.leftFacingArrow.hidden = true;
            self.basketBallCourt.image = [UIImage  imageNamed:@"basketBallCourt.png"];
            
            freeThrough_line_view.image = [UIImage imageNamed:@"bar_with_line_right.png"];
            freeThrough_TeamA_Dot.hidden = true;
            freeThrough_TeamB_Dot.hidden = false;
          //  free_Throw_Label.text = (NSString*)[throwData valueForKey:@"message"];
       
            self.FirstTeamScore_Label.text = [NSString stringWithFormat:@"%ld", (teamA_totalScore + 1)];
            self.leftFacingArrow.hidden = true;
            self.rightFacingArrow.hidden = true;
            
        }
        
        [self moveImage:self.ballImageView withMoveX:horizontalDistanceForFreeThrow withMoveY:0 withTeam:(NSString*)throwData[@"team"] withBool:true];
        
        self.possession_Team_Name_label.hidden = false;
        self.possession_Team_Name_label.text = [NSString stringWithFormat:@"# %@ %@", [[throwData valueForKey:@"player"] valueForKey:@"number"], [[throwData valueForKey:@"player"] valueForKey:@"short_name"]];
                
                
                
        [self refreshView ];
        }
    }];

    /****fouled event******/

     [appdelegateForGameio.socketIOClient_For_Game_Animation on:@"playerFoulUpdated" callback:^(NSArray* data, SocketAckEmitter* ack) {
      
        // NSLog(@"foul: %@", data[0]);
         
         Reachability *_reachability = [Reachability reachabilityForInternetConnection];
         NetworkStatus remoteHostStatus = [_reachability currentReachabilityStatus];
         if (remoteHostStatus == NotReachable) {
             // not reachable
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please connect to Internet." preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
             [alertController addAction:ok];
             
             [self presentViewController:alertController animated:YES completion:nil];
         } else if (remoteHostStatus == ReachableViaWiFi || remoteHostStatus == ReachableViaWWAN) {
            
         possession_Team_Name_label.text = @"";
         free_Throw_Label.text = @"";
        
        self.time_out_parent_view.hidden = true;
             
         self.time_out_parent_view.hidden = true;
         self.ballImageView.hidden = true;
         //self.rightFacingArrow.hidden = true;
         //self.leftFacingArrow.hidden = true;
         self.foulsParentView.hidden = false;
         self.possessionView.hidden = true;
         self.freeThrowParentView.hidden = true;
         freeThrough_TeamA_Dot.hidden = true;
         freeThrough_TeamB_Dot.hidden = true;
         self.timingEventsView.hidden = true;
         self.possession_Team_Name_label.hidden = false;
             
        NSDictionary* fouledData = (NSDictionary*)data[0];

             
        NSLog(@"fouledData: %@", fouledData);

         NSString *messageString = [fouledData valueForKey:@"message"];

         bool isPersonal = false;
         if ([messageString rangeOfString:@"Personal"].location == NSNotFound) {
             isPersonal = true;
         } else {
             isPersonal = false;
         }
             
         self.basketBallCourt.image = [UIImage  imageNamed:@"basketBallCourt.png"];
         
         if ([(NSString*)[fouledData valueForKey:@"team"]   isEqual: @"Team B"] )
         {
      
             self.rightFacingArrow.hidden = true;
             self.leftFacingArrow.hidden = true;
             self.basketBallCourt.image = [UIImage  imageNamed:@"basketBallCourt.png"];
             
             if (!isPersonal){
                 
             A_Out_Foul_ImageView.hidden = true;
             A_In_Foul_ImageView.hidden = false;
             B_Out_Foul_ImageView.hidden = true;
             B_In_Foul_ImageView.hidden = true;
             _foulTeamLine.image = [UIImage imageNamed:@"bar_with_line_right.png"];

             //self.possession_Team_Name_label.text = [NSString stringWithFormat:@"#%@ %@ of %@ committed a technical foul", [[fouledData valueForKey:@"player"]  valueForKey:@"number"], [[fouledData valueForKey:@"player"]  valueForKey:@"player"], [[fouledData valueForKey:@"player"]  valueForKey:@"team"]];
                 
             }else{
             
                 A_Out_Foul_ImageView.hidden = false;
                 A_In_Foul_ImageView.hidden = true;
                 B_Out_Foul_ImageView.hidden = true;
                 B_In_Foul_ImageView.hidden = true;
                 _foulTeamLine.image = [UIImage imageNamed:@"bar_with_line_right.png"];
                 
                 // self.possession_Team_Name_label.text = [NSString stringWithFormat:@"#%@ %@ of %@ committed a personal foul", [[fouledData valueForKey:@"player"]  valueForKey:@"number"], [[fouledData valueForKey:@"player"]  valueForKey:@"player"], [[fouledData valueForKey:@"player"]  valueForKey:@"team"]];

             }
             
            // [eventsArray addObject:(NSString*)[NSString stringWithFormat:@"%@ Possession", team_B]];
             
         }else if([(NSString*)[fouledData valueForKey:@"team"]   isEqual: @"Team A"] ){
             
             self.rightFacingArrow.hidden = true;
             self.leftFacingArrow.hidden = true;
             self.basketBallCourt.image = [UIImage  imageNamed:@"basketBallCourt.png"];
             
             if (!isPersonal){
                 
                 A_Out_Foul_ImageView.hidden = true;
                 A_In_Foul_ImageView.hidden = true;
                 B_Out_Foul_ImageView.hidden = true;
                 B_In_Foul_ImageView.hidden = false;
                 _foulTeamLine.image = [UIImage imageNamed:@"bar_with_line_left.png"];
                 
                // self.possession_Team_Name_label.text = [NSString stringWithFormat:@"#%@ %@ of %@ committed a technical foul", [[fouledData valueForKey:@"player"]  valueForKey:@"number"], [[fouledData valueForKey:@"player"]  valueForKey:@"player"], [[fouledData valueForKey:@"player"]  valueForKey:@"team"]];
                 
             }else{
                 
                 A_Out_Foul_ImageView.hidden = true;
                 A_In_Foul_ImageView.hidden = true;
                 B_Out_Foul_ImageView.hidden = true;
                 B_In_Foul_ImageView.hidden = true;
                 _foulTeamLine.image = [UIImage imageNamed:@"bar_with_line_left.png"];
               // self.possession_Team_Name_label.text = [NSString stringWithFormat:@"#%@ %@ of %@ committed a personal foul", [[fouledData valueForKey:@"player"]  valueForKey:@"number"], [[fouledData valueForKey:@"player"]  valueForKey:@"player"], [[fouledData valueForKey:@"player"]  valueForKey:@"team"]];
             }
             
           // [eventsArray addObject:(NSString*)[NSString stringWithFormat:@"%@ Possession", team_A]];
         }
         
        [eventsArray addObject:messageString];
         
             
         NSString *s = messageString;
         NSRange r1 = [s rangeOfString:@"Foul"];
         NSRange r2 = [s rangeOfString:@"("];
         NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
         NSString *sub = [s substringWithRange:rSub];
         self.possession_Team_Name_label.text = [NSString stringWithFormat:@"%@", sub];
        
         if([s rangeOfString:@"Technical"].location == NSNotFound){
         r1 = [s rangeOfString:@","];
         r2 = [s rangeOfString:@"T"];
         rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
         sub = [s substringWithRange:rSub];
         self.labelForFoul.text = [NSString stringWithFormat:@"Personal Foul, %@T", sub];
         }else{
         self.labelForFoul.text = @"Technical Foul, 1 FT";
         }
             
        [self refreshView];
         }
    }];

    /****startOfQ event******/
     [appdelegateForGameio.socketIOClient_For_Game_Animation on:@"startOfQ" callback:^(NSArray* data, SocketAckEmitter* ack) {
       // NSLog(@"startOfQ: %@", data[0]);
         Reachability *_reachability = [Reachability reachabilityForInternetConnection];
         NetworkStatus remoteHostStatus = [_reachability currentReachabilityStatus];
         if (remoteHostStatus == NotReachable) {
             // not reachable
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please connect to Internet." preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
             [alertController addAction:ok];
             
             [self presentViewController:alertController animated:YES completion:nil];
         } else if (remoteHostStatus == ReachableViaWiFi || remoteHostStatus == ReachableViaWWAN) {

         possession_Team_Name_label.text = @"";
         free_Throw_Label.text = @"";
         self.time_out_parent_view.hidden = true;
             
        NSDictionary* startOfQData = (NSDictionary*)data[0];

         NSLog(@"startOfQData: %@", startOfQData);
             
         foulsParentView.hidden = true;
         freeThrowParentView.hidden  = true;
         time_out_View.hidden  = true;
         possessionView.hidden  = true;
         _leftFacingArrow.hidden  = true;
         _rightFacingArrow.hidden  = true;
        self.possession_Team_Name_label.hidden = false;
        self.foul_Team_Name_Label.hidden = true;
        self.timingEventsView.hidden = false;
         
        if ([startOfQData[@"ot"] integerValue] == 0 && [startOfQData[@"q"] integerValue] != 1){
        
        self.matchStateLabel.text = [NSString stringWithFormat:@"Q%ld started", [startOfQData[@"q"] integerValue] ];
 
        [eventsArray addObject:(NSString*)[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"Q%ld Started", [startOfQData[@"q"] integerValue]]]];
        self.quarterInformation = (NSString*)[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"Q%ld", [startOfQData[@"q"] integerValue]]];
            
        }else if ([startOfQData[@"ot"] integerValue] > 0){
            
            self.matchStateLabel.text = [NSString stringWithFormat:@"OT%ld started", ([startOfQData[@"ot"] integerValue] )];
            self.Quarter_And_Time_Label.text =  [NSString stringWithFormat:@"OT%ld", ([startOfQData[@"ot"] integerValue] )];
            [eventsArray addObject:[NSString stringWithFormat:@"OT%ld started", ([startOfQData[@"ot"] integerValue] )]];
            self.quarterInformation = [NSString stringWithFormat:@"OT%ld", ([startOfQData[@"ot"] integerValue] )];
        }
        
        if([startOfQData[@"q"] integerValue] == 1){
            
            self.matchStateLabel.text = @"Match Started";
            
            [eventsArray addObject:@"Match Started"];
        }

         
        }
         
        [self refreshView];
     }];
    
    /****endOfQ event******/
    [appdelegateForGameio.socketIOClient_For_Game_Animation on:@"endOfQ" callback:^(NSArray* data, SocketAckEmitter* ack) {
        Reachability *_reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus remoteHostStatus = [_reachability currentReachabilityStatus];
        if (remoteHostStatus == NotReachable) {
            // not reachable
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please connect to Internet." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        } else if (remoteHostStatus == ReachableViaWiFi || remoteHostStatus == ReachableViaWWAN) {
            // reachable via WWAN
          
        possession_Team_Name_label.text = @"";
        free_Throw_Label.text = @"";
        self.time_out_parent_view.hidden = true;
            
        NSDictionary* endOfQData = (NSDictionary*)data[0];
        NSLog(@"endOfQ: %@", endOfQData);

            
        foulsParentView.hidden = true;
        freeThrowParentView.hidden  = true;
        time_out_View.hidden  = true;
        possessionView.hidden  = true;
        _leftFacingArrow.hidden  = true;
        _rightFacingArrow.hidden  = true;
        self.timingEventsView.hidden = false;
        self.possession_Team_Name_label.hidden = false;
        self.foul_Team_Name_Label.hidden = true;
        time_ForBTeam_ImageView.hidden = true;
        time_ForATeam_ImageView.hidden = true;
            
        if (([endOfQData[@"ot"] integerValue] == 0) && [endOfQData[@"q"] integerValue] != -1){

        if(![(NSString*)[NSString stringWithFormat:@"Q%ld ended", ([endOfQData[@"q"] integerValue]  )]  isEqual: @"Q-1 ended"])
        
            if ([endOfQData[@"ot"] integerValue] == 0 && !(([endOfQData[@"q"] integerValue] - 1 ) == -1))
            {
            [eventsArray addObject:(NSString*)[NSString stringWithFormat:@"Q%ld ended", ([endOfQData[@"q"] integerValue] - 1 )]];
            self.matchStateLabel.text = (NSString*)[NSString stringWithFormat:@"Q%ld ended", ([endOfQData[@"q"] integerValue] - 1 )];
            self.quarterInformation = (NSString*)[NSString stringWithFormat:@"Q%ld", ([endOfQData[@"q"] integerValue] - 1 )];
            self.timeInformation = @"10:00";
            self.Quarter_And_Time_Label.text =  [NSString stringWithFormat:@"Q%ld - %@", [endOfQData[@"q"] integerValue] , self.timeInformation];
            }
            else {

            [eventsArray addObject:(NSString*)[NSString stringWithFormat:@"Q4 ended"]];
             self.matchStateLabel.text = (NSString*)[NSString stringWithFormat:@"Q4 ended"];
            self.quarterInformation = (NSString*)[NSString stringWithFormat:@"Q4"];
                
            self.timeInformation = @"05:00";
            self.Quarter_And_Time_Label.text =  [NSString stringWithFormat:@"OT1 - %@", self.timeInformation];
            }
        
        }else if ([endOfQData[@"ot"] integerValue] > 0 ){
            if(teamA_totalScore == teamB_totalScore){

            self.matchStateLabel.text = [NSString stringWithFormat:@"OT%ld ended", [endOfQData[@"ot"] integerValue] ];
            self.quarterInformation = [NSString stringWithFormat:@"OT%ld", [endOfQData[@"ot"] integerValue] ];
            [eventsArray addObject:[NSString stringWithFormat:@"OT%ld ended", [endOfQData[@"ot"] integerValue]]];
                
            self.timeInformation = @"05:00";
            self.Quarter_And_Time_Label.text =  [NSString stringWithFormat:@"OT%ld - %@", [endOfQData[@"ot"] integerValue] + 1, self.timeInformation];
            }
            else{
                self.timeInformation = @"00:00";
                self.matchStateLabel.text = @"Game ended";
                self.Quarter_And_Time_Label.text = @"Game ended";
                [eventsArray addObject:@"Match Ended"];
            }
        }

            [self refreshView];
        }
    }];

    /****timeout event******/

    [appdelegateForGameio.socketIOClient_For_Game_Animation on:@"timeout" callback:^(NSArray* data, SocketAckEmitter* ack) {
        Reachability *_reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus remoteHostStatus = [_reachability currentReachabilityStatus];
        if (remoteHostStatus == NotReachable) {
            // not reachable
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please connect to Internet." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        } else if (remoteHostStatus == ReachableViaWiFi || remoteHostStatus == ReachableViaWWAN) {
            // reachable via WWAN
            
            
         NSDictionary* timeoutQData = (NSDictionary*)data[0];
         NSLog(@"timeoutQData: %@", timeoutQData);
        
        self.time_out_parent_view.hidden = false;
        self.ballImageView.hidden = true;
        self.foulsParentView.hidden = true;
        self.possessionView.hidden = true;
        self.freeThrowParentView.hidden = true;
        freeThrough_TeamA_Dot.hidden = true;
        freeThrough_TeamB_Dot.hidden = true;
        self.timingEventsView.hidden = true;
        self.possession_Team_Name_label.hidden = false;
        self.foul_Team_Name_Label.hidden = true;
            
        if([(NSString*)[NSString stringWithFormat:@"%@",[timeoutQData valueForKey:@"message"]]  isEqual: @"Team B TimeOut"]){
            
            self.rightFacingArrow.hidden = true;
            self.leftFacingArrow.hidden = true;
            self.basketBallCourt.image = [UIImage  imageNamed:@"basketBallCourt.png"];
            
            time_ForBTeam_ImageView.hidden = true;
            time_ForATeam_ImageView.hidden = false;
            time_out_line_imageview.image = [UIImage imageNamed:@"bar_with_line_right.png"];
            possession_Team_Name_label.text = SecondTeam_Label.text;
            free_Throw_Label.text = @"Timeout";
        }else if([(NSString*)[NSString stringWithFormat:@"%@",[timeoutQData valueForKey:@"message"]]  isEqual: @"Team A TimeOut"]){
            
            self.rightFacingArrow.hidden = true;
            self.leftFacingArrow.hidden = true;
            self.basketBallCourt.image = [UIImage  imageNamed:@"basketBallCourt.png"];
            
            time_ForBTeam_ImageView.hidden = false;
            time_ForATeam_ImageView.hidden = true;
            time_out_line_imageview.image = [UIImage imageNamed:@"bar_with_line_left.png"];
            possession_Team_Name_label.text = FirstTeam_Label.text;
            free_Throw_Label.text = @"Timeout";
        }

       // [eventsArray addObject:(NSString*)[NSString stringWithFormat:@"%@", [timeoutQData valueForKey:@"message"]]];
        
        if ([[timeoutQData valueForKey:@"message"]  isEqual: @"Team A TimeOut"]){
            [eventsArray addObject:[NSString stringWithFormat:@"%@ TimeOut", team_A]];
        }else{
            [eventsArray addObject:[NSString stringWithFormat:@"%@ TimeOut", team_B]];
        }
            
        [self refreshView ];
        }
    }];

    /****timeUpdated event******/

    [appdelegateForGameio.socketIOClient_For_Game_Animation on:@"timeUpdated" callback:^(NSArray* data, SocketAckEmitter* ack) {
        Reachability *_reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus remoteHostStatus = [_reachability currentReachabilityStatus];
        if (remoteHostStatus == NotReachable) {
            // not reachable
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please connect to Internet." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        } else if (remoteHostStatus == ReachableViaWiFi || remoteHostStatus == ReachableViaWWAN) {
            // reachable via WWAN
            

        NSDictionary* timeUpdatedData = (NSDictionary*)data[0];
        NSLog(@"timeUpdated: %@", timeUpdatedData);
        self.possession_Team_Name_label.hidden = false;
        self.foul_Team_Name_Label.hidden = true;
            
            if([[timeUpdatedData valueForKey:@"remainMin"] integerValue] >= 0 && [[timeUpdatedData valueForKey:@"remainSec"] integerValue] >= 0){
           
            self.timeInformation = [NSString stringWithFormat:@"%02ld : %02ld", [[timeUpdatedData valueForKey:@"remainMin"] integerValue], [[timeUpdatedData valueForKey:@"remainSec"] integerValue]];

            self.Quarter_And_Time_Label.text =  [NSString stringWithFormat:@"%@ - %@", self.quarterInformation, self.timeInformation];

            [self refreshView ];
                
            }
        }
    }];
    
    /****startOfQ event******/
    [appdelegateForGameio.socketIOClient_For_Game_Animation on:@"gameEnded" callback:^(NSArray* data, SocketAckEmitter* ack) {
        // NSLog(@"startOfQ: %@", data[0]);
        Reachability *_reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus remoteHostStatus = [_reachability currentReachabilityStatus];
        if (remoteHostStatus == NotReachable) {
            // not reachable
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please connect to Internet." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        } else if (remoteHostStatus == ReachableViaWiFi || remoteHostStatus == ReachableViaWWAN) {

            possession_Team_Name_label.text = @"";
            free_Throw_Label.text = @"";
            
            NSDictionary* gameEndedData = (NSDictionary*)data[0];
            self.time_out_parent_view.hidden = true;
            NSLog(@"gameEnded: %@", gameEndedData);
            
            foulsParentView.hidden = true;
            freeThrowParentView.hidden  = true;
            time_out_View.hidden  = true;
            possessionView.hidden  = true;
            _leftFacingArrow.hidden  = true;
            _rightFacingArrow.hidden  = true;
            self.timingEventsView.hidden = false;
            self.possession_Team_Name_label.hidden = false;
            self.foul_Team_Name_Label.hidden = true;
            time_ForBTeam_ImageView.hidden = true;
            time_ForATeam_ImageView.hidden = true;
            self.matchStateLabel.text = @"Match Ended";
            
            if(![[eventsArray lastObject]  isEqual: @"Match Ended"]){
                
            [eventsArray addObject:@"Match Ended"];
            [self refreshView];
                
            }
        }
    }];


}

-(void) ballDeflected:(UIImageView*)view withMoveX:(NSInteger)moveX withMoveY:(NSInteger)moveY withMessage:(NSString*)message withTeamName:(NSString*)teamName  {
   // NSLog(@"moveImage possessionTeam : %@ ", self.possessionTeam.text);
    
    ballImageView.hidden = false;

    if ([teamName  isEqual: @"Team B"]){
        ballImageView.center = CGPointMake(xPositionForA, yPosition);
        freeThrough_TeamB_Dot.hidden = true;
        freeThrough_TeamA_Dot.hidden = false;
        freeThrough_line_view.image = [UIImage imageNamed:@"bar_with_line_left.png"];

    }else if ([teamName  isEqual: @"Team A"]){
        ballImageView.center = CGPointMake(xPositionForB, yPosition);
        freeThrough_TeamB_Dot.hidden = false;
        freeThrough_TeamA_Dot.hidden = true;
        freeThrough_line_view.image = [UIImage imageNamed:@"bar_with_line_right.png"];
    }

    
    CGFloat direction = 1.0;
    
    if ([teamName  isEqual: @"Team B"]){
        direction = -1;
    }
    
    [UIView animateWithDuration:1.0 delay:0.0 options: UIViewAnimationOptionCurveEaseOut animations:^{
        
        CATransform3D transform = CATransform3DIdentity;
        transform = CATransform3DScale(transform, 0.25, 0.25, 0.25);
        transform = CATransform3DTranslate(transform, direction *  moveX, 0, 0);
        view.layer.transform = transform;
        
        [UIView animateWithDuration:1.0
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             view.transform = CGAffineTransformMakeRotation(direction * 30);
                             view.layer.transform = transform;
                             [view setAlpha:0.2];
  
                         }
                         completion:^(BOOL finished){
                             //NSLog(@"ball rotation Done!");
                             
                             if ([teamName  isEqual: @"Team B"]){
                                 ballImageView.center = CGPointMake(xPositionForA * 0.5, yPosition);
                             }else  if ([teamName  isEqual: @"Team A"]){
                              ballImageView.center = CGPointMake(xPositionForB * 1.25 , yPosition);
                             }
                             
                             [UIView animateWithDuration:1.0 delay:0.0 options: UIViewAnimationOptionCurveEaseOut animations:^{
                                 
                                 CATransform3D transform = CATransform3DIdentity;
                                 transform = CATransform3DScale(transform, 1.0, 1.0, 1.0);
                                 transform = CATransform3DTranslate(transform, (-direction *  moveX)/10,  -direction *  moveX/10, 0);
                                 view.layer.transform = transform;
                                 
                                 [UIView animateWithDuration:1.0
                                                       delay:0.0
                                                     options: UIViewAnimationOptionCurveEaseOut
                                                  animations:^{
                                                      
                                                      view.transform = CGAffineTransformMakeRotation(direction * 30);
                                                      view.layer.transform = transform;
                                                      
                                                      [view setAlpha:1.0];
                                                      
                                                  }
                                  completion:^(BOOL finished){
                                    //  NSLog(@"ball rotation Done!");
                                  }];
                                 
                             }
                          completion:^(BOOL finished){
                             // NSLog(@"ball translation Done!");
                          }];
                         }];
        
                    }
                     completion:^(BOOL finished){
                        // NSLog(@"ball translation Done!");
    }];


    

    
}



-(void) moveImage:(UIImageView*)view withMoveX:(NSInteger)moveX withMoveY:(NSInteger)moveY withTeam:(NSString*)team withBool:(BOOL)is3pts{
    //NSLog(@"moveImage possessionTeam : %@ ", self.possessionTeam.text);

        if( is3pts){
            if ([team  isEqual: @"Team B"]){
                ballImageView.center = CGPointMake(xPositionForA, yPosition);
            }else if ([team  isEqual: @"Team A"]){
                ballImageView.center = CGPointMake(xPositionForB, yPosition);
            }
        }else{
            
            ballImageView.center = CGPointMake(ballCenterPosition, yPosition);
            
        }
        
        CGFloat direction = 1.0;
        
        if ([team  isEqual: @"Team B"]){
            direction = -1;
        }
        [UIView animateWithDuration:1.0
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{

                             CATransform3D transform = CATransform3DIdentity;
                             transform = CATransform3DScale(transform, 0.25, 0.25, 0.25);
                             transform = CATransform3DTranslate(transform, direction *  moveX, 0, 0);
                             view.layer.transform = transform;

                             [UIView animateWithDuration:1.0
                                                   delay:0.0
                                                 options: UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  
                                              view.transform = CGAffineTransformMakeRotation(direction * 30);
                                              view.layer.transform = transform;
                                            
                                              [view setAlpha:1.0];
                                                  [UIView animateWithDuration:1.f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
                                                      [view setAlpha:0.4];
                                                  } completion:nil];
                                                  
                                              }
                                              completion:^(BOOL finished){
                                                 // NSLog(@"ball rotation Done!");
                            }];

                         }
                         completion:^(BOOL finished){
                             //NSLog(@"ball translation Done!");
        }];
   
}

-(void) refreshView
{
    //print("scoreArray : \(eventsArray)")
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        [self.tableViewForGameScore reloadData ];
        [self.view setNeedsDisplay ];
        
        self.view.alpha = 1.0;
        [activityIndicator stopAnimating];
        [activityIndicator setHidden:true];

    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/****uittableview delegate methods******/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    //return arrayOfDictionaryForChampionship.count;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Game Events";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return eventsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    //
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if( [eventsArray count] > 0){
        //cell.textLabel.font = cell.textLabel.font;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.text = (NSString*)eventsArray[ (eventsArray.count - 1) - indexPath.row ] ;
        cell.textLabel.numberOfLines = 3;

    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
 
}

@end
