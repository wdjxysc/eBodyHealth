//
//  BloodPressMeasureViewController.m
//  eBodyHealth
//
//  Created by 夏 伟 on 13-8-6.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import "BloodPressMeasureViewController.h"

@interface BloodPressMeasureViewController ()

@end

@implementation BloodPressMeasureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor  = [UIColor colorWithRed:233.0/255.0
                                                     green:235.0/255.0
                                                      blue:242.0/255.0
                                                     alpha:1.0];
        // Custom initialization
        self.navigationItem.title = NSLocalizedString(@"MEASURE_TYPE_BLOODPRESSURE", nil);
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:20.0/255.0
                                                                            green:185.0/255.0
                                                                             blue:214.0/255.0
                                                                            alpha:1.0]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sysLabel.text = NSLocalizedString(@"USER_SYS", nil);
    diaLabel.text = NSLocalizedString(@"USER_DIA", nil);
    pulseLabel.text = NSLocalizedString(@"USER_PULSE", nil);
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
