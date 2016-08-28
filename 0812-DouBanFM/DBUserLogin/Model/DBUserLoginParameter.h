//
//  DBUserLoginParameter.h
//  0812-DouBanFM
//
//  Created by 洪龙通 on 16/8/18.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBUserLoginParameter : NSObject

/**
 *  数据获取源
 */
@property (nonatomic, copy) NSString *source;
/**
 *  二维码
 */
@property (nonatomic, copy) NSString *captcha_solution;
/**
 *  用户名alias
 */
@property (nonatomic, copy) NSString *alias;
/**
 *  密码
 */
@property (nonatomic, copy) NSString *form_password;
/**
 *  二维码获取所需的id
 */
@property (nonatomic, copy) NSString *captcha_id;
/**
 *  请求任务
 */
@property (nonatomic, copy) NSString *task;

@end
