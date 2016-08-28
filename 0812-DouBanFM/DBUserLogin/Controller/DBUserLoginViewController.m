//
//  DBUserLoginViewController.m
//  0812-DouBanFM
//
//  Created by 洪龙通 on 16/8/14.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "DBUserLoginViewController.h"
#import "DBUserLoginParameter.h"
#import "DBNetwork.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "IQKeyboardManager.h"

@interface DBUserLoginViewController ()

@property (nonatomic, weak) UITextField *userTextField;
@property (nonatomic, weak) UITextField *passwdTextField;
@property (nonatomic, weak) UITextField *captchaTextField;
@property (nonatomic, weak) UIImageView *captchaImage;
@end

@implementation DBUserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)setupSubviews
{
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login"]];
    backgroundView.frame        = self.view.bounds;
    [self.view addSubview:backgroundView];
    
    UIButton *closeBtn       = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setTitle:@"返回" forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake(10, 10, 50, 50);
    [self.view addSubview:closeBtn];
    
    UIButton *signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [signInBtn setTitle:@"登  录" forState:UIControlStateNormal];
    [signInBtn setBackgroundImage:[UIImage imageNamed:@"signIn"] forState:UIControlStateNormal];
    CGSize signInBtnS  = signInBtn.currentBackgroundImage.size;
    CGFloat signInBtnX = self.view.center.x - signInBtnS.width * 0.5;
    CGFloat signInBtnY = 390;
    signInBtn.frame    = (CGRect){signInBtnX, signInBtnY, signInBtnS};
    [signInBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signInBtn];
    
    UITextField *userTextField          = [[UITextField alloc] init];
    userTextField.clearButtonMode       = UITextFieldViewModeWhileEditing;
    NSDictionary *attributeDict         = @{NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    userTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入用户名" attributes:attributeDict];
    userTextField.textColor             = [UIColor whiteColor];
    userTextField.backgroundColor       = [UIColor clearColor];
    CGFloat userW                       = 200;
    CGFloat userH                       = 40;
    CGFloat userX                       = self.view.center.x - userW * 0.5 + 10;
    CGFloat userY                       = 232;
    userTextField.frame                 = CGRectMake(userX, userY, userW, userH);
    [self.view addSubview:userTextField];
    self.userTextField = userTextField;
    
    UITextField *passwdTextField          = [[UITextField alloc] init];
    passwdTextField.secureTextEntry       = YES;
    passwdTextField.clearButtonMode       = UITextFieldViewModeWhileEditing;
    passwdTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:attributeDict];
    passwdTextField.textColor             = [UIColor whiteColor];
    passwdTextField.backgroundColor       = [UIColor clearColor];
    passwdTextField.frame                 = CGRectMake(userX, CGRectGetMaxY(userTextField.frame) + 5, userW, userH);;
    [self.view addSubview:passwdTextField];
    self.passwdTextField = passwdTextField;
    
    UITextField *captchaTextField          = [[UITextField alloc] init];
    captchaTextField.clearButtonMode       = UITextFieldViewModeWhileEditing;
    captchaTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证码" attributes:attributeDict];
    captchaTextField.textColor             = [UIColor whiteColor];
    captchaTextField.backgroundColor       = [UIColor clearColor];
    captchaTextField.frame                 = CGRectMake(userX, CGRectGetMaxY(passwdTextField.frame), userW, userH);
    [self.view addSubview:captchaTextField];
    self.captchaTextField = captchaTextField;
    
    UIImageView *captchaImage = [[UIImageView alloc] init];
    captchaImage.frame        = CGRectMake(CGRectGetMaxX(captchaTextField.frame) - 80, CGRectGetMaxY(passwdTextField.frame), 100, 43);
    [self.view addSubview:captchaImage];
    self.captchaImage = captchaImage;
    [self loadCaptchaImage];
    
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  加载二维码
 */
- (void)loadCaptchaImage
{
    __weak typeof(self) selfVC = self;
    [DBNetwork loadCaptchaImageWithBlock:^(NSString *url) {
        if (url) {
            [selfVC.captchaImage sd_setImageWithURL:[NSURL URLWithString:url]];
        }else{
            [selfVC loadCaptchaImage];
        }
    }];
}

- (void)login
{
    DBUserLoginParameter *loginParameter = [[DBUserLoginParameter alloc] init];
    loginParameter.alias                 = self.userTextField.text;
    loginParameter.form_password         = self.passwdTextField.text;
    loginParameter.source                = @"radio";
    loginParameter.captcha_solution      = self.captchaTextField.text;
    loginParameter.task                  = @"sync_channel_list";
    
    [DBNetwork loginWithParameter:loginParameter finish:^(BOOL isSuccess) {
        if (isSuccess) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows lastObject] animated:YES];
            hud.label.text     = @"登录成功";
            [hud hideAnimated:YES afterDelay:1.0];
            self.userTextField.text   = @"";
            self.passwdTextField.text = @"";
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            self.passwdTextField.text  = @"";
            self.captchaTextField.text = @"";
            MBProgressHUD *hud         = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode                   = MBProgressHUDModeText;
            hud.label.text             = @"登录失败";
            [hud hideAnimated:YES afterDelay:1.0];
            [self loadCaptchaImage];
        }
    }];
}
@end
