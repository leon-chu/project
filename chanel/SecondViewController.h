//
//  SecondViewController.h
//  chanel
//
//  Created by LeonChu on 14/11/5.
//  Copyright (c) 2014年 LeonChu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController<UIWebViewDelegate>


@property (weak, nonatomic) IBOutlet UIWebView *h5WebView;

@property (weak, nonatomic) IBOutlet UITextField *addressText;

@end

