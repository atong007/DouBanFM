//
//  DBLrlView.m
//  0812-DouBanFM
//
//  Created by 洪龙通 on 16/8/17.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "DBLrcView.h"
#import "DBLrcCell.h"
#import "DBLrcData.h"

@interface DBLrcView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *lrcTableView;
@end
@implementation DBLrcView

- (instancetype)init
{
    if (self = [super init]) {
//        self.backgroundColor = [UIColor redColor];
        UITableView *lrcTableView = [[UITableView alloc] init];
        lrcTableView.dataSource = self;
        lrcTableView.delegate = self;
        lrcTableView.rowHeight = 23;
        lrcTableView.scrollEnabled = NO;
        lrcTableView.allowsSelection = YES;
        lrcTableView.userInteractionEnabled = NO;
        lrcTableView.backgroundView = nil;
        lrcTableView.backgroundColor = [UIColor clearColor];
        lrcTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:lrcTableView];
        self.lrcTableView = lrcTableView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.lrcTableView.frame = self.bounds;
}


#pragma mark - Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.lrcData) {
        return 0;
    }
    return self.lrcData.timeArray.count;
}

/**
 *  tableView cell的设置
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.创建cell
    DBLrcCell *cell = [DBLrcCell cellWithTableView:tableView];
    
    //2.传递数据模型来设置cell属性
    NSString *timeStr = [self.lrcData.timeArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [self.lrcData.lrcDictionary objectForKey:timeStr];
    
    //3.返回cell
    return cell;
}

- (void)reloadData {
    [self.lrcTableView reloadData];
}


- (void)selectRow:(NSInteger)row
{
    [self.lrcTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}
@end
