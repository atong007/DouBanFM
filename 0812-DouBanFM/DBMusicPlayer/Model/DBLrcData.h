//
//  DBLrcData.h
//  0812-DouBanFM
//
//  Created by 洪龙通 on 16/8/17.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBLrcData : NSObject

@property (nonatomic, copy) NSArray *timeArray;
@property (nonatomic, copy) NSDictionary *lrcDictionary;

+ (instancetype)lrcDataWithString:(NSString *)contentStr;
@end
