//
//  CellWHModel.h
//  chanel
//
//  Created by LeonChu on 14/11/10.
//  Copyright (c) 2014年 LeonChu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CellWHModel : NSObject

/*
 * 图片高
 */
@property (nonatomic, assign) NSInteger imageHeight;

/*
 * 图片宽
 */
@property (nonatomic, assign) NSInteger imageWidth;

/*
 * 列 1:左 2:右
 */
@property (nonatomic, assign) NSInteger column;

/*
 * 列当前在View中的高度(Y的高度)
 */
@property (nonatomic, assign) NSInteger columnCurrentHeight;


@property(nonatomic) CGRect frame;

@property (nonatomic) CGSize size;


@end
