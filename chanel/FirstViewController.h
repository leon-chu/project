//
//  FirstViewController.h
//  chanel
//
//  Created by LeonChu on 14/11/5.
//  Copyright (c) 2014年 LeonChu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemModel.h"
#import "ItemInfoCell.h"
#import "CellWHModel.h"
#import "FlowWaterLayout.h"
#import "SecondViewController.h"

@interface FirstViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *headWebView;
@property (nonatomic,strong) NSMutableArray* imagesNsdata;
@property (weak, nonatomic) IBOutlet UICollectionView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *goTopButton;
@property (copy, nonatomic)NSArray *sections;

- (int) clacImageWidthHeightPercent:(int)width calc:(int)height;
- (void) requestMtopData:(int)pageNo:(int)count;
+ (NSMutableDictionary*) getImageCache;

- (IBAction)goTop:(id)sender;
@end

