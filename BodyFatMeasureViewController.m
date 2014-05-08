//
//  BodyFatMeasureViewController.m
//  eBodyHealth
//
//  Created by 夏 伟 on 13-8-6.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import "BodyFatMeasureViewController.h"
#import <sqlite3.h>
#import <stdlib.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "MySingleton.h"
#import "WeightMeasureViewController.h"
#import "WQPlaySound.h"


@interface BodyFatMeasureViewController ()

@end

@implementation BodyFatMeasureViewController

@synthesize bluetoothImageView;
@synthesize bmiDataLabel;
@synthesize bmrDataLabel;
@synthesize boneDataLabel;
@synthesize weightDataLabel;
@synthesize fatDataLabel;
@synthesize muscleDataLabel;
@synthesize visceralFatDataLabel;
@synthesize waterDataLabel;

@synthesize weightLabel;
@synthesize fatLabel;
@synthesize muscleLabel;
@synthesize waterLabel;
@synthesize boneLabel;
@synthesize bmrLabel;
@synthesize bmiLabel;
@synthesize visceralFatLabel;

@synthesize centralManager;
@synthesize discoveredPeripheral;
@synthesize writeCharacteristic;
@synthesize notifyCharacteristic;
@synthesize targetPeripheral;
@synthesize data;

@synthesize lastwater;
@synthesize lastweight;
@synthesize lastbmi;
@synthesize lastbmr;
@synthesize lastbone;
@synthesize lastfat;
@synthesize lastheight;
@synthesize lastmuscle;
@synthesize lastvisfat;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.view.backgroundColor  = [UIColor colorWithRed:233.0/255.0 green:235.0/255.0 blue:242.0/255.0 alpha:1.0];
        // Custom initialization
        self.navigationItem.title = NSLocalizedString(@"MEASURE_TYPE_BODYFAT", nil);
        weightLabel.text = NSLocalizedString(@"USER_WEIGHT", nil);
        fatLabel.text = NSLocalizedString(@"USER_FAT", nil);
        muscleLabel.text = NSLocalizedString(@"USER_MUSCLE", nil);
        waterLabel.text = NSLocalizedString(@"USER_WATER", nil);
        visceralFatLabel.text = NSLocalizedString(@"USER_VISFAT", nil);
        boneLabel.text = NSLocalizedString(@"USER_BONE", nil);
        bmiLabel.text = NSLocalizedString(@"USER_BMI", nil);
        bmrLabel.text = NSLocalizedString(@"USER_BMR", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    weightLabel.text = NSLocalizedString(@"USER_WEIGHT", nil);
    fatLabel.text = NSLocalizedString(@"USER_FAT", nil);
    muscleLabel.text = NSLocalizedString(@"USER_MUSCLE", nil);
    waterLabel.text = NSLocalizedString(@"USER_WATER", nil);
    visceralFatLabel.text = NSLocalizedString(@"USER_VISFAT", nil);
    boneLabel.text = NSLocalizedString(@"USER_BONE", nil);
    bmiLabel.text = NSLocalizedString(@"USER_BMI", nil);
    bmrLabel.text = NSLocalizedString(@"USER_BMR", nil);
    // Do any additional setup after loading the view from its nib.
    
    // Start up the CBCentralManager
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    // And somewhere to store the incoming data
    self.data = [[NSMutableData alloc] init];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.centralManager stopScan];
    [self cleanup];
}

-(void)viewWillAppear:(BOOL)animated
{
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

-(IBAction)unitSelect:(id)sender
{
    if([sender selectedSegmentIndex]==0)
    {
        //trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去掉字符串中的空字符
        NSString *weightstr = weightDataLabel.text;
        weightstr = [weightstr stringByReplacingOccurrencesOfString:@"lb" withString:@""];
        weightstr = [weightstr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去掉字符串中的空字符
        float weight = [weightstr floatValue];
        weight = weight*0.45359;
        weightDataLabel.text = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%.1f kg",weight]];
        
        NSString *bonestr = boneDataLabel.text;
        bonestr = [bonestr stringByReplacingOccurrencesOfString:@"lb" withString:@""];
        bonestr = [bonestr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去掉字符串中的空字符
        float bone = [bonestr floatValue];
        bone = bone*0.45359;
        boneDataLabel.text = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%.1f kg",bone]];
    }
    else if([sender selectedSegmentIndex]==1)
    {
        NSString *weightstr = weightDataLabel.text;
        weightstr = [weightstr stringByReplacingOccurrencesOfString:@"kg" withString:@""];
        weightstr = [weightstr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去掉字符串中的空字符
        float weight = [weightstr floatValue];
        weight = weight/0.45359;
        weightDataLabel.text = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%.1f lb",weight]];
        
        NSString *bonestr = boneDataLabel.text;
        bonestr = [bonestr stringByReplacingOccurrencesOfString:@"kg" withString:@""];
        bonestr = [bonestr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去掉字符串中的空字符
        float bone = [bonestr floatValue];
        bone = bone/0.45359;
        boneDataLabel.text = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%.1f lb",bone]];
    }
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Yes"])
    {
        NSLog(@"User pressed the Yes button.");
        int i = [self saveFatData];
    }
    else if ([buttonTitle isEqualToString:@"No"])
    {
        NSLog(@"User pressed the No button.");
    }
}

-(IBAction)saveButtonPressed:(id)sender
{
    [self saveFatData];
}

-(int)saveFatData
{
    int result = 0;
    
    double userid = [MySingleton sharedSingleton].nowuserid;
    NSString *username = [[MySingleton sharedSingleton].nowuserinfo objectForKey:@"Name"];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
    NSDate *brithdate =[dateFormat dateFromString:[[NSString alloc]initWithFormat:@"%@",[[MySingleton sharedSingleton].nowuserinfo objectForKey:@"Brithday"]]];
    double age = [self GetAgeByBrithday:brithdate];
    NSString *sex = [[MySingleton sharedSingleton].nowuserinfo objectForKey:@"Sex"];
    NSString *sportlvl = [[MySingleton sharedSingleton].nowuserinfo objectForKey:@"Sportlvl"];
    double height = self.lastheight;
    double weight = self.lastweight;
    double fat = self.lastfat;
    double visceralfat = self.lastvisfat;
    double water = self.lastwater;
    double bone = self.lastbone;
    double muscle = self.lastmuscle;
    double bmr = self.lastbmr;
    double bmi = self.lastbmi;
    double version = 1.0;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *issendstr = @"N";
    
    NSString *filePath = [self dataFilePath];
    NSLog(@"filePath=%@",filePath);
    
    sqlite3 *database;
    char* errorMsg;
    if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"数据库打开失败");
    }
    
    NSString *sql2 = [NSString stringWithFormat:
                      @"INSERT INTO 'BODYFATDATA' ('USERID', 'USERNAME', 'AGE', 'SEX', 'SPORTLVL', 'HEIGHT', 'WEIGHT', 'BODYFAT', 'VISCERALFAT', 'WATER', 'BONE', 'MUSCLE', 'BMR', 'BMI', 'TESTTIME', 'VERSION', 'ISSEND') VALUES ('%f', '%@', '%f', '%@', '%@', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%f', '%@', '%f', '%@')",userid,username, age, sex, sportlvl, height, weight, fat, visceralfat, water, bone, muscle, bmr, bmi, strDate, version, issendstr];
    if(sqlite3_exec(database, [sql2 UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK){//备注2
        //插入数据失败，关闭数据库
        sqlite3_close(database);
        NSAssert1(0, @"插入数据失败：%@", errorMsg);
        NSLog(@"%s",errorMsg);
        sqlite3_free(errorMsg);
        result = -1;
    }
    
    //关闭数据库
    sqlite3_close(database);
    
    return result;
}

-(NSString *)dataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //return [documentsDirectory stringByAppendingPathComponent:kFileName];
    return [documentsDirectory stringByAppendingPathComponent:kSqliteFileName];
}

-(int)GetAgeByBrithday:(NSDate *)brithday
{
    int age = 0;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *brithdaycomps = [[NSDateComponents alloc] init];
    NSDateComponents *nowcomps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//这句我也不明白具体时用来做什么。。。
    brithdaycomps = [calendar components:unitFlags fromDate:brithday];
    nowcomps = [calendar components:unitFlags fromDate:NSDate.date];
    //    long brithdayweekNumber = [brithdaycomps weekday]; //获取星期对应的长整形字符串
    long brithdayday=[brithdaycomps day];//获取日期对应的长整形字符串
    long brithdayyear=[brithdaycomps year];//获取年对应的长整形字符串
    long brithdaymonth=[brithdaycomps month];//获取月对应的长整形字符串
    //    long brithdayhour=[brithdaycomps hour];//获取小时对应的长整形字符串
    //    long brithdayminute=[brithdaycomps minute];//获取月对应的长整形字符串
    //    long brithdaysecond=[brithdaycomps second];//获取秒对应的长整形字符串
    //    long nowweekNumber = [nowcomps weekday]; //获取星期对应的长整形字符串
    long nowday=[nowcomps day];//获取日期对应的长整形字符串
    long nowyear=[nowcomps year];//获取年对应的长整形字符串
    long nowmonth=[nowcomps month];//获取月对应的长整形字符串
    //    long nowhour=[nowcomps hour];//获取小时对应的长整形字符串
    //    long nowminute=[nowcomps minute];//获取月对应的长整形字符串
    //    long nowsecond=[nowcomps second];//获取秒对应的长整形字符串
    
    if(nowyear>brithdayyear)
    {
        if(nowmonth>brithdaymonth)
        {
            age = nowyear - brithdayyear;
        }
        else if(nowmonth == brithdaymonth)
        {
            if(nowday>=brithdayday)
            {
                age = nowyear - brithdayyear;
            }
            else
            {
                age = nowyear - brithdayyear - 1;
            }
        }
        else
        {
            age = nowyear - brithdayyear - 1;
        }
        
    }
    else
    {
        age = 0;
    }
    return age;
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
    if([peripheral.name isEqual: @"eBody-Scale"]||[peripheral.name isEqual: @"S-Power"]||[peripheral.name isEqual: @"eBody-Fat"]||[peripheral.name isEqual:@"eBody-Fat-Analyzer"]||[peripheral.name isEqual: @"eBody-Fat-Scale"])
    {
        if (self.discoveredPeripheral != peripheral) {
            
            // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
            self.discoveredPeripheral = peripheral;
            
            // And connect
            NSLog(@"Connecting to peripheral %@", peripheral);
            [self.centralManager connectPeripheral:peripheral options:nil];
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
    
    self.bluetoothImageView.image = [UIImage imageNamed:@"ly"];
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
//        [self cleanup];
//        return;
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
            //TRANSFER_WRITECHARACTERISTIC_UUID
        }
        else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_WRITECHARACTERISTIC_UUID]])
        {
            Byte weighthigh,weightlow,sportlvl,genderage,height;
            NSString *weightstr = [[MySingleton sharedSingleton].nowuserinfo objectForKey:@"Weight"];
            double weight = [weightstr doubleValue];
            weighthigh = ((int)(weight*10))/256;
            weightlow = ((int)(weight*10))%256;
            weighthigh += 64;
            NSString *sportlvlstr = [[MySingleton sharedSingleton].nowuserinfo objectForKey:@"Sportlvl"];
            sportlvl = 0;
            sportlvl += 64;
            if([sportlvlstr isEqualToString:@""]||sportlvlstr == nil)
            {
                sportlvl = 0;
            }
            else
            {
                sportlvl = ([sportlvlstr intValue] - 1 )*16 + 1;
            }
            
            NSString *sexstr = [[MySingleton sharedSingleton].nowuserinfo objectForKey:@"Sex"];
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
            [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
            NSDate *brithdate =[dateFormat dateFromString:[[NSString alloc]initWithFormat:@"%@",[[MySingleton sharedSingleton].nowuserinfo objectForKey:@"Brithday"]]];
            Byte age = [self GetAgeByBrithday:brithdate];
            if([sexstr isEqualToString:@"0"])
            {
                genderage =  age + 0x80;
            }
            else
            {
                genderage = age;
            }
            
            height = [[[MySingleton sharedSingleton].nowuserinfo objectForKey:@"Height"] intValue];
            
            sleep(3);
            Byte setUserInfo[] = {0xfd,0x53,weighthigh,weightlow,sportlvl,genderage,height};
            NSData *testData = [[NSData alloc]initWithBytes:setUserInfo length:sizeof(setUserInfo)];
            [peripheral writeValue:testData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
            NSLog(@"write value %@ ---- 0x02,0x20,0xdd,0x02,0xfd,0x29,0xd4",[CBUUID UUIDWithString:TRANSFER_NOTIFYCHARACTERISTIC_UUID]);
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
    Byte *revdata = (Byte *)[lol bytes];
    for(int i = 0;i<[lol length];i++)
    {
        NSLog(@"收到字节：%d",revdata[i]);
    }
    
    
    
    if(revdata[0] == 0xff && [lol length]==20)
    {
        Byte weightHigh = revdata[1] & 0x3f;
        float weightdata = (float)(weightHigh * 256 + revdata[2])/10.0;
        double heightdata = revdata[10]/100.0;
        double fatdata = ((revdata[12]>>4) * 256 + revdata[11])/10.0;
        double waterdata = ((revdata[12] & 0x0f) * 256 + revdata[13])/10.0;
        double muscledata = (revdata[14]*256 + revdata[15])/10.0;
        double bonedata = revdata[16]/10.0;
        int visfatdata = revdata[17];
        int bmrdata = revdata[18]*256 + revdata[19];
        double bmidata = weightdata /(heightdata*heightdata);
        
        fatDataLabel.text = [[NSString alloc]initWithFormat:@"%.1f %%",fatdata];
        waterDataLabel.text = [[NSString alloc]initWithFormat:@"%.1f %%",waterdata];
        muscleDataLabel.text = [[NSString alloc]initWithFormat:@"%.1f %%",muscledata];
        boneDataLabel.text = [[NSString alloc]initWithFormat:@"%.1f kg",bonedata];
        visceralFatDataLabel.text = [[NSString alloc]initWithFormat:@"%d",visfatdata];
        bmrDataLabel.text = [[NSString alloc]initWithFormat:@"%d kcal",bmrdata];
        bmiDataLabel.text = [[NSString alloc]initWithFormat:@"%.1f",bmidata];
        
        
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *testTime = [dateFormatter stringFromDate:date];
        
        if(unitSegmentedControl.selectedSegmentIndex==0)
        {
            NSString *strData = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%.1f kg",weightdata]];
            weightDataLabel.text = strData;
        }
        else if(unitSegmentedControl.selectedSegmentIndex==0)
        {
            weightdata = weightdata/0.45359;
            NSString *strData = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%.1f lb",weightdata]];
            
            weightDataLabel.text = strData;
        }
        if (!(weightdata == lastweight && fatdata == lastfat && waterdata ==  lastwater && bonedata == lastbone && bmidata == lastbmi && bmrdata == lastbmr && heightdata == lastheight && muscledata == lastmuscle && visfatdata == lastvisfat)) {
            
            lastweight = weightdata;
            lastfat = fatdata;
            lastwater = waterdata;
            lastbone = bonedata;
            lastbmi = bmidata;
            lastbmr = bmrdata;
            lastheight = heightdata;
            lastmuscle = muscledata;
            lastvisfat = visfatdata;
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Notice" message:@"Do you want save this data?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alert show];
            
            NSThread* myThread1 = [[NSThread alloc] initWithTarget:self selector:@selector(mySoundPlayer)object:nil];
            [myThread1 start];
        }
    }

    Byte getData[] = {0xfd,0x31};
    NSData *testData = [[NSData alloc]initWithBytes:getData length:sizeof(getData)];
    [self.targetPeripheral writeValue:testData forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithResponse];
//    [self.targetPeripheral writeValue:testData forDescriptor:nil];
    NSLog(@"write value 0x02,0x20,0xdd,0x02,0xfd,0x30,0xd4");
    
    NSThread* myThread = [[NSThread alloc] initWithTarget:self selector:@selector(myThreadMainMethod)object:nil];
    [myThread start];
    
    
    
    // Have we got everything we need?
    if ([stringFromData isEqualToString:@"EOM"]) {
        
        // We have, so show the data,
        //[self.textview setText:[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding]];
        NSLog(@"GetDataValue : %@",[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding]);
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
        [peripheral readValueForCharacteristic:characteristic];
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
    
    self.bluetoothImageView.image = [UIImage imageNamed:@"ly0"];
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
    weightLabel.text = @"adsdasd";
    for(int i = 0;i<1;i++){
        sleep(2);
        Byte getData[] = {0xfd,0x31};
        NSData *testData = [[NSData alloc]initWithBytes:getData length:sizeof(getData)];
        [self.targetPeripheral writeValue:testData forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
        NSLog(@"write value 0x02,0x20,0xdd,0x02,0xfd,0x29,0xd4");
        
        sleep(5);
        lastweight = 0;
        lastwater = 0;
        lastmuscle = 0;
        lastfat = 0;
    }
}

-(void)mySoundPlayer
{
    WQPlaySound *sound = sound = [[WQPlaySound alloc]initForPlayingSoundEffectWith:NSLocalizedString(@"NOVA_GOTIT", nil)];
    
    [sound play];
    sleep(2);
}


@end
