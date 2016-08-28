//
//  UIImage+AT.m
//  0812-DouBanFM
//
//  Created by 洪龙通 on 16/8/21.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "UIImage+AT.h"

@implementation UIImage (AT)

/**
  * 将UIColor变换为UIImage
  *
  **/
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
@end
