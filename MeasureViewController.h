//
//  MeasureViewController.h
//  eBodyHealth
//
//  Created by 夏 伟 on 13-8-3.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserSelectViewController.h"
@class WeightMeasureViewController;
@class ChooseMeasureViewController;
@class BloodPressMeasureViewController;

@interface MeasureViewController : UIViewController<UINavigationBarDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIButton *weightButton;
    IBOutlet UIButton *bloodPressureButton;
    IBOutlet UIButton *bodyFatButton;
    IBOutlet UIButton *oxygenButton;
    IBOutlet UIButton *glucoseButton;
    
    IBOutlet UILabel *weightLabel;
    IBOutlet UILabel *bloodPressureLabel;
    IBOutlet UILabel *bodyFatLabel;
    IBOutlet UILabel *oxygenLabel;
    IBOutlet UILabel *glucoseLabel;
}

@property(nonatomic,strong) UserSelectViewController *userSelectViewController;
@property(nonatomic,strong)WeightMeasureViewController *weightMeasureViewController;
@property(nonatomic,strong)ChooseMeasureViewController *chooseMeasureViewController;
@property(nonatomic,strong)BloodPressMeasureViewController *bloodPressMeasureViewController;
-(IBAction)showLoginView:(id)sender;

-(IBAction)showWeightMeasureView:(id)sender;
-(IBAction)showBloodPressMeasureView:(id)sender;
-(IBAction)showOxygenMeasureView:(id)sender;
-(IBAction)showGlucoseMeasureView:(id)sender;
-(IBAction)showBodyFatMeasureView:(id)sender;

@property(nonatomic,strong)UIButton *weightButton;
@property(nonatomic,strong)UIButton *bloodPressureButton;
@property(nonatomic,strong)UIButton *bodyFatButton;
@property(nonatomic,strong)UIButton *oxygenButton;
@property(nonatomic,strong)UIButton *glucoseButton;
@end
