//
//  UserSelectViewController.m
//  eBodyHealth
//
//  Created by 夏 伟 on 13-8-2.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//
#import <sqlite3.h>
#import "UserSelectViewController.h"
#import "CreateUserViewController.h"
#import "MeasureViewController.h"
#import "HistoryViewController.h"
#import "ChartViewController.h"
#import "SettingsViewController.h"
#import "MySingleton.h"

@interface UserSelectViewController ()

@end

CreateUserViewController *createUserViewController;

@implementation UserSelectViewController

@synthesize tabBarController;
@synthesize measureNaviController;
@synthesize loginButtton;
@synthesize showCreateUserViewButton;
@synthesize settingNaviController;
@synthesize historyNaviController;
@synthesize chartNaviController;

@synthesize imageViews;
@synthesize scrollView;
@synthesize pageControl;
@synthesize spotNameLabel;
@synthesize scoreLabel;
@synthesize currentPage;
@synthesize pageControlUsed;
@synthesize titles;
@synthesize subtitles;

@synthesize userstestinfo;
@synthesize usersinfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        showCreateUserViewButton.titleLabel.text = NSLocalizedString(@"ENTER", nil);
//        loginButtton.titleLabel.text = NSLocalizedString(@"ADDNEWUSER", nil);
        
    }
    return self;
}

- (void)viewDidLoad
{
    [showCreateUserViewButton setTitle:NSLocalizedString(@"ADDNEWUSER", nil) forState:UIControlStateNormal];
    [loginButtton setTitle:NSLocalizedString(@"ENTER", nil) forState:UIControlStateNormal];
    softwareNameLabel.text = NSLocalizedString(@"EBELTER_HEALTH_CENTER", nil);
    
    userstestinfo = [[NSMutableArray alloc]init];
    [super viewDidLoad];
     [NSThread sleepForTimeInterval:2.0];   //设置进程停止2秒
    [self initDataBase];
    [self initScrollView];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewWillAppear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self initScrollView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initScrollView {
    
    [self GetUsersFromDataBase];
    self.titles = [NSArray arrayWithObjects:@"Page 1", @"Page 2", @"Page 3", @"Page 4", @"Page 5",nil];
    self.subtitles= [NSArray arrayWithObjects:
                     @"★ ★ ★", @"★ ★ ★ ☆",
                     @"★ ★ ★ ★", @"★ ★ ★ ★ ☆",
                     @"★ ★ ★ ★ ★",
                     nil];
    
    
    int kNumberOfPages = usersinfo.count;
    
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++) {
        [views addObject:[NSNull null]];
    }
    self.imageViews = views;
    
    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.clipsToBounds = NO;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    currentPage = 0;
    
    pageControl.numberOfPages = kNumberOfPages;
    pageControl.currentPage = 0;
    pageControl.backgroundColor = [UIColor whiteColor];
    
    [self createAllEmptyPagesForScrollView: kNumberOfPages];
    
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
//    [self loadScrollViewWithPage:0];
//    [self loadScrollViewWithPage:1];
    currentPage = 0;
    [scrollView setContentOffset:CGPointMake(0, 0)];
}

- (void)createAllEmptyPagesForScrollView: (int) pages {
    if (pages < 0) {
        return;
    }
    
    for (int page = 0; page < pages; page++) {
        CGRect frame = scrollView.frame;
        
        UIButton *backgroundButton =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
        backgroundButton.frame = CGRectMake(frame.size.width * page + 5, 0, 270, 328);
        //CGRectMake(frame.size.width * page + 8, 0, 293, 258);
        [backgroundButton setEnabled:false];
        [scrollView addSubview:backgroundButton];
        [backgroundButton setTintColor: [UIColor purpleColor]];
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 43, 14, 186, 21)];
        [name setTextAlignment:NSTextAlignmentCenter];
        name.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:17];
        UIImageView *usernameline = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width * page + 7, 39, 267, 1)];
        usernameline.image = [UIImage imageNamed:@"sc"];
        
        UILabel *age = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 7, 44, 85, 16)];
        [age setTextAlignment:NSTextAlignmentCenter];
        age.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:14];
        age.text = NSLocalizedString(@"USER_AGE", nil);
        UILabel *ageData = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 7, 60, 85, 16)];
        [ageData setTextAlignment:NSTextAlignmentCenter];
        ageData.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:14];
        ageData.text = @"Age";
        ageData.textColor = [UIColor colorWithRed:20.0/255.0 green:185.0/255.0 blue:214.0/255.0 alpha:1.0];
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
        NSDate *date =[dateFormat dateFromString:[[NSString alloc]initWithFormat:@"%@",[[usersinfo objectAtIndex:page]objectForKey:@"Brithday"]]];
        ageData.text = [[NSString alloc]initWithFormat:@"%d",[self GetAgeByBrithday:date] ];

        
        UILabel *gender = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 92, 44, 85, 16)];
        [gender setTextAlignment:NSTextAlignmentCenter];
        gender.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:14];
        gender.text = NSLocalizedString(@"USER_GENDER", nil);
        UILabel *genderData = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 92, 60, 85, 16)];
        [genderData setTextAlignment:NSTextAlignmentCenter];
        genderData.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:14];
        genderData.text = @"Gender";
        genderData.textColor = [UIColor colorWithRed:20.0/255.0 green:185.0/255.0 blue:214.0/255.0 alpha:1.0];
        
        UILabel *height = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 177, 44, 85, 16)];
        [height setTextAlignment:NSTextAlignmentCenter];
        height.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:14];
        height.text = NSLocalizedString(@"USER_HEIGHT", nil);
        UILabel *heightData = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 177, 60, 85, 16)];
        [heightData setTextAlignment:NSTextAlignmentCenter];
        heightData.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:14];
        heightData.text = @"Height";
        heightData.textColor = [UIColor colorWithRed:20.0/255.0 green:185.0/255.0 blue:214.0/255.0 alpha:1.0];
        heightData.text = [[NSString alloc]initWithFormat:@"%@cm", [[usersinfo objectAtIndex:page] objectForKey:@"Height"] ];
        
        UIImageView *userinfoline = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width * page + 7, 80, 267, 1)];
        userinfoline.image = [UIImage imageNamed:@"sc"];
        UIImageView *bodyfatimage = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width * page + 10, 95, 37, 36)];
        bodyfatimage.image = [UIImage imageNamed:@"Body fat_icon0"];
        UIImageView *deractionline = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width * page + 50, 87, 3, 60)];
        deractionline.image =[UIImage imageNamed:@"list001"];
        UIImageView *bodyfatmiddleline = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width * page + 58, 116, 209, 1)];
        bodyfatmiddleline.image =[UIImage imageNamed:@"sc"];
        
        UILabel *bodyfatweight = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 53, 85, 55, 15)];
        [bodyfatweight setTextAlignment:NSTextAlignmentCenter];
        bodyfatweight.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        bodyfatweight.text = NSLocalizedString(@"USER_WEIGHT", nil);
        UILabel *bodyfatweightData = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 53, 101, 55, 15)];
        [bodyfatweightData setTextAlignment:NSTextAlignmentCenter];
        bodyfatweightData.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        bodyfatweightData.text = @"Weight";
        bodyfatweightData.textColor = [UIColor colorWithRed:20.0/255.0 green:185.0/255.0 blue:214.0/255.0 alpha:1.0];
        if([userstestinfo count] > page){
        if([[userstestinfo objectAtIndex:page] objectForKey:@"Weight"] != nil){
            bodyfatweightData.text = [[NSString alloc]initWithFormat:@"%@kg", [[userstestinfo objectAtIndex:page] objectForKey:@"Weight"] ];
        }
        else
        {
            bodyfatweightData.text = @"---";
        }
        }
        else
        {
            bodyfatweightData.text = @"---";
        }
        
        UILabel *bodyfatfat = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 105, 85, 55, 15)];
        [bodyfatfat setTextAlignment:NSTextAlignmentCenter];
        bodyfatfat.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        bodyfatfat.text = NSLocalizedString(@"USER_FAT", nil);
        UILabel *bodyfatfatData = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 105, 101, 55, 15)];
        [bodyfatfatData setTextAlignment:NSTextAlignmentCenter];
        bodyfatfatData.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        bodyfatfatData.text = @"Fat";
        bodyfatfatData.textColor = [UIColor colorWithRed:20.0/255.0 green:185.0/255.0 blue:214.0/255.0 alpha:1.0];
        if([userstestinfo count] > page){
        if([[userstestinfo objectAtIndex:page] objectForKey:@"Fat"] ){
            bodyfatfatData.text = [[NSString alloc]initWithFormat:@"%@%%", [[userstestinfo objectAtIndex:page] objectForKey:@"Fat"] ];
        }
        else
        {
            bodyfatfatData.text = @"---";
        }
        }
        else
        {
            bodyfatfatData.text = @"---";
        }
        
        UILabel *bodyfatmuscle = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 160, 85, 55, 15)];
        [bodyfatmuscle setTextAlignment:NSTextAlignmentCenter];
        bodyfatmuscle.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        bodyfatmuscle.text = NSLocalizedString(@"USER_MUSCLE", nil);
        UILabel *bodyfatmuscleData = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 160, 101, 55, 15)];
        [bodyfatmuscleData setTextAlignment:NSTextAlignmentCenter];
        bodyfatmuscleData.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        bodyfatmuscleData.text = @"Muscle";
        bodyfatmuscleData.textColor = [UIColor colorWithRed:20.0/255.0 green:185.0/255.0 blue:214.0/255.0 alpha:1.0];
        if([userstestinfo count] > page){
        if([[userstestinfo objectAtIndex:page] objectForKey:@"Muscle"] != nil){
            bodyfatmuscleData.text = [[NSString alloc]initWithFormat:@"%@kg", [[userstestinfo objectAtIndex:page] objectForKey:@"Muscle"] ];
        }
        else
        {
            bodyfatmuscleData.text = @"---";
        }
        }
        else
        {
            bodyfatmuscleData.text = @"---";
        }
        
        UILabel *bodyfatwater = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 215, 85, 55, 15)];
        [bodyfatwater setTextAlignment:NSTextAlignmentCenter];
        bodyfatwater.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        bodyfatwater.text = NSLocalizedString(@"USER_WATER", nil);
        UILabel *bodyfatwaterData = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 215, 101, 55, 15)];
        [bodyfatwaterData setTextAlignment:NSTextAlignmentCenter];
        bodyfatwaterData.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        bodyfatwaterData.text = @"Water";
        bodyfatwaterData.textColor = [UIColor colorWithRed:20.0/255.0 green:185.0/255.0 blue:214.0/255.0 alpha:1.0];
        if([userstestinfo count] > page){
        if([[userstestinfo objectAtIndex:page] objectForKey:@"Water"] != nil){
        bodyfatwaterData.text = [[NSString alloc]initWithFormat:@"%@%%", [[userstestinfo objectAtIndex:page] objectForKey:@"Water"] ];
        }
        else
        {
            bodyfatwaterData.text= @"---";
        }
        }
        else
        {
            bodyfatwaterData.text= @"---";
        }
        
        UILabel *bodyfatvirfat = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 53, 117, 55, 15)];
        [bodyfatvirfat setTextAlignment:NSTextAlignmentCenter];
        bodyfatvirfat.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        bodyfatvirfat.text = NSLocalizedString(@"USER_VISFAT", nil);
        UILabel *bodyfatvirfatData = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 53, 133, 55, 15)];
        [bodyfatvirfatData setTextAlignment:NSTextAlignmentCenter];
        bodyfatvirfatData.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        bodyfatvirfatData.text = @"Vir Fat";
        bodyfatvirfatData.textColor = [UIColor colorWithRed:20.0/255.0 green:185.0/255.0 blue:214.0/255.0 alpha:1.0];
        if([userstestinfo count] > page){
        if([[userstestinfo objectAtIndex:page] objectForKey:@"VisceralFat"] != nil){
        bodyfatvirfatData.text = [[NSString alloc]initWithFormat:@"%@", [[userstestinfo objectAtIndex:page] objectForKey:@"VisceralFat"] ];
        }
        else
        {
            bodyfatvirfatData.text = @"---";
        }
        }
        else
        {
            bodyfatvirfatData.text = @"---";
        }
        
        UILabel *bodyfatbone = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 105, 117, 55, 15)];
        [bodyfatbone setTextAlignment:NSTextAlignmentCenter];
        bodyfatbone.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        bodyfatbone.text = NSLocalizedString(@"USER_BONE", nil);
        UILabel *bodyfatboneData = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 105, 133, 55, 15)];
        [bodyfatboneData setTextAlignment:NSTextAlignmentCenter];
        bodyfatboneData.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        bodyfatboneData.text = @"Bone";
        bodyfatboneData.textColor = [UIColor colorWithRed:20.0/255.0 green:185.0/255.0 blue:214.0/255.0 alpha:1.0];
        if([userstestinfo count] > page){
        if([[userstestinfo objectAtIndex:page] objectForKey:@"Bone"] != nil){
        bodyfatboneData.text = [[NSString alloc]initWithFormat:@"%@kg", [[userstestinfo objectAtIndex:page] objectForKey:@"Bone"] ];
        }
        else
        {
            bodyfatboneData.text = @"---";
        }
        }
        else
        {
            bodyfatboneData.text = @"---";
        }
        
        UILabel *bodyfatbmr = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 160, 117, 55, 15)];
        [bodyfatbmr setTextAlignment:NSTextAlignmentCenter];
        bodyfatbmr.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        bodyfatbmr.text = NSLocalizedString(@"USER_BMI", nil);
        UILabel *bodyfatbmrData = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 160, 133, 55, 15)];
        [bodyfatbmrData setTextAlignment:NSTextAlignmentCenter];
        bodyfatbmrData.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        bodyfatbmrData.text = @"BMI";
        bodyfatbmrData.textColor = [UIColor colorWithRed:20.0/255.0 green:185.0/255.0 blue:214.0/255.0 alpha:1.0];
        if([userstestinfo count] > page){
        if([[userstestinfo objectAtIndex:page] objectForKey:@"BMI"] != nil){
            bodyfatbmrData.text = [[NSString alloc]initWithFormat:@"%@", [[userstestinfo objectAtIndex:page] objectForKey:@"BMI"] ];
        }
        else
        {
            bodyfatbmrData.text = @"---";
        }
        }
        else
        {
            bodyfatbmrData.text = @"---";
        }
        
        UILabel *bodyfatbmi = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 215, 117, 55, 15)];
        [bodyfatbmi setTextAlignment:NSTextAlignmentCenter];
        bodyfatbmi.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        bodyfatbmi.text = NSLocalizedString(@"USER_BMR", nil);
        UILabel *bodyfatbmiData = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 215, 133, 55, 15)];
        [bodyfatbmiData setTextAlignment:NSTextAlignmentCenter];
        bodyfatbmiData.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:11];
        bodyfatbmiData.text = @"BMR";
        bodyfatbmiData.textColor = [UIColor colorWithRed:20.0/255.0 green:185.0/255.0 blue:214.0/255.0 alpha:1.0];
        if([userstestinfo count] > page){
        if([[userstestinfo objectAtIndex:page] objectForKey:@"BMR"] != nil){
            bodyfatbmiData.text = [[NSString alloc]initWithFormat:@"%@kcal", [[userstestinfo objectAtIndex:page] objectForKey:@"BMR"] ];
        }
        else
        {
            bodyfatbmiData.text = @"---";
        }
        }
        else
        {
            bodyfatbmiData.text = @"---";
        }
        
        UIImageView *bodyfatline = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width * page + 7, 150, 267, 1)];
        bodyfatline.image = [UIImage imageNamed:@"sc"];
        
        UIImageView *weightimage = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width * page + 10, 155, 37, 36)];
        weightimage.image = [UIImage imageNamed:@"Weight_icon0"];
        UIImageView *weightderactionline = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width * page + 50, 152, 3, 40)];
        weightderactionline.image =[UIImage imageNamed:@"list001"];
        UIImageView *weightline = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width * page + 7, 194, 267, 1)];
        weightline.image = [UIImage imageNamed:@"sc"];
        
        UILabel *weight = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 53, 157, 55, 15)];
        [weight setTextAlignment:NSTextAlignmentCenter];
        weight.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        weight.text = NSLocalizedString(@"USER_WEIGHT", nil);
        UILabel *weightData = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 53, 173, 55, 15)];
        [weightData setTextAlignment:NSTextAlignmentCenter];
        weightData.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        weightData.text = @"Weight";
        weightData.textColor = [UIColor colorWithRed:20.0/255.0 green:185.0/255.0 blue:214.0/255.0 alpha:1.0];
        if([[usersinfo objectAtIndex:page] objectForKey:@"Weight"] != nil){
            weightData.text = [[NSString alloc]initWithFormat:@"%@kg", [[usersinfo objectAtIndex:page] objectForKey:@"Weight"] ];
        }
        else
        {
            weightData.text = @"---";
        }
        
        UIImageView *bloodpressimage = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width * page + 10, 196, 37, 36)];
        bloodpressimage.image = [UIImage imageNamed:@"Blood pressure_icon0"];
        UIImageView *bloodpressderactionline = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width * page + 50, 195, 3, 40)];
        bloodpressderactionline.image =[UIImage imageNamed:@"list001"];
        
        UILabel *highpress = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 53, 202, 55, 15)];
        [highpress setTextAlignment:NSTextAlignmentCenter];
        highpress.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        highpress.text = NSLocalizedString(@"USER_SYS", nil);
        UILabel *highpressData = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 53, 218, 55, 15)];
        [highpressData setTextAlignment:NSTextAlignmentCenter];
        highpressData.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        highpressData.text = @"SYS";
        highpressData.textColor = [UIColor colorWithRed:20.0/255.0 green:185.0/255.0 blue:214.0/255.0 alpha:1.0];
        if([[usersinfo objectAtIndex:page] objectForKey:@"SYS"] != nil){
            highpressData.text = [[NSString alloc]initWithFormat:@"%@", [[usersinfo objectAtIndex:page] objectForKey:@"SYS"] ];
        }
        else
        {
            highpressData.text = @"---";
        }
        
        UILabel *lowpress = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 105, 202, 55, 15)];
        [lowpress setTextAlignment:NSTextAlignmentCenter];
        lowpress.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        lowpress.text = NSLocalizedString(@"USER_DIA", nil);
        UILabel *lowpressData = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 105, 218, 55, 15)];
        [lowpressData setTextAlignment:NSTextAlignmentCenter];
        lowpressData.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        lowpressData.text = @"DIA";
        lowpressData.textColor = [UIColor colorWithRed:20.0/255.0 green:185.0/255.0 blue:214.0/255.0 alpha:1.0];
        if([[usersinfo objectAtIndex:page] objectForKey:@"DIA"] != nil){
            lowpressData.text = [[NSString alloc]initWithFormat:@"%@", [[usersinfo objectAtIndex:page] objectForKey:@"DIA"] ];
        }
        else
        {
            lowpressData.text = @"---";
        }
        
        UILabel *bloodpresspulse = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 160, 202, 55, 15)];
        [bloodpresspulse setTextAlignment:NSTextAlignmentCenter];
        bloodpresspulse.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        bloodpresspulse.text = NSLocalizedString(@"USER_PULSE", nil);
        UILabel *bloodpresspulseData = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 160, 218, 55, 15)];
        [bloodpresspulseData setTextAlignment:NSTextAlignmentCenter];
        bloodpresspulseData.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        bloodpresspulseData.text = @"Pulse";
        bloodpresspulseData.textColor = [UIColor colorWithRed:20.0/255.0 green:185.0/255.0 blue:214.0/255.0 alpha:1.0];
        if([[usersinfo objectAtIndex:page] objectForKey:@"Pulse"] != nil){
            bloodpresspulseData.text = [[NSString alloc]initWithFormat:@"%@", [[usersinfo objectAtIndex:page] objectForKey:@"Pulse"] ];
        }
        else
        {
            bloodpresspulseData.text = @"---";
        }
        
        UIImageView *bloodpressline = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width * page + 7, 238, 267, 1)];
        bloodpressline.image = [UIImage imageNamed:@"sc"];
        
        UIImageView *oxygenimage = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width * page + 10, 243, 37, 36)];
        oxygenimage.image = [UIImage imageNamed:@"Oxygen_icon0"];
        UIImageView *oxygenderactionline = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width * page + 50, 240, 3, 40)];
        oxygenderactionline.image =[UIImage imageNamed:@"list001"];
        
        UILabel *oxygen = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 53, 247, 55, 15)];
        [oxygen setTextAlignment:NSTextAlignmentCenter];
        oxygen.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        oxygen.text = NSLocalizedString(@"USER_OXYGEN", nil);
        UILabel *oxygenData = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 53, 263, 55, 15)];
        [oxygenData setTextAlignment:NSTextAlignmentCenter];
        oxygenData.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        oxygenData.text = @"Oxgen";
        oxygenData.textColor = [UIColor colorWithRed:20.0/255.0 green:185.0/255.0 blue:214.0/255.0 alpha:1.0];
        if([[usersinfo objectAtIndex:page] objectForKey:@"Oxgen"] != nil){
            oxygenData.text = [[NSString alloc]initWithFormat:@"%@%%", [[usersinfo objectAtIndex:page] objectForKey:@"Oxgen"] ];
        }
        else
        {
            oxygenData.text =@"---";
        }
        
        UILabel *oxygenpulse = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 105, 247, 55, 15)];
        [oxygenpulse setTextAlignment:NSTextAlignmentCenter];
        oxygenpulse.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        oxygenpulse.text = NSLocalizedString(@"USER_PULSE", nil);
        UILabel *oxygenpulseData = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 105, 263, 55, 15)];
        [oxygenpulseData setTextAlignment:NSTextAlignmentCenter];
        oxygenpulseData.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        oxygenpulseData.text = @"Pulse";
        oxygenpulseData.textColor = [UIColor colorWithRed:20.0/255.0 green:185.0/255.0 blue:214.0/255.0 alpha:1.0];
        if([[usersinfo objectAtIndex:page] objectForKey:@"Pulse"] != nil){
            oxygenpulseData.text = [[NSString alloc]initWithFormat:@"%@", [[usersinfo objectAtIndex:page] objectForKey:@"Pulse"] ];
        }
        else
        {
            oxygenpulseData.text = @"---";
        }
        
        UIImageView *oxygenline = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width * page + 7, 282, 267, 1)];
        oxygenline.image = [UIImage imageNamed:@"sc"];
        UIImageView *glucoseimage = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width * page + 10, 289, 37, 36)];
        glucoseimage.image = [UIImage imageNamed:@"Blood sugar_icon0"];
        UIImageView *glucosederactionline = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width * page + 50, 286, 3, 40)];
        glucosederactionline.image =[UIImage imageNamed:@"list001"];
//        UIImageView *glucoseline = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width * page + 7, 196, 267, 1)];
//        glucoseline.image = [UIImage imageNamed:@"sc"];
        UILabel *glucose = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 53, 291, 100, 15)];
        [glucose setTextAlignment:NSTextAlignmentCenter];
        glucose.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        glucose.text = NSLocalizedString(@"USER_GLUCOSE", nil);
        UILabel *glucoseData = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 53, 307, 100, 15)];
        [glucoseData setTextAlignment:NSTextAlignmentCenter];
        glucoseData.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        glucoseData.text = @"Glucose";
        glucoseData.textColor = [UIColor colorWithRed:20.0/255.0 green:185.0/255.0 blue:214.0/255.0 alpha:1.0];
        if([[usersinfo objectAtIndex:page] objectForKey:@"Glucose"] != nil)
        {
            glucoseData.text = [[NSString alloc]initWithFormat:@"%@mmol/L", [[usersinfo objectAtIndex:page] objectForKey:@"Glucose"] ];
        }
        else
        {
            glucoseData.text = @"---";
        }
        
        
        UILabel *score = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * page + 92, 40, 85, 16)];
        [score setTextAlignment:NSTextAlignmentCenter];
        score.font = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"Helvetica"] objectAtIndex:1]size:13];
        name.text = [self.titles objectAtIndex:page];
        name.text =[[usersinfo objectAtIndex:page]objectForKey:@"UserName"];
        score.text = [self.subtitles objectAtIndex:page];
        if([[[usersinfo objectAtIndex:page] objectForKey:@"Sex"] isEqualToString:@"0"])
        {
            genderData.text = NSLocalizedString(@"GENDER_MALE", nil);
        }
        else
        {
            genderData.text = NSLocalizedString(@"GENDER_FEMALE", nil);
        }
        
        
        [scrollView addSubview:name];
//        [scrollView addSubview:score];
        [scrollView addSubview:usernameline];
        [scrollView addSubview:age];
        [scrollView addSubview:ageData];
        [scrollView addSubview:gender];
        [scrollView addSubview:genderData];
        [scrollView addSubview:height];
        [scrollView addSubview:heightData];
        [scrollView addSubview:userinfoline];
        [scrollView addSubview:bodyfatimage];
        [scrollView addSubview:deractionline];
        [scrollView addSubview:bodyfatmiddleline];
        [scrollView addSubview:bodyfatweight];
        [scrollView addSubview:bodyfatweightData];
        [scrollView addSubview:bodyfatfat];
        [scrollView addSubview:bodyfatfatData];
        [scrollView addSubview:bodyfatmuscle];
        [scrollView addSubview:bodyfatmuscleData];
        [scrollView addSubview:bodyfatwater];
        [scrollView addSubview:bodyfatwaterData];
        [scrollView addSubview:bodyfatvirfat];
        [scrollView addSubview:bodyfatvirfatData];
        [scrollView addSubview:bodyfatbone];
        [scrollView addSubview:bodyfatboneData];
        [scrollView addSubview:bodyfatbmi];
        [scrollView addSubview:bodyfatbmiData];
        [scrollView addSubview:bodyfatbmr];
        [scrollView addSubview:bodyfatbmrData];
        [scrollView addSubview:bodyfatline];
        [scrollView addSubview:weightimage];
        [scrollView addSubview:weightderactionline];
        [scrollView addSubview:weightline];
        [scrollView addSubview:weight];
        [scrollView addSubview:weightData];
        [scrollView addSubview:bloodpressimage];
        [scrollView addSubview:bloodpressderactionline];
        [scrollView addSubview:highpress];
        [scrollView addSubview:highpressData];
        [scrollView addSubview:lowpress];
        [scrollView addSubview:lowpressData];
        [scrollView addSubview:bloodpresspulse];
        [scrollView addSubview:bloodpresspulseData];
        [scrollView addSubview:bloodpressline];
        [scrollView addSubview:oxygenimage];
        [scrollView addSubview:oxygenderactionline];
        [scrollView addSubview:oxygen];
        [scrollView addSubview:oxygenData];
        [scrollView addSubview:oxygenpulse];
        [scrollView addSubview:oxygenpulseData];
        [scrollView addSubview:oxygenline];
        [scrollView addSubview:glucoseimage];
        [scrollView addSubview:glucosederactionline];
        [scrollView addSubview:glucose];
        [scrollView addSubview:glucoseData];
        
//        UIButton *detailButton =  [UIButton buttonWithType:UIButtonTypeInfoDark];
//        detailButton.frame = CGRectMake(frame.size.width * page + 242, 16, 29, 31);
//        [detailButton addTarget:self
//                         action:@selector(doTabImageViewAction)
//               forControlEvents:UIControlEventTouchUpInside];
//        [scrollView addSubview:detailButton];
        
        UIActivityIndicatorView *actIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                                                 UIActivityIndicatorViewStyleWhiteLarge];
        [actIndicator setCenter:CGPointMake(frame.size.width * page + 140, 131)];
//        [scrollView addSubview:actIndicator];
        [actIndicator startAnimating];
    }
}

- (void)loadScrollViewWithPage:(int)page {
	int kNumberOfPages = usersinfo.count;
	
    if (page < 0) {
        return;
    }
    if (page >= kNumberOfPages) {
        return;
    }
    
    //currentPage = page;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        TapDetectingImageView *tempView = [imageViews objectAtIndex:page];
        if ((NSNull *)tempView == [NSNull null]) {
            //NSString* imgURL = [[self.recommendSpots objectAtIndex:page] faceImg];
//            UIImage* image = [UIImage imageNamed:@"img.gif"];
            UIImage* image = [UIImage imageNamed:@"login_back"];
            /*if ([imgURL isEqualToString:@"nil"]) {
             image = [UIImage imageNamed: @"Default.png"];
             } else {
             NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imgURL]];
             image = [[UIImage alloc] initWithData:imageData];
             }*/
            
            tempView = [[TapDetectingImageView alloc] initWithImage:image];
            tempView.parentView = self;
            [imageViews replaceObjectAtIndex:page withObject:tempView];
        }
        
        if (tempView) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (nil == tempView.superview) {
                    CGRect frame = scrollView.frame;
                    frame.origin.x = frame.size.width * page;
                    frame.origin.y = 0;
                    tempView.frame = CGRectMake(frame.size.width * page + 0, 1, 1, 1);
                    [scrollView addSubview:tempView];
                    //[scrollView setContentOffset:CGPointMake(frame.size.width * page, 0)];
                }
                //[scrollView setContentOffset:CGPointMake(scrollView.frame.size.width * page, 0)];
            });
        }
        else {
            //NSLog(@"impossible download image");
        }
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (page < 0 || page >= 5) {
        return;
    }
    pageControl.currentPage = page;
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = YES;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    currentPage = page;
    pageControlUsed = YES;
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    return YES;
}
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return NO;
}

//for TapDetectingImageViewDelegate
- (void)doTabImageViewAction {
//    DetailedView *detailView = [[DetailedView alloc]initWithNibName:@"DetailedView" bundle:nil];
//    detailView.hidesBottomBarWhenPushed = YES;
//    detailView.page = self.currentPage + 1;
//    [[self navigationController] pushViewController:detailView animated:YES];
    //[self.parentView pushViewAction:objectDetailView];
}


-(IBAction)showCreatUserView:(id)sender
{
    
    if(createUserViewController == nil){
        createUserViewController = [[CreateUserViewController alloc]initWithNibName:@"CreateUserViewController" bundle:nil];
        //NSLog(@"infoViewController is nil");
    }else{
        //NSLog(@"infoViewController is not nil");
    }
    
    
    createUserViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //registerViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //infoViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //infoViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    //infoViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    
    
    //[self presentModalViewController:infoViewController animated:YES];//备注1
    [self presentViewController:createUserViewController animated:YES completion:^{//备注2
        NSLog(@"show InfoView!");
    }];
    
//    [self.view addSubview:createUserViewController.view];
    
    //presentedViewController
    NSLog(@"self.presentedViewController=%@",self.presentedViewController);//备注3

}

-(IBAction)login:(id)sender
{
    
//    //UIViewController *userSelectViewController = [[UserSelectViewController alloc] initWithNibName:@"UserSelectViewController" bundle:nil];
//    [MySingleton sharedSingleton].nowuserid = 1;
//    
//    NSString *filePath = [self dataFilePath];
//    NSLog(@"filePath=%@",filePath);
//    
//    sqlite3 *database;
//    if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
//        sqlite3_close(database);
//        NSLog(@"数据库打开失败");
//    }
//    
//    char* errorMsg;
//    //创建脂肪秤数据表 数据id，用户id，用户名，年龄，性别，运动等级，身高，体重，脂肪率，内脏脂肪等级，水分率，骨量，肌肉量，卡路里，BMI，测试时间，版本号，是否发送
//    NSString *sqlSelectUser = [[NSString alloc]initWithFormat:@"SELECT * FROM USER WHERE USERID = %d",[MySingleton sharedSingleton].nowuserid];
//    sqlSelectUser = @"SELECT * FROM USER";
//    sqlite3_stmt * statement;
//    if (sqlite3_prepare_v2(database, [sqlSelectUser UTF8String], -1, &statement, nil) == SQLITE_OK) {
//        while (sqlite3_step(statement) == SQLITE_ROW) {
//            int userid = sqlite3_column_int(statement, 0);
//            char *username = sqlite3_column_text(statement,1);
//            char *password = sqlite3_column_text(statement,8);
////            double weight = sqlite3_column_double(statement, 3);
////            char *testtimechar = sqlite3_column_text(statement, 4);
////            NSString *testtimestr = [[NSString  alloc]initWithFormat:@"%s",testtimechar];
////            NSString *weightstr = [[NSString alloc]initWithFormat:@"%.1f",weight];
////            
////            NSDictionary *dataRow1 =[[NSDictionary alloc] initWithObjectsAndKeys:
////                                     [[NSString alloc] initWithFormat:@"%@", testtimestr],
////                                     @"TestTime",
////                                     weightstr,
////                                     @"Weight",
////                                     nil];
//            
//            //NSLog(@"USERNAME:%@  AGE:%d  SEX:%@",weightstr,age, nsAddressStr);
//            
//        }
//    }
//
//
    bool ispass = NO;
    
    int a = [usersinfo count];
    if(a != 0)
    {
    
        if([[[usersinfo objectAtIndex:self.currentPage] objectForKey:@"PassWord"] isEqualToString:@""])
        {
            [MySingleton sharedSingleton].nowuserinfo = [usersinfo objectAtIndex:self.currentPage];
            ispass = YES;
        }
        else
        {
//        UIAlertView *alert = 
        }
    
    
    
        if(ispass){
            
            [MySingleton sharedSingleton].nowuserid = [[[usersinfo objectAtIndex:currentPage] objectForKey:@"Userid"] intValue];
            NSLog(@"user %d login!",[MySingleton sharedSingleton].nowuserid);
            UIViewController *measureViewController = [[MeasureViewController alloc] initWithNibName:@"MeasureViewController" bundle:nil];
            UIViewController *historyViewController = [[HistoryViewController alloc] initWithNibName:@"HistoryViewController" bundle:nil];
            UIViewController *chartViewController = [[ChartViewController alloc] initWithNibName:@"ChartViewController" bundle:nil];
            UIViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    
            measureNaviController = [[UINavigationController alloc]initWithRootViewController:measureViewController];
//            [measureNaviController.navigationBar setBackgroundImage:[UIImage imageNamed:@"S"] forBarMetrics:UIBarMetricsDefault];
//        [measureViewController.navigationItem.leftBarButtonItem setBackgroundImage:@"History" forState:UIControlStateNormal style:UIBarButtonItemStyleBordered barMetrics:UIBarMetricsDefault];
//            measureNaviController.navigationBar.tintColor = [UIColor colorWithRed:20.0/255.0 green:185.0/255.0 blue:214.0/255.0 alpha:1.0];
            settingNaviController = [[UINavigationController alloc]initWithRootViewController:settingsViewController];
//            settingNaviController.navigationBar.tintColor = [UIColor colorWithRed:20.0/255.0 green:185.0/255.0 blue:214.0/255.0 alpha:1.0];
            historyNaviController =  [[UINavigationController alloc]initWithRootViewController:historyViewController];
//            historyNaviController.navigationBar.tintColor = [UIColor colorWithRed:20.0/255.0 green:185.0/255.0 blue:214.0/255.0 alpha:1.0];
            chartNaviController = [[UINavigationController alloc]initWithRootViewController:chartViewController];
//            chartNaviController.navigationBar.tintColor = [UIColor colorWithRed:20.0/255.0 green:185.0/255.0 blue:214.0/255.0 alpha:1.0];
            self.tabBarController = [[UITabBarController alloc] init];
    
//        self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:60.0/255.0 green:185.0/255.0 blue:214.0/255.0 alpha:1.0];
            self.tabBarController.viewControllers = [NSArray arrayWithObjects:measureNaviController,historyNaviController,chartNaviController, settingNaviController,nil];
            self.tabBarController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:tabBarController animated:YES completion:^{//备注2
                NSLog(@"show InfoView!");
        
            }];
        }
    }
    else
    {
        UIAlertView *alert  = [[UIAlertView alloc]initWithTitle:@"Notice" message:@"Please create a new user." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

-(void)initDataBase
{
    //确定是否有数据文件及相应表，若无则创建
    NSString *filePath = [self dataFilePath];
    NSLog(@"filePath=%@",filePath);
    
    sqlite3 *database;
    if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"数据库打开失败");
    }
    char* errorMsg;
    //创建脂肪秤数据表 数据id，用户id，用户名，年龄，性别，运动等级，身高，体重，脂肪率，内脏脂肪等级，水分率，骨量，肌肉量，BMR(基础代谢)，BMI，测试时间，版本号，是否发送
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS BODYFATDATA(DATAID INTEGER PRIMARY KEY AUTOINCREMENT, USERID INTEGER, USERNAME TEXT, AGE INTEGER, SEX INTEGER, SPORTLVL INTEGER, HEIGHT INTEGER, WEIGHT FLOAT, BODYFAT FLOAT, VISCERALFAT INTEGER, WATER FLOAT, BONE FLOAT, MUSCLE FLOAT, BMR INTEGER, BMI FLOAT, TESTTIME TIMESTAMP, VERSION FLOAT,ISSEND TEXT)";
    if(sqlite3_exec(database, [sqlCreateTable UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK){//备注2
        //创建表失败，关闭数据库
        sqlite3_close(database);
        NSAssert1(0, @"创建表失败：%@", errorMsg);
        sqlite3_free(errorMsg);
    }
    
    //创建健康秤数据表 数据id，用户id，用户名，体重，测量时间，是否上传
    NSString *sqlCreatrWeightTable = @"CREATE TABLE IF NOT EXISTS WEIGHTDATA(DATAID INTEGER PRIMARY KEY AUTOINCREMENT, USERID INTEGER, USERNAME TEXT, WEIGHT FLOAT, TESTTIME TIMESTAMP, ISSEND TEXT)";
    if(sqlite3_exec(database, [sqlCreatrWeightTable UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK){//备注2
        //创建表失败，关闭数据库
        sqlite3_close(database);
        NSAssert1(0, @"创建表失败：%@", errorMsg);
        sqlite3_free(errorMsg);
    }
    
    //创建用户表 用户id，用户名，生日，性别(0男,1女)，运动级别(1白领，2普通，3运动员),身高（cm），体重，步幅，密码，
    NSString *sqlCreateUserTable = @"CREATE TABLE IF NOT EXISTS USER(USERID INTEGER PRIMARY KEY AUTOINCREMENT, USERNAME TEXT, BRITHDAY TIMESTAMP, SEX INTEGER, SPORTLVL INTEGER, HEIGHT INTEGER, WEIGHT FLOAT, STEPLENGTH INTEGER, PASSWORD TEXT)";
    if(sqlite3_exec(database, [sqlCreateUserTable UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK){//备注2
        //创建表失败，关闭数据库
        sqlite3_close(database);
        NSAssert1(0, @"创建表失败：%@", errorMsg);
        sqlite3_free(errorMsg);
    }
    
    sqlite3_close(database);
//    //增加用户表列password
//    NSString *sqlAddPassWord = @"ALTER TABLE USER ADD PASSWORD TEXT";
//    if(sqlite3_exec(database, [sqlAddPassWord UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK){//备注2
//        //创建表失败，关闭数据库
//        sqlite3_close(database);
//        NSAssert1(0, @"创建表失败：%@", errorMsg);
//    }
}

-(NSString *)dataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kSqliteFileName];
}

-(void)GetUsersFromDataBase
{
    //初始化用户列表
    usersinfo = [[NSMutableArray alloc]init];
    userstestinfo = [[NSMutableArray alloc]init];
    //获取数据库路径
    NSString *filePath = [self dataFilePath];
    NSLog(@"filePath=%@",filePath);
    
    sqlite3 *database;
    if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"数据库打开失败");
    }
    char* errorMsg;
    
    NSString *sqlQuery = [[NSString alloc]initWithFormat:@"SELECT USERID,USERNAME,PASSWORD, WEIGHT,BRITHDAY,SEX,HEIGHT,SPORTLVL FROM USER ORDER BY USERID ASC"];
    //sqlQuery = @"SELECT * FROM WEIGHTDATA WHERE USERID = 1";
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int userid = sqlite3_column_double(statement, 0);
            char *username = sqlite3_column_text(statement,1);
            char *password = sqlite3_column_text(statement,2);
            double weight = sqlite3_column_double(statement, 3);
            char *brithday = sqlite3_column_text(statement,4);
            int sex = sqlite3_column_double(statement, 5);
            int height = sqlite3_column_double(statement, 6);
            int sportlvl = sqlite3_column_double(statement, 7);
            
            NSString *weightstr = [[NSString alloc]initWithFormat:@"%.1f",weight];
            
            NSDictionary *onedata =[[NSDictionary alloc] initWithObjectsAndKeys:
                                     [[NSString alloc] initWithFormat:@"%d", userid],
                                     @"Userid",
                                     [[NSString alloc] initWithFormat:@"%s", username],
                                     @"UserName",
                                     [[NSString alloc] initWithFormat:@"%s", password],
                                     @"PassWord",
                                     weightstr,
                                     @"Weight",
                                    [[NSString alloc] initWithFormat:@"%s", brithday],
                                    @"Brithday",
                                    [[NSString alloc] initWithFormat:@"%d", sex],
                                    @"Sex",
                                    [[NSString alloc] initWithFormat:@"%d", height],
                                    @"Height",
                                    [[NSString alloc] initWithFormat:@"%d", sportlvl],
                                    @"Sportlvl",
                                     nil];
            
            //NSLog(@"USERNAME:%@  AGE:%d  SEX:%@",weightstr,age, nsAddressStr);
            
            [usersinfo addObject:onedata];
        }
    }
    //关闭数据库
    sqlite3_finalize(statement);  
    sqlite3_close(database);
    
    if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"数据库打开失败");
    }
    
    for (int i =0; i<[usersinfo count]; i++) {
        NSString *sql2=[[NSString alloc]initWithFormat:@"SELECT * FROM BODYFATDATA WHERE USERID = %d ORDER BY TESTTIME DESC",[[[usersinfo objectAtIndex:i] objectForKey:@"Userid"] intValue]];
        
        if (sqlite3_prepare_v2(database, [sql2 UTF8String], -1, &statement, nil) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                double weight = sqlite3_column_double(statement, 7);
                double fat = sqlite3_column_double(statement, 8);
                int visceralfat = sqlite3_column_int(statement, 9);
                double water = sqlite3_column_double(statement, 10);
                double bone = sqlite3_column_double(statement, 11);
                double muscle = sqlite3_column_double(statement, 12);
                int bmr = sqlite3_column_int(statement, 13);
                double bmi = sqlite3_column_double(statement, 14);
                char *testtimechar = sqlite3_column_text(statement, 15);
                NSString *testtimestr = [[NSString  alloc]initWithFormat:@"%s",testtimechar];
                NSString *weightstr = [[NSString alloc]initWithFormat:@"%.1f",weight];
                NSString *fatstr = [[NSString alloc]initWithFormat:@"%.1f",fat];
                NSString *visceralfatstr = [[NSString alloc]initWithFormat:@"%d",visceralfat];
                NSString *waterstr = [[NSString alloc]initWithFormat:@"%.1f",water];
                NSString *bonestr = [[NSString alloc]initWithFormat:@"%.1f",bone];
                NSString *musclestr = [[NSString alloc]initWithFormat:@"%.1f",muscle];
                NSString *bmrstr = [[NSString alloc]initWithFormat:@"%d",bmr];
                NSString *bmistr = [[NSString alloc]initWithFormat:@"%.1f",bmi];
                
                NSDictionary *dataRow1 =[[NSDictionary alloc] initWithObjectsAndKeys:
                                         [[usersinfo objectAtIndex:i] objectForKey:@"Userid"],
                                         @"Userid",
                                         [[usersinfo objectAtIndex:i] objectForKey:@"UserName"],
                                         @"UserName",
                                         [[usersinfo objectAtIndex:i] objectForKey:@"PassWord"],
                                         @"PassWord",
                                         [[NSString alloc] initWithFormat:@"%@", testtimestr] ,
                                         @"TestTime",
                                         [[usersinfo objectAtIndex:i] objectForKey:@"Weight"],
                                         @"Weight",
                                         fatstr,
                                         @"Fat",
                                         musclestr,
                                         @"Muscle",
                                         waterstr,
                                         @"Water",
                                         bonestr,
                                         @"Bone",
                                         visceralfatstr,
                                         @"VisceralFat",
                                         bmrstr,
                                         @"BMR",
                                         bmistr,
                                         @"BMI",
                                         nil];
                
                //NSLog(@"USERNAME:%@  AGE:%d  SEX:%@",weightstr,age, nsAddressStr);
                
                [userstestinfo addObject:dataRow1];
            }
            sqlite3_finalize(statement);  
        }
    }
    
    
    //关闭数据库
    sqlite3_close(database);
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
