//
//  DBAudioPlayer.m
//  0812-DouBanFM
//
//  Created by 洪龙通 on 16/8/13.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "DBAudioPlayer.h"
#import "AFSoundManager.h"

@implementation DBAudioPlayer

+ (void)playAudioWithItem:(NSString *)item withBlock:(updateBlock)block andFinishedBlock:(finished)finishedBlock
{
    if ([AFSoundManager sharedManager].status == AFSoundManagerStatusPlaying)
    {
        [[AFSoundManager sharedManager] pause];
    }
    [[AFSoundManager sharedManager] startStreamingRemoteAudioFromURL:item andBlock:^(int percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
        
        if (block) {
            block(elapsedTime, timeRemaining + elapsedTime);
        }
        if (finished) {
            finishedBlock();
        }
    }];
}

+ (void)pause
{
    [[AFSoundManager sharedManager] pause];
}

+ (void)resume
{
    [[AFSoundManager sharedManager] resume];
}

+ (float)duration
{
    return CMTimeGetSeconds([AFSoundManager sharedManager].player.currentItem.duration);
}

+ (float)escapeTime
{
    return CMTimeGetSeconds([AFSoundManager sharedManager].player.currentItem.currentTime);
}

@end
