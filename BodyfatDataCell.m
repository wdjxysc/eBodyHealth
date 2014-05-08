//
//  BodyfatDataCell.m
//  QRBodyfat
//
//  Created by 夏 伟 on 13-5-30.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import "BodyfatDataCell.h"

@implementation BodyfatDataCell
@synthesize testTimeLabel,weightDataLabel,fatDataLabel,muscleDataLabel,waterDataLabel,boneDataLabel,visceralFatDataLabel,bmrDataLabel,bmiDataLabel,weightButton,fatButton,muscleButton,waterButton,boneButton,visceralFatButton,bmrButton,bmiButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [weightButton setTitle:NSLocalizedString(@"USER_WEIGHT", nil) forState:UIControlStateNormal];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
