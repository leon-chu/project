//
//  SecondViewController.m
//  chanel
//
//  Created by LeonChu on 14/11/5.
//  Copyright (c) 2014年 LeonChu. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureWebView];
    [self loadAddressURL];

}


#pragma mark - Configuration
- (void)configureWebView {
    self.h5WebView.backgroundColor = [UIColor whiteColor];
    self.h5WebView.scalesPageToFit = YES;
    self.h5WebView.dataDetectorTypes = UIDataDetectorTypeAll;
}

- (void)loadAddressURL {
    NSURL *requestURL = [NSURL URLWithString:self.addressText.text];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    [self.h5WebView loadRequest:request];
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    // Report the error inside the web view.
    NSString *localizedErrorMessage = NSLocalizedString(@"An error occured:", nil);
    NSString *errorFormatString = @"<!doctype html><html><body><div style=\"width: 100%%; text-align: center; font-size: 36pt;\">%@%@</div></body></html>";
    
    NSString *errorHTML = [NSString stringWithFormat:errorFormatString, localizedErrorMessage, error.localizedDescription];
    [self.h5WebView loadHTMLString:errorHTML baseURL:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


#pragma mark - UITextFieldDelegate

// This helps dismiss the keyboard when the "Done" button is clicked.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    [self loadAddressURL];
    
    return YES;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
