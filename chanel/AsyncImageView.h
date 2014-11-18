//
//  AsyncImageView.h
//  chanel
//
//  Created by LeonChu on 14/11/7.
//  Copyright (c) 2014年 LeonChu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

@interface AsyncImageView : UIImageView <ASIHTTPRequestDelegate>{
    
}

@property (strong, nonatomic) NSOperationQueue  *queue;
- (void) loadImage:(NSString*)imageURL;
- (void) loadImage:(NSString*)imageURL withPlaceholdImage:(UIImage*)image;


@end
