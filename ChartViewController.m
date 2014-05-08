//
//  ChartViewController.m
//  eBodyHealth
//
//  Created by 夏 伟 on 13-8-3.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import "ChartViewController.h"
#import "UserSelectViewController.h"
#import <sqlite3.h>
#import "MySingleton.h"

//#define PERFORMANCE_TEST
#define GREEN_PLOT_IDENTIFIER       @"Green Plot"
#define BLUE_PLOT_IDENTIFIER        @"Blue Plot"

@interface ChartViewController ()
{
    CPTXYGraph * _graph;
    NSMutableArray * _dataForPlot;
}

- (void)setupCoreplotViews;

-(CPTPlotRange *)CPTPlotRangeFromFloat:(float)location length:(float)length;

@end

@implementation ChartViewController
@synthesize dataForPlot1;
@synthesize myview;
@synthesize bodyfatdata;
@synthesize weightdata;
@synthesize nowdevice;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.image = [UIImage imageNamed:@"Chart"];
        self.tabBarItem.title = NSLocalizedString(@"CHART", nil);
        self.navigationItem.title = NSLocalizedString(@"CHART", nil);
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setupCoreplotViews];
    
    [weightButton setTitle:NSLocalizedString(@"USER_WEIGHT", nil) forState:UIControlStateNormal];
    [fatButton setTitle:NSLocalizedString(@"USER_FAT", nil) forState:UIControlStateNormal];
    [visfatButton setTitle:NSLocalizedString(@"USER_VISFAT", nil) forState:UIControlStateNormal];
    [waterButton setTitle:NSLocalizedString(@"USER_WATER", nil) forState:UIControlStateNormal];
    [muscleButton setTitle:NSLocalizedString(@"USER_MUSCLE", nil) forState:UIControlStateNormal];
    [boneButton setTitle:NSLocalizedString(@"USER_BONE", nil) forState:UIControlStateNormal];
    [bmiButton setTitle:NSLocalizedString(@"USER_BMI", nil) forState:UIControlStateNormal];
    [bmrButton setTitle:NSLocalizedString(@"USER_BMR", nil) forState:UIControlStateNormal];
    [sysButton setTitle:NSLocalizedString(@"USER_SYS", nil) forState:UIControlStateNormal];
    [diaButton setTitle:NSLocalizedString(@"USER_DIA", nil) forState:UIControlStateNormal];
    [pulseButton setTitle:NSLocalizedString(@"USER_PULSE", nil) forState:UIControlStateNormal];
    [oxygenButton setTitle:NSLocalizedString(@"USER_OXYGEN", nil) forState:UIControlStateNormal];
    [oxygenpulseButton setTitle:NSLocalizedString(@"USER_PULSE", nil) forState:UIControlStateNormal];
    [glucoseButton setTitle:NSLocalizedString(@"USER_GLUCOSE", nil) forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Rotation

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

#pragma mark -
#pragma mark Setup coreplot views

- (void)setupCoreplotViews
{
    weightButton.hidden = NO;
    fatButton.hidden = NO;
    visfatButton.hidden = NO;
    waterButton.hidden = NO;
    muscleButton.hidden = NO;
    boneButton.hidden = NO;
    bmiButton.hidden = NO;
    bmrButton.hidden = NO;
    glucoseButton.hidden = YES;
    sysButton.hidden = YES;
    diaButton.hidden = YES;
    pulseButton.hidden = YES;
    oxygenButton.hidden = YES;
    oxygenpulseButton.hidden = YES;
    
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    
    // Create graph from theme: 设置主题
    //
    _graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme * theme = [CPTTheme themeNamed:kCPTSlateTheme];
    //    theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    //    theme = [CPTTheme themeNamed:kCPTPlainBlackTheme];
    //    theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    //    theme = [CPTTheme themeNamed:kCPTStocksTheme];
    [_graph applyTheme:theme];
    
    CPTGraphHostingView * hostingView = (CPTGraphHostingView *)self.myview;
    hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    hostingView.hostedGraph = _graph;
    
    _graph.paddingLeft = _graph.paddingRight = 10.0;  //图的边框与视图边框之间的空隙
    _graph.paddingTop = _graph.paddingBottom = 10.0;
    _graph.plotAreaFrame.paddingLeft = 5.0 ;
    _graph.plotAreaFrame.paddingTop = 5.0 ;
    _graph.plotAreaFrame.paddingRight = 5.0 ;
    _graph.plotAreaFrame.paddingBottom = 5.0 ;
//    _graph.plotAreaFrame.paddingLeft = 0 ;
//    _graph.plotAreaFrame.paddingTop = 0 ;
//    _graph.plotAreaFrame.paddingRight = 0 ;
//    _graph.plotAreaFrame.paddingBottom = 0 ;
    
    // Setup plot space: 设置一屏内可显示的x,y量度范围
    //
    CPTXYPlotSpace * plotSpace = (CPTXYPlotSpace *)_graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;  //允许用户拖动视图
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(10.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(200.0)];
    
    // Axes: 设置x,y轴属性，如原点，量度间隔，标签，刻度，颜色等
    //
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)_graph.axisSet;
    
    lineStyle.miterLimit = 1.0f;
    lineStyle.lineWidth = 2.0;
    lineStyle.lineColor = [CPTColor whiteColor];
    
    CPTXYAxis * x = axisSet.xAxis;
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // 原点的 x 位置
    x.majorIntervalLength = CPTDecimalFromString(@"1");   // x轴主刻度：显示数字标签的量度间隔
    x.minorTicksPerInterval = 0;    // x轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    x.minorTickLineStyle = lineStyle;
    
    // 需要排除的不显示数字的主刻度
    NSArray * exclusionRanges = [NSArray arrayWithObjects:
                                 [self CPTPlotRangeFromFloat:0.99 length:0.02],
                                 [self CPTPlotRangeFromFloat:2.99 length:0.02],
                                 nil];
    x.labelExclusionRanges = exclusionRanges;
    
    CPTXYAxis * y = axisSet.yAxis;
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // 原点的 y 位置
    y.majorIntervalLength = CPTDecimalFromString(@"20");   // y轴主刻度：显示数字标签的量度间隔
    y.minorTicksPerInterval = 4;    // y轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    y.minorTickLineStyle = lineStyle;
    exclusionRanges = [NSArray arrayWithObjects:
                       [self CPTPlotRangeFromFloat:1.99 length:0.02],
                       [self CPTPlotRangeFromFloat:2.99 length:0.02],
                       nil];
    y.labelExclusionRanges = exclusionRanges;
    y.delegate = self;
    
    // Create a red-blue plot area
    //
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 3.0f;
    lineStyle.lineColor         = [CPTColor blueColor];
    
    CPTScatterPlot * boundLinePlot  = [[CPTScatterPlot alloc] init];
    boundLinePlot.dataLineStyle = lineStyle;
    boundLinePlot.identifier    = BLUE_PLOT_IDENTIFIER;
    boundLinePlot.dataSource    = self;
    
    // Do a red-blue gradient: 渐变色区域
    //
    CPTColor * blueColor        = [CPTColor colorWithComponentRed:0.3 green:0.3 blue:1.0 alpha:0.8];
    CPTColor * redColor         = [CPTColor colorWithComponentRed:1.0 green:0.3 blue:0.3 alpha:0.8];
    CPTGradient * areaGradient1 = [CPTGradient gradientWithBeginningColor:blueColor
                                                              endingColor:redColor];
    areaGradient1.angle = -90.0f;
    CPTFill * areaGradientFill  = [CPTFill fillWithGradient:areaGradient1];
    boundLinePlot.areaFill      = areaGradientFill;
    boundLinePlot.areaBaseValue = [[NSDecimalNumber numberWithFloat:1.0] decimalValue]; // 渐变色的起点位置
    
    // Add plot symbols: 表示数值的符号的形状
    //
    CPTMutableLineStyle * symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPTColor blackColor];
    symbolLineStyle.lineWidth = 2.0;
    
    CPTPlotSymbol * plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill          = [CPTFill fillWithColor:[CPTColor blueColor]];
    plotSymbol.lineStyle     = symbolLineStyle;
    plotSymbol.size          = CGSizeMake(5.0, 5.0);  //数据点大小
    boundLinePlot.plotSymbol = plotSymbol;
    
    [_graph addPlot:boundLinePlot];
    
    // Create a green plot area: 画破折线
    //
    lineStyle                = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth      = 3.f;
    lineStyle.lineColor      = [CPTColor greenColor];
    lineStyle.dashPattern    = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:5.0f],
                                [NSNumber numberWithFloat:5.0f], nil];
    
    CPTScatterPlot * dataSourceLinePlot = [[CPTScatterPlot alloc] init];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    dataSourceLinePlot.identifier = GREEN_PLOT_IDENTIFIER;
    dataSourceLinePlot.dataSource = self;
    
    // Put an area gradient under the plot above
    //
    CPTColor * areaColor            = [CPTColor colorWithComponentRed:0.3 green:1.0 blue:0.3 alpha:0.8];
    CPTGradient * areaGradient      = [CPTGradient gradientWithBeginningColor:areaColor
                                                                  endingColor:[CPTColor clearColor]];
    areaGradient.angle              = -90.0f;
    areaGradientFill                = [CPTFill fillWithGradient:areaGradient];
    dataSourceLinePlot.areaFill     = areaGradientFill;
    dataSourceLinePlot.areaBaseValue= CPTDecimalFromString(@"1.75");
    
    // Animate in the new plot: 淡入动画
    dataSourceLinePlot.opacity = 0.0f;
    
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.duration            = 1.0f;
    fadeInAnimation.removedOnCompletion = NO;
    fadeInAnimation.fillMode            = kCAFillModeForwards;
    fadeInAnimation.toValue             = [NSNumber numberWithFloat:1.0];
    [dataSourceLinePlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
    
//    [_graph addPlot:dataSourceLinePlot];
    
    // Add some initial data
    //
//    _dataForPlot = [NSMutableArray arrayWithCapacity:100];
//    NSUInteger i;
//    for ( i = 0; i < 2; i++ ) {
//        id x = [NSNumber numberWithFloat:0 + i];
//        id y = [NSNumber numberWithFloat:1.2 * rand() / (float)RAND_MAX + 1.2];
//        [_dataForPlot addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
//    }
//    
    [self getDataFromDataBase:@"bodyfat"];
    
    if(bodyfatdata !=nil)
    {
        for (int i = 0; i<[bodyfatdata count]; i++) {
            NSString *xp = [NSString stringWithFormat:@"%d",i+2];
            NSString *yp;
            yp = [NSString stringWithFormat:@"%.1f",[[[bodyfatdata objectAtIndex:i] objectForKey:@"Weight"] doubleValue]];
            NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
            [_dataForPlot addObject:point1];
        }
    }

    
//    [self changePlotRange];
    
#ifdef PERFORMANCE_TEST
    //    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(changePlotRange) userInfo:nil repeats:YES];
#endif
    
}

-(void)changePlotRange
{
    // Change plot space
    CPTXYPlotSpace * plotSpace = (CPTXYPlotSpace *)_graph.defaultPlotSpace;
    
    plotSpace.xRange = [self CPTPlotRangeFromFloat:0.0 length:(3.0 + 2.0 * rand() / RAND_MAX)];
    plotSpace.yRange = [self CPTPlotRangeFromFloat:0.0 length:(3.0 + 2.0 * rand() / RAND_MAX)];
}

-(CPTPlotRange *)CPTPlotRangeFromFloat:(float)location length:(float)length
{
    return [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(location) length:CPTDecimalFromFloat(length)];
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [_dataForPlot count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSString * key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
    NSNumber * num = [[_dataForPlot objectAtIndex:index] valueForKey:key];
    
    // Green plot gets shifted above the blue
    if ([(NSString *)plot.identifier isEqualToString:GREEN_PLOT_IDENTIFIER]) {
        if (fieldEnum == CPTScatterPlotFieldY) {
            num = [NSNumber numberWithDouble:[num doubleValue] + 1.0];
        }
    }
    
    return num;
}

#pragma mark -
#pragma mark Axis Delegate Methods

-(BOOL)axis:(CPTAxis *)axis shouldUpdateAxisLabelsAtLocations:(NSSet *)locations
{
    static CPTTextStyle * positiveStyle = nil;
    static CPTTextStyle * negativeStyle = nil;
    
    NSNumberFormatter * formatter   = axis.labelFormatter;
    CGFloat labelOffset             = axis.labelOffset;
    NSDecimalNumber * zero          = [NSDecimalNumber zero];
    
    NSMutableSet * newLabels        = [NSMutableSet set];
    
    for (NSDecimalNumber * tickLocation in locations) {
        CPTTextStyle *theLabelTextStyle;
        
        if ([tickLocation isGreaterThanOrEqualTo:zero]) {
            if (!positiveStyle) {
                CPTMutableTextStyle * newStyle = [axis.labelTextStyle mutableCopy];
                newStyle.color = [CPTColor greenColor];
                positiveStyle  = newStyle;
            }
            
            theLabelTextStyle = positiveStyle;
        }
        else {
            if (!negativeStyle) {
                CPTMutableTextStyle * newStyle = [axis.labelTextStyle mutableCopy];
                newStyle.color = [CPTColor redColor];
                negativeStyle  = newStyle;
            }
            
            theLabelTextStyle = negativeStyle;
        }
        
        NSString * labelString      = [formatter stringForObjectValue:tickLocation];
        CPTTextLayer * newLabelLayer= [[CPTTextLayer alloc] initWithText:labelString style:theLabelTextStyle];
        
        CPTAxisLabel * newLabel     = [[CPTAxisLabel alloc] initWithContentLayer:newLabelLayer];
        newLabel.tickLocation       = tickLocation.decimalValue;
        newLabel.offset             = labelOffset;
        
        [newLabels addObject:newLabel];
    }
    
    axis.axisLabels = newLabels;
    
    return NO;
}



//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//    
//    graph = [[CPTXYGraph alloc] initWithFrame:myview.bounds];
//    
//    //给画板添加一个主题
//    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
//    [graph applyTheme:theme];
//    
//    //创建主画板视图添加画板
//    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:myview.bounds];
//    hostingView.hostedGraph = graph;
//    
//	[myview addSubview:hostingView];
//    
//    //设置留白
//    graph.paddingLeft = 20;
//	graph.paddingTop = 20;
//	graph.paddingRight = 20;
//	graph.paddingBottom = 20;
//    
//    graph.plotAreaFrame.paddingLeft = 45.0 ;
//    graph.plotAreaFrame.paddingTop = 40.0 ;
//    graph.plotAreaFrame.paddingRight = 5.0 ;
//    graph.plotAreaFrame.paddingBottom = 80.0 ;
//    graph.plotAreaFrame.paddingLeft = 0 ;
//    graph.plotAreaFrame.paddingTop = 0 ;
//    graph.plotAreaFrame.paddingRight = 0 ;
//    graph.plotAreaFrame.paddingBottom = 0 ;
//    //设置坐标范围
//    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
//    plotSpace.xRange =[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(1.0)length:CPTDecimalFromFloat(2.0)];
//    plotSpace.yRange =[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(1.0)length:CPTDecimalFromFloat(3.0)];
//    
//    plotSpace.allowsUserInteraction = YES;
//    
//    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(200.0)];
//    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(200.0)];
//    
//    //设置坐标刻度大小
//    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) graph.axisSet ;
//    CPTXYAxis *x = axisSet.xAxis ;
//    x. minorTickLineStyle = nil ;
//    // 大刻度线间距： 50 单位
//    x. majorIntervalLength = CPTDecimalFromString (@"50");
//    // 坐标原点： 0
//    x. orthogonalCoordinateDecimal = CPTDecimalFromString ( @"0" );
//    
//    CPTXYAxis *y = axisSet.yAxis ;
//    //y 轴：不显示小刻度线
//    y. minorTickLineStyle = nil ;
//    // 大刻度线间距： 50 单位
//    y. majorIntervalLength = CPTDecimalFromString ( @"50" );
//    // 坐标原点： 0
//    y. orthogonalCoordinateDecimal = CPTDecimalFromString (@"0");
//    
//    //创建绿色区域
//    dataSourceLinePlot = [[CPTScatterPlot alloc] init];
//    dataSourceLinePlot.identifier = @"Green Plot";
//    
//    //设置绿色区域边框的样式
//    CPTMutableLineStyle *lineStyle = [dataSourceLinePlot.dataLineStyle mutableCopy];
//    lineStyle.lineWidth = 1.f;
//    lineStyle.lineColor = [CPTColor greenColor];
//    dataSourceLinePlot.dataLineStyle = lineStyle;
//    //设置透明实现添加动画
//    dataSourceLinePlot.opacity = 0.0f;
//    
//    //设置数据元代理
//    dataSourceLinePlot.dataSource = self;
//    [graph addPlot:dataSourceLinePlot];
//    
//    // 创建一个颜色渐变：从 建变色 1 渐变到 无色
//    CPTGradient *areaGradient = [ CPTGradient gradientWithBeginningColor :[CPTColor greenColor] endingColor :[CPTColor colorWithComponentRed:0.65 green:0.65 blue:0.16 alpha:0.2]];
//    // 渐变角度： -90 度（顺时针旋转）
//    areaGradient.angle = -90.0f ;
//    // 创建一个颜色填充：以颜色渐变进行填充
//    CPTFill *areaGradientFill = [ CPTFill fillWithGradient :areaGradient];
//    // 为图形设置渐变区
//    dataSourceLinePlot. areaFill = areaGradientFill;
//    dataSourceLinePlot. areaBaseValue = CPTDecimalFromString ( @"0.0" );
//    dataSourceLinePlot.interpolation = CPTScatterPlotInterpolationLinear ;
//    
//    
//    dataForPlot1 = [[NSMutableArray alloc] init];
//    j = 200;
//    r = 0;
////    timer1 = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(dataOpt) userInfo:nil repeats:YES];
////    [timer1 fire];
//
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (void) dataOpt:(NSString *)datatype :(NSString *)childdatatype
//{
//    //添加随机数
//    if ([dataSourceLinePlot.identifier isEqual:@"Green Plot"]) {
//        NSString *xp = [NSString stringWithFormat:@"%d",j];
//        NSString *yp = [NSString stringWithFormat:@"%d",(rand()%100)];
//        NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
//        [dataForPlot1 insertObject:point1 atIndex:0];
//    }
//    //初始化数据数组 
//    dataForPlot1 = [[NSMutableArray alloc]init];
//    
//    
//    if(bodyfatdata !=nil && [datatype isEqualToString:@"bodyfat"])
//    {
//        for (int i = 0; i<[bodyfatdata count]; i++) {
//            NSString *xp = [NSString stringWithFormat:@"%d",i];
//            NSString *yp;
//            if([childdatatype isEqualToString:@"weight"])
//            {
//                yp = [NSString stringWithFormat:@"%.1f",[[[bodyfatdata objectAtIndex:i] objectForKey:@"Weight"] doubleValue]];
//            }
//            NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
//            [dataForPlot1 addObject:point1];
//        }
//    }
//    else if([datatype isEqualToString:@"weight"] && weightdata != nil)
//    {
//        
//    }
//    //刷新画板
//    [graph reloadData];
//    j = j + 20;
//    r = r + 20;
//}
//
//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//}
//#pragma mark - dataSourceOpt
//
//-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
//{
//    return [dataForPlot1 count];
//}
//
//-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
//{
//    NSString *key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
//    NSNumber *num;
//    //让视图偏移
//	if ( [(NSString *)plot.identifier isEqualToString:@"Green Plot"] ) {
//        num = [[dataForPlot1 objectAtIndex:index] valueForKey:key];
//        if ( fieldEnum == CPTScatterPlotFieldX ) {
//			num = [NSNumber numberWithDouble:[num doubleValue] - r];
//		}
//	}
//    //添加动画效果
//    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//	fadeInAnimation.duration = 0.0f;
//	fadeInAnimation.removedOnCompletion = YES;
//	fadeInAnimation.fillMode = kCAFillModeForwards;
//	fadeInAnimation.toValue = [NSNumber numberWithFloat:2.0];
//	[dataSourceLinePlot addAnimation:fadeInAnimation forKey:@"animateOpacity"];
//    return num;
//}

-(void)getDataFromDataBase:(NSString *) datatype
{
    //获取数据库路径
    NSString *filePath = [self dataFilePath];
    NSLog(@"filePath=%@",filePath);
    
    sqlite3 *database;
    if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"数据库打开失败");
    }
    char* errorMsg;
    
    NSString *sql;
    
    if ([datatype isEqualToString:@"bodyfat"])
    {
//        NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS BODYFATDATA(DATAID INTEGER PRIMARY KEY AUTOINCREMENT, USERID INTEGER, USERNAME TEXT, AGE INTEGER, SEX INTEGER, SPORTLVL INTEGER, HEIGHT INTEGER, WEIGHT FLOAT, BODYFAT FLOAT, VISCERALFAT INTEGER, WATER FLOAT, BONE FLOAT, MUSCLE FLOAT, BMR INTEGER, BMI FLOAT, TESTTIME TIMESTAMP, VERSION FLOAT,ISSEND TEXT)";
        sqlite3_stmt * statement;
        bodyfatdata = [[NSMutableArray alloc]init];
        sql =[[NSString alloc]initWithFormat: @"SELECT WEIGHT,BODYFAT,VISCERALFAT,WATER,BONE,MUSCLE,BMR,BMI,TESTTIME FROM BODYFATDATA WHERE USERID = %d ORDER BY TESTTIME ASC",[MySingleton sharedSingleton].nowuserid ];
        
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                double weight = sqlite3_column_double(statement, 0);
                double fat = sqlite3_column_double(statement, 1);
                int visceralfat = sqlite3_column_int(statement, 2);
                double water = sqlite3_column_double(statement, 3);
                double bone = sqlite3_column_double(statement, 4);
                double muscle = sqlite3_column_double(statement, 5);
                int bmr = sqlite3_column_int(statement, 6);
                double bmi = sqlite3_column_double(statement, 7);
                char *testtimechar = sqlite3_column_text(statement, 8);
                NSString *testtimestr = [[NSString  alloc]initWithFormat:@"%s",testtimechar];
                NSString *weightstr = [[NSString alloc]initWithFormat:@"%.1f",weight];
                NSString *fatstr = [[NSString alloc]initWithFormat:@"%.1f",fat];
                NSString *visceralfatstr = [[NSString alloc]initWithFormat:@"%d",visceralfat];
                NSString *waterstr = [[NSString alloc]initWithFormat:@"%.1f",water];
                NSString *bonestr = [[NSString alloc]initWithFormat:@"%.1f",bone];
                NSString *musclestr = [[NSString alloc]initWithFormat:@"%.1f",muscle];
                NSString *bmrstr = [[NSString alloc]initWithFormat:@"%d",bmr];
                NSString *bmistr = [[NSString alloc]initWithFormat:@"%.1f",bmi];
                
                NSDictionary *dataRow1 =[[NSDictionary alloc] initWithObjectsAndKeys:
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
                                         bmrstr,
                                         @"BMR",
                                         bmistr,
                                         @"BMI",
                                         testtimestr,
                                         @"TestTime",
                                         nil];
                
                [self.bodyfatdata addObject:dataRow1];
            }
        }
        sqlite3_finalize(statement);
    }
    else if([datatype isEqualToString:@"weight"])
    {
        sqlite3_stmt * statement;
        weightdata = [[NSMutableArray alloc]init];
        sql =[[NSString alloc]initWithFormat: @"SELECT WEIGHT,TESTTIME FROM WEIGHTDATA WHERE USERID = %d ORDER BY TESTTIME ASC",[MySingleton sharedSingleton].nowuserid ];
        
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                double weight = sqlite3_column_double(statement, 0);
                char *testtimechar = sqlite3_column_text(statement, 1);
                NSString *testtimestr = [[NSString  alloc]initWithFormat:@"%s",testtimechar];
                NSString *weightstr = [[NSString alloc]initWithFormat:@"%.1f",weight];
                
                NSDictionary *dataRow1 =[[NSDictionary alloc] initWithObjectsAndKeys:
                                         weightstr,
                                         @"Weight",
                                         testtimestr,
                                         @"TestTime",
                                         nil];
                
                [self.weightdata addObject:dataRow1];
            }
        }
        sqlite3_finalize(statement);
        
    }
    
    
    //关闭数据库
    sqlite3_close(database);
}

-(NSString *)dataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kSqliteFileName];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getDataFromDataBase:@"weight"];
    [self getDataFromDataBase:@"bodyfat"];
}

-(IBAction)weightbuttonPress:(id)sender
{
    if([nowdevice isEqualToString:@"bodyfat"])
    {
        [self drawWeightPlot];
    }
    else if([nowdevice isEqualToString:@"weight"])
    {
        [self drawWeightWeightPlot];
    }
//    [self dataOpt:@"bodyfat" :@"weight"];
    weightButton.titleLabel.textColor = [UIColor redColor];
    fatButton.titleLabel.textColor = [UIColor blackColor];
    visfatButton.titleLabel.textColor = [UIColor blackColor];
    waterButton.titleLabel.textColor = [UIColor blackColor];
    muscleButton.titleLabel.textColor = [UIColor blackColor];
    boneButton.titleLabel.textColor = [UIColor blackColor];
    bmiButton.titleLabel.textColor = [UIColor blackColor];
    bmrButton.titleLabel.textColor = [UIColor blackColor];
}

-(IBAction)fatbuttonPress:(id)sender
{
    [self drawFatPlot];
    weightButton.titleLabel.textColor = [UIColor blackColor];
    fatButton.titleLabel.textColor = [UIColor redColor];
    visfatButton.titleLabel.textColor = [UIColor blackColor];
    waterButton.titleLabel.textColor = [UIColor blackColor];
    muscleButton.titleLabel.textColor = [UIColor blackColor];
    boneButton.titleLabel.textColor = [UIColor blackColor];
    bmiButton.titleLabel.textColor = [UIColor blackColor];
    bmrButton.titleLabel.textColor = [UIColor blackColor];
}

-(IBAction)visfatbuttonPress:(id)sender
{
    [self drawVisceralFatPlot];
    weightButton.titleLabel.textColor = [UIColor blackColor];
    fatButton.titleLabel.textColor = [UIColor blackColor];
    visfatButton.titleLabel.textColor = [UIColor redColor];
    waterButton.titleLabel.textColor = [UIColor blackColor];
    muscleButton.titleLabel.textColor = [UIColor blackColor];
    boneButton.titleLabel.textColor = [UIColor blackColor];
    bmiButton.titleLabel.textColor = [UIColor blackColor];
    bmrButton.titleLabel.textColor = [UIColor blackColor];
}

-(IBAction)waterbuttonPress:(id)sender
{
    [self drawWaterPlot];
    weightButton.titleLabel.textColor = [UIColor blackColor];
    fatButton.titleLabel.textColor = [UIColor blackColor];
    visfatButton.titleLabel.textColor = [UIColor blackColor];
    waterButton.titleLabel.textColor = [UIColor redColor];
    muscleButton.titleLabel.textColor = [UIColor blackColor];
    boneButton.titleLabel.textColor = [UIColor blackColor];
    bmiButton.titleLabel.textColor = [UIColor blackColor];
    bmrButton.titleLabel.textColor = [UIColor blackColor];
}

-(IBAction)musclebuttonPress:(id)sender
{
    [self drawMusclePlot];
    weightButton.titleLabel.textColor = [UIColor blackColor];
    fatButton.titleLabel.textColor = [UIColor blackColor];
    visfatButton.titleLabel.textColor = [UIColor blackColor];
    waterButton.titleLabel.textColor = [UIColor blackColor];
    muscleButton.titleLabel.textColor = [UIColor redColor];
    boneButton.titleLabel.textColor = [UIColor blackColor];
    bmiButton.titleLabel.textColor = [UIColor blackColor];
    bmrButton.titleLabel.textColor = [UIColor blackColor];
}

-(IBAction)bonebuttonPress:(id)sender
{
    [self drawBonePlot];
    weightButton.titleLabel.textColor = [UIColor blackColor];
    fatButton.titleLabel.textColor = [UIColor blackColor];
    visfatButton.titleLabel.textColor = [UIColor blackColor];
    waterButton.titleLabel.textColor = [UIColor blackColor];
    muscleButton.titleLabel.textColor = [UIColor blackColor];
    boneButton.titleLabel.textColor = [UIColor redColor];
    bmiButton.titleLabel.textColor = [UIColor blackColor];
    bmrButton.titleLabel.textColor = [UIColor blackColor];
}

-(IBAction)bmibuttonPress:(id)sender
{
    [self drawBMIPlot];
    weightButton.titleLabel.textColor = [UIColor blackColor];
    fatButton.titleLabel.textColor = [UIColor blackColor];
    visfatButton.titleLabel.textColor = [UIColor blackColor];
    waterButton.titleLabel.textColor = [UIColor blackColor];
    muscleButton.titleLabel.textColor = [UIColor blackColor];
    boneButton.titleLabel.textColor = [UIColor blackColor];
    bmiButton.titleLabel.textColor = [UIColor redColor];
    bmrButton.titleLabel.textColor = [UIColor blackColor];
}

-(IBAction)bmrbuttonPress:(id)sender
{
    [self drawBMRPlot];
    weightButton.titleLabel.textColor = [UIColor blackColor];
    fatButton.titleLabel.textColor = [UIColor blackColor];
    visfatButton.titleLabel.textColor = [UIColor blackColor];
    waterButton.titleLabel.textColor = [UIColor blackColor];
    muscleButton.titleLabel.textColor = [UIColor blackColor];
    boneButton.titleLabel.textColor = [UIColor blackColor];
    bmiButton.titleLabel.textColor = [UIColor blackColor];
    bmrButton.titleLabel.textColor = [UIColor redColor];
}

-(IBAction)weightDeviceButtonPressed:(id)sender
{
    [weightDeviceButton setBackgroundImage:[UIImage imageNamed:@"Weight_button"] forState:UIControlStateNormal];
    [bodyfatDeviceButton setBackgroundImage:[UIImage imageNamed:@"Body fat_button_03"] forState:UIControlStateNormal];
    [bloodpressureDeviceButton setBackgroundImage:[UIImage imageNamed:@"Blood pressure_button_03"] forState:UIControlStateNormal];
    [glucoseDeviceButton setBackgroundImage:[UIImage imageNamed:@"Blood sugar_button_03"] forState:UIControlStateNormal];
    [oxygenDeviceButton setBackgroundImage:[UIImage imageNamed:@"Oxygen_button_03"] forState:UIControlStateNormal];
    weightButton.hidden = NO;
    fatButton.hidden = YES;
    visfatButton.hidden = YES;
    waterButton.hidden = YES;
    muscleButton.hidden = YES;
    boneButton.hidden = YES;
    bmiButton.hidden = YES;
    bmrButton.hidden = YES;
    glucoseButton.hidden = YES;
    sysButton.hidden = YES;
    diaButton.hidden = YES;
    pulseButton.hidden = YES;
    oxygenButton.hidden = YES;
    oxygenpulseButton.hidden = YES;
    
    nowdevice = @"weight";
}

-(IBAction)bodyfatDeviceButtonPressed:(id)sender
{
    [weightDeviceButton setBackgroundImage:[UIImage imageNamed:@"Weight_button_03"] forState:UIControlStateNormal];
    [bodyfatDeviceButton setBackgroundImage:[UIImage imageNamed:@"Body fat_button"] forState:UIControlStateNormal];
    [bloodpressureDeviceButton setBackgroundImage:[UIImage imageNamed:@"Blood pressure_button_03"] forState:UIControlStateNormal];
    [glucoseDeviceButton setBackgroundImage:[UIImage imageNamed:@"Blood sugar_button_03"] forState:UIControlStateNormal];
    [oxygenDeviceButton setBackgroundImage:[UIImage imageNamed:@"Oxygen_button_03"] forState:UIControlStateNormal];
    weightButton.hidden = NO;
    fatButton.hidden = NO;
    visfatButton.hidden = NO;
    waterButton.hidden = NO;
    muscleButton.hidden = NO;
    boneButton.hidden = NO;
    bmiButton.hidden = NO;
    bmrButton.hidden = NO;
    glucoseButton.hidden = YES;
    sysButton.hidden = YES;
    diaButton.hidden = YES;
    pulseButton.hidden = YES;
    oxygenButton.hidden = YES;
    oxygenpulseButton.hidden = YES;
    
    nowdevice = @"bodyfat";
}

-(IBAction)bloodpressureDeviceButtonPressed:(id)sender
{
    [weightDeviceButton setBackgroundImage:[UIImage imageNamed:@"Weight_button_03"] forState:UIControlStateNormal];
    [bodyfatDeviceButton setBackgroundImage:[UIImage imageNamed:@"Body fat_button_03"] forState:UIControlStateNormal];
    [bloodpressureDeviceButton setBackgroundImage:[UIImage imageNamed:@"Blood pressure_button"] forState:UIControlStateNormal];
    [glucoseDeviceButton setBackgroundImage:[UIImage imageNamed:@"Blood sugar_button_03"] forState:UIControlStateNormal];
    [oxygenDeviceButton setBackgroundImage:[UIImage imageNamed:@"Oxygen_button_03"] forState:UIControlStateNormal];
    weightButton.hidden = YES;
    fatButton.hidden = YES;
    visfatButton.hidden = YES;
    waterButton.hidden = YES;
    muscleButton.hidden = YES;
    boneButton.hidden = YES;
    bmiButton.hidden = YES;
    bmrButton.hidden = YES;
    glucoseButton.hidden = YES;
    sysButton.hidden = NO;
    diaButton.hidden = NO;
    pulseButton.hidden = NO;
    oxygenButton.hidden = YES;
    oxygenpulseButton.hidden = YES;
    
    nowdevice = @"bloodpress";
}

-(IBAction)glucoseDeviceButtonPressed:(id)sender
{
    [weightDeviceButton setBackgroundImage:[UIImage imageNamed:@"Weight_button_03"] forState:UIControlStateNormal];
    [bodyfatDeviceButton setBackgroundImage:[UIImage imageNamed:@"Body fat_button_03"] forState:UIControlStateNormal];
    [bloodpressureDeviceButton setBackgroundImage:[UIImage imageNamed:@"Blood pressure_button_03"] forState:UIControlStateNormal];
    [glucoseDeviceButton setBackgroundImage:[UIImage imageNamed:@"Blood sugar_button"] forState:UIControlStateNormal];
    [oxygenDeviceButton setBackgroundImage:[UIImage imageNamed:@"Oxygen_button_03"] forState:UIControlStateNormal];
    weightButton.hidden = YES;
    fatButton.hidden = YES;
    visfatButton.hidden = YES;
    waterButton.hidden = YES;
    muscleButton.hidden = YES;
    boneButton.hidden = YES;
    bmiButton.hidden = YES;
    bmrButton.hidden = YES;
    glucoseButton.hidden = NO;
    sysButton.hidden = YES;
    diaButton.hidden = YES;
    pulseButton.hidden = YES;
    oxygenButton.hidden = YES;
    oxygenpulseButton.hidden = YES;
    
    nowdevice = @"glucose";
}

-(IBAction)oxygenDeviceButtonPressed:(id)sender
{
    [weightDeviceButton setBackgroundImage:[UIImage imageNamed:@"Weight_button_03"] forState:UIControlStateNormal];
    [bodyfatDeviceButton setBackgroundImage:[UIImage imageNamed:@"Body fat_button_03"] forState:UIControlStateNormal];
    [bloodpressureDeviceButton setBackgroundImage:[UIImage imageNamed:@"Blood pressure_button_03"] forState:UIControlStateNormal];
    [glucoseDeviceButton setBackgroundImage:[UIImage imageNamed:@"Blood sugar_button_03"] forState:UIControlStateNormal];
    [oxygenDeviceButton setBackgroundImage:[UIImage imageNamed:@"Oxygen_button"] forState:UIControlStateNormal];
    weightButton.hidden = YES;
    fatButton.hidden = YES;
    visfatButton.hidden = YES;
    waterButton.hidden = YES;
    muscleButton.hidden = YES;
    boneButton.hidden = YES;
    bmiButton.hidden = YES;
    bmrButton.hidden = YES;
    glucoseButton.hidden = YES;
    sysButton.hidden = YES;
    diaButton.hidden = YES;
    pulseButton.hidden = YES;
    oxygenButton.hidden = NO;
    oxygenpulseButton.hidden = NO;
    
    nowdevice = @"oxygen";
}

-(void)drawWeightWeightPlot
{
    _dataForPlot = [[NSMutableArray alloc]init];
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    
    // Create graph from theme: 设置主题
    //
    _graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme * theme = [CPTTheme themeNamed:kCPTSlateTheme];
    //    theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    //    theme = [CPTTheme themeNamed:kCPTPlainBlackTheme];
    //    theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    //    theme = [CPTTheme themeNamed:kCPTStocksTheme];
    [_graph applyTheme:theme];
    
    CPTGraphHostingView * hostingView = (CPTGraphHostingView *)self.myview;
    hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    hostingView.hostedGraph = _graph;
    
    _graph.paddingLeft = _graph.paddingRight = 10.0;  //图的边框与视图边框之间的空隙
    _graph.paddingTop = _graph.paddingBottom = 10.0;
    _graph.plotAreaFrame.paddingLeft = 5.0 ;
    _graph.plotAreaFrame.paddingTop = 5.0 ;
    _graph.plotAreaFrame.paddingRight = 5.0 ;
    _graph.plotAreaFrame.paddingBottom = 5.0 ;
    
    // Setup plot space: 设置一屏内可显示的x,y量度范围
    //
    CPTXYPlotSpace * plotSpace = (CPTXYPlotSpace *)_graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;  //允许用户拖动视图
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(10.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(200.0)];
    
    // Axes: 设置x,y轴属性，如原点，量度间隔，标签，刻度，颜色等
    //
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)_graph.axisSet;
    
    lineStyle.miterLimit = 1.0f;
    lineStyle.lineWidth = 2.0;
    lineStyle.lineColor = [CPTColor whiteColor];
    
    CPTXYAxis * x = axisSet.xAxis;
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // 原点的 x 位置
    x.majorIntervalLength = CPTDecimalFromString(@"1");   // x轴主刻度：显示数字标签的量度间隔
    x.minorTicksPerInterval = 0;    // x轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    x.minorTickLineStyle = lineStyle;
    
    // 需要排除的不显示数字的主刻度
    NSArray * exclusionRanges = [NSArray arrayWithObjects:
                                 [self CPTPlotRangeFromFloat:0.99 length:0.02],
                                 [self CPTPlotRangeFromFloat:2.99 length:0.02],
                                 nil];
    x.labelExclusionRanges = exclusionRanges;
    
    CPTXYAxis * y = axisSet.yAxis;
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // 原点的 y 位置
    y.majorIntervalLength = CPTDecimalFromString(@"20");   // y轴主刻度：显示数字标签的量度间隔
    y.minorTicksPerInterval = 4;    // y轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    y.minorTickLineStyle = lineStyle;
    exclusionRanges = [NSArray arrayWithObjects:
                       [self CPTPlotRangeFromFloat:1.99 length:0.02],
                       [self CPTPlotRangeFromFloat:2.99 length:0.02],
                       nil];
    y.labelExclusionRanges = exclusionRanges;
    y.delegate = self;
    
    // Create a red-blue plot area
    //
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 3.0f;
    lineStyle.lineColor         = [CPTColor blueColor];
    
    CPTScatterPlot * boundLinePlot  = [[CPTScatterPlot alloc] init];
    boundLinePlot.dataLineStyle = lineStyle;
    boundLinePlot.identifier    = BLUE_PLOT_IDENTIFIER;
    boundLinePlot.dataSource    = self;
    
    // Do a red-blue gradient: 渐变色区域
    //
    CPTColor * blueColor        = [CPTColor colorWithComponentRed:0.3 green:0.3 blue:1.0 alpha:0.8];
    CPTColor * redColor         = [CPTColor colorWithComponentRed:1.0 green:0.3 blue:0.3 alpha:0.8];
    CPTGradient * areaGradient1 = [CPTGradient gradientWithBeginningColor:blueColor
                                                              endingColor:redColor];
    areaGradient1.angle = -90.0f;
    CPTFill * areaGradientFill  = [CPTFill fillWithGradient:areaGradient1];
    boundLinePlot.areaFill      = areaGradientFill;
    boundLinePlot.areaBaseValue = [[NSDecimalNumber numberWithFloat:0.0] decimalValue]; // 渐变色的起点位置
    
    // Add plot symbols: 表示数值的符号的形状
    //
    CPTMutableLineStyle * symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPTColor blackColor];
    symbolLineStyle.lineWidth = 2.0;
    
    CPTPlotSymbol * plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill          = [CPTFill fillWithColor:[CPTColor blueColor]];
    plotSymbol.lineStyle     = symbolLineStyle;
    plotSymbol.size          = CGSizeMake(5.0, 5.0);  //数据点大小
    boundLinePlot.plotSymbol = plotSymbol;
    
    [_graph addPlot:boundLinePlot];
    
    // Create a green plot area: 画破折线
    //
    lineStyle                = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth      = 3.f;
    lineStyle.lineColor      = [CPTColor greenColor];
    lineStyle.dashPattern    = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:5.0f],
                                [NSNumber numberWithFloat:5.0f], nil];
    
    
    
    if(weightdata !=nil)
    {
        for (int i = 0; i<[weightdata count]; i++) {
            NSString *xp = [NSString stringWithFormat:@"%d",i];
            NSString *yp;
            yp = [NSString stringWithFormat:@"%.1f",[[[weightdata objectAtIndex:i] objectForKey:@"Weight"] doubleValue]];
            NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
            [_dataForPlot addObject:point1];
        }
    }
    
    [_graph reloadData];
}

-(void)drawWeightPlot
{
    _dataForPlot = [[NSMutableArray alloc]init];
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    
    // Create graph from theme: 设置主题
    //
    _graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme * theme = [CPTTheme themeNamed:kCPTSlateTheme];
    //    theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    //    theme = [CPTTheme themeNamed:kCPTPlainBlackTheme];
    //    theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    //    theme = [CPTTheme themeNamed:kCPTStocksTheme];
    [_graph applyTheme:theme];
    
    CPTGraphHostingView * hostingView = (CPTGraphHostingView *)self.myview;
    hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    hostingView.hostedGraph = _graph;
    
    _graph.paddingLeft = _graph.paddingRight = 10.0;  //图的边框与视图边框之间的空隙
    _graph.paddingTop = _graph.paddingBottom = 10.0;
    _graph.plotAreaFrame.paddingLeft = 5.0 ;
    _graph.plotAreaFrame.paddingTop = 5.0 ;
    _graph.plotAreaFrame.paddingRight = 5.0 ;
    _graph.plotAreaFrame.paddingBottom = 5.0 ;
    
    // Setup plot space: 设置一屏内可显示的x,y量度范围
    //
    CPTXYPlotSpace * plotSpace = (CPTXYPlotSpace *)_graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;  //允许用户拖动视图
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(10.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(200.0)];
    
    // Axes: 设置x,y轴属性，如原点，量度间隔，标签，刻度，颜色等
    //
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)_graph.axisSet;
    
    lineStyle.miterLimit = 1.0f;
    lineStyle.lineWidth = 2.0;
    lineStyle.lineColor = [CPTColor whiteColor];
    
    CPTXYAxis * x = axisSet.xAxis;
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // 原点的 x 位置
    x.majorIntervalLength = CPTDecimalFromString(@"1");   // x轴主刻度：显示数字标签的量度间隔
    x.minorTicksPerInterval = 0;    // x轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    x.minorTickLineStyle = lineStyle;
    
    // 需要排除的不显示数字的主刻度
    NSArray * exclusionRanges = [NSArray arrayWithObjects:
                                 [self CPTPlotRangeFromFloat:0.99 length:0.02],
                                 [self CPTPlotRangeFromFloat:2.99 length:0.02],
                                 nil];
    x.labelExclusionRanges = exclusionRanges;
    
    CPTXYAxis * y = axisSet.yAxis;
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // 原点的 y 位置
    y.majorIntervalLength = CPTDecimalFromString(@"20");   // y轴主刻度：显示数字标签的量度间隔
    y.minorTicksPerInterval = 4;    // y轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    y.minorTickLineStyle = lineStyle;
    exclusionRanges = [NSArray arrayWithObjects:
                       [self CPTPlotRangeFromFloat:1.99 length:0.02],
                       [self CPTPlotRangeFromFloat:2.99 length:0.02],
                       nil];
    y.labelExclusionRanges = exclusionRanges;
    y.delegate = self;
    
    // Create a red-blue plot area
    //
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 3.0f;
    lineStyle.lineColor         = [CPTColor blueColor];
    
    CPTScatterPlot * boundLinePlot  = [[CPTScatterPlot alloc] init];
    boundLinePlot.dataLineStyle = lineStyle;
    boundLinePlot.identifier    = BLUE_PLOT_IDENTIFIER;
    boundLinePlot.dataSource    = self;
    
    // Do a red-blue gradient: 渐变色区域
    //
    CPTColor * blueColor        = [CPTColor colorWithComponentRed:0.3 green:0.3 blue:1.0 alpha:0.8];
    CPTColor * redColor         = [CPTColor colorWithComponentRed:1.0 green:0.3 blue:0.3 alpha:0.8];
    CPTGradient * areaGradient1 = [CPTGradient gradientWithBeginningColor:blueColor
                                                              endingColor:redColor];
    areaGradient1.angle = -90.0f;
    CPTFill * areaGradientFill  = [CPTFill fillWithGradient:areaGradient1];
    boundLinePlot.areaFill      = areaGradientFill;
    boundLinePlot.areaBaseValue = [[NSDecimalNumber numberWithFloat:0.0] decimalValue]; // 渐变色的起点位置
    
    // Add plot symbols: 表示数值的符号的形状
    //
    CPTMutableLineStyle * symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPTColor blackColor];
    symbolLineStyle.lineWidth = 2.0;
    
    CPTPlotSymbol * plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill          = [CPTFill fillWithColor:[CPTColor blueColor]];
    plotSymbol.lineStyle     = symbolLineStyle;
    plotSymbol.size          = CGSizeMake(5.0, 5.0);  //数据点大小
    boundLinePlot.plotSymbol = plotSymbol;
    
    [_graph addPlot:boundLinePlot];
    
    // Create a green plot area: 画破折线
    //
    lineStyle                = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth      = 3.f;
    lineStyle.lineColor      = [CPTColor greenColor];
    lineStyle.dashPattern    = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:5.0f],
                                [NSNumber numberWithFloat:5.0f], nil];
    
    
    
    if(bodyfatdata !=nil)
    {
        for (int i = 0; i<[bodyfatdata count]; i++) {
            NSString *xp = [NSString stringWithFormat:@"%d",i];
            NSString *yp;
            yp = [NSString stringWithFormat:@"%.1f",[[[bodyfatdata objectAtIndex:i] objectForKey:@"Weight"] doubleValue]];
            NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
            [_dataForPlot addObject:point1];
        }
    }
    
    [_graph reloadData];
}

-(void)drawFatPlot
{
    _dataForPlot = [[NSMutableArray alloc]init];
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    
    // Create graph from theme: 设置主题
    //
    _graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme * theme = [CPTTheme themeNamed:kCPTSlateTheme];
    //    theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    //    theme = [CPTTheme themeNamed:kCPTPlainBlackTheme];
    //    theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    //    theme = [CPTTheme themeNamed:kCPTStocksTheme];
    [_graph applyTheme:theme];
    
    CPTGraphHostingView * hostingView = (CPTGraphHostingView *)self.myview;
    hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    hostingView.hostedGraph = _graph;
    
    _graph.paddingLeft = _graph.paddingRight = 10.0;  //图的边框与视图边框之间的空隙
    _graph.paddingTop = _graph.paddingBottom = 10.0;
    _graph.plotAreaFrame.paddingLeft = 5.0 ;
    _graph.plotAreaFrame.paddingTop = 5.0 ;
    _graph.plotAreaFrame.paddingRight = 5.0 ;
    _graph.plotAreaFrame.paddingBottom = 5.0 ;
    
    // Setup plot space: 设置一屏内可显示的x,y量度范围
    //
    CPTXYPlotSpace * plotSpace = (CPTXYPlotSpace *)_graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;  //允许用户拖动视图
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(10.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(100.0)];
    
    // Axes: 设置x,y轴属性，如原点，量度间隔，标签，刻度，颜色等
    //
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)_graph.axisSet;
    
    lineStyle.miterLimit = 1.0f;
    lineStyle.lineWidth = 2.0;
    lineStyle.lineColor = [CPTColor whiteColor];
    
    CPTXYAxis * x = axisSet.xAxis;
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // 原点的 x 位置
    x.majorIntervalLength = CPTDecimalFromString(@"1");   // x轴主刻度：显示数字标签的量度间隔
    x.minorTicksPerInterval = 0;    // x轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    x.minorTickLineStyle = lineStyle;
    
    // 需要排除的不显示数字的主刻度
    NSArray * exclusionRanges = [NSArray arrayWithObjects:
                                 [self CPTPlotRangeFromFloat:0.99 length:0.02],
                                 [self CPTPlotRangeFromFloat:2.99 length:0.02],
                                 nil];
    x.labelExclusionRanges = exclusionRanges;
    
    CPTXYAxis * y = axisSet.yAxis;
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // 原点的 y 位置
    y.majorIntervalLength = CPTDecimalFromString(@"10");   // y轴主刻度：显示数字标签的量度间隔
    y.minorTicksPerInterval = 4;    // y轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    y.minorTickLineStyle = lineStyle;
    exclusionRanges = [NSArray arrayWithObjects:
                       [self CPTPlotRangeFromFloat:1.99 length:0.02],
                       [self CPTPlotRangeFromFloat:2.99 length:0.02],
                       nil];
    y.labelExclusionRanges = exclusionRanges;
    y.delegate = self;
    
    // Create a red-blue plot area
    //
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 3.0f;
    lineStyle.lineColor         = [CPTColor blueColor];
    
    CPTScatterPlot * boundLinePlot  = [[CPTScatterPlot alloc] init];
    boundLinePlot.dataLineStyle = lineStyle;
    boundLinePlot.identifier    = BLUE_PLOT_IDENTIFIER;
    boundLinePlot.dataSource    = self;
    
    // Do a red-blue gradient: 渐变色区域
    //
    CPTColor * blueColor        = [CPTColor colorWithComponentRed:0.3 green:0.3 blue:1.0 alpha:0.8];
    CPTColor * redColor         = [CPTColor colorWithComponentRed:1.0 green:0.3 blue:0.3 alpha:0.8];
    CPTGradient * areaGradient1 = [CPTGradient gradientWithBeginningColor:blueColor
                                                              endingColor:redColor];
    areaGradient1.angle = -90.0f;
    CPTFill * areaGradientFill  = [CPTFill fillWithGradient:areaGradient1];
    boundLinePlot.areaFill      = areaGradientFill;
    boundLinePlot.areaBaseValue = [[NSDecimalNumber numberWithFloat:0.0] decimalValue]; // 渐变色的起点位置
    
    // Add plot symbols: 表示数值的符号的形状
    //
    CPTMutableLineStyle * symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPTColor blackColor];
    symbolLineStyle.lineWidth = 2.0;
    
    CPTPlotSymbol * plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill          = [CPTFill fillWithColor:[CPTColor blueColor]];
    plotSymbol.lineStyle     = symbolLineStyle;
    plotSymbol.size          = CGSizeMake(5.0, 5.0);  //数据点大小
    boundLinePlot.plotSymbol = plotSymbol;
    
    [_graph addPlot:boundLinePlot];
    
    // Create a green plot area: 画破折线
    //
    lineStyle                = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth      = 3.f;
    lineStyle.lineColor      = [CPTColor greenColor];
    lineStyle.dashPattern    = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:5.0f],
                                [NSNumber numberWithFloat:5.0f], nil];
    
    if(bodyfatdata !=nil)
    {
        for (int i = 0; i<[bodyfatdata count]; i++) {
            NSString *xp = [NSString stringWithFormat:@"%d",i];
            NSString *yp;
            yp = [NSString stringWithFormat:@"%.1f",[[[bodyfatdata objectAtIndex:i] objectForKey:@"Fat"] doubleValue]];
            NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
            [_dataForPlot addObject:point1];
        }
    }
    
    [_graph reloadData];
}
-(void)drawVisceralFatPlot
{
    _dataForPlot = [[NSMutableArray alloc]init];
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    
    // Create graph from theme: 设置主题
    //
    _graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme * theme = [CPTTheme themeNamed:kCPTSlateTheme];
    //    theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    //    theme = [CPTTheme themeNamed:kCPTPlainBlackTheme];
    //    theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    //    theme = [CPTTheme themeNamed:kCPTStocksTheme];
    [_graph applyTheme:theme];
    
    CPTGraphHostingView * hostingView = (CPTGraphHostingView *)self.myview;
    hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    hostingView.hostedGraph = _graph;
    
    _graph.paddingLeft = _graph.paddingRight = 10.0;  //图的边框与视图边框之间的空隙
    _graph.paddingTop = _graph.paddingBottom = 10.0;
    _graph.plotAreaFrame.paddingLeft = 5.0 ;
    _graph.plotAreaFrame.paddingTop = 5.0 ;
    _graph.plotAreaFrame.paddingRight = 5.0 ;
    _graph.plotAreaFrame.paddingBottom = 5.0 ;
    
    // Setup plot space: 设置一屏内可显示的x,y量度范围
    //
    CPTXYPlotSpace * plotSpace = (CPTXYPlotSpace *)_graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;  //允许用户拖动视图
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(10.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(30.0)];
    
    // Axes: 设置x,y轴属性，如原点，量度间隔，标签，刻度，颜色等
    //
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)_graph.axisSet;
    
    lineStyle.miterLimit = 1.0f;
    lineStyle.lineWidth = 2.0;
    lineStyle.lineColor = [CPTColor whiteColor];
    
    CPTXYAxis * x = axisSet.xAxis;
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // 原点的 x 位置
    x.majorIntervalLength = CPTDecimalFromString(@"1");   // x轴主刻度：显示数字标签的量度间隔
    x.minorTicksPerInterval = 0;    // x轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    x.minorTickLineStyle = lineStyle;
    
    // 需要排除的不显示数字的主刻度
    NSArray * exclusionRanges = [NSArray arrayWithObjects:
                                 [self CPTPlotRangeFromFloat:0.99 length:0.02],
                                 [self CPTPlotRangeFromFloat:2.99 length:0.02],
                                 nil];
    x.labelExclusionRanges = exclusionRanges;
    
    CPTXYAxis * y = axisSet.yAxis;
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // 原点的 y 位置
    y.majorIntervalLength = CPTDecimalFromString(@"5");   // y轴主刻度：显示数字标签的量度间隔
    y.minorTicksPerInterval = 4;    // y轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    y.minorTickLineStyle = lineStyle;
    exclusionRanges = [NSArray arrayWithObjects:
                       [self CPTPlotRangeFromFloat:1.99 length:0.02],
                       [self CPTPlotRangeFromFloat:2.99 length:0.02],
                       nil];
    y.labelExclusionRanges = exclusionRanges;
    y.delegate = self;
    
    // Create a red-blue plot area
    //
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 3.0f;
    lineStyle.lineColor         = [CPTColor blueColor];
    
    CPTScatterPlot * boundLinePlot  = [[CPTScatterPlot alloc] init];
    boundLinePlot.dataLineStyle = lineStyle;
    boundLinePlot.identifier    = BLUE_PLOT_IDENTIFIER;
    boundLinePlot.dataSource    = self;
    
    // Do a red-blue gradient: 渐变色区域
    //
    CPTColor * blueColor        = [CPTColor colorWithComponentRed:0.3 green:0.3 blue:1.0 alpha:0.8];
    CPTColor * redColor         = [CPTColor colorWithComponentRed:1.0 green:0.3 blue:0.3 alpha:0.8];
    CPTGradient * areaGradient1 = [CPTGradient gradientWithBeginningColor:blueColor
                                                              endingColor:redColor];
    areaGradient1.angle = -90.0f;
    CPTFill * areaGradientFill  = [CPTFill fillWithGradient:areaGradient1];
    boundLinePlot.areaFill      = areaGradientFill;
    boundLinePlot.areaBaseValue = [[NSDecimalNumber numberWithFloat:0.0] decimalValue]; // 渐变色的起点位置
    
    // Add plot symbols: 表示数值的符号的形状
    //
    CPTMutableLineStyle * symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPTColor blackColor];
    symbolLineStyle.lineWidth = 2.0;
    
    CPTPlotSymbol * plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill          = [CPTFill fillWithColor:[CPTColor blueColor]];
    plotSymbol.lineStyle     = symbolLineStyle;
    plotSymbol.size          = CGSizeMake(5.0, 5.0);  //数据点大小
    boundLinePlot.plotSymbol = plotSymbol;
    
    [_graph addPlot:boundLinePlot];
    
    // Create a green plot area: 画破折线
    //
    lineStyle                = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth      = 3.f;
    lineStyle.lineColor      = [CPTColor greenColor];
    lineStyle.dashPattern    = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:5.0f],
                                [NSNumber numberWithFloat:5.0f], nil];
    
    if(bodyfatdata !=nil)
    {
        for (int i = 0; i<[bodyfatdata count]; i++) {
            NSString *xp = [NSString stringWithFormat:@"%d",i];
            NSString *yp;
            yp = [NSString stringWithFormat:@"%.1f",[[[bodyfatdata objectAtIndex:i] objectForKey:@"VisceralFat"] doubleValue]];
            NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
            [_dataForPlot addObject:point1];
        }
    }
    
    [_graph reloadData];
}
-(void)drawWaterPlot
{
    _dataForPlot = [[NSMutableArray alloc]init];
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    
    // Create graph from theme: 设置主题
    //
    _graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme * theme = [CPTTheme themeNamed:kCPTSlateTheme];
    //    theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    //    theme = [CPTTheme themeNamed:kCPTPlainBlackTheme];
    //    theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    //    theme = [CPTTheme themeNamed:kCPTStocksTheme];
    [_graph applyTheme:theme];
    
    CPTGraphHostingView * hostingView = (CPTGraphHostingView *)self.myview;
    hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    hostingView.hostedGraph = _graph;
    
    _graph.paddingLeft = _graph.paddingRight = 10.0;  //图的边框与视图边框之间的空隙
    _graph.paddingTop = _graph.paddingBottom = 10.0;
    _graph.plotAreaFrame.paddingLeft = 5.0 ;
    _graph.plotAreaFrame.paddingTop = 5.0 ;
    _graph.plotAreaFrame.paddingRight = 5.0 ;
    _graph.plotAreaFrame.paddingBottom = 5.0 ;
    
    // Setup plot space: 设置一屏内可显示的x,y量度范围
    //
    CPTXYPlotSpace * plotSpace = (CPTXYPlotSpace *)_graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;  //允许用户拖动视图
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(10.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(100.0)];
    
    // Axes: 设置x,y轴属性，如原点，量度间隔，标签，刻度，颜色等
    //
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)_graph.axisSet;
    
    lineStyle.miterLimit = 1.0f;
    lineStyle.lineWidth = 2.0;
    lineStyle.lineColor = [CPTColor whiteColor];
    
    CPTXYAxis * x = axisSet.xAxis;
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // 原点的 x 位置
    x.majorIntervalLength = CPTDecimalFromString(@"1");   // x轴主刻度：显示数字标签的量度间隔
    x.minorTicksPerInterval = 0;    // x轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    x.minorTickLineStyle = lineStyle;
    
    // 需要排除的不显示数字的主刻度
    NSArray * exclusionRanges = [NSArray arrayWithObjects:
                                 [self CPTPlotRangeFromFloat:0.99 length:0.02],
                                 [self CPTPlotRangeFromFloat:2.99 length:0.02],
                                 nil];
    x.labelExclusionRanges = exclusionRanges;
    
    CPTXYAxis * y = axisSet.yAxis;
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // 原点的 y 位置
    y.majorIntervalLength = CPTDecimalFromString(@"10");   // y轴主刻度：显示数字标签的量度间隔
    y.minorTicksPerInterval = 4;    // y轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    y.minorTickLineStyle = lineStyle;
    exclusionRanges = [NSArray arrayWithObjects:
                       [self CPTPlotRangeFromFloat:1.99 length:0.02],
                       [self CPTPlotRangeFromFloat:2.99 length:0.02],
                       nil];
    y.labelExclusionRanges = exclusionRanges;
    y.delegate = self;
    
    // Create a red-blue plot area
    //
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 3.0f;
    lineStyle.lineColor         = [CPTColor blueColor];
    
    CPTScatterPlot * boundLinePlot  = [[CPTScatterPlot alloc] init];
    boundLinePlot.dataLineStyle = lineStyle;
    boundLinePlot.identifier    = BLUE_PLOT_IDENTIFIER;
    boundLinePlot.dataSource    = self;
    
    // Do a red-blue gradient: 渐变色区域
    //
    CPTColor * blueColor        = [CPTColor colorWithComponentRed:0.3 green:0.3 blue:1.0 alpha:0.8];
    CPTColor * redColor         = [CPTColor colorWithComponentRed:1.0 green:0.3 blue:0.3 alpha:0.8];
    CPTGradient * areaGradient1 = [CPTGradient gradientWithBeginningColor:blueColor
                                                              endingColor:redColor];
    areaGradient1.angle = -90.0f;
    CPTFill * areaGradientFill  = [CPTFill fillWithGradient:areaGradient1];
    boundLinePlot.areaFill      = areaGradientFill;
    boundLinePlot.areaBaseValue = [[NSDecimalNumber numberWithFloat:0.0] decimalValue]; // 渐变色的起点位置
    
    // Add plot symbols: 表示数值的符号的形状
    //
    CPTMutableLineStyle * symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPTColor blackColor];
    symbolLineStyle.lineWidth = 2.0;
    
    CPTPlotSymbol * plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill          = [CPTFill fillWithColor:[CPTColor blueColor]];
    plotSymbol.lineStyle     = symbolLineStyle;
    plotSymbol.size          = CGSizeMake(5.0, 5.0);  //数据点大小
    boundLinePlot.plotSymbol = plotSymbol;
    
    [_graph addPlot:boundLinePlot];
    
    // Create a green plot area: 画破折线
    //
    lineStyle                = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth      = 3.f;
    lineStyle.lineColor      = [CPTColor greenColor];
    lineStyle.dashPattern    = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:5.0f],
                                [NSNumber numberWithFloat:5.0f], nil];
    
    if(bodyfatdata !=nil)
    {
        for (int i = 0; i<[bodyfatdata count]; i++) {
            NSString *xp = [NSString stringWithFormat:@"%d",i];
            NSString *yp;
            yp = [NSString stringWithFormat:@"%.1f",[[[bodyfatdata objectAtIndex:i] objectForKey:@"Water"] doubleValue]];
            NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
            [_dataForPlot addObject:point1];
        }
    }
    
    [_graph reloadData];
}
-(void)drawMusclePlot
{
    _dataForPlot = [[NSMutableArray alloc]init];
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    
    // Create graph from theme: 设置主题
    //
    _graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme * theme = [CPTTheme themeNamed:kCPTSlateTheme];
    //    theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    //    theme = [CPTTheme themeNamed:kCPTPlainBlackTheme];
    //    theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    //    theme = [CPTTheme themeNamed:kCPTStocksTheme];
    [_graph applyTheme:theme];
    
    CPTGraphHostingView * hostingView = (CPTGraphHostingView *)self.myview;
    hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    hostingView.hostedGraph = _graph;
    
    _graph.paddingLeft = _graph.paddingRight = 10.0;  //图的边框与视图边框之间的空隙
    _graph.paddingTop = _graph.paddingBottom = 10.0;
    _graph.plotAreaFrame.paddingLeft = 5.0 ;
    _graph.plotAreaFrame.paddingTop = 5.0 ;
    _graph.plotAreaFrame.paddingRight = 5.0 ;
    _graph.plotAreaFrame.paddingBottom = 5.0 ;
    
    // Setup plot space: 设置一屏内可显示的x,y量度范围
    //
    CPTXYPlotSpace * plotSpace = (CPTXYPlotSpace *)_graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;  //允许用户拖动视图
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(10.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(50.0)];
    
    // Axes: 设置x,y轴属性，如原点，量度间隔，标签，刻度，颜色等
    //
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)_graph.axisSet;
    
    lineStyle.miterLimit = 1.0f;
    lineStyle.lineWidth = 2.0;
    lineStyle.lineColor = [CPTColor whiteColor];
    
    CPTXYAxis * x = axisSet.xAxis;
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // 原点的 x 位置
    x.majorIntervalLength = CPTDecimalFromString(@"1");   // x轴主刻度：显示数字标签的量度间隔
    x.minorTicksPerInterval = 0;    // x轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    x.minorTickLineStyle = lineStyle;
    
    // 需要排除的不显示数字的主刻度
    NSArray * exclusionRanges = [NSArray arrayWithObjects:
                                 [self CPTPlotRangeFromFloat:0.99 length:0.02],
                                 [self CPTPlotRangeFromFloat:2.99 length:0.02],
                                 nil];
    x.labelExclusionRanges = exclusionRanges;
    
    CPTXYAxis * y = axisSet.yAxis;
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // 原点的 y 位置
    y.majorIntervalLength = CPTDecimalFromString(@"5");   // y轴主刻度：显示数字标签的量度间隔
    y.minorTicksPerInterval = 4;    // y轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    y.minorTickLineStyle = lineStyle;
    exclusionRanges = [NSArray arrayWithObjects:
                       [self CPTPlotRangeFromFloat:1.99 length:0.02],
                       [self CPTPlotRangeFromFloat:2.99 length:0.02],
                       nil];
    y.labelExclusionRanges = exclusionRanges;
    y.delegate = self;
    
    // Create a red-blue plot area
    //
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 3.0f;
    lineStyle.lineColor         = [CPTColor blueColor];
    
    CPTScatterPlot * boundLinePlot  = [[CPTScatterPlot alloc] init];
    boundLinePlot.dataLineStyle = lineStyle;
    boundLinePlot.identifier    = BLUE_PLOT_IDENTIFIER;
    boundLinePlot.dataSource    = self;
    
    // Do a red-blue gradient: 渐变色区域
    //
    CPTColor * blueColor        = [CPTColor colorWithComponentRed:0.3 green:0.3 blue:1.0 alpha:0.8];
    CPTColor * redColor         = [CPTColor colorWithComponentRed:1.0 green:0.3 blue:0.3 alpha:0.8];
    CPTGradient * areaGradient1 = [CPTGradient gradientWithBeginningColor:blueColor
                                                              endingColor:redColor];
    areaGradient1.angle = -90.0f;
    CPTFill * areaGradientFill  = [CPTFill fillWithGradient:areaGradient1];
    boundLinePlot.areaFill      = areaGradientFill;
    boundLinePlot.areaBaseValue = [[NSDecimalNumber numberWithFloat:0.0] decimalValue]; // 渐变色的起点位置
    
    // Add plot symbols: 表示数值的符号的形状
    //
    CPTMutableLineStyle * symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPTColor blackColor];
    symbolLineStyle.lineWidth = 2.0;
    
    CPTPlotSymbol * plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill          = [CPTFill fillWithColor:[CPTColor blueColor]];
    plotSymbol.lineStyle     = symbolLineStyle;
    plotSymbol.size          = CGSizeMake(5.0, 5.0);  //数据点大小
    boundLinePlot.plotSymbol = plotSymbol;
    
    [_graph addPlot:boundLinePlot];
    
    // Create a green plot area: 画破折线
    //
    lineStyle                = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth      = 3.f;
    lineStyle.lineColor      = [CPTColor greenColor];
    lineStyle.dashPattern    = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:5.0f],
                                [NSNumber numberWithFloat:5.0f], nil];
    
    if(bodyfatdata !=nil)
    {
        for (int i = 0; i<[bodyfatdata count]; i++) {
            NSString *xp = [NSString stringWithFormat:@"%d",i];
            NSString *yp;
            yp = [NSString stringWithFormat:@"%.1f",[[[bodyfatdata objectAtIndex:i] objectForKey:@"Muscle"] doubleValue]];
            NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
            [_dataForPlot addObject:point1];
        }
    }
    
    [_graph reloadData];
}
-(void)drawBonePlot
{
    _dataForPlot = [[NSMutableArray alloc]init];
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    
    // Create graph from theme: 设置主题
    //
    _graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme * theme = [CPTTheme themeNamed:kCPTSlateTheme];
    //    theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    //    theme = [CPTTheme themeNamed:kCPTPlainBlackTheme];
    //    theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    //    theme = [CPTTheme themeNamed:kCPTStocksTheme];
    [_graph applyTheme:theme];
    
    CPTGraphHostingView * hostingView = (CPTGraphHostingView *)self.myview;
    hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    hostingView.hostedGraph = _graph;
    
    _graph.paddingLeft = _graph.paddingRight = 10.0;  //图的边框与视图边框之间的空隙
    _graph.paddingTop = _graph.paddingBottom = 10.0;
    _graph.plotAreaFrame.paddingLeft = 5.0 ;
    _graph.plotAreaFrame.paddingTop = 5.0 ;
    _graph.plotAreaFrame.paddingRight = 5.0 ;
    _graph.plotAreaFrame.paddingBottom = 5.0 ;
    
    // Setup plot space: 设置一屏内可显示的x,y量度范围
    //
    CPTXYPlotSpace * plotSpace = (CPTXYPlotSpace *)_graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;  //允许用户拖动视图
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(10.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(10.0)];
    
    // Axes: 设置x,y轴属性，如原点，量度间隔，标签，刻度，颜色等
    //
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)_graph.axisSet;
    
    lineStyle.miterLimit = 1.0f;
    lineStyle.lineWidth = 2.0;
    lineStyle.lineColor = [CPTColor whiteColor];
    
    CPTXYAxis * x = axisSet.xAxis;
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // 原点的 x 位置
    x.majorIntervalLength = CPTDecimalFromString(@"1");   // x轴主刻度：显示数字标签的量度间隔
    x.minorTicksPerInterval = 0;    // x轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    x.minorTickLineStyle = lineStyle;
    
    // 需要排除的不显示数字的主刻度
    NSArray * exclusionRanges = [NSArray arrayWithObjects:
                                 [self CPTPlotRangeFromFloat:0.99 length:0.02],
                                 [self CPTPlotRangeFromFloat:2.99 length:0.02],
                                 nil];
    x.labelExclusionRanges = exclusionRanges;
    
    CPTXYAxis * y = axisSet.yAxis;
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // 原点的 y 位置
    y.majorIntervalLength = CPTDecimalFromString(@"1");   // y轴主刻度：显示数字标签的量度间隔
    y.minorTicksPerInterval = 4;    // y轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    y.minorTickLineStyle = lineStyle;
    exclusionRanges = [NSArray arrayWithObjects:
                       [self CPTPlotRangeFromFloat:1.99 length:0.02],
                       [self CPTPlotRangeFromFloat:2.99 length:0.02],
                       nil];
    y.labelExclusionRanges = exclusionRanges;
    y.delegate = self;
    
    // Create a red-blue plot area
    //
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 3.0f;
    lineStyle.lineColor         = [CPTColor blueColor];
    
    CPTScatterPlot * boundLinePlot  = [[CPTScatterPlot alloc] init];
    boundLinePlot.dataLineStyle = lineStyle;
    boundLinePlot.identifier    = BLUE_PLOT_IDENTIFIER;
    boundLinePlot.dataSource    = self;
    
    // Do a red-blue gradient: 渐变色区域
    //
    CPTColor * blueColor        = [CPTColor colorWithComponentRed:0.3 green:0.3 blue:1.0 alpha:0.8];
    CPTColor * redColor         = [CPTColor colorWithComponentRed:1.0 green:0.3 blue:0.3 alpha:0.8];
    CPTGradient * areaGradient1 = [CPTGradient gradientWithBeginningColor:blueColor
                                                              endingColor:redColor];
    areaGradient1.angle = -90.0f;
    CPTFill * areaGradientFill  = [CPTFill fillWithGradient:areaGradient1];
    boundLinePlot.areaFill      = areaGradientFill;
    boundLinePlot.areaBaseValue = [[NSDecimalNumber numberWithFloat:0.0] decimalValue]; // 渐变色的起点位置
    
    // Add plot symbols: 表示数值的符号的形状
    //
    CPTMutableLineStyle * symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPTColor blackColor];
    symbolLineStyle.lineWidth = 2.0;
    
    CPTPlotSymbol * plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill          = [CPTFill fillWithColor:[CPTColor blueColor]];
    plotSymbol.lineStyle     = symbolLineStyle;
    plotSymbol.size          = CGSizeMake(5.0, 5.0);  //数据点大小
    boundLinePlot.plotSymbol = plotSymbol;
    
    [_graph addPlot:boundLinePlot];
    
    // Create a green plot area: 画破折线
    //
    lineStyle                = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth      = 3.f;
    lineStyle.lineColor      = [CPTColor greenColor];
    lineStyle.dashPattern    = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:5.0f],
                                [NSNumber numberWithFloat:5.0f], nil];
    
    if(bodyfatdata !=nil)
    {
        for (int i = 0; i<[bodyfatdata count]; i++) {
            NSString *xp = [NSString stringWithFormat:@"%d",i];
            NSString *yp;
            yp = [NSString stringWithFormat:@"%.1f",[[[bodyfatdata objectAtIndex:i] objectForKey:@"Bone"] doubleValue]];
            NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
            [_dataForPlot addObject:point1];
        }
    }
    
    [_graph reloadData];
}
-(void)drawBMIPlot
{
    _dataForPlot = [[NSMutableArray alloc]init];
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    
    // Create graph from theme: 设置主题
    //
    _graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme * theme = [CPTTheme themeNamed:kCPTSlateTheme];
    //    theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    //    theme = [CPTTheme themeNamed:kCPTPlainBlackTheme];
    //    theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    //    theme = [CPTTheme themeNamed:kCPTStocksTheme];
    [_graph applyTheme:theme];
    
    CPTGraphHostingView * hostingView = (CPTGraphHostingView *)self.myview;
    hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    hostingView.hostedGraph = _graph;
    
    _graph.paddingLeft = _graph.paddingRight = 10.0;  //图的边框与视图边框之间的空隙
    _graph.paddingTop = _graph.paddingBottom = 10.0;
    _graph.plotAreaFrame.paddingLeft = 5.0 ;
    _graph.plotAreaFrame.paddingTop = 5.0 ;
    _graph.plotAreaFrame.paddingRight = 5.0 ;
    _graph.plotAreaFrame.paddingBottom = 5.0 ;
    
    // Setup plot space: 设置一屏内可显示的x,y量度范围
    //
    CPTXYPlotSpace * plotSpace = (CPTXYPlotSpace *)_graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;  //允许用户拖动视图
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(10.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(50.0)];
    
    // Axes: 设置x,y轴属性，如原点，量度间隔，标签，刻度，颜色等
    //
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)_graph.axisSet;
    
    lineStyle.miterLimit = 1.0f;
    lineStyle.lineWidth = 2.0;
    lineStyle.lineColor = [CPTColor whiteColor];
    
    CPTXYAxis * x = axisSet.xAxis;
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // 原点的 x 位置
    x.majorIntervalLength = CPTDecimalFromString(@"1");   // x轴主刻度：显示数字标签的量度间隔
    x.minorTicksPerInterval = 0;    // x轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    x.minorTickLineStyle = lineStyle;
    
    // 需要排除的不显示数字的主刻度
    NSArray * exclusionRanges = [NSArray arrayWithObjects:
                                 [self CPTPlotRangeFromFloat:0.99 length:0.02],
                                 [self CPTPlotRangeFromFloat:2.99 length:0.02],
                                 nil];
    x.labelExclusionRanges = exclusionRanges;
    
    CPTXYAxis * y = axisSet.yAxis;
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // 原点的 y 位置
    y.majorIntervalLength = CPTDecimalFromString(@"5");   // y轴主刻度：显示数字标签的量度间隔
    y.minorTicksPerInterval = 4;    // y轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    y.minorTickLineStyle = lineStyle;
    exclusionRanges = [NSArray arrayWithObjects:
                       [self CPTPlotRangeFromFloat:1.99 length:0.02],
                       [self CPTPlotRangeFromFloat:2.99 length:0.02],
                       nil];
    y.labelExclusionRanges = exclusionRanges;
    y.delegate = self;
    
    // Create a red-blue plot area
    //
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 3.0f;
    lineStyle.lineColor         = [CPTColor blueColor];
    
    CPTScatterPlot * boundLinePlot  = [[CPTScatterPlot alloc] init];
    boundLinePlot.dataLineStyle = lineStyle;
    boundLinePlot.identifier    = BLUE_PLOT_IDENTIFIER;
    boundLinePlot.dataSource    = self;
    
    // Do a red-blue gradient: 渐变色区域
    //
    CPTColor * blueColor        = [CPTColor colorWithComponentRed:0.3 green:0.3 blue:1.0 alpha:0.8];
    CPTColor * redColor         = [CPTColor colorWithComponentRed:1.0 green:0.3 blue:0.3 alpha:0.8];
    CPTGradient * areaGradient1 = [CPTGradient gradientWithBeginningColor:blueColor
                                                              endingColor:redColor];
    areaGradient1.angle = -90.0f;
    CPTFill * areaGradientFill  = [CPTFill fillWithGradient:areaGradient1];
    boundLinePlot.areaFill      = areaGradientFill;
    boundLinePlot.areaBaseValue = [[NSDecimalNumber numberWithFloat:0.0] decimalValue]; // 渐变色的起点位置
    
    // Add plot symbols: 表示数值的符号的形状
    //
    CPTMutableLineStyle * symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPTColor blackColor];
    symbolLineStyle.lineWidth = 2.0;
    
    CPTPlotSymbol * plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill          = [CPTFill fillWithColor:[CPTColor blueColor]];
    plotSymbol.lineStyle     = symbolLineStyle;
    plotSymbol.size          = CGSizeMake(5.0, 5.0);  //数据点大小
    boundLinePlot.plotSymbol = plotSymbol;
    
    [_graph addPlot:boundLinePlot];
    
    // Create a green plot area: 画破折线
    //
    lineStyle                = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth      = 3.f;
    lineStyle.lineColor      = [CPTColor greenColor];
    lineStyle.dashPattern    = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:5.0f],
                                [NSNumber numberWithFloat:5.0f], nil];
    
    if(bodyfatdata !=nil)
    {
        for (int i = 0; i<[bodyfatdata count]; i++) {
            NSString *xp = [NSString stringWithFormat:@"%d",i];
            NSString *yp;
            yp = [NSString stringWithFormat:@"%.1f",[[[bodyfatdata objectAtIndex:i] objectForKey:@"BMI"] doubleValue]];
            NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
            [_dataForPlot addObject:point1];
        }
    }
    
    [_graph reloadData];
}

-(void)drawBMRPlot
{
    _dataForPlot = [[NSMutableArray alloc]init];
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    
    // Create graph from theme: 设置主题
    //
    _graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme * theme = [CPTTheme themeNamed:kCPTSlateTheme];
    //    theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    //    theme = [CPTTheme themeNamed:kCPTPlainBlackTheme];
    //    theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    //    theme = [CPTTheme themeNamed:kCPTStocksTheme];
    [_graph applyTheme:theme];
    
    CPTGraphHostingView * hostingView = (CPTGraphHostingView *)self.myview;
    hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    hostingView.hostedGraph = _graph;
    
    _graph.paddingLeft = _graph.paddingRight = 10.0;  //图的边框与视图边框之间的空隙
    _graph.paddingTop = _graph.paddingBottom = 10.0;
    _graph.plotAreaFrame.paddingLeft = 5.0 ;
    _graph.plotAreaFrame.paddingTop = 5.0 ;
    _graph.plotAreaFrame.paddingRight = 5.0 ;
    _graph.plotAreaFrame.paddingBottom = 5.0 ;
    
    // Setup plot space: 设置一屏内可显示的x,y量度范围
    //
    CPTXYPlotSpace * plotSpace = (CPTXYPlotSpace *)_graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;  //允许用户拖动视图
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(10.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(2000.0)];
    
    // Axes: 设置x,y轴属性，如原点，量度间隔，标签，刻度，颜色等
    //
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)_graph.axisSet;
    
    lineStyle.miterLimit = 1.0f;
    lineStyle.lineWidth = 2.0;
    lineStyle.lineColor = [CPTColor whiteColor];
    
    CPTXYAxis * x = axisSet.xAxis;
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // 原点的 x 位置
    x.majorIntervalLength = CPTDecimalFromString(@"1");   // x轴主刻度：显示数字标签的量度间隔
    x.minorTicksPerInterval = 0;    // x轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    x.minorTickLineStyle = lineStyle;
    
    // 需要排除的不显示数字的主刻度
    NSArray * exclusionRanges = [NSArray arrayWithObjects:
                                 [self CPTPlotRangeFromFloat:0.99 length:0.02],
                                 [self CPTPlotRangeFromFloat:2.99 length:0.02],
                                 nil];
    x.labelExclusionRanges = exclusionRanges;
    
    CPTXYAxis * y = axisSet.yAxis;
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0"); // 原点的 y 位置
    y.majorIntervalLength = CPTDecimalFromString(@"200");   // y轴主刻度：显示数字标签的量度间隔
    y.minorTicksPerInterval = 4;    // y轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    y.minorTickLineStyle = lineStyle;
    exclusionRanges = [NSArray arrayWithObjects:
                       [self CPTPlotRangeFromFloat:1.99 length:0.02],
                       [self CPTPlotRangeFromFloat:2.99 length:0.02],
                       nil];
    y.labelExclusionRanges = exclusionRanges;
    y.delegate = self;
    
    // Create a red-blue plot area
    //
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 3.0f;
    lineStyle.lineColor         = [CPTColor blueColor];
    
    CPTScatterPlot * boundLinePlot  = [[CPTScatterPlot alloc] init];
    boundLinePlot.dataLineStyle = lineStyle;
    boundLinePlot.identifier    = BLUE_PLOT_IDENTIFIER;
    boundLinePlot.dataSource    = self;
    
    // Do a red-blue gradient: 渐变色区域
    //
    CPTColor * blueColor        = [CPTColor colorWithComponentRed:0.3 green:0.3 blue:1.0 alpha:0.8];
    CPTColor * redColor         = [CPTColor colorWithComponentRed:1.0 green:0.3 blue:0.3 alpha:0.8];
    CPTGradient * areaGradient1 = [CPTGradient gradientWithBeginningColor:blueColor
                                                              endingColor:redColor];
    areaGradient1.angle = -90.0f;
    CPTFill * areaGradientFill  = [CPTFill fillWithGradient:areaGradient1];
    boundLinePlot.areaFill      = areaGradientFill;
    boundLinePlot.areaBaseValue = [[NSDecimalNumber numberWithFloat:0.0] decimalValue]; // 渐变色的起点位置
    
    // Add plot symbols: 表示数值的符号的形状
    //
    CPTMutableLineStyle * symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPTColor blackColor];
    symbolLineStyle.lineWidth = 2.0;
    
    CPTPlotSymbol * plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill          = [CPTFill fillWithColor:[CPTColor blueColor]];
    plotSymbol.lineStyle     = symbolLineStyle;
    plotSymbol.size          = CGSizeMake(5.0, 5.0);  //数据点大小
    boundLinePlot.plotSymbol = plotSymbol;
    
    [_graph addPlot:boundLinePlot];
    
    // Create a green plot area: 画破折线
    //
    lineStyle                = [CPTMutableLineStyle lineStyle];
    lineStyle.lineWidth      = 3.f;
    lineStyle.lineColor      = [CPTColor greenColor];
    lineStyle.dashPattern    = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:5.0f],
                                [NSNumber numberWithFloat:5.0f], nil];
    
    if(bodyfatdata !=nil)
    {
        for (int i = 0; i<[bodyfatdata count]; i++) {
            NSString *xp = [NSString stringWithFormat:@"%d",i];
            NSString *yp;
            yp = [NSString stringWithFormat:@"%.1f",[[[bodyfatdata objectAtIndex:i] objectForKey:@"BMR"] doubleValue]];
            NSMutableDictionary *point1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:xp, @"x", yp, @"y", nil];
            [_dataForPlot addObject:point1];
        }
    }
    
    [_graph reloadData];
}

@end
