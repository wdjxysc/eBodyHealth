//
//  SettingUserInfoViewController.m
//  eBodyHealth
//
//  Created by 夏 伟 on 13-8-14.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import "SettingUserInfoViewController.h"
#import "UserSelectViewController.h"
#import "MySingleton.h"

@interface SettingUserInfoViewController ()

@end

@implementation SettingUserInfoViewController
@synthesize myTableView;
@synthesize brithdayTextField;
@synthesize ageTextField;
@synthesize heightUnit;
@synthesize heightTextField;
@synthesize weightTextField;
@synthesize athletictypeTextField;
@synthesize nameTextField;
@synthesize genderTextField;
@synthesize userinfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        heightUnit = @"cm";
        self.navigationItem.title = @"Edit User";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:normal target:self action:@selector(createUserButtonPressed:)];
    }
    return self;
}

- (void)viewDidLoad
{
//    userinfo = [self GetUserInfo:[MySingleton sharedSingleton].nowuserid];
    NSString *s = [userinfo objectForKey:@"UserName"];
    [super viewDidLoad];
    
    myBrithdayNavigationItem.title = NSLocalizedString(@"USERINFO_BRITHDAY", nil);
    myHeightNavigationItem.title = NSLocalizedString(@"USERINFO_HEIGHT", nil);
    myWeightNavigationItem.title = NSLocalizedString(@"USERINFO_WEIGHT", nil);
    self.navigationItem.title = NSLocalizedString(@"EDITUSER", nil);
    self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"SAVE", nil);
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.myTableView])
    {
        NSLog(@"%@",[NSString stringWithFormat:@"Cell %ld in section %ld is selected",(long)indexPath.row,(long)indexPath.section]);
        
        if(indexPath.section == 0 && indexPath.row == 1)
        {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"USERINFO_GENDER", nil)
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:NSLocalizedString(@"GENDER_MALE", nil), NSLocalizedString(@"GENDER_FEMALE", nil), nil];
            [sheet showInView:self.view];
        }
        if(indexPath.section == 0&& indexPath.row == 2)
        {
            //            NSLog(@"Brithday");
            //            [self.view addSubview:myView];
        }
        if(indexPath.section ==0&&  indexPath.row == 3)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"USERINFO_AGE", nil)
                                                                message:NSLocalizedString(@"PLEASE_INPUT_BRITHDAY", nil)
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
            [alertView show];
        }
        if(indexPath.section ==0&&  indexPath.row == 6) //选中运动级别cell
        {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"USERINFO_ATHLETICTYPE", nil)
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:NSLocalizedString(@"ATHLETICTYPE_NON_ATHLETE", nil), NSLocalizedString(@"ATHLETICTYPE_AMATEUR_ATHLETE", nil), NSLocalizedString(@"ATHLETICTYPE_PROFEESSIONAL_ATHLETE", nil), nil];
            [sheet showInView:self.view];
        }
        if(indexPath.section == 1&&indexPath.row == 0)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NOTICE", nil)
                                                                message:NSLocalizedString(@"SURE_DELETE_USER", nil)
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
                                                      otherButtonTitles:NSLocalizedString(@"YES", nil), nil];
            alertView.delegate = self;
            [alertView show];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSIndexPath *indexPath = myTableView.indexPathForSelectedRow;
    if(indexPath.section == 1&& indexPath.row ==0)
    {
        if(buttonIndex == 1)
        {
            NSString *filePath = [self dataFilePath];
            sqlite3 *database;
            char* errorMsg;
            if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
                sqlite3_close(database);
                NSLog(@"数据库打开失败");
            }
            
            int userid = [MySingleton sharedSingleton].nowuserid;
            NSString *sql2 = [NSString stringWithFormat:@"DELETE FROM USER WHERE USERID = %d", userid];
            
            if(sqlite3_exec(database, [sql2 UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK){//备注2
                //插入数据失败，关闭数据库
                sqlite3_close(database);
                //        NSAssert1(0, @"插入数据失败：%@", errorMsg);
                NSLog(@"%s",errorMsg);
            }
            //关闭数据库
            sqlite3_close(database);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    self.myTableView = nil;
}
-(void)viewWillAppear:(BOOL)animated
{
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //    for (UIView *view in carousel.visibleItemViews)
    //    {
    //        view.alpha = 1.0;
    //    }
    //
    //    [UIView beginAnimations:nil context:nil];
    //    carousel.type = buttonIndex;
    //    [UIView commitAnimations];
    //
    //    navItem.title = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    NSIndexPath *indexPath = myTableView.indexPathForSelectedRow;
    UITableViewCell *cell = [myTableView cellForRowAtIndexPath:indexPath];
    UITextField *textField = (UITextField *)cell.accessoryView;
    textField.text = [actionSheet buttonTitleAtIndex:buttonIndex];
}

-(IBAction)backToUserSelectView:(id)sender
{
    //    [self.view removeFromSuperview]; //这样返回没有动画效果
    
    //返回上一视图
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger result = 0;
    if([tableView isEqual:myTableView])
    {
        result = 2;
    }
    return result;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = 0;
    if([tableView isEqual:myTableView])
    {
        switch (section) {
            case 0:
                result = 7;
                break;
            case 1:
                result = 1;
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
    
    if([tableView isEqual:myTableView])
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
            //            result.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            result.textLabel.text = NSLocalizedString(@"USERINFO_NAME", nil);
            UITextField *textField =[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 25)];
            textField.borderStyle = UITextBorderStyleNone;
            textField.clearButtonMode =  UITextFieldViewModeWhileEditing;
            textField.clearButtonMode =  UITextFieldViewModeNever;
            textField.textAlignment = UITextAlignmentRight;
            textField.textColor = [UIColor purpleColor];
            
            [textField addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
            nameTextField = textField;
            textField.text = [[MySingleton sharedSingleton].nowuserinfo objectForKey:@"UserName"];
            result.accessoryView = textField;
            //被选中无效果
            result.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(indexPath.section == 0 && indexPath.row == 1){
            //            result.accessoryType = UITableViewCellAccessoryCheckmark;
            result.textLabel.text = NSLocalizedString(@"USERINFO_GENDER", nil);
            UITextField *textField =[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 25)];
            textField.borderStyle = UITextBorderStyleNone;
            textField.clearButtonMode =  UITextFieldViewModeWhileEditing;
            textField.clearButtonMode =  UITextFieldViewModeNever;
            textField.textAlignment = UITextAlignmentRight;
            textField.textColor = [UIColor purpleColor];
            textField.enabled = FALSE;
            genderTextField = textField;
            if([[[MySingleton sharedSingleton].nowuserinfo objectForKey:@"Sex"] isEqualToString:@"0"])
            {
                genderTextField.text = NSLocalizedString(@"GENDER_MALE", nil);
            }
            else
            {
                genderTextField.text = NSLocalizedString(@"GENDER_FEMALE", nil);
            }
            
            result.accessoryView = textField;
            result.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(indexPath.section == 0 && indexPath.row == 2){
            //            result.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            result.textLabel.text = NSLocalizedString(@"USERINFO_BRITHDAY", nil);
            UITextField *textField =[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 25)];
            textField.borderStyle = UITextBorderStyleNone;
            textField.clearButtonMode =  UITextFieldViewModeNever;
            textField.textAlignment = UITextAlignmentRight;
            textField.textColor = [UIColor purpleColor];
            textField.inputAccessoryView = myNavigationBar;
            textField.inputView = myDatePicker;
            brithdayTextField = textField;
            NSString *s =  [[MySingleton sharedSingleton].nowuserinfo objectForKey:@"Brithday"];
            brithdayTextField.text = [[MySingleton sharedSingleton].nowuserinfo objectForKey:@"Brithday"];
            [textField addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
            result.accessoryView = textField;
            result.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(indexPath.section == 0 && indexPath.row == 3){
            //            result.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            result.textLabel.text = NSLocalizedString(@"USERINFO_AGE", nil);
            UITextField *textField =[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 25)];
            textField.borderStyle = UITextBorderStyleNone;
            textField.clearButtonMode =  UITextFieldViewModeWhileEditing;
            textField.clearButtonMode =  UITextFieldViewModeNever;
            textField.textAlignment = UITextAlignmentRight;
            textField.textColor = [UIColor purpleColor];
            textField.enabled = FALSE;
            result.accessoryView = textField;
            ageTextField = textField;
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
            [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
            NSDate *date =[dateFormat dateFromString:[[NSString alloc]initWithFormat:@"%@",[[MySingleton sharedSingleton].nowuserinfo objectForKey:@"Brithday"]]];
            ageTextField.text = [[NSString alloc]initWithFormat:@"%d",[self GetAgeByBrithday:date] ];
            result.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(indexPath.section == 0 && indexPath.row == 4){
            //            result.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            result.textLabel.text = NSLocalizedString(@"USERINFO_HEIGHT", nil);
            UITextField *textField =[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 25)];
            textField.borderStyle = UITextBorderStyleNone;
            textField.clearButtonMode =  UITextFieldViewModeNever;
            textField.textAlignment = UITextAlignmentRight;
            textField.textColor = [UIColor purpleColor];
            [textField addTarget:self action:@selector(endEdit:) forControlEvents:UIControlEventEditingDidEndOnExit];
            textField.text = [[NSString alloc]initWithFormat:@"%@",heightUnit];
            
            //初始化picker
            myHeightPicker = [[UIPickerView alloc]init];
            myHeightPicker.dataSource = self;
            myHeightPicker.delegate = self;
            myHeightPicker.showsSelectionIndicator = YES;
            [myHeightPicker selectRow:159 inComponent:0 animated:YES]; //设置pickerview初始值
            
            textField.inputView = myHeightPicker;
            textField.inputAccessoryView = myHeightNavigationBar;
            
            result.accessoryView = textField;
            heightTextField = textField;
            NSString *s = [[MySingleton sharedSingleton].nowuserinfo objectForKey:@"Height"];
            heightTextField.text =[[NSString alloc]initWithFormat:@"%@cm",s ];
            result.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(indexPath.section == 0 && indexPath.row == 5)
        {
            result.textLabel.text = NSLocalizedString(@"USERINFO_WEIGHT", nil);
            UITextField *textField =[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 25)];
            textField.borderStyle = UITextBorderStyleNone;
            textField.clearButtonMode =  UITextFieldViewModeWhileEditing;
            textField.clearButtonMode =  UITextFieldViewModeNever;
            textField.textAlignment = UITextAlignmentRight;
            textField.textColor = [UIColor purpleColor];
            //初始化picker
            myWeightPicker = [[UIPickerView alloc]init];
            myWeightPicker.dataSource = self;
            myWeightPicker.delegate = self;
            myWeightPicker.showsSelectionIndicator = YES;
            [myWeightPicker selectRow:59 inComponent:0 animated:YES]; //设置pickerview初始值
            
            textField.text = [[NSString alloc]initWithFormat:@"%@kg",[[MySingleton sharedSingleton].nowuserinfo objectForKey:@"Weight"]];
            textField.inputView = myWeightPicker;
            textField.inputAccessoryView = myWeightNavigationBar;
            weightTextField = textField;
            result.accessoryView = textField;
            result.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(indexPath.section == 0 && indexPath.row == 6){
            //            result.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            result.textLabel.text = NSLocalizedString(@"USERINFO_ATHLETICTYPE", nil);
            UITextField *textField =[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 25)];
            textField.borderStyle = UITextBorderStyleNone;
            textField.clearButtonMode =  UITextFieldViewModeWhileEditing;
            textField.clearButtonMode =  UITextFieldViewModeNever;
            textField.textAlignment = UITextAlignmentRight;
            textField.textColor = [UIColor purpleColor];
            textField.enabled = FALSE;
            athletictypeTextField = textField;
            
            if([[[MySingleton sharedSingleton].nowuserinfo objectForKey:@"Sportlvl"] isEqualToString:@"1"])
            {
                athletictypeTextField.text = NSLocalizedString(@"ATHLETICTYPE_NON_ATHLETE",nil);
            }
            else if([[[MySingleton sharedSingleton].nowuserinfo objectForKey:@"Sportlvl"] isEqualToString:@"2"])
            {
                athletictypeTextField.text = NSLocalizedString(@"ATHLETICTYPE_AMATEUR_ATHLETE",nil);
            }
            else if([[[MySingleton sharedSingleton].nowuserinfo objectForKey:@"Sportlvl"] isEqualToString:@"3"])
            {
                athletictypeTextField.text = NSLocalizedString(@"ATHLETICTYPE_PROFEESSIONAL_ATHLETE",nil);
            }
            
            result.accessoryView = textField;
            result.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(indexPath.section == 1 && indexPath.row == 0)
        {
            result.textLabel.text = NSLocalizedString(@"DELETEUSER",nil);
            result.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        //        result.accessoryView = button;
    }
    return result;
}

-(void)performExpand:(UIButton *)paramSender
{
    UITableViewCell *ownerCell = (UITableViewCell *)paramSender.superview;
    if(ownerCell != nil)
    {
        NSIndexPath *ownerCellIndexPath = [self.myTableView indexPathForCell:ownerCell];
        NSLog(@"Accessory in index path is tapped Index path = %@",ownerCellIndexPath);
        
        if(ownerCellIndexPath.section == 0 && ownerCellIndexPath.row == 1)
        {
            
        }
    }
}

-(void)endEdit:(UITextField *)textField
{
    [textField resignFirstResponder];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Accessory button is tapped for cell at index path = %@",indexPath);
    UITableViewCell *ownerCell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Cell Title = %@",ownerCell.textLabel.text);
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;
    if([tableView isEqual:myTableView])
    {
        result = UITableViewCellEditingStyleDelete;
    }
    return result;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.myTableView setEditing:editing animated:animated];
}

//滑动删除方法
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(editingStyle == UITableViewCellEditingStyleDelete)
//    {
////        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//    }
//}

//设置Header和Footer 文字
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *result = nil;
    if([tableView isEqual:myTableView]&& section ==0)
    {
        result = NSLocalizedString(@"USERINFO", nil);
    }
    else if([tableView isEqual:myTableView]&& section ==1)
    {
        result = NSLocalizedString(@"OPTIONAL_INFO", nil);
    }
    
    return result;
}

-(NSString  *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *result = nil;
    if([tableView isEqual:myTableView]&& section ==0)
    {
        result = NSLocalizedString(@"SET_USER_INFO", nil);
        
    }
    else if([tableView isEqual:myTableView]&& section ==1)
    {
        result = NSLocalizedString(@"SET_OPTIONAL_INFO", nil);
    }
    
    return result;
}


//完成生日输入，更改年龄
-(IBAction)buttonPressed:(id)sender
{
    //    NSIndexPath *indexPath = myTableView.indexPathForSelectedRow;
    //    UITableViewCell *cell = [myTableView cellForRowAtIndexPath:indexPath];
    //    UITextField *textField = (UITextField *)cell.accessoryView;
    //    textField.text = @"asdfsafdsa";
    if([brithdayTextField isFirstResponder])
    {
        [brithdayTextField resignFirstResponder];
        NSDateFormatter *dateFormatter= [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        brithdayTextField.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:myDatePicker.date]];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
        NSDateComponents *brithdaycomps = [[NSDateComponents alloc] init];
        NSDateComponents *nowcomps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//这句我也不明白具体时用来做什么。。。
        brithdaycomps = [calendar components:unitFlags fromDate:myDatePicker.date];
        nowcomps = [calendar components:unitFlags fromDate:NSDate.date];
        //    long brithdayweekNumber = [brithdaycomps weekday]; //获取星期对应的长整形字符串
        long brithdayday=[brithdaycomps day];//获取日期对应的长整形字符串
        long brithdayyear=[brithdaycomps year];//获取年对应的长整形字符串
        long brithdaymonth=[brithdaycomps month];//获取月对应的长整形字符串
        //    long brithdayhour=[brithdaycomps hour];//获取小时对应的长整形字符串
        //    long brithdayminute=[brithdaycomps minute];//获取月对应的长整形字符串
        //    long brithdaysecond=[brithdaycomps second];//获取秒对应的长整形字符串
        //    long nowweekNumber = [nowcomps weekday]; //获取星期对应的长整形字符串
        long nowday=[nowcomps day];//获取日期对应的长整形字符串
        long nowyear=[nowcomps year];//获取年对应的长整形字符串
        long nowmonth=[nowcomps month];//获取月对应的长整形字符串
        //    long nowhour=[nowcomps hour];//获取小时对应的长整形字符串
        //    long nowminute=[nowcomps minute];//获取月对应的长整形字符串
        //    long nowsecond=[nowcomps second];//获取秒对应的长整形字符串
        
        if(nowyear>brithdayyear)
        {
            if(nowmonth>brithdaymonth)
            {
                long age = nowyear - brithdayyear;
                ageTextField.text = [[NSString alloc]initWithFormat:@"%ld", age];
            }
            else if(nowmonth == brithdaymonth)
            {
                if(nowday>=brithdayday)
                {
                    long age = nowyear - brithdayyear;
                    ageTextField.text = [[NSString alloc]initWithFormat:@"%ld", age];
                }
                else
                {
                    long age = nowyear - brithdayyear - 1;
                    ageTextField.text = [[NSString alloc]initWithFormat:@"%ld", age];
                }
            }
            else
            {
                long age = nowyear - brithdayyear - 1;
                ageTextField.text = [[NSString alloc]initWithFormat:@"%ld", age];
            }
            
        }
        else
        {
            ageTextField.text = @"0";
        }
    }
}
-(IBAction)inputBrithdayCancel:(id)sender
{
    if([brithdayTextField isFirstResponder])
    {
        [brithdayTextField resignFirstResponder];
    }
}


-(IBAction)inputHeightDone:(id)sender
{
    if([heightTextField isFirstResponder])
    {
        [heightTextField resignFirstResponder];
    }
    NSInteger row = [myHeightPicker selectedRowInComponent:0];
    int height = row;
    heightTextField.text = [[NSString alloc]initWithFormat:@"%dcm",height];
}

-(IBAction)inputHeightCancel:(id)sender
{
    if([heightTextField isFirstResponder])
    {
        [heightTextField resignFirstResponder];
    }
}

-(IBAction)inputWeightDone:(id)sender
{
    if([weightTextField isFirstResponder])
    {
        [weightTextField resignFirstResponder];
    }
    NSInteger row1 = [myWeightPicker selectedRowInComponent:0]; //体重整数部分
    NSInteger row2 = [myWeightPicker selectedRowInComponent:1]; //体重小数部分
    weightTextField.text = [[NSString alloc]initWithFormat:@"%d.%dkg",row1,row2];
}

-(IBAction)inputWeightCancel:(id)sender
{
    if([weightTextField isFirstResponder])
    {
        [weightTextField resignFirstResponder];
    }
}

-(IBAction)selectCell:(id)sender
{
    NSIndexPath *indexPath = myTableView.indexPathForSelectedRow;
    UITableViewCell *cell = [myTableView cellForRowAtIndexPath:indexPath];
    UITextField *textField = (UITextField *)cell.accessoryView;
    textField.text = @"asdfsafdsa";
}

//datepicker值改变触发
- (IBAction)dateChanged:(id)sender {
    UIDatePicker *picker = (UIDatePicker *)sender;
    NSDate *brithday = picker.date;
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    brithdayTextField.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:brithday]];
}


//设置heightPickerView pickerView属性，几行几列及要显示什么
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger result = 0;
    if (pickerView == myHeightPicker)
    {
        result = 2;
    }
    else if (pickerView == myWeightPicker)
    {
        result = 3;
    }
    return result;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger result = 0;
    if (pickerView == myHeightPicker)
    {
        switch (component) {
            case 0:
                result = 250;
                break;
            case 1:
                result = 1;
                break;
            default:
                break;
        }
    }
    else if(pickerView == myWeightPicker)
    {
        switch (component) {
            case 0:
                result = 150;
                break;
            case 1:
                result = 10;
                break;
            case 2:
                result = 1;
                break;
            default:
                break;
        }
    }
    return result;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *result = nil;
    if (pickerView == myHeightPicker)
    {
        /* Row is zero-based and we want the first row (with index 0) to be rendered as Row 1 so we have to +1 every row index */
        switch (component) {
            case 0:
                result = [NSString stringWithFormat:@"%ld", (long)row];
                break;
            case 1:
                result = @"cm";
                break;
            default:
                break;
        }
    }
    else if (pickerView == myWeightPicker)
    {
        switch (component) {
            case 0:
                result = [NSString stringWithFormat:@"%ld",(long)row];
                break;
            case 1:
                result = [NSString stringWithFormat:@"%ld",(long)row];
                break;
            case 2:
                result = @"kg";
                break;
            default:
                break;
        }
    }
    //设置初始值
    //    [pickerView selectRow:169 inComponent:0 animated:NO];
    return result;
}





-(IBAction)createUserButtonPressed:(id)sender
{
    NSString *name = nil;
    int height = nil;
    int steplength = nil;
    int sex = nil;
    int sportlvl = nil;
    double weight = 60;
    NSString *brithday = nil;
    
    
    if(![self isBlankString:nameTextField.text])
    {
        name = nameTextField.text;
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NOTICE",@"")
                                                            message:NSLocalizedString(@"PLEASE_INPUT_USERNAME",@"")
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedString(@"OK",@""), nil];
        [alertView show];
        return;
    }
    
    if(![self isBlankString:heightTextField.text])
    {
        int strlength = [heightTextField.text length];
        NSString *heightstr = [heightTextField.text substringToIndex:strlength -2];
        height = [heightstr intValue];
        steplength = (int)height*0.45;
        
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NOTICE",@"")
                                                            message:NSLocalizedString(@"PLEASE_INPUT_HEIGHT",@"")
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedString(@"OK",@""), nil];
        [alertView show];
        return;
    }
    
    if(![self isBlankString:weightTextField.text])
    {
        NSRange range = [weightTextField.text rangeOfString:@"kg"]; //查找“kg”在字符串的位置，若没有则为"lb"
        if(range.location != NSNotFound)
        {
            NSString *weightstr = weightTextField.text;
            weightstr = [weightstr stringByReplacingOccurrencesOfString:@"kg" withString:@""];
            weightstr = [weightstr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去掉字符串中的空字符
            weight =  [weightstr floatValue];
        }
        else
        {
            NSString *weightstr = weightTextField.text;
            weightstr = [weightstr stringByReplacingOccurrencesOfString:@"lb" withString:@""];
            weightstr = [weightstr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去掉字符串中的空字符
            weight = [weightstr floatValue];
            weight = weight * 0.45359;
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NOTICE",@"")
                                                            message:NSLocalizedString(@"PLEASE_INPUT_WEIGHT",@"")
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedString(@"OK",@""), nil];
        [alertView show];
        return;
    }
    
    if(![self isBlankString:genderTextField.text])
    {
        if ([genderTextField.text isEqualToString:NSLocalizedString(@"GENDER_FEMALE",@"")])
        {
            sex = 1;
        }
        else
        {
            sex = 0;
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NOTICE",@"")
                                                            message:NSLocalizedString(@"PLEASE_INPUT_GENDER",@"")
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedString(@"OK",@""), nil];
        [alertView show];
        return;
    }
    
    if(![self isBlankString:brithdayTextField.text])
    {
        brithday = brithdayTextField.text;
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NOTICE",@"")
                                                            message:NSLocalizedString(@"PLEASE_INPUT_BRITHDAY",@"")
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedString(@"OK",@""), nil];
        [alertView show];
        return;
    }
    
    if(![self isBlankString:athletictypeTextField.text])
    {
        if([athletictypeTextField.text isEqualToString:NSLocalizedString(@"ATHLETICTYPE_NON_ATHLETE",@"")])
        {
            sportlvl = 1;
        }
        else if([athletictypeTextField.text isEqualToString:NSLocalizedString(@"ATHLETICTYPE_AMATEUR_ATHLETE",@"")])
        {
            sportlvl = 2;
        }
        else if([athletictypeTextField.text isEqualToString:NSLocalizedString(@"ATHLETICTYPE_PROFEESSIONAL_ATHLETE",@"")])
        {
            sportlvl = 3;
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NOTICE",@"")
                                                            message:NSLocalizedString(@"PLEASE_INPUT_ATHLETE_TYPE",@"")
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedString(@"OK",@""), nil];
        [alertView show];
        return;
    }
    
    NSString *filePath = [self dataFilePath];
    sqlite3 *database;
    char* errorMsg;
//    if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
//        sqlite3_close(database);
//        NSLog(@"数据库打开失败");
//    }
    
    int userid = 1;
    userid = [MySingleton sharedSingleton].nowuserid;
    NSString *username = name;
    NSString *datestrformat = brithdayTextField.text;
    
//    sqlite3_stmt * statement;
//    
//    NSString *sql1 = [NSString stringWithFormat:@"SELECT * FROM USER WHERE USERNAME = '%@'",username];
//    //    sql1 = @"SELECT * FROM USER WHERE USERNAME = 'wahaha'";
//    if (sqlite3_prepare_v2(database, [sql1 UTF8String], -1, &statement, nil) == SQLITE_OK) {
//        while (sqlite3_step(statement) == SQLITE_ROW) {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"User name already exits, choose another user name!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//            [alertView show];
//            return;
//            //NSLog(@"USERNAME:%@  AGE:%d  SEX:%@",weightstr,age, nsAddressStr);
//        }
//    }
//    sqlite3_close(database);
    
    if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"数据库打开失败");
    }
//    NSString *sql2 = [NSString stringWithFormat:
//                      @"INSERT INTO 'USER' ('USERNAME', 'BRITHDAY', 'SEX', 'SPORTLVL','HEIGHT','WEIGHT','STEPLENGTH') VALUES ('%@', '%@', '%d', '%d', '%d','%.1f','%d')", username, datestrformat, sex, sportlvl, height, weight, steplength];
    NSString *sql2 = [NSString stringWithFormat:@"UPDATE 'USER' SET USERNAME = '%@', BRITHDAY = '%@', SEX = %d, SPORTLVL = %d, HEIGHT = %d,WEIGHT = %.1f,STEPLENGTH = %d,PASSWORD = '' WHERE USERID = %d", username, datestrformat, sex, sportlvl, height, weight, steplength, userid];
    
    if(sqlite3_exec(database, [sql2 UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK){//备注2
        //插入数据失败，关闭数据库
        sqlite3_close(database);
        //        NSAssert1(0, @"插入数据失败：%@", errorMsg);
        NSLog(@"%s",errorMsg);
        sqlite3_free(errorMsg);
    }
    //关闭数据库
    sqlite3_close(database);
    
    [self backToUserSelectView:sender];
}

-(NSString *)dataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kSqliteFileName];
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


//软键盘打开和隐藏

-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)handleKeyboardWillShow:(NSNotification *)paramNotification
{
    NSDictionary *userInfo = [paramNotification userInfo];
    NSValue *animationCurveObject = [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSValue *animationDurationObject = [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSValue *keyboardEndObject =[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    NSUInteger animationCurve = 0;
    double animationDuration = 0.0f;
    CGRect keyboardEndRect = CGRectMake(0, 0, 0, 0);
    [animationCurveObject getValue:&animationCurve];
    [animationDurationObject getValue:&animationDuration];
    [keyboardEndObject getValue:&keyboardEndRect];
    [UIView beginAnimations:@"changeTableViewContentInset" context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
    UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
    CGRect interSectionOfKeyboardRectAndWindowRect = CGRectIntersection(window.frame, keyboardEndRect);
    CGFloat bottomInset = interSectionOfKeyboardRectAndWindowRect.size.height;
    self.myTableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, bottomInset, 0.0f);
    NSIndexPath *indexPathOfOwnerCell = nil;
    NSInteger numberOfCells = [self.myTableView.dataSource tableView:self.myTableView numberOfRowsInSection:0];
    for(NSInteger counter =0;counter<numberOfCells;counter++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:counter inSection:0];
        UITableViewCell *cell = [myTableView cellForRowAtIndexPath:indexPath];
        UITextField *textField = (UITextField *)cell.accessoryView;
        if([textField isKindOfClass:[UITextField class]] == NO)
        {
            continue;
        }
        
        if([textField isFirstResponder])
        {
            indexPathOfOwnerCell = indexPath;
            break;
        }
    }
    [UIView commitAnimations];
    if(indexPathOfOwnerCell != nil)
    {
        [self.myTableView scrollToRowAtIndexPath:indexPathOfOwnerCell atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

-(void)handleKeyboardWillHide:(NSNotification *)paramNotification
{
    if(UIEdgeInsetsEqualToEdgeInsets(self.myTableView.contentInset, UIEdgeInsetsZero))
    {
        return;
    }
    
    NSDictionary *userInfo = [paramNotification userInfo];
    NSValue *animationCurveObject = [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSValue *animationDurationObject = [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSValue *keyboardEndObject =[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    NSUInteger animationCurve = 0;
    double animationDuration = 0.0f;
    CGRect keyboardEndRect = CGRectMake(0, 0, 0, 0);
    [animationCurveObject getValue:&animationCurve];
    [animationDurationObject getValue:&animationDuration];
    [keyboardEndObject getValue:&keyboardEndRect];
    [UIView beginAnimations:@"changeTableViewContentInset" context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
    self.myTableView.contentInset = UIEdgeInsetsZero;
    [UIView commitAnimations];
}

-(NSDictionary *)GetUserInfo:(int) userid
{
    NSDictionary *user = [[NSDictionary alloc]init];
    
    NSString *filePath = [self dataFilePath];
    NSLog(@"filePath=%@",filePath);
    
    sqlite3 *database;
    if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"数据库打开失败");
    }
    char* errorMsg;
    
    NSString *sqlQuery = [[NSString alloc]initWithFormat:@"SELECT * FROM USER WHERE USERID = %d",userid];
    //sqlQuery = @"SELECT * FROM WEIGHTDATA WHERE USERID = 1";
    //用户id，用户名，生日，性别(0男,1女)，运动级别(1白领，2普通，3运动员),身高（cm），体重，步幅，密码，
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            int userid = sqlite3_column_double(statement, 0);
            char *username = sqlite3_column_text(statement,1);
            char *brithday = sqlite3_column_text(statement, 2);
            int sex = sqlite3_column_double(statement, 3);
            int sportlvl = sqlite3_column_double(statement, 4);
            int height = sqlite3_column_double(statement, 5);
            double weight = sqlite3_column_double(statement, 6);
            char *password = sqlite3_column_text(statement,8);
            
            
            NSString *weightstr = [[NSString alloc]initWithFormat:@"%.1f",weight];
            
            NSDictionary *onedata =[[NSDictionary alloc] initWithObjectsAndKeys:
                                    [[NSString alloc] initWithFormat:@"%d", userid],
                                    @"Userid",
                                    [[NSString alloc] initWithFormat:@"%s", username],
                                    @"UserName",
                                    [[NSString alloc] initWithFormat:@"%s", brithday],
                                    @"Brithday",
                                    [[NSString alloc] initWithFormat:@"%d", sex],
                                    @"Sex",
                                    [[NSString alloc] initWithFormat:@"%d", sportlvl],
                                    @"Sportlvl",
                                    [[NSString alloc] initWithFormat:@"%d", height],
                                    @"Height",
                                    [[NSString alloc] initWithFormat:@"%.1f", weight],
                                    @"Weight",
                                    [[NSString alloc] initWithFormat:@"%s", password],
                                    @"PassWord",
                                    weightstr,
                                    @"Weight",
                                    nil];
            user = onedata;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return user;
//    nameTextField.text = [[user objectForKey:@"UserName"] stringValue];
//    brithdayTextField.text = [[user objectForKey:@"Brithday"] stringValue];
//    
//    if([[user objectForKey:@"Sex"] isEqualToString:@"0"])
//    {
//        genderTextField.text = @"Male";
//    }
//    else
//    {
//        genderTextField.text = @"Female";
//    }
//    
//    if([[user objectForKey:@"Sportlvl"] isEqualToString:@"1"])
//    {
//        athletictypeTextField.text = @"Non-athlete";
//    }
//    else if([[user objectForKey:@"Sportlvl"] isEqualToString:@"2"])
//    {
//        athletictypeTextField.text = @"Amateur athlete";
//    }
//    else if([[user objectForKey:@"Sportlvl"] isEqualToString:@"3"])
//    {
//        athletictypeTextField.text = @"Professional athlete";
//    }
//    
//    heightTextField.text = [[user objectForKey:@"Height"] stringValue];
}

-(int)GetAgeByBrithday:(NSDate *)brithday
{
    int age = 0;
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
        NSDateComponents *brithdaycomps = [[NSDateComponents alloc] init];
        NSDateComponents *nowcomps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//这句我也不明白具体时用来做什么。。。
        brithdaycomps = [calendar components:unitFlags fromDate:brithday];
        nowcomps = [calendar components:unitFlags fromDate:NSDate.date];
        //    long brithdayweekNumber = [brithdaycomps weekday]; //获取星期对应的长整形字符串
        long brithdayday=[brithdaycomps day];//获取日期对应的长整形字符串
        long brithdayyear=[brithdaycomps year];//获取年对应的长整形字符串
        long brithdaymonth=[brithdaycomps month];//获取月对应的长整形字符串
        //    long brithdayhour=[brithdaycomps hour];//获取小时对应的长整形字符串
        //    long brithdayminute=[brithdaycomps minute];//获取月对应的长整形字符串
        //    long brithdaysecond=[brithdaycomps second];//获取秒对应的长整形字符串
        //    long nowweekNumber = [nowcomps weekday]; //获取星期对应的长整形字符串
        long nowday=[nowcomps day];//获取日期对应的长整形字符串
        long nowyear=[nowcomps year];//获取年对应的长整形字符串
        long nowmonth=[nowcomps month];//获取月对应的长整形字符串
        //    long nowhour=[nowcomps hour];//获取小时对应的长整形字符串
        //    long nowminute=[nowcomps minute];//获取月对应的长整形字符串
        //    long nowsecond=[nowcomps second];//获取秒对应的长整形字符串
        
        if(nowyear>brithdayyear)
        {
            if(nowmonth>brithdaymonth)
            {
                age = nowyear - brithdayyear;
            }
            else if(nowmonth == brithdaymonth)
            {
                if(nowday>=brithdayday)
                {
                    age = nowyear - brithdayyear;
                }
                else
                {
                    age = nowyear - brithdayyear - 1;
                }
            }
            else
            {
                age = nowyear - brithdayyear - 1;
            }
            
        }
        else
        {
            age = 0;
        }
    return age;
}

@end
