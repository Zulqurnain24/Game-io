//
//  ViewController.m
//  Game_io_Objective_C
//
//  Created by Mohammad Zulqurnain on 23/10/2016.
//  Copyright © 2016 Mohammad Zulqurnain. All rights reserved.
//

#import "GamesMenu.h"
#import "GameCellTableViewCell.h"
#import "LiveGameView.h"
#import "Reachability.h"
@interface GamesMenu ()

@end


@implementation GamesMenu
@synthesize  tableViewForGames, activityIndicator,textCellIdentifier,selectedrow, socketURL;
NSInteger counterForTotalGames;
NSString *urlStringForSocketBackend =  @"https://liveadmin.herokuapp.com";
NSInteger count = 0;
NSString* matchID;
NSString* countryID;
NSInteger previousSeconds = 0;
AppDelegate* appdelegateForGameio_for_menu;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    appdelegateForGameio_for_menu = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    tableViewForGames.delegate = self;
    tableViewForGames.dataSource = self;
    appdelegateForGameio_for_menu.gamesForChampionshipArray  = [NSArray array];

}

-(void)viewWillAppear:(BOOL)animated{
    
    // Do any additional setup after loading the view, typically from a nib.
    [self fillChampionshipAndGamesArray:@"https://liveadmin.herokuapp.com/api/countries/games/"];
    
}

-(void) updateGameTimeFromLastLiveGame{
    
    NSString *lastM_id = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"lastM_id"];
    NSObject * object = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastM_id"];
    if(object != nil){
        //object is there

        for(int i = 0; i < [appdelegateForGameio_for_menu.gamesForChampionshipArray count]; i++){
            
            for(int j = 0; j < [appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game].count; j++){
                
                // NSLog(@"m_id: %@, game array m_id: %@, boolean value for: %d", m_id, [NSString stringWithFormat:@"%@",[((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]) m_id]],  [m_id integerValue] == [[NSString stringWithFormat:@"%@",[((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]) m_id]] integerValue]);
           
                if([lastM_id integerValue] == [[NSString stringWithFormat:@"%@",[((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]) m_id]] integerValue]){
                    
                    // NSLog(@"team_a_result: %@ , team_b_result: %@ , active_q: %@ , Q_Time: %@ ",((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).team_a_result, ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).team_b_result, ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).active_q, ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).Q_Time);
                    NSString *lastTime = [[NSUserDefaults standardUserDefaults]
                                            stringForKey:@"lastTime"];
                    
                    ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).Q_Time = [NSString stringWithFormat:@"%@", lastTime];
                    
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        
                        // Build the two index paths
                        NSIndexPath* indexPath1 = [NSIndexPath indexPathForRow:j inSection:i];
                        NSIndexPath* indexPath2 = [NSIndexPath indexPathForRow:j inSection:i];
                        // Add them in an index path array
                        NSArray* indexArray = [NSArray arrayWithObjects:indexPath1, indexPath2, nil];
                        // Launch reload for the two index path
                        [self.tableViewForGames reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
                        
                    });
                    break;
                }
                
            }
        }
    }
    
    NSString *valueToSave = nil;
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"lastTime"];
    NSString *last_m_id = nil;
    [[NSUserDefaults standardUserDefaults] setObject:last_m_id forKey:@"lastM_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)viewDidAppear:(BOOL)animated{
    
   tableViewForGames.userInteractionEnabled = true;

    
}

-(void)viewWillDisappear:(BOOL)animated{

    NSLog(@"appdelegateForGameio.socketUUID : %@", appdelegateForGameio_for_menu.socketUUID);
    [appdelegateForGameio_for_menu.socketIOClient_For_Games_Menu off:@"globalTimeUpdated"];
   // [appdelegateForGameio_for_menu.socketIOClient_For_Games_Menu offWithId:appdelegateForGameio_for_menu.socketUUID];
    [appdelegateForGameio_for_menu.socketIOClient_For_Games_Menu  removeAllHandlers];
    
    [appdelegateForGameio_for_menu.socketIOClient_For_Games_Menu off:@"globalStartOfQ"];
   // [appdelegateForGameio_for_menu.socketIOClient_For_Games_Menu offWithId:appdelegateForGameio_for_menu.socketUUID];
    [appdelegateForGameio_for_menu.socketIOClient_For_Games_Menu  removeAllHandlers];
    
    [appdelegateForGameio_for_menu.socketIOClient_For_Games_Menu off:@"globalEndOfQ"];
    [appdelegateForGameio_for_menu.socketIOClient_For_Games_Menu offWithId:appdelegateForGameio_for_menu.socketUUID];
    [appdelegateForGameio_for_menu.socketIOClient_For_Games_Menu  removeAllHandlers];
    

}

-(void) socketLogicAndEvents{
    
    socketURL = urlStringForSocketBackend;
    NSURL* url = [[NSURL alloc] initWithString:socketURL];
    
    appdelegateForGameio_for_menu.socketIOClient_For_Games_Menu = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @NO, @"forcePolling": @YES}];
    
    [appdelegateForGameio_for_menu.socketIOClient_For_Games_Menu on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
       // NSLog(@"***-socket connected-***");
   

    }];
    
    
    [self navigationController].title = @"<Live Game Menu>";
    [appdelegateForGameio_for_menu.socketIOClient_For_Games_Menu connect];

    
    /****Global Events******/
    
    //global time updated event
    appdelegateForGameio_for_menu.socketUUID = [appdelegateForGameio_for_menu.socketIOClient_For_Games_Menu on:@"globalTimeUpdated" callback:^(NSArray* data, SocketAckEmitter* ack) {
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


            
        NSDictionary* globalUpdateEventData = (NSDictionary*)data[0];
            
        NSLog(@"globalUpdateEventData : %@", globalUpdateEventData);
            
        NSDictionary* scoreData = (NSDictionary*)data[0];
        NSString* m_id =  (NSString*)[scoreData valueForKey:@"m_id"];
        
        for(int i = 0; i < [appdelegateForGameio_for_menu.gamesForChampionshipArray count]; i++){
            
            for(int j = 0; j < [appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game].count; j++){

                if([m_id integerValue] == [[NSString stringWithFormat:@"%@",[((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]) m_id]] integerValue]){
                    //display time if positive only(takes care of time even triggering twice)
                   if( ([scoreData[@"time"][@"remainSec"] integerValue] != previousSeconds) && ([scoreData[@"time"][@"remainSec"] integerValue] >= 0 && [scoreData[@"time"][@"remainMin"] integerValue] >= 0)){

                    NSLog(@"time in min: %ld", [scoreData[@"time"][@"remainMin"] integerValue]);
                    NSLog(@"time in sec: %ld", [scoreData[@"time"][@"remainSec"] integerValue]);
        
                    ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).Q_Time = [NSString stringWithFormat:@"%02ld : %02ld",  [scoreData[@"time"][@"remainMin"] integerValue], [scoreData[@"time"][@"remainSec"] integerValue]];
               
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        
                        // Build the two index paths
                        NSIndexPath* indexPath1 = [NSIndexPath indexPathForRow:j inSection:i];
                        NSIndexPath* indexPath2 = [NSIndexPath indexPathForRow:j inSection:i];
                        // Add them in an index path array
                        NSArray* indexArray = [NSArray arrayWithObjects:indexPath1, indexPath2, nil];
                        // Launch reload for the two index path
                        [self.tableViewForGames reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
                    });
                       
                    }
                    
                    previousSeconds = [scoreData[@"time"][@"remainSec"] integerValue];
                    
                    break;
                }
                
            }
        }
        }
    }];


    /*******gameEnded*************/
    [appdelegateForGameio_for_menu.socketIOClient_For_Games_Menu on:@"gameEnded" callback:^(NSArray* data, SocketAckEmitter* ack) {
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
            
            NSDictionary* globalGameEndedData = (NSDictionary*)data[0];
            NSDictionary* scoreData = (NSDictionary*)data[0];
            NSString* m_id =  (NSString*)[scoreData valueForKey:@"m_id"];
            NSLog(@"%@", [NSString stringWithFormat:@"globalGameEndedData : %@", globalGameEndedData]);
            
            for(int i = 0; i < [appdelegateForGameio_for_menu.gamesForChampionshipArray count]; i++){
                
                for(int j = 0; j < [appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game].count; j++){
                    
                    // NSLog(@"m_id: %@, game array m_id: %@, boolean value for: %d", m_id, [NSString stringWithFormat:@"%@",[((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]) m_id]],  [m_id integerValue] == [[NSString stringWithFormat:@"%@",[((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]) m_id]] integerValue]);
                    
                    if([m_id integerValue] == [[NSString stringWithFormat:@"%@",[((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]) m_id]] integerValue]){
                        
                        // NSLog(@"team_a_result: %@ , team_b_result: %@ , active_q: %@ , Q_Time: %@ ",((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).team_a_result, ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).team_b_result, ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).active_q, ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).Q_Time);
                        
                        ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).active_q = [NSString stringWithFormat:@"%@",  globalGameEndedData[@"q"]];
                        
                        ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).ot_count = [NSString stringWithFormat:@"%ld", ([globalGameEndedData[@"ot"] integerValue] )];
                        
                        ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).Q_Time = [NSString stringWithFormat:@"00:00"];
                        
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            
                            // Build the two index paths
                            NSIndexPath* indexPath1 = [NSIndexPath indexPathForRow:j inSection:i];
                            NSIndexPath* indexPath2 = [NSIndexPath indexPathForRow:j inSection:i];
                            // Add them in an index path array
                            NSArray* indexArray = [NSArray arrayWithObjects:indexPath1, indexPath2, nil];
                            // Launch reload for the two index path
                            [self.tableViewForGames reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
                            
                        });
                        break;
                    }
                    
                }
            }
        }
    }];
    
    /*****Global start of quarter****/
    [appdelegateForGameio_for_menu.socketIOClient_For_Games_Menu on:@"globalStartOfQ" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
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

            NSDictionary* globalStartOfData = (NSDictionary*)data[0];
             NSLog(@"globalStartOfQ : %@", globalStartOfData);
            NSString* m_id =  (NSString*)[globalStartOfData valueForKey:@"m_id"];
            
            for(int i = 0; i < [appdelegateForGameio_for_menu.gamesForChampionshipArray count]; i++){
                
                for(int j = 0; j < [appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game].count; j++){
                    
                    // NSLog(@"m_id: %@, game array m_id: %@, boolean value for: %d", m_id, [NSString stringWithFormat:@"%@",[((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]) m_id]],  [m_id integerValue] == [[NSString stringWithFormat:@"%@",[((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]) m_id]] integerValue]);
                    
                    if([m_id integerValue] == [[NSString stringWithFormat:@"%@",[((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]) m_id]] integerValue]){
                        
                        // NSLog(@"team_a_result: %@ , team_b_result: %@ , active_q: %@ , Q_Time: %@ ",((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).team_a_result, ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).team_b_result, ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).active_q, ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).Q_Time);
                        
                        ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).active_q = [NSString stringWithFormat:@"%@",  globalStartOfData[@"q"]];
                        
                        ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).ot_count = [NSString stringWithFormat:@"%ld", ([globalStartOfData[@"ot"] integerValue])];
                        
                        ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).Q_Time = [NSString stringWithFormat:@"10:00"];
                        
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            
                            // Build the two index paths
                            NSIndexPath* indexPath1 = [NSIndexPath indexPathForRow:j inSection:i];
                            NSIndexPath* indexPath2 = [NSIndexPath indexPathForRow:j inSection:i];
                            // Add them in an index path array
                            NSArray* indexArray = [NSArray arrayWithObjects:indexPath1, indexPath2, nil];
                            // Launch reload for the two index path
                            [self.tableViewForGames reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
                            
                        });
                        break;
                    }
                    
                }
            }
        }
        
    }];
    
    /*****Global start of quarter****/
    [appdelegateForGameio_for_menu.socketIOClient_For_Games_Menu on:@"globalEndOfQ" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
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
            
            NSDictionary* globalEndOfQData = (NSDictionary*)data[0];
            NSLog(@"globalEndOfQ : %@", globalEndOfQData);
            NSString* m_id =  (NSString*)[globalEndOfQData valueForKey:@"m_id"];
            
            for(int i = 0; i < [appdelegateForGameio_for_menu.gamesForChampionshipArray count]; i++){
                
                for(int j = 0; j < [appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game].count; j++){
                    
                    // NSLog(@"m_id: %@, game array m_id: %@, boolean value for: %d", m_id, [NSString stringWithFormat:@"%@",[((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]) m_id]],  [m_id integerValue] == [[NSString stringWithFormat:@"%@",[((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]) m_id]] integerValue]);
                    
                    if([m_id integerValue] == [[NSString stringWithFormat:@"%@",[((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]) m_id]] integerValue]){
                        
                        // NSLog(@"team_a_result: %@ , team_b_result: %@ , active_q: %@ , Q_Time: %@ ",((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).team_a_result, ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).team_b_result, ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).active_q, ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).Q_Time);
                        
                        ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).active_q = [NSString stringWithFormat:@"%@",  globalEndOfQData[@"q"]];
                        
                        ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).ot_count = [NSString stringWithFormat:@"%ld", ([globalEndOfQData[@"ot"] integerValue])];
                        
                        ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).Q_Time = [NSString stringWithFormat:@"10:00"];
                        
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                            
                            // Build the two index paths
                            NSIndexPath* indexPath1 = [NSIndexPath indexPathForRow:j inSection:i];
                            NSIndexPath* indexPath2 = [NSIndexPath indexPathForRow:j inSection:i];
                            // Add them in an index path array
                            NSArray* indexArray = [NSArray arrayWithObjects:indexPath1, indexPath2, nil];
                            // Launch reload for the two index path
                            [self.tableViewForGames reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
                            
                        });
                        break;
                    }
                    
                }
            }
        }
        
    }];

    
    /*****Global Score Updated****/
    [appdelegateForGameio_for_menu.socketIOClient_For_Games_Menu on:@"globalScoreUpdated" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
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
            

    NSDictionary* globalUpdateEventData = (NSDictionary*)data[0];

     NSLog(@"globalScoreUpdatedEventData : %@", globalUpdateEventData);
        
    NSDictionary* scoreData = (NSDictionary*)data[0];
    NSString* m_id =  (NSString*)[scoreData valueForKey:@"m_id"];

    for(int i = 0; i < [appdelegateForGameio_for_menu.gamesForChampionshipArray count]; i++){

        for(int j = 0; j < [appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game].count; j++){

           // NSLog(@"m_id: %@, game array m_id: %@, boolean value for: %d", m_id, [NSString stringWithFormat:@"%@",[((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]) m_id]],  [m_id integerValue] == [[NSString stringWithFormat:@"%@",[((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]) m_id]] integerValue]);
            
            if([m_id integerValue] == [[NSString stringWithFormat:@"%@",[((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]) m_id]] integerValue]){

               // NSLog(@"team_a_result: %@ , team_b_result: %@ , active_q: %@ , Q_Time: %@ ",((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).team_a_result, ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).team_b_result, ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).active_q, ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).Q_Time);
                

                   ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).team_a_result = [NSString stringWithFormat:@"%ld",  [scoreData[@"team_a_result"] integerValue]];

                   ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).team_b_result = [NSString stringWithFormat:@"%ld",  [scoreData[@"team_b_result"] integerValue]];
                
             
                   ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).active_q = [NSString stringWithFormat:@"%@",  scoreData[@"q"]];
                
                    ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).ot_count = [NSString stringWithFormat:@"%ld", ([scoreData[@"ot_count"] integerValue] + 1)];
                
                    ((Game*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j]).Q_Time = [NSString stringWithFormat:@"%@",  scoreData[@"time"] ];
                
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                   
                        // Build the two index paths
                        NSIndexPath* indexPath1 = [NSIndexPath indexPathForRow:j inSection:i];
                        NSIndexPath* indexPath2 = [NSIndexPath indexPathForRow:j inSection:i];
                        // Add them in an index path array
                        NSArray* indexArray = [NSArray arrayWithObjects:indexPath1, indexPath2, nil];
                        // Launch reload for the two index path
                        [self.tableViewForGames reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
                    
                    });
                break;
               }

        }
    }
    }

    }];
    
    /****Global Events******/
    
    /****Game Started Event*******/
    [appdelegateForGameio_for_menu.socketIOClient_For_Games_Menu on:@"gameStarted" callback:^(NSArray* data, SocketAckEmitter* ack) {
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
            _MenuGameView.alpha = 0.6;
        });
        
        NSDictionary* gameStartedEventData = (NSDictionary*)data[0];
        
        NSLog(@"gameStartedEventData : %@ ",  gameStartedEventData);
            
        bool isGameAdded = false;
        
        for(ChampionshipGameObject* elementOfChampionShipGames in appdelegateForGameio_for_menu.gamesForChampionshipArray){
            
          //  NSLog(@"(NSString*)[[elementOfChampionShipGames championShip] c_id] == (NSString*)gameStartedEventData[@c_id] : %d and %ld == %ld",  [[[elementOfChampionShipGames championShip] c_id] integerValue] == [gameStartedEventData[@"c_id"] integerValue], (long)[[[elementOfChampionShipGames championShip] c_id] integerValue],  [gameStartedEventData[@"c_id"] integerValue]);

            if([[[elementOfChampionShipGames championShip] c_id] integerValue] == [gameStartedEventData[@"c_id"] integerValue]){
                
                NSLog(@"related championship match found and game array updated c_id : %@ ",  (NSString*)[[elementOfChampionShipGames championShip] c_id] );
                
                isGameAdded = true;
                Game* gameObject = [[Game alloc] initWithParams:(NSString*)gameStartedEventData[@"m_id"] withC_id:(NSString*)gameStartedEventData[@"c_id"] withChampionshipName:(NSString*)gameStartedEventData[@"championship_name"] withR_id:(NSString*)gameStartedEventData[@"r_id"] withTeam_a_name:(NSString*)gameStartedEventData[@"team_a"] withTeam_b_name:(NSString*)gameStartedEventData[@"team_b"]  withTeam_a_result:(NSString*)gameStartedEventData[@"team_a_result"] withTeam_b_result:(NSString*)gameStartedEventData[@"team_b_result"] withStop_min:@"10" withStop_sec:@"00"  withCountry_id:(NSString*)gameStartedEventData[@"country_id"] withQ_Active:(NSString*)gameStartedEventData[@"active_q"]withVenue:(NSString*)gameStartedEventData[@"venue"]withOT_count:(NSString*)gameStartedEventData[@"ot_count"]withIsRunning:(NSNumber*)gameStartedEventData[@"is_running"]];
               elementOfChampionShipGames.game = [[elementOfChampionShipGames game] arrayByAddingObject:gameObject];
            }

            if(!isGameAdded && (NSString*)[[elementOfChampionShipGames championShip] c_id] == (NSString*)[[[appdelegateForGameio_for_menu.gamesForChampionshipArray lastObject] championShip] c_id]){
                
                // NSLog(@"new championship added with c_id : %@ ",  (NSString*)[[elementOfChampionShipGames championShip] c_id] );
                
                ChampionShip* championShip = [[ChampionShip alloc] initWithParam:(NSString*)gameStartedEventData[@"c_id"] withChampionshipName:(NSString*)gameStartedEventData[@"championship_name"]];
                ChampionshipGameObject* championshipGameObject = [[ChampionshipGameObject alloc] init];
                NSArray* gameUpdatedArray = [NSArray array];
                 Game* gameObject = [[Game alloc] initWithParams:(NSString*)gameStartedEventData[@"m_id"] withC_id:(NSString*)gameStartedEventData[@"c_id"] withChampionshipName:(NSString*)gameStartedEventData[@"championship_name"] withR_id:(NSString*)gameStartedEventData[@"r_id"] withTeam_a_name:(NSString*)gameStartedEventData[@"team_a"] withTeam_b_name:(NSString*)gameStartedEventData[@"team_b"]  withTeam_a_result:(NSString*)gameStartedEventData[@"team_a_result"] withTeam_b_result:(NSString*)gameStartedEventData[@"team_b_result"] withStop_min:@"10" withStop_sec:@"00"  withCountry_id:(NSString*)gameStartedEventData[@"country_id"] withQ_Active:(NSString*)gameStartedEventData[@"active_q"]withVenue:(NSString*)gameStartedEventData[@"venue"]withOT_count:(NSString*)gameStartedEventData[@"ot_count"]withIsRunning:(NSNumber*)gameStartedEventData[@"is_running"]];
                gameUpdatedArray = [gameUpdatedArray arrayByAddingObject:gameObject];
                [championshipGameObject  initWithDict:championShip withGames:gameUpdatedArray];
                appdelegateForGameio_for_menu.gamesForChampionshipArray = [appdelegateForGameio_for_menu.gamesForChampionshipArray arrayByAddingObject:championshipGameObject];
            }


        }

            
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            //Run UI Updates
            [tableViewForGames reloadData];
            _MenuGameView.alpha = 1.0;
            [activityIndicator stopAnimating];
            [activityIndicator setHidden:true];
            
        });

        }
    }];
    
    //newly added
     /****Game published Event*******/
    [appdelegateForGameio_for_menu.socketIOClient_For_Games_Menu on:@"published" callback:^(NSArray* data, SocketAckEmitter* ack) {
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
                _MenuGameView.alpha = 0.6;
            });
            
            NSDictionary* publishedData = (NSDictionary*)data[0];
            
            NSLog(@"publishedData : %@ ",  publishedData);
            
            bool isGameAdded = false;
            
            for(ChampionshipGameObject* elementOfChampionShipGames in appdelegateForGameio_for_menu.gamesForChampionshipArray){
                
                //  NSLog(@"(NSString*)[[elementOfChampionShipGames championShip] c_id] == (NSString*)gameStartedEventData[@c_id] : %d and %ld == %ld",  [[[elementOfChampionShipGames championShip] c_id] integerValue] == [gameStartedEventData[@"c_id"] integerValue], (long)[[[elementOfChampionShipGames championShip] c_id] integerValue],  [gameStartedEventData[@"c_id"] integerValue]);
                
                if([[[elementOfChampionShipGames championShip] c_id] integerValue] == [[[publishedData valueForKey:@"game"]valueForKey:@"c_id" ] integerValue]){
                    
                    NSLog(@"related championship match found and game array updated c_id : %@ ",  (NSString*)[[elementOfChampionShipGames championShip] c_id] );
                    
                    isGameAdded = true;
                    Game* gameObject = [[Game alloc] initWithParams:(NSString*)[[publishedData valueForKey:@"game"]valueForKey:@"m_id" ] withC_id:(NSString*)[[publishedData valueForKey:@"game"]valueForKey:@"c_id" ] withChampionshipName:(NSString*)[[publishedData valueForKey:@"game"]valueForKey:@"championship_name" ]  withR_id:(NSString*)[[publishedData valueForKey:@"game"]valueForKey:@"r_id" ] withTeam_a_name:(NSString*)[[publishedData valueForKey:@"game"]valueForKey:@"team_a" ] withTeam_b_name:(NSString*)(NSString*)[[publishedData valueForKey:@"game"]valueForKey:@"team_b" ] withTeam_a_result:(NSString*)[[publishedData valueForKey:@"game"]valueForKey:@"team_a_result" ] withTeam_b_result:(NSString*)[[publishedData valueForKey:@"game"]valueForKey:@"team_b_result" ] withStop_min:(NSString*)[[publishedData valueForKey:@"game"]valueForKey:@"stop_min" ] withStop_sec:(NSString*)[[publishedData valueForKey:@"game"]valueForKey:@"stop_sec" ]   withCountry_id:(NSString*)[[publishedData valueForKey:@"game"]valueForKey:@"country_id" ] withQ_Active:(NSString*)[[publishedData valueForKey:@"game"]valueForKey:@"active_q" ] withVenue:(NSString*)[[publishedData valueForKey:@"game"]valueForKey:@"venue" ]withOT_count:(NSString*)[[publishedData valueForKey:@"game"]valueForKey:@"ot_count" ] withIsRunning:[[publishedData valueForKey:@"game"]valueForKey:@"is_running" ]];
                    elementOfChampionShipGames.game = [[elementOfChampionShipGames game] arrayByAddingObject:gameObject];
                    break;
                }
  
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                //Run UI Updates
                [tableViewForGames reloadData];
                _MenuGameView.alpha = 1.0;
                [activityIndicator stopAnimating];
                [activityIndicator setHidden:true];
                
            });
            
        }
    }];
    
    //Newly added
    /****Game unpublished Event*******/
    [appdelegateForGameio_for_menu.socketIOClient_For_Games_Menu on:@"unpublished" callback:^(NSArray* data, SocketAckEmitter* ack) {
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
                _MenuGameView.alpha = 0.6;
            });
            
            NSDictionary* gameStartedEventData = (NSDictionary*)data[0];
            
            NSLog(@"unpublishedData : %@ ",  gameStartedEventData);

            for(int i = 0; i < [appdelegateForGameio_for_menu.gamesForChampionshipArray count]; i++){

                NSLog(@"c_id : %@ ", [[gameStartedEventData valueForKey:@"game"] valueForKey:@"c_id"]);
                
                if([[[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] championShip] c_id] integerValue] == [[[gameStartedEventData valueForKey:@"game"] valueForKey:@"c_id"] integerValue]){
                    
                    
                     for(int j = 0; j < [(NSArray*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game] count]; j++){
                         if(([[[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j] m_id] integerValue])  == [[[gameStartedEventData valueForKey:@"game"] valueForKey:@"m_id"] integerValue]){
                   
                             NSMutableArray* tempArray = [(NSArray*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game] mutableCopy];
                             
                             [(NSMutableArray*)tempArray removeObjectAtIndex:j];
                             
                             ((ChampionshipGameObject*)appdelegateForGameio_for_menu.gamesForChampionshipArray[i]).game = [NSArray arrayWithArray:tempArray];
                            
                             break;
                         }
                     }
                   

                }
                
                
                
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                //Run UI Updates
                [tableViewForGames reloadData];
                _MenuGameView.alpha = 1.0;
                [activityIndicator stopAnimating];
                [activityIndicator setHidden:true];
                
            });
            
        }
    }];

    //Newly added
    /****Game gameDeleted Event*******/
    [appdelegateForGameio_for_menu.socketIOClient_For_Games_Menu on:@"gameDeleted" callback:^(NSArray* data, SocketAckEmitter* ack) {
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
                _MenuGameView.alpha = 0.6;
            });
           
            NSDictionary* gameStartedEventData = (NSDictionary*)data[0];
            
            NSLog(@"gameDeletedData : %@ ",  gameStartedEventData);
            
            for(int i = 0; i < [appdelegateForGameio_for_menu.gamesForChampionshipArray count]; i++){
                
                NSLog(@"c_id : %@ ", [[gameStartedEventData valueForKey:@"game"] valueForKey:@"c_id"]);
                
                if([[[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] championShip] c_id] integerValue] == [[[gameStartedEventData valueForKey:@"game"] valueForKey:@"c_id"] integerValue]){
                    
                    
                    for(int j = 0; j < [(NSArray*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game] count]; j++){
                        if(([[[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game][j] m_id] integerValue])  == [[[gameStartedEventData valueForKey:@"game"] valueForKey:@"m_id"] integerValue]){
                            
                            NSMutableArray* tempArray = [(NSArray*)[appdelegateForGameio_for_menu.gamesForChampionshipArray[i] game] mutableCopy];
                            
                            if(tempArray.count > 0){
                                
                            [(NSMutableArray*)tempArray removeObjectAtIndex: (j)];
                 
                            }
                            ((ChampionshipGameObject*)appdelegateForGameio_for_menu.gamesForChampionshipArray[i]).game = [NSArray arrayWithArray:tempArray];
 
                            
                            if(tempArray.count == 0){
                                
                               // [((ChampionshipGameObject*)appdelegateForGameio_for_menu.gamesForChampionshipArray[i]) championShip].c_name = @"";
                                NSMutableArray* tempArrayAppdelegateForGameio_for_menu = [(NSArray*)appdelegateForGameio_for_menu.gamesForChampionshipArray mutableCopy];
                                [(NSMutableArray*)tempArrayAppdelegateForGameio_for_menu removeObjectAtIndex: i];
                                appdelegateForGameio_for_menu.gamesForChampionshipArray = [NSArray arrayWithArray:tempArrayAppdelegateForGameio_for_menu];
                              
                            }
                            
                            
                            break;
                        }
                    }
                    
                    
                }
                
                
                
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                //Run UI Updates
                //

                [tableViewForGames reloadData];
                _MenuGameView.alpha = 1.0;
                [activityIndicator stopAnimating];
                [activityIndicator setHidden:true];
                
            });
            
        }
    }];
}

- (void)fillChampionshipAndGamesArray:(NSString*)urlString
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
        _MenuGameView.alpha = 0.6;
    });
    appdelegateForGameio_for_menu.gamesForChampionshipArray = [NSArray array];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        if ([data length] > 0)
        {

            id jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

           // NSLog(@"games json: %@", jsonArray);
            NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"c_id" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
            jsonArray = [jsonArray sortedArrayUsingDescriptors:sortDescriptors];
            NSLog(@"sortedArray: %@", jsonArray);

              NSArray* gameUpdatedArray = [NSArray array];
              NSDictionary* previousJsonObj = [jsonArray firstObject];
            
                for (NSDictionary* jsonObject in jsonArray){
                    
                    if((NSString*)jsonObject[@"c_id"]  == (NSString*)previousJsonObj[@"c_id"]){
                        
                        Game* game = [[Game alloc] init];
                        [game initWithDict:jsonObject];
                        
                        NSLog(@"[game.stop_min integerValue]: %ld",(long)[game.stop_min integerValue]);
                        NSLog(@"[game.stop_sec integerValue]: %ld",(long)[game.stop_sec integerValue]);
                        
                        if([game.stop_min integerValue] == 0 && [game.stop_sec integerValue] == 0  && !game.q_is_started){
                            if([game.active_q  isEqual: @"OT"]){
                            game.Q_Time = [NSString stringWithFormat:@"05:00"];
                            }else{
                                game.Q_Time = [NSString stringWithFormat:@"10:00"];
                            }
                        }else{
                        //stop_min
                         game.Q_Time = [NSString stringWithFormat:@"%02ld:%02ld", (long)[game.stop_min intValue], (long)[game.stop_sec intValue]];
                        }
                        
                        gameUpdatedArray = [gameUpdatedArray arrayByAddingObject:game];
                        
                    }else if((NSString*)jsonObject[@"c_id"]  != (NSString*)previousJsonObj[@"c_id"]){
                    
                        ChampionShip* championShip = [[ChampionShip alloc] initWithParam:(NSString*)previousJsonObj[@"c_id"] withChampionshipName:(NSString*)previousJsonObj[@"championship_name"]];
                        ChampionshipGameObject* championshipGameObject = [[ChampionshipGameObject alloc] init];
                        [championshipGameObject  initWithDict:championShip withGames:gameUpdatedArray];
                        appdelegateForGameio_for_menu.gamesForChampionshipArray = [appdelegateForGameio_for_menu.gamesForChampionshipArray arrayByAddingObject:championshipGameObject];
                        
                      //  NSLog(@"gamesForChampionshipArray Iteration= %lu", (unsigned long)[appdelegateForGameio_for_menu.gamesForChampionshipArray count]);

                        gameUpdatedArray = [NSArray array];
                        Game* game = [[Game alloc] init];
                        [game initWithDict:jsonObject];
                        if([game.stop_min integerValue] == 0 && [game.stop_sec integerValue] == 0){
                            if([game.active_q  isEqual: @"OT"]){
                                game.Q_Time = [NSString stringWithFormat:@"05:00"];
                            }else{
                                game.Q_Time = [NSString stringWithFormat:@"10:00"];
                            }
                        }else{
                            //stop_min
                            game.Q_Time = [NSString stringWithFormat:@"%02ld:%02ld", (long)[game.stop_min intValue], (long)[game.stop_sec intValue]];
                        }
                        
                        gameUpdatedArray = [gameUpdatedArray arrayByAddingObject:game];
                        
                    }
                    
                    if((NSString*)jsonObject[@"m_id"]  == (NSString*)[jsonArray lastObject][@"m_id"]){
                    
                        ChampionShip* championShip = [[ChampionShip alloc] initWithParam:(NSString*)jsonObject[@"c_id"] withChampionshipName:(NSString*)jsonObject[@"championship_name"]];
                        ChampionshipGameObject* championshipGameObject = [[ChampionshipGameObject alloc] init];
                        [championshipGameObject  initWithDict:championShip withGames:gameUpdatedArray];
                        appdelegateForGameio_for_menu.gamesForChampionshipArray = [appdelegateForGameio_for_menu.gamesForChampionshipArray arrayByAddingObject:championshipGameObject];
                    }
                    previousJsonObj = jsonObject;
                    
                }
            [self socketLogicAndEvents ];
            dispatch_async(dispatch_get_main_queue(), ^(void){

                    //Run UI Updates
                    [tableViewForGames reloadData];
                    [self.view setNeedsDisplay];
                    counterForTotalGames = 0;
                    _MenuGameView.alpha = 1.0;
                    [activityIndicator stopAnimating];
                    [activityIndicator setHidden:true];
                    [self updateGameTimeFromLastLiveGame];

            });

            
        }else{
            NSLog(@"Error: %@", error);
        }
        
    }] resume];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        // Make sure your segue name in storyboard is the same as this line
        if ([[segue identifier] isEqualToString:@"matchViewAnimationIdentifier"])
        {
            // Get reference to the destination view controller
            LiveGameView *destination = [segue destinationViewController];
            destination.countryID =  countryID;
            destination.matchID = matchID;
           // [appdelegateForGameio_for_menu.socketIOClient_For_Games_Menu disconnect];
        }
    //});

}


/****uittableview delegate methods******/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return appdelegateForGameio_for_menu.gamesForChampionshipArray.count;
    //return arrayOfDictionaryForChampionship.count;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   //  NSLog(@"appdelegateForGameio_for_menu: %lu", (unsigned long)appdelegateForGameio_for_menu.gamesForChampionshipArray.count );
     return (NSString*)[[((ChampionshipGameObject*)appdelegateForGameio_for_menu.gamesForChampionshipArray[section])championShip] c_name];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
  // NSLog(@"rows : %lu", count);
   return [(ChampionshipGameObject*)appdelegateForGameio_for_menu.gamesForChampionshipArray[section] game].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSLog(@"indexPath : %@", indexPath);
    NSString *simpleTableIdentifier = @"gameCell";
    
    GameCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
        cell = [[GameCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

    if( ((ChampionshipGameObject*)appdelegateForGameio_for_menu.gamesForChampionshipArray[indexPath.section]).game.count > 0){

     cell.teamA_Name_Label.text  = [(Game*)((ChampionshipGameObject*)appdelegateForGameio_for_menu.gamesForChampionshipArray[indexPath.section]).game[indexPath.row] team_a];
    cell.teamB_Name_Label.text  = [(Game*)((ChampionshipGameObject*)appdelegateForGameio_for_menu.gamesForChampionshipArray[indexPath.section]).game[indexPath.row] team_b];
    cell.teamA_Score.text  = [NSString stringWithFormat:@"%ld",(long)[(NSNumber*)[(Game*)((ChampionshipGameObject*)appdelegateForGameio_for_menu.gamesForChampionshipArray[indexPath.section]).game[indexPath.row] team_a_result] integerValue]];
    cell.teamB_Score.text  = [NSString stringWithFormat:@"%ld",(long)[(NSNumber*)[(Game*)((ChampionshipGameObject*)appdelegateForGameio_for_menu.gamesForChampionshipArray[indexPath.section]).game[indexPath.row] team_b_result] integerValue]];

    NSString* isRunning =  [NSString stringWithFormat:@"%@", (NSNumber*)[(Game*)((ChampionshipGameObject*)appdelegateForGameio_for_menu.gamesForChampionshipArray[indexPath.section]).game[indexPath.row] is_running]];
   
    NSLog(@"isRunning: %@ , m_id:%@", isRunning, (NSNumber*)[(Game*)((ChampionshipGameObject*)appdelegateForGameio_for_menu.gamesForChampionshipArray[indexPath.section]).game[indexPath.row] m_id]);
        
    if([isRunning  isEqual: @"0"]){
        NSLog(@"isRunning contains 0 value");
        cell.round_stadium_score.text = [NSString stringWithFormat:@"Final"];
        
    }else if([isRunning  isEqual: @"1"]) {
        
        if([[(Game*)((ChampionshipGameObject*)appdelegateForGameio_for_menu.gamesForChampionshipArray[indexPath.section]).game[indexPath.row] active_q]  isEqual: @"OT"]){
             NSLog(@"isRunning contains 1 value");
            cell.round_stadium_score.text = [NSString stringWithFormat:@"%@%@ - %2@", [(Game*)((ChampionshipGameObject*)appdelegateForGameio_for_menu.gamesForChampionshipArray[indexPath.section]).game[indexPath.row] active_q], [(Game*)((ChampionshipGameObject*)appdelegateForGameio_for_menu.gamesForChampionshipArray[indexPath.section]).game[indexPath.row] ot_count], [(Game*)((ChampionshipGameObject*)appdelegateForGameio_for_menu.gamesForChampionshipArray[indexPath.section]).game[indexPath.row] Q_Time]];
            
        }else{
            
            cell.round_stadium_score.text = [NSString stringWithFormat:@"Q%@ - %2@", [(Game*)((ChampionshipGameObject*)appdelegateForGameio_for_menu.gamesForChampionshipArray[indexPath.section]).game[indexPath.row] active_q], [(Game*)((ChampionshipGameObject*)appdelegateForGameio_for_menu.gamesForChampionshipArray[indexPath.section]).game[indexPath.row] Q_Time]];
        }
        
    }
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    //http://livescore-admin.herokuapp.com/api/countries/match/:countryId/:matchId
    tableViewForGames.userInteractionEnabled = false;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    matchID = (NSString*)[(Game*)((ChampionshipGameObject*)appdelegateForGameio_for_menu.gamesForChampionshipArray[section]).game[row] m_id];
    countryID = (NSString*)[(Game*)((ChampionshipGameObject*)appdelegateForGameio_for_menu.gamesForChampionshipArray[section]).game[row] country_id];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self performSegueWithIdentifier:@"matchViewAnimationIdentifier" sender:self];
        
    });

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
