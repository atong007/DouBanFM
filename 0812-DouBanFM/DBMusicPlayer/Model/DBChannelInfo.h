//
//  DBChannelInfo.h
//  0812-DouBanFM
//
//  Created by 洪龙通 on 16/8/13.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBChannelInfo : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, copy) NSString *name;

+ (instancetype)currentChannel;
+ (void)updateChannelsTitleWithArray:(NSArray *)array;
+ (NSArray *)channelsTitle;
+ (instancetype)channelInfoWithDict:(NSDictionary *)dict;
@end

