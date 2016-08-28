//
//  DBNetwork.m
//  0812-DouBanFM
//
//  Created by 洪龙通 on 16/8/13.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "DBNetwork.h"
#import "AFNetworking.h"
#import "DBSongInfo.h"
#import "DBChannelInfo.h"
#import "DBHttpTools.h"
#import "DBUserLoginParameter.h"
#import "UserInfo.h"
#import "MJExtension.h"
#import "DBAudioPlayer.h"

static NSMutableString *captchaID;

@implementation DBNetwork

+ (void)loadFMListWithType:(NSString *)type success:(void (^)())success
{
    if ([DBChannelInfo currentChannel].ID == nil) {
        DBChannelInfo *currentChannel = [DBChannelInfo currentChannel];
        currentChannel.ID             = @0;
        currentChannel.name           = @"我的私人";
    }
    NSString *urlString = [NSString stringWithFormat:PLAYLISTURLFORMATSTRING, type, [DBSongInfo currentSong].sid, [DBAudioPlayer escapeTime], [DBChannelInfo currentChannel].ID];

    [DBHttpTools GET:urlString parameters:nil success:^(id responseObject) {
        
        [DBSongInfo setInfoWithDictionary:[responseObject[@"song"] firstObject]];
        if(success)
        {
            success();
        }
    } failure:^(NSError *error) {
        WBLog(@"LoadFMList error:%@", error);
    }];
}

+ (void)loadChannelsWihtURL:(NSString *)urlString complete:(completeBlock)complete
{
    [DBHttpTools GET:urlString parameters:nil success:^(id responseObject) {
        NSDictionary *dict = responseObject[@"data"];
        NSMutableArray *dataArray = [NSMutableArray array];
        if (dict[@"res"])
        {
            NSDictionary *resDict = dict[@"res"];
            if (resDict[@"rec_chls"]) {
                for (NSDictionary *channelDict in resDict[@"rec_chls"]) {
                    DBChannelInfo *channel = [DBChannelInfo channelInfoWithDict:channelDict];
                    [dataArray addObject:channel];
                }
            }else {
                DBChannelInfo *channel = [DBChannelInfo channelInfoWithDict:resDict];
                [dataArray addObject:channel];
            }
            
        }else if (dict[@"channels"]) {
            for (NSDictionary *channelDict in dict[@"channels"]) {
                DBChannelInfo *channel = [DBChannelInfo channelInfoWithDict:channelDict];
                [dataArray addObject:channel];
            }
        }
        if (complete) {
            complete([dataArray copy]);
        }
    } failure:^(NSError *error) {
        WBLog(@"LoadChannels error:%@", error);
    }];
	
}

+ (void)loadSongLrcWithBlock:(finishBlock)finish
{
    NSString *urlString = [NSString stringWithFormat:@"http://geci.me/api/lyric/%@/%@", [DBSongInfo currentSong].title, [DBSongInfo currentSong].artist];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    [DBHttpTools GET:urlString parameters:nil success:^(id responseObject) {
        
        NSDictionary *data = responseObject;
        NSInteger count = [[data objectForKey:@"count"] integerValue];
        //判断是否获取到json数据才开始解析
        if (count != 0) {
            
            NSArray *resultArray = [data objectForKey:@"result"];
            for (NSDictionary *lrcDict in resultArray) {
                NSURL *url = [NSURL URLWithString: lrcDict[@"lrc"]];
                NSData *contentData = [NSData dataWithContentsOfURL:url];
                NSString *contentStr = [[NSString alloc] initWithData:contentData encoding:NSUTF8StringEncoding];
                
                if (contentStr != nil) {
                    [DBSongInfo currentSong].lrcContentStr = contentStr;
                    break;
                }
            }
            
        }else{
            [DBSongInfo currentSong].lrcContentStr = nil;
        }
        if(finish)
        {
            finish();
        }
    } failure:^(NSError *error) {
        WBLog(@"Load Song Lrc error:%@", error);
    }];
    
}

+ (void)loginWithParameter:(DBUserLoginParameter *)loginParameter finish:(void (^)(BOOL))finish
{
    loginParameter.captcha_id = captchaID;
    
    NSString *urlString = [NSString stringWithFormat:LOGINURLSTRING, loginParameter.alias, loginParameter.form_password, loginParameter.captcha_solution, loginParameter.captcha_id];
    
    [DBHttpTools GET:urlString parameters:nil success:^(id responseObject)
    {
        if ([responseObject objectForKey:@"err_msg"]) {
            NSLog(@"GET error:%@", responseObject[@"err_msg"]);
        }
        NSDictionary *dictionary = responseObject;
        if ([[dictionary objectForKey:@"r"] intValue] == 0) {
            [UserInfo setValuesWithDictionary:[dictionary objectForKey:@"user_info"]];
            [UserInfo storeUserInfo];
            if (finish) {
                finish(YES);
            };
            
        }else{
            if (finish) {
                finish(NO);
            };
        }
        captchaID = nil;
        
    } failure:^(NSError *error) {
        WBLog(@"Login error:%@", error);
    }];
}

+ (void)loadCaptchaImageWithBlock:(void (^)(NSString *))success
{
    WBLog(@"加载验证码");
    [DBHttpTools GETByHttpResponseWithURL:CAPTCHAIDURLSTRING parameters:nil success:^(id responseObject) {
        
        if (responseObject) {
            NSMutableString *dataString = [[NSMutableString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            [dataString replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [dataString length])];
            captchaID = dataString;
            NSString *captchaURLString = [NSString stringWithFormat:CAPTCHAIMGURLFORMATSTRING,captchaID];
            if (success) {
                success(captchaURLString);
            }
        }
        
    } failure:^(NSError *error) {
        WBLog(@"Load captcha fail:%@", error);
    }];
}

+ (void)logoutUserWithBlock:(void (^)())success
{
    WBLog(@"登出");
    NSDictionary *logoutParameters = @{@"source": @"radio",
                                       @"ck": [UserInfo userInfo].ck,
                                       @"no_login": @"y"};
    [DBHttpTools GETByHttpResponseWithURL:LOGOUTURLSTRING parameters:logoutParameters success:^(id responseObject) {
        
        if (success){
            success();
        }
    } failure:^(NSError *error) {
        WBLog(@"LOGOUT_ERROR:%@", error);
    }];
}

@end

