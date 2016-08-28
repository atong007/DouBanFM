//
//  DBLrcData.m
//  0812-DouBanFM
//
//  Created by 洪龙通 on 16/8/17.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "DBLrcData.h"

@implementation DBLrcData

+ (instancetype)lrcDataWithString:(NSString *)contentStr {
    
    DBLrcData *lrcData = [[DBLrcData alloc] init];
    
    NSMutableArray *timeArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *lrcDictionary = [[NSMutableDictionary alloc] init];
    
    NSArray *contentsArray = [contentStr componentsSeparatedByString:@"\n"];
    for (int i = 0; i < [contentsArray count] ; i++) {
        NSArray *separateArray = [contentsArray[i] componentsSeparatedByString:@"]"];
        if ([separateArray count] >= 2) {
            for (int j = 0; j < [separateArray count]-1; j++) {
                
                if ([[separateArray objectAtIndex:j] length] < 5 || [[separateArray lastObject] length] <= 1) {
                    continue;
                }
                NSString *timeStr = [[separateArray objectAtIndex:j] substringWithRange:NSMakeRange(1, 5)];
                [timeArray addObject:timeStr];
                [lrcDictionary setObject:[separateArray lastObject] forKey:timeStr];
            }
            
        }
    }
    [timeArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"mm:ss"];
        NSDate *date1 = [dateFormatter dateFromString:obj1];
        NSDate *date2 = [dateFormatter dateFromString:obj2];
        return [date1 compare:date2];
    }];
    
    lrcData.timeArray = timeArray;
    lrcData.lrcDictionary = lrcDictionary;
    return lrcData;
}

@end
