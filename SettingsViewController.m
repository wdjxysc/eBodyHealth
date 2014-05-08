//
//  SettingsViewController.m
//  eBodyHealth
//
//  Created by 夏 伟 on 13-8-3.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingUserInfoViewController.h"
#import "UserSelectViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize settingTableView;
@synthesize userSettingButton;
@synthesize userSelectViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.image = [UIImage imageNamed:@"Settings"];
        self.tabBarItem.title = NSLocalizedString(@"SETTINGS", nil);
        self.navigationItem.title = NSLocalizedString(@"SETTINGS", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showUserSettingView:(id)sender
{
    SettingUserInfoViewController *settingUserInfoViewController = [[SettingUserInfoViewController alloc]initWithNibName:@"SettingUserInfoViewController" bundle:nil];
    
    [self.navigationController pushViewController:settingUserInfoViewController animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger result = 0;
    if([tableView isEqual:settingTableView])
    {
        result = 2;
    }
    return result;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = 0;
    if([tableView isEqual:settingTableView])
    {
        switch (section) {
            case 0:
                result = 1;
                break;
            case 1:
                result = 0;
                break;
            case 2:
                result = 1;
                break;
            default:
                break;
        }
    }
    return  result;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *result = nil;
    
    if([tableView isEqual:settingTableView])
    {
        static NSString *TableViewCellIdentifier = @"MyCells";
        result = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
        
        if(result == nil)
        {
            result = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewCellIdentifier];
        }
        
        result.textLabel.text = [NSString stringWithFormat:@"Section %ld in cell %ld",(long)indexPath.section,(long)indexPath.row];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0, 0, 150, 25);
        [button setTitle:@"Expand" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(performExpand:) forControlEvents:UIControlEventTouchUpInside];
        
        if(indexPath.section == 0 && indexPath.row == 0){
            result.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            result.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            result.textLabel.text = NSLocalizedString(@"EDITUSER", nil);
//            UITextField *textField =[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 25)];
//            textField.borderStyle = UITextBorderStyleNone;
//            textField.clearButtonMode =  UITextFieldViewModeWhileEditing;
//            textField.clearButtonMode =  UITextFieldViewModeNever;
//            textField.textAlignment = UITextAlignmentRight;
//            textField.textColor = [UIColor purpleColor];
//            
//            [textField addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
//            nameTextField = textField;
//            textField.text = [userinfo objectForKey:@"UserName"];
//            result.accessoryView = textField;
//            //被选中无效果
            result.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(indexPath.section == 0 && indexPath.row == 1){
        }
        if(indexPath.section == 0 && indexPath.row == 2){
        }
        if(indexPath.section == 0 && indexPath.row == 3){
        }
        if(indexPath.section == 0 && indexPath.row == 4){
        }
        if(indexPath.section == 0 && indexPath.row == 5){
        }
        if(indexPath.section == 1 && indexPath.row == 0)
        {
//            result.textLabel.text = @"Delete User";
//            result.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        //        result.accessoryView = button;
    }
    return result;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.settingTableView])
    {
        NSLog(@"%@",[NSString stringWithFormat:@"Cell %ld in section %ld is selected",(long)indexPath.row,(long)indexPath.section]);
        
        if(indexPath.section == 0 && indexPath.row == 0)
        {
            SettingUserInfoViewController *settingUserInfoViewController = [[SettingUserInfoViewController alloc]initWithNibName:@"SettingUserInfoViewController" bundle:nil];
            
            [self.navigationController pushViewController:settingUserInfoViewController animated:YES];
        }
    }
}

//设置Header和Footer 文字
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *result = nil;
    if([tableView isEqual:settingTableView]&& section ==0)
    {
        result = NSLocalizedString(@"USER", nil);
    }
    else if([tableView isEqual:settingTableView]&& section ==1)
    {
//        result = @"Optional Info";
    }
    
    return result;
}

-(NSString  *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *result = nil;
    if([tableView isEqual:settingTableView]&& section ==0)
    {
//        result = @"set user information";
        
    }
    else if([tableView isEqual:settingTableView]&& section ==1)
    {
//        result = @"set optional infomation";
    }
    
    return result;
}

@end
