//
//  AppDelegate.m
//  0812-DouBanFM
//
//  Created by 洪龙通 on 16/8/12.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "DBChannelViewController.h"
#import "DBUserViewController.h"
#import <MediaPlayer/MPMediaItem.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "DBSongInfo.h"
#import "DBAudioPlayer.h"
#import "UIImage+AT.h"

@interface AppDelegate ()

@property (nonatomic, assign) UIBackgroundTaskIdentifier bgTaskId;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window.rootViewController = self.drawerViewController;
    
    [self configureDrawerViewController];
    
    //  [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)configureDrawerViewController {
    
    self.drawerViewController.leftViewController   = self.leftDrawerViewController;
    self.drawerViewController.centerViewController = self.playerViewViewController;
    self.drawerViewController.rightViewController  = self.rightDrawerViewController;
    
    self.drawerViewController.animator = self.drawerAnimator;
    
    self.drawerViewController.backgroundImage = [UIImage imageNamed:@"bgImage"];
}

#pragma mark - Drawer View Controllers

- (JVFloatingDrawerViewController *)drawerViewController {
    if (!_drawerViewController) {
        _drawerViewController                  = [[JVFloatingDrawerViewController alloc] init];
        _drawerViewController.rightDrawerWidth = 200.0;
        _drawerViewController.leftDrawerWidth  = 100;
        
    }
    
    return _drawerViewController;
}

- (UIViewController *)playerViewViewController {
    if (!_playerViewViewController) {
        _playerViewViewController = [[ViewController alloc] init];
    }
    
    return _playerViewViewController;
}

- (UIViewController *)userLoginViewController {
    if (!_userLoginViewController) {
        _userLoginViewController = [[UIViewController alloc] init];
    }
    
    return _userLoginViewController;
}


#pragma mark Sides

- (UIViewController *)leftDrawerViewController {
    if (!_leftDrawerViewController) {
        _leftDrawerViewController = [[DBUserViewController alloc] init];
    }
    
    return _leftDrawerViewController;
}

- (UITableViewController *)rightDrawerViewController {
    if (!_rightDrawerViewController) {
        _rightDrawerViewController = [[DBChannelViewController alloc] init];
    }
    
    return _rightDrawerViewController;
}

- (JVFloatingDrawerSpringAnimator *)drawerAnimator {
    if (!_drawerAnimator) {
        _drawerAnimator = [[JVFloatingDrawerSpringAnimator alloc] init];
    }
    
    return _drawerAnimator;
}

#pragma mark - Global Access Helper

+ (AppDelegate *)globalDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)toggleLeftDrawer:(id)sender animated:(BOOL)animated {
    [self.drawerViewController toggleDrawerWithSide:JVFloatingDrawerSideLeft animated:animated completion:nil];
}

- (void)toggleRightDrawer:(id)sender animated:(BOOL)animated {
    [self.drawerViewController toggleDrawerWithSide:JVFloatingDrawerSideRight animated:animated completion:nil];
}


-(void)reloadScreenView
{
    NSMutableDictionary *currentSongInfo = [[NSMutableDictionary alloc] init];
    
    MPMediaItemArtwork *albumImageItem = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[DBSongInfo currentSong].picture]]]];
    [currentSongInfo setObject:[NSNumber numberWithFloat:[DBAudioPlayer escapeTime]] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [currentSongInfo setObject:[NSNumber numberWithFloat:[DBAudioPlayer duration]] forKey:MPMediaItemPropertyPlaybackDuration];
    [currentSongInfo setObject:[DBSongInfo currentSong].title forKey:MPMediaItemPropertyTitle];
    [currentSongInfo setObject:[DBSongInfo currentSong].artist forKey:MPMediaItemPropertyArtist];
    [currentSongInfo setObject:albumImageItem  forKey:MPMediaItemPropertyArtwork];
    
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:currentSongInfo];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [application beginBackgroundTaskWithExpirationHandler:nil];
    [self reloadScreenView];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [(ViewController *)_playerViewViewController resumeAlbumRotating];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
