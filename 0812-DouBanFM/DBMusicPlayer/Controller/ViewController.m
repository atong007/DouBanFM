//
//  ViewController.m
//  0812-DouBanFM
//
//  Created by 洪龙通 on 16/8/12.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "ViewController.h"
#import "DBAlbumView.h"
#import "DBNetwork.h"
#import "DBSongInfo.h"
#import "DBChannelInfo.h"
#import "UIImageView+WebCache.h"
#import "DBAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "DBUserLoginViewController.h"
#import "DBLrcView.h"
#import "DBLrcData.h"
#import "UserInfo.h"
#import "MBProgressHUD.h"
#import "DBChannelViewController.h"


#define DBMusiMargin    10
#define DBTopviewMargin 15

@interface ViewController ()

@property (nonatomic, weak  ) UILabel        *songLabel;
@property (nonatomic, weak  ) UILabel        *artistLabel;
@property (nonatomic, weak  ) UIImageView    *backgroundView;
@property (nonatomic, weak  ) DBAlbumView    *albumView;
@property (nonatomic, weak  ) UIImageView    *needleView;
@property (nonatomic, weak  ) UIButton       *playBtn;
@property (nonatomic, weak  ) UIProgressView *songProgress;
@property (nonatomic, weak  ) UILabel        *timeLabel;
@property (nonatomic, weak  ) UIButton       *likeBtn;
@property (nonatomic, weak  ) UIButton       *nextBtn;
@property (nonatomic, weak  ) UIView         *bottomView;
@property (nonatomic, weak  ) DBLrcView      *lrcView;
@property (nonatomic, strong) DBLrcData      *lrcData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置唱片及背景view
    [self setupDiskView];
    
    // 设置顶部的view
    [self setupTopView];
    
    // 设置歌词界面
    [self setupLrlView];
    
    // 设置底部的按钮
    [self setupBottomView];
    
    // 加载网络
    [self setupNetWork];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.albumView startRotating];
    [super viewDidAppear:animated];
}

/**
 *  这句必须加，不然接收不了锁屏的事件！
 */
- (BOOL) canBecomeFirstResponder {
    return YES;
}

/**
 *  远程控制事件处理
 */
-(void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            [DBAudioPlayer resume];
            break;
        case UIEventSubtypeRemoteControlPause:
            [DBAudioPlayer pause];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self nextSong];
            break;
        default:
            break;
    }
}


/**
 *  设置唱片及背景view
 */
- (void)setupDiskView
{
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    backgroundView.frame        = self.view.bounds;
    [self.view addSubview:backgroundView];
    self.backgroundView = backgroundView;
    
    UIBlurEffect *effect           = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.alpha               = 1.0;
    effectView.frame               = backgroundView.frame;
    [backgroundView addSubview:effectView];
    
    UIImageView *diskMask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_play_disc_mask"]];
    CGFloat diskY         = 90;
    diskMask.frame        = CGRectMake(0, diskY, diskMask.frame.size.width, diskMask.frame.size.height);
    [backgroundView addSubview:diskMask];
    
    UIImageView *playDisc = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cm2_play_disc"]];
    playDisc.center       = CGPointMake(backgroundView.center.x, backgroundView.center.y - DBMusiMargin);
    [backgroundView addSubview:playDisc];
    
    UILabel *timeLabel      = [[UILabel alloc] init];
    timeLabel.font          = [UIFont boldSystemFontOfSize:13.0];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor     = [UIColor redColor];
    CGFloat timeLabelW      = 100;
    CGFloat timeLabelH      = 15;
    CGFloat timeLabelX      = (self.view.frame.size.width - timeLabelW) * 0.5;
    CGFloat timeLabelY      = CGRectGetMaxY(playDisc.frame) + DBMusiMargin;
    timeLabel.frame         = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
    [backgroundView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    DBAlbumView *albumView = [[DBAlbumView alloc] init];
    CGFloat albumW         = playDisc.frame.size.width - 90;
    CGFloat albumH         = albumW;
    albumView.center       = CGPointMake(playDisc.frame.size.width * 0.5, playDisc.frame.size.height * 0.5);
    albumView.bounds       = CGRectMake(0, 0, albumW, albumH);
    albumView.image        = [UIImage imageNamed:@"defaultCover"];
    [playDisc addSubview:albumView];
    self.albumView = albumView;
    
    // 设置磁盘唱针
    UIImageView *needleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play_needle_play"]];
    CGSize needleS          = needleView.image.size;
    CGFloat needleX         = backgroundView.center.x - 28;
    CGFloat needleY         = 55;
    needleView.frame        = (CGRect){needleX, needleY, needleS};
    // anchorPoint的比例就是position在父layer中的位置,两个互相影响,需要同时修改
    [self setAnchorPoint:CGPointMake(0.25, 0.16) forView:needleView];
    [backgroundView addSubview:needleView];
    self.needleView = needleView;
    
    // 设置时间进度条
    UIProgressView *songProgress   = [[UIProgressView alloc] init];
    songProgress.progressTintColor = [UIColor redColor];
    songProgress.progress          = 0.0;
    CGFloat progressW              = 250;
    CGFloat progressH              = 2;
    CGFloat progressX              = (self.view.frame.size.width - progressW) * 0.5;
    CGFloat progressY              = CGRectGetMaxY(playDisc.frame) + 100;
    songProgress.frame             = CGRectMake(progressX, progressY, progressW, progressH);
    [backgroundView addSubview:songProgress];
    self.songProgress = songProgress;
    
}
/***********************************************************************
 说明：anchorPoint是相对当前view的相对位置，而position是相对父视图view的坐标
 frame.origin.x = position.x - anchorPoint.x * bounds.size.width；
 frame.origin.y = position.y - anchorPoint.y * bounds.size.height；
 anchorPoint或者position的改变不会互相影响，但是会影响上诉的frame的origin，
 它们处于不同坐标空间中的重合点。
 **********************************************************************/
- (void) setAnchorPoint:(CGPoint)anchorpoint forView:(UIView *)view
{
    //设置完新的anchorPoint后，frame会发生改变，只需将frame重新调整到旧的frame，就能不改变frame的origin
    CGRect oldFrame        = view.frame;
    view.layer.anchorPoint = anchorpoint;
    view.frame             = oldFrame;
}

/**
 *  设置歌词界面
 */
- (void)setupLrlView
{
    DBLrcView *lrcView = [[DBLrcView alloc] init];
    [self.view addSubview:lrcView];
    lrcView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *lrcCenterX = [NSLayoutConstraint constraintWithItem:lrcView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self.view addConstraint:lrcCenterX];
    NSLayoutConstraint *lrcCenterY = [NSLayoutConstraint constraintWithItem:lrcView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:170];
    [self.view addConstraint:lrcCenterY];
    NSLayoutConstraint *lrcW = [NSLayoutConstraint constraintWithItem:lrcView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:280];
    [lrcView addConstraint:lrcW];
    NSLayoutConstraint *lrcH = [NSLayoutConstraint constraintWithItem:lrcView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:55];
    [lrcView addConstraint:lrcH];
    self.lrcView = lrcView;
}

/**
 *  设置顶部View
 */
- (void)setupTopView
{
    UIView *topView         = [[UIView alloc] init];
    topView.frame           = CGRectMake(0, 0, self.view.frame.size.width, 90);
    topView.backgroundColor = RGBCOLOR(192, 23, 31);
    [self.view addSubview:topView];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"userInfo"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
    CGFloat leftBtnH = 25;
    CGFloat leftBtnW = 25;
    CGFloat leftBtnX = DBMusiMargin;
    CGFloat leftBtnY = topView.frame.size.height - leftBtnH - DBTopviewMargin;
    leftButton.frame = CGRectMake(leftBtnX, leftBtnY, leftBtnW, leftBtnH);
    [topView addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"radioList"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(showChannels) forControlEvents:UIControlEventTouchUpInside];
    CGFloat rightBtnH = leftBtnH;
    CGFloat rightBtnW = leftBtnW;
    CGFloat rightBtnX = topView.frame.size.width - rightBtnW - DBTopviewMargin;
    CGFloat rightBtnY = leftBtnY;
    rightButton.frame = CGRectMake(rightBtnX, rightBtnY, rightBtnW, rightBtnH);
    [topView addSubview:rightButton];
    
    UILabel *artistLabel      = [[UILabel alloc] init];
    artistLabel.textColor     = [UIColor whiteColor];
    artistLabel.font          = [UIFont systemFontOfSize:13.0];
    artistLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat artistW           = topView.frame.size.width - leftBtnW - rightBtnW - DBMusiMargin * 2;
    CGFloat artistH           = 15;
    CGFloat artistX           = CGRectGetMaxX(leftButton.frame);
    CGFloat artistY           = topView.frame.size.height - artistH - DBTopviewMargin;
    artistLabel.frame         = CGRectMake(artistX, artistY, artistW, artistH);
    [topView addSubview:artistLabel];
    self.artistLabel = artistLabel;
    
    UILabel *songLabel      = [[UILabel alloc] init];
    songLabel.textColor     = [UIColor whiteColor];
    songLabel.font          = [UIFont boldSystemFontOfSize:16.0];
    songLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat songW           = artistW;
    CGFloat songH           = 20;
    CGFloat songX           = CGRectGetMaxX(leftButton.frame);
    CGFloat songY           = artistY - songH - 5;
    songLabel.frame         = CGRectMake(songX, songY, songW, songH);
    [topView addSubview:songLabel];
    self.songLabel = songLabel;
    
}

/**
 *  设置底部的按钮
 */
- (void)setupBottomView
{
    UIView *bottomView         = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:0.6];
    CGFloat bottomW            = self.view.frame.size.width;
    CGFloat bottomH            = 50;
    CGFloat bottomY            = self.view.frame.size.height - bottomH;
    bottomView.frame           = CGRectMake(0, bottomY, bottomW, bottomH);
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    
    
    UIButton *likeBtn                   = [UIButton buttonWithType:UIButtonTypeCustom];
    likeBtn.adjustsImageWhenHighlighted = NO;
    [likeBtn setBackgroundImage:[UIImage imageNamed:@"cm2_play_icn_love"] forState:UIControlStateNormal];
    [likeBtn setBackgroundImage:[UIImage imageNamed:@"cm2_play_icn_love_prs"] forState:UIControlStateSelected];
    [likeBtn addTarget:self action:@selector(loveBtnClick:) forControlEvents:UIControlEventTouchDown];
    CGFloat likeBtnH = bottomView.frame.size.height;
    CGFloat likeBtnW = likeBtnH;
    CGFloat likeBtnX = DBMusiMargin;
    CGFloat likeBtnY = 0;
    likeBtn.frame    = CGRectMake(likeBtnX, likeBtnY, likeBtnW, likeBtnH);
    [bottomView addSubview:likeBtn];
    self.likeBtn = likeBtn;
    
    UIButton *playBtn                   = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.adjustsImageWhenHighlighted = NO;
    [playBtn setImage:[UIImage imageNamed:@"pauseButton"] forState:UIControlStateNormal];
    [playBtn setImage:[UIImage imageNamed:@"playButton"] forState:UIControlStateSelected];
    [playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchDown];
    CGFloat playBtnH = likeBtnH;
    CGFloat playBtnW = playBtnH;
    CGFloat playBtnX = bottomView.center.x - playBtnW * 0.5;
    CGFloat playBtnY = 0;
    playBtn.frame    = CGRectMake(playBtnX, playBtnY, playBtnW, playBtnH);
    [bottomView addSubview:playBtn];
    self.playBtn = playBtn;
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setImage:[UIImage imageNamed:@"playNextButton"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextSong) forControlEvents:UIControlEventTouchDown];
    CGFloat nextBtnH = likeBtnH;
    CGFloat nextBtnW = nextBtnH;
    CGFloat nextBtnX = bottomView.frame.size.width - nextBtnW - DBMusiMargin;
    CGFloat nextBtnY = 0;
    nextBtn.frame    = CGRectMake(nextBtnX, nextBtnY, nextBtnW, nextBtnH);
    [bottomView addSubview:nextBtn];
    self.nextBtn = nextBtn;
}

/**
 *  加载网络
 */
- (void)setupNetWork
{
    [DBNetwork loadFMListWithType:@"n" success:^{
        [self loadNetworkData];
        if (!self.playBtn.selected)
        {
            self.playBtn.selected = YES;
        }
    }];
}

/**
 *  加载网络数据更新界面
 */
- (void)loadNetworkData
{
    DBSongInfo *songInfo  = [DBSongInfo currentSong];
    self.songLabel.text   = songInfo.title;
    self.artistLabel.text = songInfo.artist;
    self.likeBtn.selected = songInfo.like;
    self.likeBtn.enabled  = YES;
    self.nextBtn.enabled  = YES;
    self.playBtn.enabled  = YES;
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        [[AppDelegate globalDelegate] reloadScreenView];
    }
    
    [DBAudioPlayer playAudioWithItem:songInfo.url withBlock:^(NSInteger timePlayed, NSInteger duration)
     {
         [self updateViewWithTime:timePlayed duration:duration];
     } andFinishedBlock:^{
         [self nextSong];
     }];
    
    [self.albumView sd_setImageWithURL:[NSURL URLWithString:songInfo.picture] placeholderImage:[UIImage imageNamed:@"defaultCover"]];
    [self.backgroundView sd_setImageWithURL:[NSURL URLWithString:songInfo.picture] placeholderImage:[UIImage imageNamed:@"backgroud"]];
    
    [DBNetwork loadSongLrcWithBlock:^{
        [self loadLrcView];
    }];
}

- (void)updateViewWithTime:(float)timePlayed duration:(float)duration
{
    if (duration) {
        [self.songProgress setProgress:(float)timePlayed / duration animated:YES];
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%@ / %@", [self timeFormatToMinuteSecondsWithSeconds:timePlayed], [self timeFormatToMinuteSecondsWithSeconds:duration]];
    
    self.bottomView.userInteractionEnabled = YES;
    
    for (int i = 0; i < [self.lrcData.timeArray count]; i++) {
        if ([self.lrcData.timeArray[i] isEqualToString:[self timeFormatToMinuteSecondsWithSeconds:timePlayed]])
        {
            [self.lrcView selectRow:i];
        }
    }
}

-(NSString *)timeFormatToMinuteSecondsWithSeconds:(NSTimeInterval)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm:ss"];
    NSString *result = [formatter stringFromDate:[[NSDate alloc] initWithTimeIntervalSince1970:time]];
    return result;
}

/**
 *  歌词数据加载
 */
-(void)loadLrcView
{
    if ([DBSongInfo currentSong].lrcContentStr != nil) {
        self.lrcData = [DBLrcData lrcDataWithString:[DBSongInfo currentSong].lrcContentStr];
    }else
    {
        self.lrcData = nil;
    }
    self.lrcView.lrcData = self.lrcData;
    [self.lrcView reloadData];
    
}

- (void)loveBtnClick:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        [DBSongInfo currentSong].like = YES;
        [DBNetwork loadFMListWithType:@"r" success:nil];
    }else {
        [DBSongInfo currentSong].like = NO;
        [DBNetwork loadFMListWithType:@"u" success:nil];
    }
}

- (void)playBtnClick:(UIButton *)button
{
    CGFloat angle;
    if (button.selected) {
        [self.albumView stoptRotating];
        angle = - M_PI_4 * 0.5;
        [DBAudioPlayer pause];
    }else {
        [self.albumView resumeRotating];
        angle = 0;
        [DBAudioPlayer resume];
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.needleView.transform = CGAffineTransformMakeRotation(angle);
    }];
    button.selected = !button.selected;
}

- (void)nextSong
{
    [DBAudioPlayer pause];
    self.songProgress.progress = 0.0;
    self.likeBtn.enabled       = NO;
    self.nextBtn.enabled       = NO;
    self.playBtn.enabled       = NO;
    
    __weak ViewController *selfVC = self;
    [DBNetwork loadFMListWithType:@"s" success:^{
        if (!selfVC.playBtn.selected)
        {
            [selfVC playBtnClick:selfVC.playBtn];
        }
        [selfVC loadNetworkData];
    }];
}

/**
 *  用户登录
 */
- (void)userLogin
{
    if ([UserInfo userInfo].ck) {
        [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
    }else {
        [self presentViewController:[[DBUserLoginViewController alloc] init] animated:YES completion:nil];
    }
}

- (void)showChannels
{
    [[AppDelegate globalDelegate] toggleRightDrawer:self animated:YES];
}

/**
 *  切换channel
 */
- (void)channelUpdate {
    
    [DBAudioPlayer pause];
    self.songProgress.progress = 0.0;
    __weak ViewController *selfVC = self;
    [DBNetwork loadFMListWithType:@"n" success:^{
        [selfVC loadNetworkData];
        if (!selfVC.playBtn.selected)
        {
            [selfVC playBtnClick:self.playBtn];
        }
    }];
}

/**
 *  后台至前台时恢复唱片的转动
 */
- (void)resumeAlbumRotating {
    [self.albumView startRotating];
}
@end
