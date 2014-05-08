//
//  GlucoseMeasureViewController.m
//  eBodyHealth
//
//  Created by 夏 伟 on 13-8-6.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import "GlucoseMeasureViewController.h"

@interface GlucoseMeasureViewController ()

@end

@implementation GlucoseMeasureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor  = [UIColor colorWithRed:233.0/255.0 green:235.0/255.0 blue:242.0/255.0 alpha:1.0];
        // Custom initialization
        self.navigationItem.title = NSLocalizedString(@"MEASURE_TYPE_GLUCOSE", nil);
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

@end
