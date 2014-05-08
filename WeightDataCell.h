//
//  WeightDataCell.h
//  eBodyScale
//
//  Created by 夏 伟 on 13-8-1.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeightDataCell : UITableViewCell
{
    IBOutlet UILabel *testTimeLabel;
    IBOutlet UILabel *weightDataLabel;
    IBOutlet UIButton *weightButton;
}

@property(nonatomic,retain)UILabel  *testTimeLabel;
@property(nonatomic,retain)UILabel  *weightDataLabel;

@property(nonatomic,retain)UIButton *weightButton;

@end
