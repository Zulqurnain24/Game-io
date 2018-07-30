//
//  GameCellTableViewCell.h
//  Game_io_Objective_C
//
//  Created by Mohammad Zulqurnain on 23/10/2016.
//  Copyright © 2016 Mohammad Zulqurnain. All rights reserved.
//

#import <UIKit/UIKit.h>

//UiTableviewcell for championship games display
@interface GameCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *teamA_Name_Label;
@property (weak, nonatomic) IBOutlet UILabel *teamB_Name_Label;
@property (weak, nonatomic) IBOutlet UILabel *round_stadium_score;
@property (weak, nonatomic) IBOutlet UILabel *teamA_Score;
@property (weak, nonatomic) IBOutlet UILabel *teamB_Score;

@end
