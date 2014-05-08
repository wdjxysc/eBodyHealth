//
//  WeightMeasureViewController.h
//  eBodyHealth
//
//  Created by 夏 伟 on 13-8-3.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeasureViewController.h"
#import <sqlite3.h>
#import <CoreBluetooth/CoreBluetooth.h>
@class MeasureViewController;

#define kSqliteFileName                     @"data.db3"
#define TRANSFER_SERVICE_UUID               @"fff0"
#define TRANSFER_NOTIFYCHARACTERISTIC_UUID  @"fff4"
#define TRANSFER_WRITECHARACTERISTIC_UUID   @"fff3"

@interface WeightMeasureViewController : UIViewController<CBCentralManagerDelegate,
CBPeripheralDelegate>
{
    IBOutlet UILabel *weightLabel;
    IBOutlet UISegmentedControl *unitSegmentedControl;
    IBOutlet UILabel *testTimeLabel;
}

@property(nonatomic,retain)MeasureViewController *measureViewController;
@property(nonatomic,retain)UILabel *weightLabel;
@property(nonatomic,retain)UILabel *testTimeLabel;
@property(nonatomic,retain)UISegmentedControl *unitSegmentedControl;

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral     *discoveredPeripheral;
@property (strong, nonatomic) CBCharacteristic *writeCharacteristic;
@property (strong, nonatomic) CBCharacteristic *notifyCharacteristic;
@property (strong, nonatomic) CBPeripheral     *targetPeripheral;
@property (nonatomic, strong) NSMutableData    *data;

@property float lastWeightData;

-(IBAction)unitSelect:(id)sender;

@end
