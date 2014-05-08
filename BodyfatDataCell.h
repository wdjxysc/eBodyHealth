//
//  BodyfatDataCell.h
//  QRBodyfat
//
//  Created by 夏 伟 on 13-5-30.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BodyfatDataCell : UITableViewCell
{
    IBOutlet UILabel *testTimeLabel;
    
    IBOutlet UILabel *weightDataLabel;
    IBOutlet UILabel *fatDataLabel;
    IBOutlet UILabel *muscleDataLabel;
    IBOutlet UILabel *waterDataLabel;
    IBOutlet UILabel *boneDataLabel;
    IBOutlet UILabel *visceralFatDataLabel;
    IBOutlet UILabel *bmrDataLabel;
    IBOutlet UILabel *bmiDataLabel;
    
    IBOutlet UIButton *weightButton;
    IBOutlet UIButton *fatButton;
    IBOutlet UIButton *muscleButton;
    IBOutlet UIButton *waterButton;
    IBOutlet UIButton *boneButton;
    IBOutlet UIButton *visceralFatButton;
    IBOutlet UIButton *bmrButton;
    IBOutlet UIButton *bmiButton;
}

@property(nonatomic,retain)UILabel  *testTimeLabel;

@property(nonatomic,retain)UILabel  *weightDataLabel;
@property(nonatomic,retain)UILabel  *fatDataLabel;
@property(nonatomic,retain)UILabel  *muscleDataLabel;
@property(nonatomic,retain)UILabel  *waterDataLabel;
@property(nonatomic,retain)UILabel  *boneDataLabel;
@property(nonatomic,retain)UILabel  *visceralFatDataLabel;
@property(nonatomic,retain)UILabel  *bmrDataLabel;
@property(nonatomic,retain)UILabel  *bmiDataLabel;

@property(nonatomic,retain)UIButton *weightButton;
@property(nonatomic,retain)UIButton *fatButton;
@property(nonatomic,retain)UIButton *muscleButton;
@property(nonatomic,retain)UIButton *waterButton;
@property(nonatomic,retain)UIButton *boneButton;
@property(nonatomic,retain)UIButton *visceralFatButton;
@property(nonatomic,retain)UIButton *bmrButton;
@property(nonatomic,retain)UIButton *bmiButton;

@end
