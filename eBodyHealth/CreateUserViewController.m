//
//  CreateUserViewController.m
//  eBodyHealth
//
//  Created by 夏 伟 on 13-8-3.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import "CreateUserViewController.h"
#import "UserSelectViewController.h"

@interface CreateUserViewController ()

@end

@implementation CreateUserViewController
@synthesize myTableView;
@synthesize brithdayTextField;
@synthesize ageTextField;
@synthesize heightUnit;
@synthesize heightTextField;
@synthesize athletictypeTextField;
@synthesize nameTextField;
@synthesize genderTextField;
@synthesize myHeightPicker;
@synthesize myWeightPicker;
@synthesize weightTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        heightUnit = @"cm";
        
    }
    return self;
}

- (void)viewDidLoad
{
    myBrithdayNavigationItem.title = NSLocalizedString(@"USERINFO_BRITHDAY", nil);
    myHeightNavigationItem.title = NSLocalizedString(@"USERINFO_HEIGHT", nil);
    myWeightNavigationItem.title = NSLocalizedString(@"USERINFO_WEIGHT", nil);
    addNewUserNavigationItem.title = NSLocalizedString(@"ADDNEWUSER", nil);
    addNewUserNavigationItem.rightBarButtonItem.title = NSLocalizedString(@"SAVE", nil);
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.myTableView =  [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
//    self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//    self.myTableView.dataSource = self;
//    self.myTableView.delegate = self;
    
//    [self.view addSubview:self.myTableView];
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
    }
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    self.myTableView = nil;
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
        result = 1;
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
            [myHeightPicker selectRow:171 inComponent:0 animated:YES]; //设置pickerview初始值
            
            textField.inputView = myHeightPicker;
            textField.inputAccessoryView = myHeightNavigationBar;
            result.accessoryView = textField;
            heightTextField = textField;
            result.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(indexPath.section == 0&& indexPath.row == 5)
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
            result.accessoryView = textField;
            result.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(indexPath.self == 0 && indexPath.row == 6)
        {
            
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
    int height = row + 1;
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
                result = [NSString stringWithFormat:@"%ld", (long)row +1];
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
    NSString *password = @"";
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
    
    if(![self isBlankString:weightTextField.text]){
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NOTICE",nil)
                                                            message:NSLocalizedString(@"PLEASE_INPUT_WEIGHT",nil)
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedString(@"OK",nil), nil];
        [alertView show];
        return;
    }
    
    if(![self isBlankString:genderTextField.text])
    {
        if ([genderTextField.text isEqualToString:NSLocalizedString(@"GENDER_FEMALE",nil)]) {
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
    
    bool hassame  = false;
    
    NSString *filePath = [self dataFilePath];
    sqlite3 *database;
    char* errorMsg;
    if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"数据库打开失败");
    }
//    sqlite3_busy_timeout(database, 100);
    
    NSString *username = name;
    NSString *datestrformat = brithdayTextField.text;
    
//    sqlite3_stmt * statement;
//    
//    NSString *sql1 = [NSString stringWithFormat:@"SELECT * FROM USER WHERE USERNAME = '%@'",username];
////    sql1 = @"SELECT * FROM USER WHERE USERNAME = 'wahaha'";
//    if (sqlite3_prepare_v2(database, [sql1 UTF8String], -1, &statement, nil) == SQLITE_OK) {
//        if (sqlite3_step(statement) == SQLITE_ROW) {
//            
//            hassame = true;
//            //NSLog(@"USERNAME:%@  AGE:%d  SEX:%@",weightstr,age, nsAddressStr);
//        }
//    }
//    sqlite3_close(database);
    
    if(hassame == false)
    {
        if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
            sqlite3_close(database);
            NSLog(@"数据库打开失败");
        }
        NSString *sql2 = [NSString stringWithFormat:
                          @"INSERT INTO 'USER' ('USERNAME', 'BRITHDAY', 'SEX', 'SPORTLVL','HEIGHT','WEIGHT','STEPLENGTH','PASSWORD') VALUES ('%@', '%@', '%d', '%d', '%d','%.1f','%d','%@')", username, datestrformat, sex, sportlvl, height, weight, steplength,password];
//    sql2 = [NSString stringWithFormat:@"UPDATE USER SET USERNAME = '%@', BRITHDAY = '%@', SEX = %d, SPORTLVL = %d, HEIGHT = %d,WEIGHT = %.1f,STEPLENGTH = %d,PASSWORD = '' WHERE USERID = %d", username, datestrformat, sex, sportlvl, height, weight, steplength,1];
    
        if(sqlite3_exec(database, [sql2 UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK){//备注2
            //插入数据失败，关闭数据库
            sqlite3_close(database);
//        NSAssert1(0, @"插入数据失败：%@", errorMsg);
            NSLog(@"插入数据失败：%@",errorMsg);
            sqlite3_free(errorMsg);
        }
        //关闭数据库
        sqlite3_close(database);
    
        [self backToUserSelectView:sender];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                            message:@"User name already exits, choose another user name!"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Ok", nil];
        [alertView show];
    }
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
























@end
