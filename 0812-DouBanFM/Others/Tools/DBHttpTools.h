//
//  DBHttpTools.h
//  0812-DouBanFM
//
//  Created by 洪龙通 on 16/8/13.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBHttpTools : NSObject

+ (void)GET:(NSString *)URLString parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;

+ (void)GETByHttpResponseWithURL:(NSString *)URLString parameters:(id)parameters
                     success:(void (^)(id))success
                     failure:(void (^)(NSError *))failure;

+ (void)POST:(NSString *)URLString parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;
@end
