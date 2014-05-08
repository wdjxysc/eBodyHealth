//
//  UserSelectViewController.h
//  eBodyHealth
//
//  Created by 夏 伟 on 13-8-2.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "TapDetectingImageView.h"

#define kSqliteFileName                     @"data.db3"

@interface UserSelectViewController : UIViewController<UIScrollViewDelegate, TapDetectingImageViewFotParentViewDelegate>
{
    IBOutlet UILabel *softwareNameLabel;
    
    IBOutlet UIButton *showCreateUserViewButton;
    IBOutlet UIButton *loginButtton;
    
    IBOutlet UIScrollView *scrollView;
	IBOutlet UIPageControl *pageControl;
	NSMutableArray *imageViews;
    IBOutlet UILabel *spotNameLabel;
    IBOutlet UILabel *scoreLabel;
    int currentPage;
    BOOL pageControlUsed;
    NSArray *titles;
    NSArray *subtitles;
    
    NSMutableArray *userstestinfo;
    NSMutableArray *usersinfo;
}

@property (nonatomic, retain) NSMutableArray *imageViews;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) UILabel *spotNameLabel;
@property (nonatomic, retain) UILabel *scoreLabel;
@property int currentPage;
@property BOOL pageControlUsed;
@property (nonatomic, retain) NSArray *titles;
@property (nonatomic, retain) NSArray *subtitles;

@property(nonatomic,retain)NSMutableArray *userstestinfo;
@property(nonatomic,retain)NSMutableArray *usersinfo;



@property(nonatomic,retain) UIButton *showCreateUserViewButton;
@property(nonatomic,retain) UIButton *loginButtton;

@property (strong, nonatomic)  UINavigationController *measureNaviController;
@property (strong, nonatomic)  UINavigationController *settingNaviController;
@property(strong,nonatomic)UINavigationController *historyNaviController;
@property(strong,nonatomic)UINavigationController *chartNaviController;

-(IBAction)showCreatUserView:(id)sender;
-(IBAction)login:(id)sender;


- (void)initScrollView;
- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;
- (void)createAllEmptyPagesForScrollView: (int) pages;

@property (strong, nonatomic) UITabBarController *tabBarController;

@end
