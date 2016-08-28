//
//  DBHttpTools.m
//  0812-DouBanFM
//
//  Created by 洪龙通 on 16/8/13.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "DBHttpTools.h"
#import "AFNetworking.h"
#import "DBSongInfo.h"
#import "DBChannelInfo.h"

static AFHTTPSessionManager *_manager;

@implementation DBHttpTools

+ (void)initialize
{
    _manager = [AFHTTPSessionManager manager];
}

+ (void)GET:(NSString *)URLString parameters:(id)parameters
    success:(void (^)(id))success
    failure:(void (^)(NSError *))failure
{
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSLog(@"_manager:%p", _manager);

    [_manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success)
        {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure)
        {
            failure(error);
        }
    }];
}

+ (void)GETByHttpResponseWithURL:(NSString *)URLString parameters:(id)parameters
    success:(void (^)(id))success
    failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    WBLog(@"httpManager:%p", httpManager);
    [httpManager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success)
        {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure)
        {
            failure(error);
        }
    }];
}

+ (void)POST:(NSString *)URLString parameters:(id)parameters
    success:(void (^)(id))success
    failure:(void (^)(NSError *))failure
{
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    WBLog(@"parameters:%@", parameters);
    [_manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(success)
        {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failure)
        {
            failure(error);
        }
    }];
}

@end
