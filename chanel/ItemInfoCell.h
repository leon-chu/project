//
//  ItemInfoCell.h
//  chanel
//
//  Created by LeonChu on 14/11/9.
//  Copyright (c) 2014年 LeonChu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "ItemModel.h"

@interface ItemInfoCell : UICollectionViewCell

/*
 * photo view
 */
@property (nonatomic, strong) AsyncImageView *photoView;
/*
 * title view
 */
@property (nonatomic, strong) UILabel *titleLabel;
/*
 * 原价 view
 */
@property (nonatomic, strong) UILabel *priceLabel;
/*
 * 优惠价 view
 */
@property (nonatomic, strong) UILabel *priceWithRateLabel;

-(void)setItemInfo:(ItemModel *)itemModel;

@end
