//
//  DBLrcView.h
//  0812-DouBanFM
//
//  Created by 洪龙通 on 16/8/17.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBLrcData;
@interface DBLrcView : UIView

@property (nonatomic, strong) DBLrcData *lrcData;
- (void)reloadData;
- (void)selectRow:(NSInteger)row;
@end
