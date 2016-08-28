//
//  DBCommon.h
//  0812-DouBanFM
//
//  Created by 洪龙通 on 16/8/19.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#ifndef DBCommon_h
#define DBCommon_h


#define PLAYLISTURLFORMATSTRING @"http://douban.fm/j/mine/playlist?type=%@&sid=%@&pt=%f&channel=%@&from=mainsite"

//#define LOGINURLSTRING     @"http://douban.fm/j/login"
#define LOGINURLSTRING     @"https://douban.fm/j/login?source=radio&alias=%@&form_password=%@&captcha_solution=%@&captcha_id=%@&task=sync_channel_list"
#define LOGOUTURLSTRING    @"http://douban.fm/partner/logout"
#define CAPTCHAIDURLSTRING @"http://douban.fm/j/new_captcha"
#define CAPTCHAIMGURLFORMATSTRING @"http://douban.fm/misc/captcha?size=m&id=%@"

#define DBUserInfoFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"userInfo.archiver"]

#define RGBCOLOR(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#endif /* DBCommon_h */
