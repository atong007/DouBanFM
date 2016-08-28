//
//  DBChannelInfo.m
//  0812-DouBanFM
//
//  Created by 洪龙通 on 16/8/13.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "DBChannelInfo.h"

static NSArray *channelsTitle;

@implementation DBChannelInfo

+ (instancetype)currentChannel
{
    static dispatch_once_t onceToken;
    static DBChannelInfo *currentChannel = nil;
    dispatch_once(&onceToken, ^{
        currentChannel = [[DBChannelInfo alloc] init];
    });
    return currentChannel;
}

+ (NSArray *)channelsTitle
{
    if (!channelsTitle) {
        channelsTitle = [NSArray array];
    }
    return channelsTitle;
}

+ (void)updateChannelsTitleWithArray:(NSArray *)array {
    
    channelsTitle = array;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

+ (instancetype)channelInfoWithDict:(NSDictionary *)dict {
    DBChannelInfo *channelInfo = [[DBChannelInfo alloc] init];
    [channelInfo setValuesForKeysWithDictionary:dict];
    return channelInfo;
}

@end
