//
//  ViewController.m
//  AF-BackgroundDownload
//
//  Created by Wilson Yuan on 16/9/9.
//  Copyright © 2016年 Wilson-Yuan. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.being.backgroundtasks"];
    config.sessionSendsLaunchEvents = YES;
    config.discretionary = YES;
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    //request
    NSURL *url = [NSURL URLWithString:@"http://7xqgm2.com2.z0.glb.qiniucdn.com/snap/video/e5652bd3-876b-4ddc-a33c-f43c78a63e02.mp4"];
    NSURLRequest *requst = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:requst progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"downloadProgress: %.2f", downloadProgress.fractionCompleted);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSLog(@"targetPath: %@", targetPath);
        return targetPath;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"%@", filePath);
    }];
    
    [manager setDidFinishEventsForBackgroundURLSessionBlock:^(NSURLSession * _Nonnull session) {
        if (self.completionHandler) {
            self.completionHandler();
        }
        
        if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.alertAction = @"FINISHED_DOWNLOAD_TASK";
            notification.alertTitle = @"Notice";
            notification.alertBody = @"Did finished download tasks";
            notification.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        }
    }];
    
    [task resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
