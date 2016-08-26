//
//  ViewController.m
//  CMPedometerDemo
//
//  Created by 徐巧霞 on 16/8/9.
//  Copyright © 2016年 徐巧霞. All rights reserved.
//

#import "ViewController.h"
#import "StepModel.h"
#import <CoreMotion/CoreMotion.h>
#import "CircleView.h"
@interface ViewController ()
{
    UILabel *variableLable;
    UILabel *variableLable1;
    UIButton *btn;
    
    CMPedometer *cmPedometer;
    CMStepCounter *cmStepCounter;
    
    NSInteger lastStepCount;
    float lastStepDis;
    
    //上次清零时间
    NSDate *lastCheckedTime;
    
    CircleView *circleView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    lastCheckedTime = nil;
    
    [self initViews];
    
    circleView = [[CircleView alloc] initWithFrame:CGRectMake(0, 30, 200, 200)];
    circleView.percent = 0.0;

    [self.view addSubview:circleView];
    circleView.backgroundColor = [UIColor whiteColor];
}

- (void)initViews{
    variableLable = [[UILabel alloc]initWithFrame:CGRectMake(10,420,220,40)];
    variableLable.text = @"步数:0";
    variableLable.backgroundColor = [UIColor grayColor];
    variableLable.textColor = [UIColor orangeColor];
    variableLable.textAlignment = NSTextAlignmentCenter;
    variableLable.font = [UIFont systemFontOfSize:22];
    [self.view addSubview:variableLable];
    
    
    variableLable1 = [[UILabel alloc]initWithFrame:CGRectMake(10,470,220,40)];
    variableLable1.text = @"距离:0";
    variableLable1.backgroundColor = [UIColor grayColor];
    variableLable1.textColor = [UIColor orangeColor];
    variableLable1.textAlignment = NSTextAlignmentCenter;
    variableLable1.font = [UIFont systemFontOfSize:22];
    [self.view addSubview:variableLable1];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(10, 370, 220, 40);
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
    [btn setTitle:@"Start" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
}

-(void)btnClick
{
    if ([btn.titleLabel.text isEqualToString:@"Start"]) {
        [btn setTitle:@"Stop" forState:(UIControlStateNormal)];
        
        [StepModel shareStepModel].isStart = YES;
        
        [self startStepCount];
        
        
    }else{
        [btn setTitle:@"Start" forState:(UIControlStateNormal)];
        
        [self stopStepCount];
        
    }
    
}

- (void)startStepCount{
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now];
    components.hour = 0;
    components.minute = 0;
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    
    __block typeof(self) weakSelf = self;
    
//    __block ViewController *weakSelf = self;

    if ([CMPedometer isStepCountingAvailable]) {
        cmPedometer = [[CMPedometer alloc] init];
        
        [cmPedometer queryPedometerDataFromDate:startDate toDate:endDate withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            
            [weakSelf checkNewDay];
            
            if (error) {
                NSLog(@"出错了");
            }else{
                NSLog(@"%@", pedometerData);
                StepModel *model = [StepModel shareStepModel];
                model.stepCount = [pedometerData.numberOfSteps integerValue];
                model.stepDis = [pedometerData.distance floatValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updateSetp: model.stepCount andDistanceper: model.stepDis];
                });
            }
        }];

        
        [cmPedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            
            [weakSelf checkNewDay];

            NSLog(@"%@", pedometerData);
            StepModel *model = [StepModel shareStepModel];
            model.stepCount += [pedometerData.numberOfSteps integerValue] - lastStepCount;
            model.stepDis += [pedometerData.distance floatValue] - lastStepDis;
            lastStepCount = [pedometerData.numberOfSteps integerValue];
            lastStepDis = [pedometerData.distance floatValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateSetp: model.stepCount andDistanceper: model.stepDis];
            });
            
            
        } ];

   }
    
//    if ([CMStepCounter isStepCountingAvailable]) {
//        cmStepCounter = [[CMStepCounter alloc] init];
//        
//        [cmStepCounter queryStepCountStartingFrom:startDate to:endDate toQueue:[[NSOperationQueue alloc] init] withHandler:^(NSInteger numberOfSteps, NSError * _Nullable error) {
//
//            if (error) {
//                NSLog(@"%@", error.localizedDescription);
//            }else{
////                stepCount = numberOfSteps;
//                StepModel *model = [StepModel shareStepModel];
//                model.stepCount = numberOfSteps;
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self updateSetp: model.stepCount andDistanceper: model.stepDis];
//                });
//                NSLog(@"cmStepCounter  Today %ld", numberOfSteps);
//            }
//
//        }];
//    
//    
//        [cmStepCounter startStepCountingUpdatesToQueue:[[NSOperationQueue alloc] init] updateOn:1 withHandler:^(NSInteger numberOfSteps, NSDate * _Nonnull timestamp, NSError * _Nullable error) {
//
//            NSLog(@"%ld", numberOfSteps);
//            StepModel *model = [StepModel shareStepModel];
//            model.stepCount += numberOfSteps - lastStepCount;
//            lastStepCount = numberOfSteps;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self updateSetp: model.stepCount andDistanceper: model.stepDis];
//            });
//            NSLog(@"cmStepCounter Moment %ld", numberOfSteps - lastStepCount);
//        }];
//        
//
//
//    }
    
}


- (void)stopStepCount{
    
    if ([CMPedometer isStepCountingAvailable]) {
        [cmPedometer stopPedometerUpdates];
        cmPedometer = nil;
    }
    
//    if ([CMStepCounter isStepCountingAvailable]) {
//        [cmStepCounter stopStepCountingUpdates];
//        cmStepCounter = nil;
//    }
    
    lastStepCount = 0;
    lastStepDis = 0;
    
}

-(void)updateSetp:(NSInteger)stepMount andDistanceper:(CGFloat)distance
{
    variableLable.text = [NSString stringWithFormat:@"步数:%ld",(long)stepMount];
    
    float distanceKm = distance/1000.0;
    variableLable1.text = [NSString stringWithFormat:@"距离:%.4f",distanceKm];
    
    circleView.percent = stepMount / 10000.0;

    
}

- (void)checkNewDay{
    
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd"];
    
    if (lastCheckedTime) {
        if (![[fmt stringFromDate:now] isEqualToString:[fmt stringFromDate:lastCheckedTime]]) {
            //新的一天
            [StepModel shareStepModel].stepDis = 0.0;
            [StepModel shareStepModel].stepCount = 0;
            [self updateSetp:[StepModel shareStepModel].stepDis andDistanceper:[StepModel shareStepModel].stepCount]
            ;
            
            [self startStepCount];
        }
        
    }
    
    lastCheckedTime = now;
}

- (void) applicationDidBecomeActive:(NSNotification *)notify{
    
    [self checkNewDay];
}

@end
