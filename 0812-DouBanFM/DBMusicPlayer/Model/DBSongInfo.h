//
//  DBSongInfo.h
//  0812-DouBanFM
//
//  Created by 洪龙通 on 16/8/13.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBSongInfo : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSString *artist;

@property (nonatomic, copy) NSString *picture;

@property (nonatomic, assign) BOOL like;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *sid;

@property (nonatomic, copy) NSString *lrcContentStr;

+ (instancetype)currentSong;
+ (void)setInfoWithDictionary:(NSDictionary *)dict;

@end
