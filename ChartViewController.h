//
//  ChartViewController.h
//  eBodyHealth
//
//  Created by 夏 伟 on 13-8-3.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface ChartViewController : UIViewController<CPTPlotDataSource, CPTAxisDelegate>
{
    CPTXYGraph                  *graph;             //画板
    CPTScatterPlot              *dataSourceLinePlot;//线
    NSMutableArray              *dataForPlot1;      //坐标数组
    NSTimer                     *timer1;            //定时器
    int                         j;
    int                         r;
    IBOutlet UIView *myview;
    
    NSMutableArray *bodyfatdata;
    NSMutableArray *weightdata;
    
    NSString *nowdevice;
    
    IBOutlet UIButton * weightDeviceButton;
    IBOutlet UIButton * bodyfatDeviceButton;
    IBOutlet UIButton * bloodpressureDeviceButton;
    IBOutlet UIButton * glucoseDeviceButton;
    IBOutlet UIButton * oxygenDeviceButton;
    
    IBOutlet UIButton *weightButton;
    IBOutlet UIButton *fatButton;
    IBOutlet UIButton *visfatButton;
    IBOutlet UIButton *waterButton;
    IBOutlet UIButton *muscleButton;
    IBOutlet UIButton *boneButton;
    IBOutlet UIButton *bmiButton;
    IBOutlet UIButton *bmrButton;
    IBOutlet UIButton *sysButton;
    IBOutlet UIButton *diaButton;
    IBOutlet UIButton *pulseButton;
    IBOutlet UIButton *glucoseButton;
    IBOutlet UIButton *oxygenButton;
    IBOutlet UIButton *oxygenpulseButton;
}

@property (retain, nonatomic) NSMutableArray *dataForPlot1;
@property (retain, nonatomic) UIView *myview;
@property (retain, nonatomic) NSMutableArray *bodyfatdata;
@property (retain, nonatomic) NSMutableArray *weightdata;

@property (retain,nonatomic)NSString *nowdevice;

-(IBAction)weightbuttonPress:(id)sender;
-(IBAction)fatbuttonPress:(id)sender;
-(IBAction)visfatbuttonPress:(id)sender;
-(IBAction)waterbuttonPress:(id)sender;
-(IBAction)musclebuttonPress:(id)sender;
-(IBAction)bonebuttonPress:(id)sender;
-(IBAction)bmibuttonPress:(id)sender;
-(IBAction)bmrbuttonPress:(id)sender;

-(IBAction)weightDeviceButtonPressed:(id)sender;
-(IBAction)bodyfatDeviceButtonPressed:(id)sender;
-(IBAction)bloodpressureDeviceButtonPressed:(id)sender;
-(IBAction)glucoseDeviceButtonPressed:(id)sender;
-(IBAction)oxygenDeviceButtonPressed:(id)sender;
@end
