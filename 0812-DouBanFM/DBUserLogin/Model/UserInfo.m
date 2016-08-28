//
//  UserInfo.m
//  0812-DouBanFM
//
//  Created by 洪龙通 on 16/8/18.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "UserInfo.h"
#import "MJExtension.h"

@implementation UserInfo
static UserInfo *userInfo;

+ (instancetype)userInfo {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //添加储存的文件名
        userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:DBUserInfoFilePath];
        NSLog(@"userInfo:%@;%@;%@;", userInfo.ID, userInfo.ck, userInfo.name);
        if (!userInfo) {
            userInfo = [[UserInfo alloc] init];
        }
    });
    return userInfo;
}

+ (void)setValuesWithDictionary:(NSDictionary *)dict {
    
    [[UserInfo userInfo] setValuesForKeysWithDictionary:dict];
}

/**
 *  dic中的key与model中的变量名字不同,需要指定如何转化
 *
 *  @param value 字典的key对应的值
 *  @param key   字典key
 */
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

MJCodingImplementation
//-(id)initWithCoder:(NSCoder *)aDecoder{
//    if (self      = [super init]) {
//        self.ck       = [aDecoder decodeObjectForKey:@"cookies"];
//        self.ID       = [aDecoder decodeObjectForKey:@"userID"];
//        self.username = [aDecoder decodeObjectForKey:@"username"];
//    }
//    return self;
//}
//
//
//-(void)encodeWithCoder:(NSCoder *)aCoder{
//    [aCoder encodeObject:_ck forKey:@"cookies"];
//    [aCoder encodeObject:_ID forKey:@"userID"];
//    [aCoder encodeObject:_username forKey:@"username"];
//}

+ (void)storeUserInfo {
    
    BOOL result = [NSKeyedArchiver archiveRootObject:[UserInfo userInfo] toFile:DBUserInfoFilePath];
    if (result) {
        WBLog(@"archiver Success!");
    }
}

+ (void)removeUserInfo
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:DBUserInfoFilePath])
    {
        NSError *error = nil;
        [manager removeItemAtPath:DBUserInfoFilePath error:&error];
        if (!error) {
            userInfo = [[UserInfo alloc] init];
        }else{
            WBLog(@"remove file error:%@", error);
        }
    }
    
}
@end
