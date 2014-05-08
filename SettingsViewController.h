//
//  SettingsViewController.h
//  eBodyHealth
//
//  Created by 夏 伟 on 13-8-3.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SettingUserInfoViewController;
@class UserSelectViewController;

@interface SettingsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *settingTableView;
    IBOutlet UIButton *userSettingButton;
}

@property(nonatomic,retain)UITableView *settingTableView;
@property(nonatomic,retain)UIButton *userSettingButton;
@property(nonatomic,strong) UserSelectViewController *userSelectViewController;

-(IBAction)showUserSettingView:(id)sender;
@end
