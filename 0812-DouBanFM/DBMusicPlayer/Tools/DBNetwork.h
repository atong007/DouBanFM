//
//  DBNetwork.h
//  0812-DouBanFM
//
//  Created by 洪龙通 on 16/8/13.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^completeBlock)(NSArray *array);
typedef void(^finishBlock)();

@class DBUserLoginParameter;
@protocol DBNetworkDelegate <NSObject>

- (void)loadNetworkData;

@end
@interface DBNetwork : NSObject

@property (nonatomic, weak) id<DBNetworkDelegate> delegate;

+ (void)loadFMListWithType:(NSString *)type success:(void (^)())success;
+ (void)loadChannelsWihtURL:(NSString *)urlString complete:(completeBlock)complete;
+ (void)loadSongLrcWithBlock:(finishBlock)finish;
+ (void)loginWithParameter:(DBUserLoginParameter *)loginParameter finish:(void (^)(BOOL isSuccess))finish;
+ (void)loadCaptchaImageWithBlock:(void (^)(NSString *url))success;
+ (void)logoutUserWithBlock:(void (^)())success;
@end
