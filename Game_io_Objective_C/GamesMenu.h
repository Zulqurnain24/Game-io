//
//  ViewController.h
//  Game_io_Objective_C
//
//  Created by Mohammad Zulqurnain on 23/10/2016.
//  Copyright © 2016 Mohammad Zulqurnain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"//;
#import "Championship.h"//;
#import "ChampionshipGameObject.h"
#import "AppDelegate.h"

@interface GamesMenu : UIViewController<UITableViewDelegate, UITableViewDataSource>
//game menu View
@property (strong, nonatomic) IBOutlet UIView *MenuGameView;

//tableview View
@property (weak, nonatomic) IBOutlet UITableView *tableViewForGames;

//socket URL
@property (strong, nonatomic) NSString * socketURL;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) NSString *lastEnteredchampionShipID;
@property (weak, nonatomic) NSString *textCellIdentifier;
@property (nonatomic) NSInteger selectedrow;

//method for getting live in-play game info from the api url link asynchronuously
- (void)getSocket_Info_From_API:(NSString*)urlString;

//method for populating the array for in-play game events on next page asynchronuously
- (void)getEvents_For_Match_API:(NSString*)urlString;

//method for populating the array of championship games  asynchronuously
- (void)fillChampionshipAndGamesArray:(NSString*)urlString ;
@end

