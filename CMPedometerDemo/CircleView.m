//
//  CircleView.m
//  CMPedometerDemo
//
//  Created by 徐巧霞 on 16/8/11.
//  Copyright © 2016年 徐巧霞. All rights reserved.
//

#import "CircleView.h"

//把角度转换成PI
#define degressToRadians(x) (M_PI*(x)/180.0)
//直径
#define Progress_Width 80
//弧线的宽度
#define Progress_Line_Width 5


@implementation CircleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self  signalCircle];
//        [self doubleCircle];
        
    }
    
    return self;
}

- (void)signalCircle{
    CAShapeLayer *trackLayer = [CAShapeLayer layer];
    trackLayer.frame = CGRectMake(10, 0, 80, 80);
    trackLayer.fillColor = [UIColor clearColor].CGColor;
    trackLayer.strokeColor = [UIColor blueColor].CGColor;
    trackLayer.opacity = 0.25;
    trackLayer.lineCap = kCALineCapRound;
    trackLayer.lineWidth = Progress_Line_Width;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 80, 80)];
    trackLayer.path = path.CGPath;
    trackLayer.strokeStart = 0;
    trackLayer.strokeEnd = 1;
    
    [self.layer addSublayer:trackLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1.0;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [trackLayer addAnimation:animation forKey:@"strokeEnd"];

}

- (void)setPercent:(CGFloat)percent
{
    _percent = percent;
    [self doubleCircle];
    
}
- (void)doubleCircle{
    
    //外圆
    UIBezierPath *trackPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(135, 135) radius:50 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    CAShapeLayer *trackLayer = [CAShapeLayer layer];
    trackLayer.frame = CGRectMake(85, 0, 100, 100);
    [self.layer addSublayer:trackLayer];
    trackLayer.fillColor = [UIColor clearColor].CGColor;
    trackLayer.strokeColor = [UIColor grayColor].CGColor;
    trackLayer.path = trackPath.CGPath;
    trackLayer.lineWidth = 10;
    trackLayer.opacity = 0.4;
    
    //内圆
    double f = degressToRadians(10 / 100 * 360 - 90);
    double g = degressToRadians(0.01 * 360 - 90);

    if (self.percent <= 0.4) {
        UIBezierPath *progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(135, 135) radius:50 startAngle: degressToRadians(270) endAngle:degressToRadians(self.percent * 360 - 90) clockwise:YES];
        CAShapeLayer *progressLayer = [CAShapeLayer layer];
        progressLayer.frame = CGRectMake(85, 0, 100, 100);
        [self.layer addSublayer:progressLayer];
        progressLayer.fillColor = [UIColor clearColor].CGColor;
        progressLayer.strokeColor = [UIColor orangeColor].CGColor;
        progressLayer.path = progressPath.CGPath;
        progressLayer.lineCap = kCALineCapRound;
        progressLayer.lineWidth = 10;
    }else if (self.percent > 0.4){
        
        UIBezierPath *progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(135, 135) radius:50 startAngle: degressToRadians(270) endAngle:degressToRadians(0.4 * 360 - 90) clockwise:YES];
        CAShapeLayer *progressLayer = [CAShapeLayer layer];
        progressLayer.frame = CGRectMake(85, 0, 100, 100);
        [self.layer addSublayer:progressLayer];
        progressLayer.fillColor = [UIColor clearColor].CGColor;
        progressLayer.strokeColor = [UIColor orangeColor].CGColor;
        progressLayer.path = progressPath.CGPath;
        progressLayer.lineCap = kCALineCapRound;
        progressLayer.lineWidth = 10;
        
        UIBezierPath *progress2Path;
        if (self.percent <= 1.0) {
            progress2Path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(135, 135) radius:50 startAngle: degressToRadians(0.4 * 360 - 90) endAngle:degressToRadians(self.percent * 360 - 90) clockwise:YES];

        }else{
            progress2Path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(135, 135) radius:50 startAngle: degressToRadians(0.4 * 360 - 90) endAngle:degressToRadians(270) clockwise:YES];
            
        }
        
        CAShapeLayer *progress2Layer = [CAShapeLayer layer];
        progress2Layer.frame = CGRectMake(85, 0, 100, 100);
        [self.layer addSublayer:progress2Layer];
        progress2Layer.fillColor = [UIColor clearColor].CGColor;
        progress2Layer.strokeColor = [UIColor blueColor].CGColor;
        progress2Layer.path = progress2Path.CGPath;
        progress2Layer.lineCap = kCALineCapRound;
        progress2Layer.lineWidth = 10;
        
        

        
        
    }
   
    
    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"stroke"];
//    animation.duration = 1.0;
//    animation.fromValue = @(0);
//    animation.toValue = @(1);
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    [progressLayer addAnimation:animation forKey:@"stroke"];
    
    
    
}


- (void)drawRect:(CGRect)rect {
    
    
}

@end
