//
//  ItemModel.h
//  chanel
//
//  Created by LeonChu on 14/11/7.
//  Copyright (c) 2014年 LeonChu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemModel : NSObject

/*
 * title
 */
@property (nonatomic, strong) NSString *title;

/*
 * 商品id
 */
@property (nonatomic, assign) long itemId;

/*
 * 图片url
 */
@property (nonatomic, strong) NSString *picUrl;

/*
 * 图片高
 */
@property (nonatomic, assign) NSInteger imageHeight;

/*
 * 图片宽
 */
@property (nonatomic, assign) NSInteger imageWidth;

/*
 * 原价
 */
@property (nonatomic, assign) double price;

/*
 * 优惠价
 */
@property (nonatomic, assign) double priceWithRate;

@end
