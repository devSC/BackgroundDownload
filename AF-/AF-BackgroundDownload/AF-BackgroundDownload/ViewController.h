//
//  ViewController.h
//  AF-BackgroundDownload
//
//  Created by Wilson Yuan on 16/9/9.
//  Copyright © 2016年 Wilson-Yuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (copy, nonatomic) void (^completionHandler)();

@end

