//
//  ItemInfoCell.m
//  chanel
//
//  Created by LeonChu on 14/11/9.
//  Copyright (c) 2014年 LeonChu. All rights reserved.
//

#import "ItemInfoCell.h"


@implementation ItemInfoCell

// 属性get set方法
@synthesize photoView;
@synthesize titleLabel;
@synthesize priceLabel;
@synthesize priceWithRateLabel;



- (AsyncImageView *)getPhotoView {
    if (!photoView) {
        photoView = [[AsyncImageView alloc] init];
        photoView.contentMode = UIViewContentModeScaleAspectFill;
        photoView.clipsToBounds = YES;
        [self addSubview:photoView];
    }
    return photoView;
}

- (UILabel *)getTitleLabel {
    if (!titleLabel) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
    }
    return titleLabel;
}

- (void)layoutSubviews :(ItemModel *)model {
    if(model == nil){
        return;
    }
    self.photoView.frame = CGRectInset(self.bounds, 0, 0);
    self.titleLabel.frame = CGRectMake(3, self.bounds.size.height - 20 - 3,
                                       self.bounds.size.width - 2 * 3, 20);

}


-(void)setItemInfo:(ItemModel *)itemModel{
    if (!itemModel) {
        NSLog(@"itemModel is nil.");
        return;
    }
    
    AsyncImageView *imageView = [self getPhotoView];

    [imageView loadImage:itemModel.picUrl];
    
    [self getTitleLabel].text = itemModel.title;
    
    [self layoutSubviews:itemModel];

}



@end
