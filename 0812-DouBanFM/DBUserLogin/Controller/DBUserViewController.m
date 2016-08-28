//
//  DBUserViewController.m
//  0812-DouBanFM
//
//  Created by 洪龙通 on 16/8/19.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "DBUserViewController.h"
#import "DBSongInfo.h"
#import "UIImageView+WebCache.h"
#import "UserInfo.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "DBNetwork.h"

@interface DBUserViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *userIcon;
@end

@implementation DBUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.userNameLabel.text = [UserInfo userInfo].name;
}

- (void)setupSubviews
{
    UIBlurEffect *effect           = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.alpha               = 1.0;
    effectView.frame               = self.view.frame;
    [self.backgroundView addSubview:effectView];
    [self.view sendSubviewToBack:self.backgroundView];
    
    self.logoutBtn.layer.cornerRadius = 15;
    [self.userIcon setImage:[UIImage imageNamed:@"userIcon"] forState:UIControlStateNormal];
    self.userIcon.layer.cornerRadius = self.userIcon.frame.size.width * 0.5;
    self.userIcon.imageView.layer.cornerRadius = self.userIcon.imageView.frame.size.height * 0.5;
    self.userIcon.contentEdgeInsets = UIEdgeInsetsMake(3.0, 3.0, 3.0, 3.0);
}

- (IBAction)logout:(UIButton *)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出登录" message:@"是否确定退出？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [DBNetwork logoutUserWithBlock:^{
            [UserInfo removeUserInfo];
            [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows lastObject] animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"登出成功！";
            [hud hideAnimated:YES afterDelay:1.0];
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:confirmAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
