//
//  UserInfo.h
//  0812-DouBanFM
//
//  Created by 洪龙通 on 16/8/18.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

/**
 *  用户名
 */
@property (nonatomic, copy) NSString *name;
/**
 *  密码
 */
@property (nonatomic, copy) NSString *passWord;
/**
 *  用户id
 */
@property (nonatomic, copy) NSString *ID;
/**
 *  cookies
 */
@property (nonatomic, copy) NSString *ck;

+ (instancetype)userInfo;
+ (void)setValuesWithDictionary:(NSDictionary *)dict;
+ (void)storeUserInfo;
+ (void)removeUserInfo;
@end
