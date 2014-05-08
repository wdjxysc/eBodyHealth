//
//  MeasureViewController.m
//  eBodyHealth
//
//  Created by 夏 伟 on 13-8-3.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import "MeasureViewController.h"
#import "ChooseMeasureViewController.h"
#import "WeightMeasureViewController.h"
#import "BloodPressMeasureViewController.h"
#import "BodyFatMeasureViewController.h"
#import "GlucoseMeasureViewController.h"
#import "OxygenMeasureViewController.h"

@interface MeasureViewController ()

@end

@implementation MeasureViewController
@synthesize weightButton;
@synthesize bloodPressureButton;
@synthesize bodyFatButton;
@synthesize oxygenButton;
@synthesize glucoseButton;
@synthesize userSelectViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor  = [UIColor colorWithRed:233.0/255.0 green:235.0/255.0 blue:242.0/255.0 alpha:1.0];
//        self.tabBarController.tabBar.backgroundImage = [UIImage imageNamed:@"04_05"];
        self.tabBarItem.image = [UIImage imageNamed:@"Measure"];
        self.tabBarItem.title = NSLocalizedString(@"MEASURE", nil);
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"BACK", nil)
                                                                                style:UIBarButtonItemStyleBordered
                                                                               target:self
                                                                               action:@selector(showLoginView:)];
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:20.0/255.0 green:185.0/255.0 blue:214.0/255.0 alpha:1.0]];
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:<#(NSString *)#> style:UIBarButtonItemStyleBordered target:<#(id)#> action:<#(SEL)#>]
//        [self.navigationItem.leftBarButtonItem setBackgroundImage:[UIImage imageNamed:@"History"] forState:UIControlStateNormal style:UIBarButtonItemStyleBordered barMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"S"] forBarMetrics:UIBarMetricsDefault];
        
        [self.weightButton setBackgroundImage:[UIImage imageNamed:@"Weight_03"] forState:UIControlStateHighlighted];
        [self.bloodPressureButton setBackgroundImage:[UIImage imageNamed:@"Blood pressure_03"] forState:UIControlStateHighlighted];
        [self.bodyFatButton setBackgroundImage:[UIImage imageNamed:@"Body Fat_03"] forState:UIControlStateHighlighted];
        
        [self.oxygenButton setBackgroundImage:[UIImage imageNamed:@"Oxygen_03"] forState:UIControlStateHighlighted];
        [self.glucoseButton setBackgroundImage:[UIImage imageNamed:@"Blood sugar_03"] forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.title = NSLocalizedString(@"MEASURE", nil);
    self.navigationItem.title = NSLocalizedString(@"MEASURE", nil);
    weightLabel.text = NSLocalizedString(@"USER_WEIGHT", nil);
    bloodPressureLabel.text = NSLocalizedString(@"MEASURE_TYPE_BLOODPRESSURE", nil);
    bodyFatLabel.text = NSLocalizedString(@"MEASURE_TYPE_BODYFAT", nil);
    oxygenLabel.text = NSLocalizedString(@"MEASURE_TYPE_OXYGEN", nil);
    glucoseLabel.text = NSLocalizedString(@"MEASURE_TYPE_GLUCOSE", nil);
    
//    ChooseMeasureViewController *chooseController = [[ChooseMeasureViewController alloc]initWithNibName:@"ChooseMeasureViewController" bundle:nil];
//    self.chooseMeasureViewController = chooseController;
//    [self.view insertSubview:chooseMeasureViewController.view atIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showLoginView:(id)sender
{
    if(userSelectViewController == nil){
        userSelectViewController = [[UserSelectViewController alloc]initWithNibName:@"UserSelectViewController" bundle:nil];
        //NSLog(@"infoViewController is nil");
    }else{
        //NSLog(@"infoViewController is not nil");
    }
    
    //userSelectViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //userSelectViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //userSelectViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //userSelectViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    userSelectViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    
    //[self presentModalViewController:infoViewController animated:YES];//备注1
    [self presentViewController:userSelectViewController animated:YES completion:^{//备注2
        NSLog(@"show InfoView!");
    }];
    
    //presentedViewController
    NSLog(@"self.presentedViewController=%@",self.presentedViewController);//备注3
}

-(IBAction)showWeightMeasureView:(id)sender
{
    WeightMeasureViewController *weightMeasureViewController = [[WeightMeasureViewController alloc]initWithNibName:@"WeightMeasureViewController" bundle:nil];
    
    [self.navigationController pushViewController:weightMeasureViewController animated:YES];
}

-(IBAction)showBloodPressMeasureView:(id)sender
{
    BloodPressMeasureViewController *bloodPressMeasureViewController = [[BloodPressMeasureViewController alloc]initWithNibName:@"BloodPressMeasureViewController" bundle:nil];
    
    [self.navigationController pushViewController:bloodPressMeasureViewController animated:YES];
}

-(IBAction)showBodyFatMeasureView:(id)sender
{
    BodyFatMeasureViewController *bodyFatMeasureViewController = [[BodyFatMeasureViewController alloc]initWithNibName:@"BodyFatMeasureViewController" bundle:nil];
    
    [self.navigationController pushViewController:bodyFatMeasureViewController animated:YES];
}

-(IBAction)showGlucoseMeasureView:(id)sender
{
    GlucoseMeasureViewController *glucoseMeasureViewController = [[GlucoseMeasureViewController alloc]initWithNibName:@"GlucoseMeasureViewController" bundle:nil];
    
    [self.navigationController pushViewController:glucoseMeasureViewController animated:YES];
}

-(IBAction)showOxygenMeasureView:(id)sender
{
    OxygenMeasureViewController *oxygenMeasureViewController = [[OxygenMeasureViewController alloc]initWithNibName:@"OxygenMeasureViewController" bundle:nil];
    
    [self.navigationController pushViewController:oxygenMeasureViewController animated:YES];
}



@end
