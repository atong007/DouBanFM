//
//  DBSongInfo.m
//  0812-DouBanFM
//
//  Created by 洪龙通 on 16/8/13.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "DBSongInfo.h"

@implementation DBSongInfo

+ (instancetype)currentSong
{
    static dispatch_once_t onceToken;
    static DBSongInfo *currentSong = nil;
    dispatch_once(&onceToken, ^{
        currentSong = [[DBSongInfo alloc] init];
    });
    return currentSong;
}

+ (void)setInfoWithDictionary:(NSDictionary *)dict
{
    DBSongInfo *songInfo = [self currentSong];
    if (songInfo) {
        [songInfo setValuesForKeysWithDictionary:dict];
    }
}

/**
 *  重写此方法可将setValuesForKeysWithDictionary中
    字典里此类不包含的value过滤,同时此类中不在字典中的值为空
 *
 *  @param value  字典里的值
 *  @param key   字典里的key
 */
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}
@end
