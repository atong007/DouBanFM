//
//  DBLrcCell.m
//  0812-DouBanFM
//
//  Created by 洪龙通 on 16/8/17.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "DBLrcCell.h"

@implementation DBLrcCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.textLabel.font = [UIFont systemFontOfSize:14.0];
        self.textLabel.textColor = [UIColor redColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;//UITableViewcell选中后怎么去掉背景灰色
        self.selectedBackgroundView = [[UIView alloc] init];
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        self.highlighted = YES;
        self.selected = YES;
        self.textLabel.highlightedTextColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableview
{
    static NSString *reuseID = @"lrc";
    DBLrcCell *cell = [tableview dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[DBLrcCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}

@end
