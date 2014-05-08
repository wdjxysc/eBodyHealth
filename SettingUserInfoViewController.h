//
//  SettingUserInfoViewController.h
//  eBodyHealth
//
//  Created by 夏 伟 on 13-8-14.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingUserInfoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    IBOutlet UITableView *myTableView;
    IBOutlet UIButton *myButton;
    IBOutlet UIDatePicker *myDatePicker;
    IBOutlet UIPickerView *myHeightPicker;
    IBOutlet UIPickerView *myWeightPicker;
    IBOutlet UIToolbar *myToolbar;
    IBOutlet UIView *myView;
    IBOutlet UINavigationBar *myNavigationBar;
    IBOutlet UINavigationBar *myHeightNavigationBar;
    IBOutlet UINavigationBar *myWeightNavigationBar;
    
    IBOutlet UINavigationItem *myHeightNavigationItem;
    IBOutlet UINavigationItem *myWeightNavigationItem;
    IBOutlet UINavigationItem *myBrithdayNavigationItem;
    
    NSDictionary *userinfo;
}

@property(nonatomic,retain)UITableView *myTableView;
@property(nonatomic,retain)UITextField *nameTextField;
@property(nonatomic,retain)UITextField *genderTextField;
@property(nonatomic,retain)UITextField *brithdayTextField;
@property(nonatomic,retain)UITextField *ageTextField;
@property(nonatomic,retain)UITextField *heightTextField;
@property(nonatomic,retain)UITextField *weightTextField;
@property(nonatomic,retain)UITextField *athletictypeTextField;
@property(nonatomic,retain)NSString  *heightUnit;
@property(nonatomic,retain)UIPickerView *myHeightPicker;
@property(nonatomic,retain)UIPickerView *myWeightPicker;
@property(nonatomic,retain)NSDictionary *userinfo;

-(IBAction)backToUserSelectView:(id)sender;

-(IBAction)inputHeightDone:(id)sender;
-(IBAction)inputHeightCancel:(id)sender;
-(IBAction)inputWeightDone:(id)sender;
-(IBAction)inputWeightCancel:(id)sender;

-(IBAction)buttonPressed:(id)sender;
-(IBAction)inputBrithdayCancel:(id)sender;

-(IBAction)dateChanged:(id)sender;
-(IBAction)createUserButtonPressed:(id)sender;
@end
