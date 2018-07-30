//
//  LiveGameView.h
//  Game_io_Objective_C
//
//  Created by Mohammad Zulqurnain on 23/10/2016.
//  Copyright © 2016 Mohammad Zulqurnain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LiveGameView : UIViewController<UITableViewDelegate, UITableViewDataSource>
//UITableview for game score events
@property (weak, nonatomic) IBOutlet UILabel *labelForFoul;
@property (weak, nonatomic) IBOutlet UITableView *tableViewForGameScore;
//activity indicator
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

//socketio objects
@property (strong, nonatomic) NSString * socketURL;

//ball animation datastructures
@property (strong, nonatomic)NSMutableArray *eventsArray;
@property (strong, nonatomic) NSString *  team_A;
@property (strong, nonatomic) NSString *  team_B;
@property (strong, nonatomic) NSString *  venue;
@property (nonatomic) NSInteger  teamB_totalScore;
@property (nonatomic) NSInteger  teamA_totalScore;
@property (strong, nonatomic) NSString * quarterInformation;
@property (strong, nonatomic) NSString * countryID;
@property (strong, nonatomic) NSString *matchID;
@property (weak, nonatomic) IBOutlet UIView *timingEventsView;
@property (weak, nonatomic) IBOutlet UILabel *matchStateLabel;


//ball animation graphics element
@property (weak, nonatomic) IBOutlet UIImageView *foulTeamLine;
@property (weak, nonatomic) IBOutlet UIImageView *rightFacingArrow;
@property (weak, nonatomic) IBOutlet UIImageView *leftFacingArrow;
@property (weak, nonatomic) IBOutlet UIImageView *time_ForBTeam_ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *time_ForATeam_ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *time_out_line_imageview;
@property (weak, nonatomic) IBOutlet UIView *time_out_parent_view;
@property (weak, nonatomic) IBOutlet UIImageView *freeThrough_line_view;
@property (weak, nonatomic) IBOutlet UIImageView *freeThrough_TeamA_Dot;
@property (weak, nonatomic) IBOutlet UIImageView *freeThrough_TeamB_Dot;
@property (weak, nonatomic) IBOutlet UILabel *free_Throw_Label;
@property (weak, nonatomic) IBOutlet UILabel *free_Throwing_player_label;
@property (weak, nonatomic) NSDictionary<NSString*, NSString*>* playerAPI;
@property (weak, nonatomic) IBOutlet UIView *freeThrowParentView;
@property (weak, nonatomic) IBOutlet UIImageView *basketBallCourt;
@property (weak, nonatomic) IBOutlet UIView *time_out_View;
@property (weak, nonatomic) IBOutlet UILabel *SecondTeam_Label;
@property (weak, nonatomic) IBOutlet UILabel *FirstTeam_Label;
@property (weak, nonatomic) IBOutlet UIImageView *team_B_Timeout_Clock;
@property (weak, nonatomic) IBOutlet UIImageView *team_A_Timeout_Clock;
@property (weak, nonatomic) IBOutlet UILabel *timeoutTeam;
@property (weak, nonatomic) IBOutlet UIImageView *time_out_Imageview;
@property (weak, nonatomic) IBOutlet UIImageView *ballPossessionImageview;
@property (weak, nonatomic) IBOutlet UILabel *possessionTeam;
@property (weak, nonatomic) IBOutlet UILabel *FirstTeamScore_Label;
@property (weak, nonatomic) IBOutlet UILabel *SecondTeamScore_Label;
@property (weak, nonatomic) IBOutlet UILabel *Quarter_And_Time_Label;
@property (weak, nonatomic) IBOutlet UILabel *vsLabel;
@property (weak, nonatomic) IBOutlet UILabel *foul_Team_Name_Label;
@property (weak, nonatomic) IBOutlet UIImageView *A_Out_Foul_ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *B_Out_Foul_ImageView;
@property (weak, nonatomic) NSString * timeInformation;
@property (weak, nonatomic) IBOutlet UIImageView *A_In_Foul_ImageView;
@property (nonatomic) NSInteger counter;
@property (weak, nonatomic) IBOutlet UIImageView *B_In_Foul_ImageView;
@property (weak, nonatomic) NSString *  socketID;
@property (weak, nonatomic) IBOutlet UIView *foulsParentView;
@property (weak, nonatomic) IBOutlet UIView *possessionView;
@property (weak, nonatomic) IBOutlet UIImageView *ballImageView;
@property (weak, nonatomic) IBOutlet UILabel *possession_Team_Name_label;
@property (weak, nonatomic) IBOutlet UIView *individual_player_event_view;
@property (weak, nonatomic) IBOutlet UILabel *totalFoulByPlayer;
@property (weak, nonatomic) IBOutlet UILabel *totalScoreByPlayer;
@property (weak, nonatomic) IBOutlet UILabel *individualPlayerName;
@property (weak, nonatomic) IBOutlet UILabel *time_out_team_label;
//method for loading the related views in animation view controller
-(void) refreshView;
//method for showing basket miss animation
-(void) ballDeflected:(UIImageView*)view withMoveX:(NSInteger)moveX withMoveY:(NSInteger)moveY withMessage:(NSString*)message withTeamName:(NSString*)teamName ;
//method for showing basket made animation
-(void) moveImage:(UIImageView*)view withMoveX:(NSInteger)moveX withMoveY:(NSInteger)moveY withTeam:(NSString*)team withBool:(BOOL)is3pts;
@end
