//
//  WeightDataCell.m
//  eBodyScale
//
//  Created by 夏 伟 on 13-8-1.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import "WeightDataCell.h"

@implementation WeightDataCell
@synthesize testTimeLabel,weightDataLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        testTimeLabel.numberOfLines =0;
        testTimeLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
