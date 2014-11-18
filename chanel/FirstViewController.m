//
//  FirstViewController.m
//  chanel
//
//  Created by LeonChu on 14/11/5.
//  Copyright (c) 2014年 LeonChu. All rights reserved.
//
#import "FirstViewController.h"


@interface FirstViewController ()

@property (strong, nonatomic) NSMutableArray *itemDoArray;

@end

static NSMutableDictionary * cache = nil;
static NSString *itemInfoCellID = @"itemInfoCellID";

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self configureWebView];
//    [self loadAddressURL];
    
    _itemDoArray = [[NSMutableArray alloc]initWithCapacity:20];
    
    
    // 发送http请求接口数据
    [self requestMtopData:1 :130];
    
    // 注册cell class
    [self.imageView registerClass:[ItemInfoCell class]
       forCellWithReuseIdentifier:itemInfoCellID];
    
    self.imageView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    
    NSLog(@"main screen width=%f", [[UIScreen mainScreen] bounds].size.width);
    NSLog(@"main screen height=%f", [[UIScreen mainScreen] bounds].size.height);
//    self.imageView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    
    FlowWaterLayout *layout = [self.imageView collectionViewLayout];
    [layout setItemDOArray:self.itemDoArray];

}


#pragma mark - Configuration
- (void)configureWebView {
    self.headWebView.backgroundColor = [UIColor grayColor];
    self.headWebView.scalesPageToFit = YES;
    self.headWebView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.headWebView.scrollView.scrollEnabled = NO;
}

- (void)loadAddressURL {
    NSURL *requestURL = [NSURL URLWithString:@"http://wapp.m.taobao.com/category/test.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    [self.headWebView loadRequest:request];
}


//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    if(navigationType == UIWebViewNavigationTypeLinkClicked)
//    {
//        SecondViewController *newWebView = [[SecondViewController alloc] init];
////        [newWebView loadRequest:request.URL];
//        [[self navigationController] pushViewController:self animated:YES];
//        return NO;
//    }
//    else {
//        return YES;
//        
//    }
//}


// 有多少个分区需要显示（非行列概念）
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}



// 某个section里有多少个item
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return _itemDoArray.count;
}



-(int) clacImageWidthHeightPercent:(int)width :(int)height{
    if(width % height){
        return[self clacImageWidthHeightPercent: height : width % height];
    } else {
         return height;
    }
}


// 对于某个位置应该显示什么样的cell ￼
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    ItemInfoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemInfoCellID forIndexPath:indexPath];
   
    ItemModel *itemModel = [_itemDoArray objectAtIndex:indexPath.row];
    
    [cell setItemInfo:itemModel];
    
    NSLog(@"row : %d", indexPath.row);
//  NSLog(@"section : %d", indexPath.section);
    
    return cell;

}


// 布局的委托方法 得到单元尺寸
//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout*)collectionViewLayout
//    sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSLog(@"row : %d, section : %d", indexPath.row, indexPath.section);
//    
//    ItemModel *itemModel = [_itemDoArray objectAtIndex:indexPath.row];
//
//    NSLog(@"row : %d", indexPath.row);
//    //    NSLog(@"section : %d", indexPath.section);
//    
//    
//    // 取父view的宽 / 列  获取每列的宽度
//    int const columnWidth = (self.imageView.frame.size.width - 60) / 2;
//    
//    double imageHeight = columnWidth;
//    double imageWidth = columnWidth;
//    
//    if (itemModel.imageHeight == itemModel.imageWidth) {
//            ;
//    } else {
//        double percent = itemModel.imageWidth / columnWidth;
//        imageWidth = itemModel.imageHeight / percent;
//        imageHeight = itemModel.imageWidth / percent;
//    }
//    return  CGSizeMake(imageWidth, imageHeight);
//}



//定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(1,1,1,1);
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [cache removeAllObjects];// 清理CACHE
    NSLog(@"didReceiveMemoryWarning, 清理CACHE.");
}


// 图片cache 方法
+(NSMutableDictionary*) getImageCache{
    if (cache != nil) {
        return cache;
    } else {
        // init image cache
        @synchronized(self){
            if (cache == nil) {
                cache = [[NSMutableDictionary alloc]init];
            }
            return cache;
        }
    }
}


/**
 *  HTTP 请求瀑布流接口类 
 *  pageNo:第几页  pageSize:每页取多少条
 */
- (void) requestMtopData:(int) pageNo:(int) pageSize{
   
    NSString *oraUrl = [[NSString alloc]initWithFormat:
                       @"http://110.75.70.9/realTimeSearch.do?albumId=NZ_ONLINE_GXH&currentPage=%d&pageSize=%d&param={\"geneid\":\"0\"}", pageNo, pageSize ];
    
    //第一步，创建URL
    NSString * encodingUrlStr = [oraUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodingUrlStr];
    
    //第二步，通过URL创建网络请求 url，缓存协议，超时时间（秒）
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:3];
    
    NSError *error;
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error != nil) {
        NSLog(@"request error:%@", [error localizedDescription]);
        return;
    } else {
        // debug info
//        NSString *jsonStr = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
//        NSLog(@"receive json :%@", jsonStr);
    }
    
    if (received == nil) {
        NSLog(@"receiced is nil");
        return;
    }
    
    // 解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:&error];
    if(jsonDic != nil && [jsonDic objectForKey:@"model"] != nil){
        NSDictionary *model = [jsonDic objectForKey:@"model"];
        
        if (model == nil) {
            return;
        }
        
        
        NSDictionary *result = [model objectForKey:@"result"];
        if (result == nil) {
            NSLog(@"result is nil, 解析数据出错!");
            return;
        }
        
        NSArray *itemList = [result objectForKey:@"itemList"];
        if (itemList == nil) {
            NSLog(@"result is nil, 解析数据出错!");
            return;
        }
        
        for(NSDictionary *item in itemList){
            if (item == nil) {
                continue;
            }
            
            ItemModel *model = [ItemModel alloc];
            // TODO 类型转换是否会异常？
            NSString *title = [item objectForKey:@"title"];
            [model setTitle:title];
            
            NSString *pic = [item objectForKey:@"picUrl"];
            NSString *cdnPic = [pic stringByAppendingString:@"_320x320q50.jpg"];
//            NSString *newpic  = [pic stringByReplacingOccurrencesOfString:@"gw" withString:@""];
            [model setPicUrl:cdnPic];
            
            long itemId = [[item objectForKey:@"itemId"] longValue];
            [model setItemId:itemId];
            
            double normalPrice = [[item objectForKey:@"normalPrice"] doubleValue];
            [model setPrice:normalPrice];
            
            double marketPrice = [[item objectForKey:@"marketPrice"] doubleValue];
            [model setPriceWithRate:marketPrice];
            
            NSInteger imageHeight = [[item objectForKey:@"imageHeight"] integerValue];
            [model setImageHeight:imageHeight];
            
            NSInteger imageWidth = [[item objectForKey:@"imageWidth"] integerValue];
            [model setImageWidth:imageWidth];

            [_itemDoArray addObject:model];
           
        }
        
         NSLog(@"item DO count = %d", _itemDoArray.count);

    }

}



- (IBAction) goTop:(id)sender{
    [self.imageView  scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO ];
}

@end
