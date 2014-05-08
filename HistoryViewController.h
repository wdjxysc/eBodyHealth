//
//  HistoryViewController.h
//  eBodyHealth
//
//  Created by 夏 伟 on 13-8-3.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIButton  *weightButton;
    IBOutlet UIButton  *bodyFatButton;
    IBOutlet UIButton  *bloodPressButton;
    IBOutlet UIButton  *glucoseButton;
    IBOutlet UIButton  *oxygenButton;
    
    IBOutlet UITableView *myTableView;
    IBOutlet UISegmentedControl *mySegmentedControl;
    NSMutableArray *weightDatas;
    NSMutableArray *bodyFatDatas;
    NSMutableArray *bloodPressDatas;
}

@property(nonatomic,retain)UIButton *weightButton;
@property(nonatomic,retain)UIButton *bodyFatButton;
@property(nonatomic,retain)UIButton *bloodPressButton;
@property(nonatomic,retain)UIButton *glucoseButton;
@property(nonatomic,retain)UIButton *oxygenButton;

@property(nonatomic,retain)UISegmentedControl *mySegmentedControl;
@property(nonatomic,retain)UITableView *myTableView;

@property(nonatomic,retain)NSMutableArray *weightDatas;
@property(nonatomic,retain)NSMutableArray *bodyFatDatas;
@property(nonatomic,retain)NSMutableArray *bloodPressDatas;
@property(nonatomic,retain)NSString *nowDataType;


-(IBAction)dataTypeSelect:(id)sender;


-(IBAction)weightButtonPressed:(id)sender;
-(IBAction)bodyFatButtonPressed:(id)sender;
-(IBAction)bloodPressButtonPressed:(id)sender;
-(IBAction)glucoseButtonPressed:(id)sender;
-(IBAction)oxygenButtonPressed:(id)sender;

@end
