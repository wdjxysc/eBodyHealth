//
//  HistoryViewController.m
//  eBodyHealth
//
//  Created by 夏 伟 on 13-8-3.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import "HistoryViewController.h"
#import "WeightDataCell.h"
#import "BodyfatDataCell.h"
#import <sqlite3.h>
#import <stdlib.h>
#import "WeightMeasureViewController.h"
#import "MySingleton.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController
@synthesize myTableView;
@synthesize mySegmentedControl;
@synthesize weightDatas;
@synthesize bloodPressDatas;
@synthesize bodyFatDatas;
@synthesize nowDataType;
@synthesize weightButton;
@synthesize bloodPressButton;
@synthesize bodyFatButton;
@synthesize glucoseButton;
@synthesize oxygenButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.image = [UIImage imageNamed:@"History"];
        self.tabBarItem.title = NSLocalizedString(@"HISTORY", nil);
        self.navigationItem.title = NSLocalizedString(@"HISTORY", nil);
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getBodyFatHistoryDataList];
    [myTableView reloadData];
}

- (void)viewDidLoad
{
    nowDataType = @"weight";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getBodyFatHistoryDataList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getBodyFatHistoryDataList
{
    NSMutableArray *weightdataArray = [[NSMutableArray alloc] init];
    
    NSString *filePath = [self dataFilePath];
    NSLog(@"filePath=%@",filePath);
    
    sqlite3 *database;
    if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"数据库打开失败");
    }
    
    NSString *weightsqlQuery = [[NSString alloc]initWithFormat:@"SELECT * FROM WEIGHTDATA WHERE USERID = %d ORDER BY TESTTIME DESC",[MySingleton sharedSingleton].nowuserid];
    //sqlQuery = @"SELECT * FROM WEIGHTDATA WHERE USERID = 1";
    sqlite3_stmt * weightstatement;
    
    if (sqlite3_prepare_v2(database, [weightsqlQuery UTF8String], -1, &weightstatement, nil) == SQLITE_OK) {
        while (sqlite3_step(weightstatement) == SQLITE_ROW) {
            double weight = sqlite3_column_double(weightstatement, 3);
            char *testtimechar = sqlite3_column_text(weightstatement, 4);
            NSString *testtimestr = [[NSString  alloc]initWithFormat:@"%s",testtimechar];
            NSString *weightstr = [[NSString alloc]initWithFormat:@"%.1f",weight];
            
            NSDictionary *dataRow1 =[[NSDictionary alloc] initWithObjectsAndKeys:
                                     [[NSString alloc] initWithFormat:@"%@", testtimestr],
                                     @"TestTime",
                                     weightstr,
                                     @"Weight",
                                     nil];
            [weightdataArray addObject:dataRow1];
        }
    }
    self.weightDatas = weightdataArray;
    sqlite3_finalize(weightstatement);
    sqlite3_close(database);
    
    if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"数据库打开失败");
    }
    NSMutableArray *bodyfatdataArray = [[NSMutableArray alloc] init];
    NSString *bodyfatsqlQuery = [[NSString alloc]initWithFormat:@"SELECT * FROM BODYFATDATA WHERE USERID = %d ORDER BY TESTTIME DESC",[MySingleton sharedSingleton].nowuserid];;
    sqlite3_stmt * bodyfatstatement;
    
    if (sqlite3_prepare_v2(database, [bodyfatsqlQuery UTF8String], -1, &bodyfatstatement, nil) == SQLITE_OK) {
        while (sqlite3_step(bodyfatstatement) == SQLITE_ROW) {
            double weight = sqlite3_column_double(bodyfatstatement, 7);
            double fat = sqlite3_column_double(bodyfatstatement, 8);
            int visceralfat = sqlite3_column_int(bodyfatstatement, 9);
            double water = sqlite3_column_double(bodyfatstatement, 10);
            double bone = sqlite3_column_double(bodyfatstatement, 11);
            double muscle = sqlite3_column_double(bodyfatstatement, 12);
            int bmr = sqlite3_column_int(bodyfatstatement, 13);
            double bmi = sqlite3_column_double(bodyfatstatement, 14);
            char *testtimechar = sqlite3_column_text(bodyfatstatement, 15);
            NSString *testtimestr = [[NSString  alloc]initWithFormat:@"%s",testtimechar];
            NSString *weightstr = [[NSString alloc]initWithFormat:@"%.1f",weight];
            NSString *fatstr = [[NSString alloc]initWithFormat:@"%.1f",fat];
            NSString *visceralfatstr = [[NSString alloc]initWithFormat:@"%d",visceralfat];
            NSString *waterstr = [[NSString alloc]initWithFormat:@"%.1f",water];
            NSString *bonestr = [[NSString alloc]initWithFormat:@"%.1f",bone];
            NSString *musclestr = [[NSString alloc]initWithFormat:@"%.1f",muscle];
            NSString *kcalstr = [[NSString alloc]initWithFormat:@"%d",bmr];
            NSString *bmistr = [[NSString alloc]initWithFormat:@"%.1f",bmi];
            
            NSDictionary *dataRow1 =[[NSDictionary alloc] initWithObjectsAndKeys:
                                     [[NSString alloc] initWithFormat:@"%@", testtimestr],
                                     @"TestTime",
                                     weightstr,
                                     @"Weight",
                                     fatstr,
                                     @"Fat",
                                     musclestr,
                                     @"Muscle",
                                     waterstr,
                                     @"Water",
                                     bonestr,
                                     @"Bone",
                                     visceralfatstr,
                                     @"VisceralFat",
                                     kcalstr,
                                     @"BMR",
                                     bmistr,
                                     @"BMI",
                                     nil];
            
            //NSLog(@"USERNAME:%@  AGE:%d  SEX:%@",weightstr,age, nsAddressStr);
            
            [bodyfatdataArray addObject:dataRow1];
            
        }
    }
    self.bodyFatDatas = bodyfatdataArray;
    sqlite3_finalize(bodyfatstatement);  
    sqlite3_close(database);
}

-(NSString *)dataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kSqliteFileName];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int i = 0;
    if([nowDataType isEqualToString:@"weight"])
    {
        i = [self.weightDatas count];
    }
    else if([nowDataType isEqualToString:@"bodyfat"])
    {
        i = [self.bodyFatDatas count];
    }
    return i;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    UITableViewCell *returncell = [[UITableViewCell alloc]init];
    if([nowDataType isEqualToString:@"weight"])
    {
        WeightDataCell *cell = (WeightDataCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    
        if(cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WeightDataCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    
        NSUInteger row = [indexPath row];
        NSDictionary *rowData = [self.weightDatas objectAtIndex:row];
        //@synthesize testTimeLabel,weightLabel,fatLabel,muscleLabel,waterLabel,boneLabel,visceralFatLabel,kcalLabel,bmiLabel;
        //cell.testTimeLabel.text = [rowData objectForKey:@""]
        //cell.colorLabel.text = [rowData objectForKey:@"Color"];
        //cell.nameLabel.text = [rowData objectForKey:@"Name"];
        cell.testTimeLabel.text = [[NSString alloc] initWithFormat:@"%@",[rowData objectForKey:@"TestTime"]];
        cell.weightDataLabel.text = [[NSString alloc] initWithFormat:@"%@ (kg)",[rowData objectForKey:@"Weight"]];
        [cell.weightButton setTitle:NSLocalizedString(@"USER_WEIGHT", nil) forState:UIControlStateNormal];
        //UIImage *image = [UIImage imageNamed:@"bluetooth.png"];
        //cell.imageView.image = image;
        returncell.selectionStyle = UITableViewCellSelectionStyleNone;
        returncell = cell;
    }
    else if([nowDataType isEqualToString:@"bodyfat"])
    {
        BodyfatDataCell *cell = (BodyfatDataCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        
        if(cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BodyfatDataCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        NSUInteger row = [indexPath row];
        NSDictionary *rowData = [self.bodyFatDatas objectAtIndex:row];
        cell.testTimeLabel.text = [[NSString alloc] initWithFormat:@"%@",[rowData objectForKey:@"TestTime"]];
        cell.weightDataLabel.text = [[NSString alloc]initWithFormat:@"%@ kg",[rowData objectForKey:@"Weight"]];
        cell.fatDataLabel.text = [[NSString alloc] initWithFormat:@"%@ %%",[rowData objectForKey:@"Fat"]];
        cell.muscleDataLabel.text = [[NSString alloc] initWithFormat:@"%@ %%",[rowData objectForKey:@"Muscle"]];
        cell.waterDataLabel.text = [[NSString alloc] initWithFormat:@"%@ %%",[rowData objectForKey:@"Water"]];
        cell.boneDataLabel.text = [[NSString alloc] initWithFormat:@"%@ kg",[rowData objectForKey:@"Bone"]];
        cell.visceralFatDataLabel.text = [[NSString alloc] initWithFormat:@"%@",[rowData objectForKey:@"VisceralFat"]];
        cell.bmrDataLabel.text = [[NSString alloc] initWithFormat:@"%@",[rowData objectForKey:@"BMR"]];
        cell.bmiDataLabel.text = [[NSString alloc] initWithFormat:@"%@",[rowData objectForKey:@"BMI"]];
        
        [cell.weightButton setTitle:NSLocalizedString(@"USER_WEIGHT", nil) forState:UIControlStateNormal];
        [cell.fatButton setTitle:NSLocalizedString(@"USER_FAT", nil) forState:UIControlStateNormal];
        [cell.muscleButton setTitle:NSLocalizedString(@"USER_MUSCLE", nil) forState:UIControlStateNormal];
        [cell.waterButton setTitle:NSLocalizedString(@"USER_WATER", nil) forState:UIControlStateNormal];
        [cell.boneButton setTitle:NSLocalizedString(@"USER_BONE", nil) forState:UIControlStateNormal];
        [cell.visceralFatButton setTitle:NSLocalizedString(@"USER_VISFAT", nil) forState:UIControlStateNormal];
        [cell.bmrButton setTitle:NSLocalizedString(@"USER_BMR", nil) forState:UIControlStateNormal];
        [cell.bmiButton setTitle:NSLocalizedString(@"USER_BMI", nil) forState:UIControlStateNormal];
        returncell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        returncell = cell;
    }
    
    return returncell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat result = 50.0f;
    if([nowDataType isEqualToString:@"weight"])
    {
        result = 70.0f;
    }
    else if([nowDataType isEqualToString:@"bodyfat"])
    {
        result = 126.0f;
    }
    return result;
//    return roundf(50);
}

-(IBAction)dataTypeSelect:(id)sender
{
    if([sender selectedSegmentIndex]==0)
    {
        //trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//去掉字符串中的空字符
        nowDataType = @"weight";
        [myTableView reloadData];
    }
    else if([sender selectedSegmentIndex]==1)
    {
        nowDataType = @"bodyfat";
        [myTableView reloadData];
    }
}

-(IBAction)weightButtonPressed:(id)sender
{
    [weightButton setBackgroundImage:[UIImage imageNamed:@"Weight_button"] forState:UIControlStateNormal];
    [bodyFatButton setBackgroundImage:[UIImage imageNamed:@"Body fat_button_03"] forState:UIControlStateNormal];
    [bloodPressButton setBackgroundImage:[UIImage imageNamed:@"Blood pressure_button_03"] forState:UIControlStateNormal];
    [glucoseButton setBackgroundImage:[UIImage imageNamed:@"Blood sugar_button_03"] forState:UIControlStateNormal];
    [oxygenButton setBackgroundImage:[UIImage imageNamed:@"Oxygen_button_03"] forState:UIControlStateNormal];
    [weightButton reloadInputViews];
    nowDataType = @"weight";
    [myTableView reloadData];
}

-(IBAction)bodyFatButtonPressed:(id)sender
{
    [weightButton setBackgroundImage:[UIImage imageNamed:@"Weight_button_03"] forState:UIControlStateNormal];
    [bodyFatButton setBackgroundImage:[UIImage imageNamed:@"Body fat_button"] forState:UIControlStateNormal];
    [bloodPressButton setBackgroundImage:[UIImage imageNamed:@"Blood pressure_button_03"] forState:UIControlStateNormal];
    [glucoseButton setBackgroundImage:[UIImage imageNamed:@"Blood sugar_button_03"] forState:UIControlStateNormal];
    [oxygenButton setBackgroundImage:[UIImage imageNamed:@"Oxygen_button_03"] forState:UIControlStateNormal];
    nowDataType = @"bodyfat";
    [myTableView reloadData];
}

-(IBAction)bloodPressButtonPressed:(id)sender
{
    [weightButton setBackgroundImage:[UIImage imageNamed:@"Weight_button_03"] forState:UIControlStateNormal];
    [bodyFatButton setBackgroundImage:[UIImage imageNamed:@"Body fat_button_03"] forState:UIControlStateNormal];
    [bloodPressButton setBackgroundImage:[UIImage imageNamed:@"Blood pressure_button"] forState:UIControlStateNormal];
    [glucoseButton setBackgroundImage:[UIImage imageNamed:@"Blood sugar_button_03"] forState:UIControlStateNormal];
    [oxygenButton setBackgroundImage:[UIImage imageNamed:@"Oxygen_button_03"] forState:UIControlStateNormal];
    nowDataType = @"bloodpress";
    [myTableView reloadData];
}

-(IBAction)glucoseButtonPressed:(id)sender
{
    [weightButton setBackgroundImage:[UIImage imageNamed:@"Weight_button_03"] forState:UIControlStateNormal];
    [bodyFatButton setBackgroundImage:[UIImage imageNamed:@"Body fat_button_03"] forState:UIControlStateNormal];
    [bloodPressButton setBackgroundImage:[UIImage imageNamed:@"Blood pressure_button_03"] forState:UIControlStateNormal];
    [glucoseButton setBackgroundImage:[UIImage imageNamed:@"Blood sugar_button"] forState:UIControlStateNormal];
    [oxygenButton setBackgroundImage:[UIImage imageNamed:@"Oxygen_button_03"] forState:UIControlStateNormal];
    nowDataType = @"glucose";
    [myTableView reloadData];
}

-(IBAction)oxygenButtonPressed:(id)sender
{
    [weightButton setBackgroundImage:[UIImage imageNamed:@"Weight_button_03"] forState:UIControlStateNormal];
    [bodyFatButton setBackgroundImage:[UIImage imageNamed:@"Body fat_button_03"] forState:UIControlStateNormal];
    [bloodPressButton setBackgroundImage:[UIImage imageNamed:@"Blood pressure_button_03"] forState:UIControlStateNormal];
    [glucoseButton setBackgroundImage:[UIImage imageNamed:@"Blood sugar_button_03"] forState:UIControlStateNormal];
    [oxygenButton setBackgroundImage:[UIImage imageNamed:@"Oxygen_button"] forState:UIControlStateNormal];
    nowDataType = @"oxygen";
    [myTableView reloadData];
}
@end
