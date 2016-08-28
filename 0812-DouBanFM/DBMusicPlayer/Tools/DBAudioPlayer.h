//
//  DBAudioPlayer.h
//  0812-DouBanFM
//
//  Created by 洪龙通 on 16/8/13.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^updateBlock)(NSInteger timePlayed, NSInteger duration);
typedef void (^finished)();

@interface DBAudioPlayer:NSObject

+ (void)playAudioWithItem:(NSString *)item withBlock:(updateBlock)block andFinishedBlock:(finished)finishedBlock;
+ (void)pause;
+ (void)resume;
+ (float)duration;
+ (float)escapeTime;
@end
