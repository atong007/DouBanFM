//
//  DBChannelViewController.m
//  0812-DouBanFM
//
//  Created by 洪龙通 on 16/8/14.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "DBChannelViewController.h"
#import "DBNetwork.h"
#import "DBChannelInfo.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "UserInfo.h"

@interface DBChannelViewController ()

@property (nonatomic, copy) NSMutableArray *channelsArray;
@property (nonatomic, strong) UIViewController *destinationViewController;
@end

@implementation DBChannelViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}
- (instancetype)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.sectionHeaderHeight = 20;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.rowHeight = 38;
    self.tableView.contentInset = UIEdgeInsetsMake(18, 0, 0, 0);
    
    [self loadChannels];
    
    self.destinationViewController = [[AppDelegate globalDelegate] playerViewViewController];
}

- (void)loadChannels
{
    if ([UserInfo userInfo].ID) {
        [self setupChannelsOfIndex:1 WithURL:[NSString stringWithFormat:@"https://douban.fm/j/explore/get_login_chls?uk=%@",[UserInfo userInfo].ID]];
    }else {
        [self setupChannelsOfIndex:1 WithURL:@"http://douban.fm/j/explore/get_recommend_chl"];
    }
    
    [self setupChannelsOfIndex:2 WithURL:@"http://douban.fm/j/explore/up_trending_channels"];
    [self setupChannelsOfIndex:3 WithURL:@"http://douban.fm/j/explore/hot_channels"];
}

- (void)setupChannelsOfIndex:(int)index WithURL:(NSString *)url
{
    [DBNetwork loadChannelsWihtURL:url complete:^(NSArray *array) {
        _channelsArray[index] = array;
        [self.tableView reloadData];
    }];
}

- (NSMutableArray *)channelsArray
{
    if (!_channelsArray) {
        _channelsArray = [NSMutableArray array];
        //初始化数据源Array
        [DBChannelInfo updateChannelsTitleWithArray:@[@"我的兆赫",@"推荐频道",@"上升最快兆赫",@"热门兆赫"]];
        //我的兆赫
        DBChannelInfo *myPrivateChannel  = [[DBChannelInfo alloc]init];
        myPrivateChannel.name            = @"我的私人";
        myPrivateChannel.ID              = @0;
        DBChannelInfo *myRedheartChannel = [[DBChannelInfo alloc]init];
        myRedheartChannel.name           = @"我的红心";
        myRedheartChannel.ID             = @(-3);
        NSArray *myChannels              = @[myPrivateChannel, myRedheartChannel];
        [_channelsArray addObject:myChannels];
        
        //推荐兆赫
        NSArray *recommendChannels = [NSArray array];
        [_channelsArray addObject:recommendChannels];
        //上升最快兆赫
        NSArray *upTrendingChannels = [NSArray array];
        [_channelsArray addObject:upTrendingChannels];
        //热门兆赫
        NSArray *hotChannels = [NSArray array];
        [_channelsArray addObject:hotChannels];

    }
    return _channelsArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.channelsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.channelsArray[section];
    return array.count;
}

/**
 *  tableView cell的设置
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.创建cell
    static NSString *reuseID = @"channels";
    UITableViewCell *cell    = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell                 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    //2.传递数据模型来设置cell属性
    DBChannelInfo *channelInfo = self.channelsArray[indexPath.section][indexPath.row];
    cell.textLabel.text        = channelInfo.name;
    
    //3.返回cell
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [DBChannelInfo channelsTitle][section];
}

//设置header头部的式样
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"  %@",[DBChannelInfo channelsTitle][section]];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.alpha = 0.5;
    return label;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    DBChannelInfo *channelInfo = self.channelsArray[indexPath.section][indexPath.row];
    [DBChannelInfo currentChannel].ID = channelInfo.ID;
    
    [[AppDelegate globalDelegate] toggleRightDrawer:self animated:YES];
    [(ViewController *)self.destinationViewController channelUpdate];
}

@end
