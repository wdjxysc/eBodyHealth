//
//  WeightMeasureViewController.m
//  eBodyHealth
//
//  Created by 夏 伟 on 13-8-3.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import "WeightMeasureViewController.h"
#import <sqlite3.h>
#import <stdlib.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "MySingleton.h"
#import "WQPlaySound.h"


@interface WeightMeasureViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *btImageView;

@end

@implementation WeightMeasureViewController
@synthesize measureViewController;
@synthesize weightLabel;
@synthesize unitSegmentedControl;
@synthesize testTimeLabel;

@synthesize centralManager;
@synthesize discoveredPeripheral;
@synthesize writeCharacteristic;
@synthesize notifyCharacteristic;
@synthesize targetPeripheral;
@synthesize data;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor  = [UIColor colorWithRed:233.0/255.0 green:235.0/255.0 blue:242.0/255.0 alpha:1.0];
        // Custom initialization
        self.navigationItem.title = NSLocalizedString(@"MEASURE_TYPE_WEIGHT", nil);
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:20 green:185 blue:214 alpha:1.0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Start up the CBCentralManager
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    // And somewhere to store the incoming data
    self.data = [[NSMutableData alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [centralManager stopScan];
    [self cleanup];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self scan];
}

-(void)didMoveToParentViewController:(UIViewController *)parent
{
    
}

-(IBAction)unitSelect:(id)sender
{
    if([sender selectedSegmentIndex]==0)
    {
        //trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去掉字符串中的空字符
        NSString *weightstr = weightLabel.text;
        weightstr = [weightstr stringByReplacingOccurrencesOfString:@"lb" withString:@""];
        weightstr = [weightstr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去掉字符串中的空字符
        float weight = [weightstr floatValue];
        weight = weight*0.45359;
        weightLabel.text = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%.1f kg",weight]];
    }
    else if([sender selectedSegmentIndex]==1)
    {
        NSString *weightstr = weightLabel.text;
        weightstr = [weightstr stringByReplacingOccurrencesOfString:@"kg" withString:@""];
        weightstr = [weightstr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去掉字符串中的空字符
        float weight = [weightstr floatValue];
        weight = weight/0.45359;
        weightLabel.text = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%.1f  lb",weight]];
    }
}

-(IBAction)saveData:(id)sender
{
    WQPlaySound *sound = [[WQPlaySound alloc]initForPlayingSystemSoundEffectWith:@"Tock" ofType:@"aiff"];
//    sound = [[WQPlaySound alloc]initForPlayingVibrate];
//    sound = [[WQPlaySound alloc]initForPlayingVibrate];
    sound = [[WQPlaySound alloc]initForPlayingSoundEffectWith:@"system.wav"];  
    [sound play];
    NSThread* myThread1 = [[NSThread alloc] initWithTarget:self selector:@selector(mySoundPlayer)object:nil];
    [myThread1 start];
    
    
    float weight = 0;
    if(unitSegmentedControl.selectedSegmentIndex==0)
    {
        NSString *weightstr = weightLabel.text;
        weightstr = [weightstr stringByReplacingOccurrencesOfString:@"kg" withString:@""];
        weightstr = [weightstr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去掉字符串中的空字符
        weight =  [weightstr floatValue];
    }
    else if(unitSegmentedControl.selectedSegmentIndex ==1)
    {
        NSString *weightstr = weightLabel.text;
        weightstr = [weightstr stringByReplacingOccurrencesOfString:@"lb" withString:@""];
        weightstr = [weightstr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去掉字符串中的空字符
        weight = [weightstr floatValue];
        weight = weight*0.45359;
    }
    
    
    NSDate *testTime = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *testTimestr = [dateFormatter stringFromDate:testTime];
    testTimeLabel.text = testTimestr;
    testTime = [dateFormatter dateFromString:testTimeLabel.text];
    
    
    NSString *filePath = [self dataFilePath];
    NSLog(@"filePath=%@",filePath);
    
    
    sqlite3 *database;
    
    char* errorMsg;
    if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"数据库打开失败");
    }
    
//    int userid = 1;
    NSString *username = @"";
    NSString *datestrformat = testTimeLabel.text;
    NSString *issendstr = @"N";
    NSString *sql2 = [NSString stringWithFormat:
                      @"INSERT INTO 'WEIGHTDATA' ('USERID', 'USERNAME', 'WEIGHT', 'TESTTIME', 'ISSEND') VALUES ('%d', '%@', '%f', '%@', '%@')",[MySingleton sharedSingleton].nowuserid,username, weight, datestrformat, issendstr];
    if(sqlite3_exec(database, [sql2 UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK){//备注2
        //插入数据失败，关闭数据库
        sqlite3_close(database);
        NSAssert1(0, @"插入数据失败：%@", errorMsg);
        sqlite3_free(errorMsg);
    }
    
    NSString *sqlupdate = [NSString stringWithFormat:@"UPDATE USER SET WEIGHT = %f WHERE USERID = %d",weight,[MySingleton sharedSingleton].nowuserid];
    if(sqlite3_exec(database, [sqlupdate UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK){//备注2
        //插入数据失败，关闭数据库
        sqlite3_close(database);
        //        NSAssert1(0, @"插入数据失败：%@", errorMsg);
        NSLog(@"%s",errorMsg);
        sqlite3_free(errorMsg);
    }
    
    //关闭数据库
    sqlite3_close(database);
}

-(NSString *)dataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kSqliteFileName];
}


///corebluetooth

#pragma mark - Central Methods



/** centralManagerDidUpdateState is a required protocol method.
 *  Usually, you'd check for other states to make sure the current device supports LE, is powered on, etc.
 *  In this instance, we're just using it to wait for CBCentralManagerStatePoweredOn, which indicates
 *  the Central is ready to be used.
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn) {
        // In a real app, you'd deal with all the states correctly
        return;
    }
    
    // The state must be CBCentralManagerStatePoweredOn...
    
    // ... so start scanning
    [self scan];
    
}

/** Scan for peripherals - specifically for our service's 128bit CBUUID
 */
- (void)scan
{
    [self.centralManager scanForPeripheralsWithServices:nil
                                                options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    
    NSLog(@"Scanning started");
}


/** This callback comes whenever a peripheral that is advertising the TRANSFER_SERVICE_UUID is discovered.
 *  We check the RSSI, to make sure it's close enough that we're interested in it, and if it is,
 *  we start the connection process
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    // Reject any where the value is above reasonable range
    
    //    if (RSSI.integerValue > -15) {
    //        return;
    //    }
    //
    //    // Reject if the signal strength is too low to be close enough (Close is around -22dB)
    //    if (RSSI.integerValue < -35) {
    //        return;
    //    }
    
    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
    
    for(int i = 0;i < sizeof(peripheral.services);i++)
    {
        NSLog(@"%@",peripheral.services[i]);
    }
    
    
    // Ok, it's in range - have we already seen it?
    if([peripheral.name isEqual: @"eBody-Scale"]||[peripheral.name isEqual: @"S-Power"])
    {
        if (self.discoveredPeripheral != peripheral) {
            
            // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
            self.discoveredPeripheral = peripheral;
            
            // And connect
            NSLog(@"Connecting to peripheral %@", peripheral);
            [self.centralManager connectPeripheral:peripheral options:nil];
            [_btImageView setImage:[UIImage imageNamed:@"ly"]];
        }
    }
}

/** If the connection fails for whatever reason, we need to deal with it.
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Failed to connect to %@. (%@)", peripheral, [error localizedDescription]);
    [self cleanup];
}


/** We've connected to the peripheral, now we need to discover the services and characteristics to find the 'transfer' characteristic.
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Peripheral Connected");
    
    // Stop scanning
    [self.centralManager stopScan];
    NSLog(@"Scanning stopped");
    
    // Clear the data that we may already have
    [self.data setLength:0];
    
    // Make sure we get the discovery callbacks
    peripheral.delegate = self;
    
    // Search only for services that match our UUID
    [peripheral discoverServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]];
}


/** The Transfer Service was discovered
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering services: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }
    
    int i = sizeof(peripheral.services);
    NSLog(@"共有服务%d个",i);
    // Discover the characteristic we want...
    
    // Loop through the newly filled peripheral.services array, just in case there's more than one.
    for (CBService *service in peripheral.services) {
        NSLog(@"Service found with UUID: %@",service.UUID);
        // Discovers the characteristics for a given service
        
        if ([service.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]])
        {
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:TRANSFER_NOTIFYCHARACTERISTIC_UUID]] forService:service];
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:TRANSFER_WRITECHARACTERISTIC_UUID]] forService:service];
            _lastWeightData = 0;
        }
        //[peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]] forService:service];
    }
}


/** The Transfer characteristic was discovered.
 *  Once this has been found, we want to subscribe to it, which lets the peripheral know we want the data it contains
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    // Deal with errors (if any)
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }
    
    CBCharacteristic *readcharacteristic;
    
    // Again, we loop through the array, just in case.
    for (CBCharacteristic *characteristic in service.characteristics) {
        
        NSLog(@"特征:%@",characteristic.UUID);
        // And check if it's the right one
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_NOTIFYCHARACTERISTIC_UUID]]) {
            
            // If it is, subscribe to it
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            
            readcharacteristic = characteristic;
            notifyCharacteristic = characteristic;
            
        }
        else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_WRITECHARACTERISTIC_UUID]])
        {
            Byte getData[] = {0xfd,0x29};
            NSData *testData = [[NSData alloc]initWithBytes:getData length:sizeof(getData)];
            [peripheral writeValue:testData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
            NSLog(@"write value 0x02,0x20,0xdd,0x02,0xfd,0x29,0xd4");
            writeCharacteristic = characteristic;
            //            [peripheral readValueForCharacteristic:characteristic];
            //            NSData *revData = characteristic.value;
            //            Byte *revbyte = (Byte *)[revData bytes];
            //            int size = sizeof(revbyte);
            //            NSLog(@"revData Length:%d",size);
            //            for(int i = 0; i<sizeof(revbyte);i++)
            //            {
            //                NSLog(@"revdata:%d",revbyte[i]);
            //            }
        }
    }
    
    //[peripheral readValueForCharacteristic:readcharacteristic];
    //NSLog(@"readcharacteristic.UUID:%@",readcharacteristic.UUID);
    // Once this is complete, we just need to wait for the data to come in.
}


/** This callback lets us know more data has arrived via notification on the characteristic
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    
    self.targetPeripheral = peripheral;
    
    NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    
    NSData *lol = characteristic.value;
    Byte *byte = (Byte *)[lol bytes];
    for(int i = 0;i<sizeof(byte);i++)
    {
        NSLog(@"收到字节：%d",byte[i]);
        
    }
    
    if(byte[0] == 0xff)
    {
        Byte weightHigh = 0;
        if(byte[1]>=0xc0)
        {
            weightHigh = byte[1] - 0xc0;
        }
        else if(byte[1] >= 0x80)
        {
            weightHigh = byte[1] - 0x80;
        }
        else if(byte[1]>= 0x40)
        {
            weightHigh = byte[1] - 0x40;
        }
        
        float weightdata = (float)(weightHigh * 256 + byte[2])/10;
        
        if(weightdata != _lastWeightData)
        {
            _lastWeightData = weightdata;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Notice" message:@"Do you want save this data?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alert show];
            NSThread* myThread1 = [[NSThread alloc] initWithTarget:self selector:@selector(mySoundPlayer)object:nil];
            [myThread1 start];
            
        }
        
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *testTime = [dateFormatter stringFromDate:date];
        testTimeLabel.text = testTime;
        
        if(unitSegmentedControl.selectedSegmentIndex==0)
        {
            NSString *strData = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%.1f kg",weightdata]];
            weightLabel.text = strData;
        }
        else if(unitSegmentedControl.selectedSegmentIndex==1)
        {
            weightdata = weightdata/0.45359;
            NSString *strData = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%.1f lb",weightdata]];
            
            weightLabel.text = strData;
        }
    }
    else
    {
        _lastWeightData = 0;
        
        Byte weightHigh = 0;
        if(byte[1]>=0xc0)
        {
            weightHigh = byte[1] - 0xc0;
        }
        else if(byte[1] >= 0x80)
        {
            weightHigh = byte[1] - 0x80;
        }
        else if(byte[1]>= 0x40)
        {
            weightHigh = byte[1] - 0x40;
        }
        
        float weightdata = (float)(weightHigh * 256 + byte[2])/10;
        if(unitSegmentedControl.selectedSegmentIndex==0)
        {
            NSString *strData = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%.1f kg",weightdata]];
            weightLabel.text = strData;
        }
        else if(unitSegmentedControl.selectedSegmentIndex==1)
        {
            weightdata = weightdata/0.45359;
            NSString *strData = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%.1f lb",weightdata]];
            
            weightLabel.text = strData;
        }
    }
    
    Byte getData[] = {0xfd,0x30};
    NSData *testData = [[NSData alloc]initWithBytes:getData length:sizeof(getData)];
    if(writeCharacteristic != nil){
        [self.targetPeripheral writeValue:testData forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithResponse];
        NSLog(@"write value 0x02,0x20,0xdd,0x02,0xfd,0x30,0xd4");
    }
    
    NSThread* myThread = [[NSThread alloc] initWithTarget:self selector:@selector(myThreadMainMethod)object:nil];
    [myThread start];
    
    
    
    // Have we got everything we need?
    if ([stringFromData isEqualToString:@"EOM"]) {
        
        // We have, so show the data,
        //[self.textview setText:[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding]];
        
        // Cancel our subscription to the characteristic
        [peripheral setNotifyValue:NO forCharacteristic:characteristic];
        
        // and disconnect from the peripehral
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
    
    // Otherwise, just add the data on to what we already have
    [self.data appendData:characteristic.value];
    
    // Log it
    NSLog(@"Received: %@", stringFromData);
}



/** The peripheral letting us know whether our subscribe/unsubscribe happened or not
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    
    // Exit if it's not the transfer characteristic
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_NOTIFYCHARACTERISTIC_UUID]]) {
        return;
    }
    
    // Notification has started
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
    }
    
    // Notification has stopped
    else {
        // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
}

/** Once the disconnection happens, we need to clean up our local copy of the peripheral
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Peripheral Disconnected");
    self.discoveredPeripheral = nil;
    _btImageView.image = [UIImage imageNamed:@"ly0"];
    // We're disconnected, so start scanning again
    [self scan];
}


/** Call this when things either go wrong, or you're done with the connection.
 *  This cancels any subscriptions if there are any, or straight disconnects if not.
 *  (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
 */
- (void)cleanup
{
    // Don't do anything if we're not connected
    if (!self.discoveredPeripheral.isConnected) {
        return;
    }
    
    // See if we are subscribed to a characteristic on the peripheral
    if (self.discoveredPeripheral.services != nil) {
        for (CBService *service in self.discoveredPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_NOTIFYCHARACTERISTIC_UUID]]) {
                        if (characteristic.isNotifying) {
                            // It is notifying, so unsubscribe
                            [self.discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                            
                            // And we're done.
                            return;
                        }
                    }
                }
            }
        }
    }
    
    // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
    [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
}

-(void)myThreadMainMethod
{
    //    weightLabel.text = @"adsdasd";
    //    for(int i = 0;i<100;i++){
    //        sleep(2);
    //        Byte getData[] = {0xfd,0x29};
    //        NSData *testData = [[NSData alloc]initWithBytes:getData length:sizeof(getData)];
    //        [self.targetPeripheral writeValue:testData forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithResponse];
    //        NSLog(@"write value 0x02,0x20,0xdd,0x02,0xfd,0x29,0xd4");
    //    }
    
    
}

-(void)mySoundPlayer
{
    WQPlaySound *sound = sound = [[WQPlaySound alloc]initForPlayingSoundEffectWith:NSLocalizedString(@"NOVA_GOTIT", nil)];
    
    [sound play];
    sleep(2);
}

@end
