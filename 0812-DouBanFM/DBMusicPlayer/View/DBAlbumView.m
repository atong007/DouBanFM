//
//  DBAlbumView.m
//  0812-DouBanFM
//
//  Created by 洪龙通 on 16/8/12.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "DBAlbumView.h"

@implementation DBAlbumView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    [super setImage:image];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.width / 2;
}

/**
 *  磁盘专辑封面开始旋转
 */
- (void)startRotating
{
    [self.layer removeAnimationForKey:@"rotation"];
    CABasicAnimation *animation = [[CABasicAnimation alloc] init];
    animation.keyPath = @"transform.rotation";
    animation.toValue = @(M_PI * 2);
    animation.duration = 10.0;
    animation.repeatCount = MAXFLOAT;
    
    [self.layer addAnimation:animation forKey:@"rotation"];
}

/**
 *  磁盘专辑封面暂停旋转
 */
- (void)stoptRotating
{
    CFTimeInterval pauseTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;
    self.layer.timeOffset = pauseTime;
}

/**
 *  磁盘专辑封面恢复旋转
 */
-(void)resumeRotating
{
    CFTimeInterval pauseTime = self.layer.timeOffset;
    self.layer.speed = 1.0;
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = 0.0;
    CFTimeInterval sinceTimeFromPause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pauseTime;
    self.layer.beginTime = sinceTimeFromPause;
}

@end
