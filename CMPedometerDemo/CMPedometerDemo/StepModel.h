//
//  StepModel.h
//  CMPedometerDemo
//
//  Created by 徐巧霞 on 16/8/9.
//  Copyright © 2016年 徐巧霞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StepModel : NSObject

+ (instancetype)shareStepModel;


/**
 *  运动是否开始
 */
@property (nonatomic, assign) BOOL isStart;

/**
 *  运动步数
 */
@property (nonatomic, assign) NSInteger stepCount;

/**
 *  运动距离
 */
@property (nonatomic, assign) float stepDis;


@end
