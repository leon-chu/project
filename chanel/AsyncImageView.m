//
//  AsyncImageView.m
//  chanel
//
//  Created by LeonChu on 14/11/7.
//  Copyright (c) 2014年 LeonChu. All rights reserved.
//


#import "AsyncImageView.h"
#import "FirstViewController.h"


@interface AsyncImageView ()

@end

@implementation AsyncImageView


- (void) loadImage:(NSString*)imageURL {
    [self loadImage:imageURL withPlaceholdImage:nil];
}



- (void) loadImage:(NSString*)imageURL withPlaceholdImage:(UIImage *)placeholdImage {
    self.image = placeholdImage;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        UIImage *image = [self imageFromCache:imageURL];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (image) 
                self.image = image;
            else
                [self downloadImage:imageURL];
        });
    });
}


#pragma mark - 
#pragma mark private downloads
- (void) downloadImage:(NSString *)imageURL {
    
// 后续比较，queue 与 block哪个效果更好
//    if (!_queue) {
//        _queue = [[NSOperationQueue alloc] init];
//    }
//    
//    NSString * newImageURL = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url = [NSURL URLWithString:newImageURL];
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    [request setDelegate:self];
//    [request setDidFinishSelector:@selector(requestDone:)];
//    [request setDidFailSelector:@selector(requestWentWrong:)];
//    [_queue addOperation:request]; //queue is an NSOperationQueue
    
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]]; 
    
    NSString * newImageURL = [imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:newImageURL];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        NSLog(@"async image download done");
        
        // Use when fetching binary data
        NSData *responseData = [request responseData];
        if (responseData == nil) {
            return;
        }
    
        UIImage *tempImage = [UIImage imageWithData:responseData];
        [self imageToCache:tempImage :imageURL];
        

        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            dispatch_sync(dispatch_get_main_queue(), ^{
                  self.image = tempImage;
            });
        });
        

    }];
    
    
    [request setFailedBlock:^{
        [request cancel];
        NSError *error = [request error];
        NSLog(@"async image download failed url:%@, error:%@", imageURL, [error localizedDescription]);
    }];
    
    [request startAsynchronous];
}



//- (void)requestDone:(ASIHTTPRequest *)request
//{
//    NSLog(@"async image download done");
//    
//    // Use when fetching binary data
//    NSData *responseData = [request responseData];
//    if (responseData == nil) {
//        return;
//    }
//    
//    self.image = [UIImage imageWithData:responseData];
//    NSURL *url = [request originalURL];
//    [self imageToCache:self.image :[url absoluteString]];
//}
//
//- (void)requestWentWrong:(ASIHTTPRequest *)request
//{
//    [request cancel];
//    NSError *error = [request error];
//    NSURL *url = [request originalURL];
//    NSLog(@"async image download failed url:%@, error:%@", [url absoluteString], [error localizedDescription]);
//    
//}







- (UIImage*) imageFromCache:(NSString*)imageURL {
    if (imageURL.length == 0) return nil;
    
    UIImage *image = nil;
    if ((image = [[FirstViewController getImageCache] objectForKey:imageURL])) {
        return image;
    }
    return image;
}



- (void) imageToCache:(UIImage*)imageObj :(NSString *)imageURL {
    if ([[FirstViewController getImageCache] count] > 100){
        NSLog(@"imageCache > MaxCacheSize.  clear cache.");
        [[FirstViewController getImageCache] removeAllObjects];
    }
    [[FirstViewController getImageCache] setObject:imageObj forKey:imageURL];
}

@end
