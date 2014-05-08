//
//  BodyFatMeasureViewController.h
//  eBodyHealth
//
//  Created by 夏 伟 on 13-8-6.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import <stdlib.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "MySingleton.h"


@interface BodyFatMeasureViewController : UIViewController<CBCentralManagerDelegate,
CBPeripheralDelegate,UIAlertViewDelegate>
{
    IBOutlet UIImageView *bodyFatImageView;
    IBOutlet UIImageView *bluetoothImageView;
    
    IBOutlet UILabel *weightLabel;
    IBOutlet UILabel *bmiLabel;
    IBOutlet UILabel *fatLabel;
    IBOutlet UILabel *waterLabel;
    IBOutlet UILabel *muscleLabel;
    IBOutlet UILabel *boneLabel;
    IBOutlet UILabel *visceralFatLabel;
    IBOutlet UILabel *bmrLabel;
    
    IBOutlet UILabel *weightDataLabel;
    IBOutlet UILabel *bmiDataLabel;
    IBOutlet UILabel *fatDataLabel;
    IBOutlet UILabel *waterDataLabel;
    IBOutlet UILabel *muscleDataLabel;
    IBOutlet UILabel *boneDataLabel;
    IBOutlet UILabel *visceralFatDataLabel;
    IBOutlet UILabel *bmrDataLabel;
    
    IBOutlet UISegmentedControl *unitSegmentedControl;
}
@property(nonatomic,retain)UIImageView  *bodyFatImageView;
@property(nonatomic,retain)UIImageView  *bluetoothImageView;

@property(nonatomic,retain)UILabel  *weightLabel;
@property(nonatomic,retain)UILabel  *fatLabel;
@property(nonatomic,retain)UILabel  *muscleLabel;
@property(nonatomic,retain)UILabel  *waterLabel;
@property(nonatomic,retain)UILabel  *boneLabel;
@property(nonatomic,retain)UILabel  *visceralFatLabel;
@property(nonatomic,retain)UILabel  *bmrLabel;
@property(nonatomic,retain)UILabel  *bmiLabel;

@property(nonatomic,retain)UILabel  *weightDataLabel;
@property(nonatomic,retain)UILabel  *fatDataLabel;
@property(nonatomic,retain)UILabel  *muscleDataLabel;
@property(nonatomic,retain)UILabel  *waterDataLabel;
@property(nonatomic,retain)UILabel  *boneDataLabel;
@property(nonatomic,retain)UILabel  *visceralFatDataLabel;
@property(nonatomic,retain)UILabel  *bmrDataLabel;
@property(nonatomic,retain)UILabel  *bmiDataLabel;

@property(nonatomic,retain)UISegmentedControl  *unitSegmentedControl;

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral     *discoveredPeripheral;
@property (strong, nonatomic) CBCharacteristic *writeCharacteristic;
@property (strong, nonatomic) CBCharacteristic *notifyCharacteristic;
@property (strong, nonatomic) CBPeripheral     *targetPeripheral;
@property (nonatomic, strong) NSMutableData    *data;

@property (nonatomic) double lastweight;
@property (nonatomic) double lastfat;
@property (nonatomic) double lastvisfat;
@property (nonatomic) double lastmuscle;
@property (nonatomic) double lastwater;
@property (nonatomic) double lastbmi;
@property (nonatomic) double lastbmr;
@property (nonatomic) double lastbone;
@property (nonatomic) double lastheight;

-(IBAction)saveButtonPressed:(id)sender;
-(IBAction)unitSelect:(id)sender;

@end
