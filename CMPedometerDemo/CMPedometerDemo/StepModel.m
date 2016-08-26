//
//  StepModel.m
//  CMPedometerDemo
//
//  Created by 徐巧霞 on 16/8/9.
//  Copyright © 2016年 徐巧霞. All rights reserved.
//

#import "StepModel.h"

@implementation StepModel

static StepModel *stepModel;

+(instancetype)shareStepModel{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stepModel = [[StepModel alloc] init];
    });

    
    return stepModel;
    
}

@end
