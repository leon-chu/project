
#import "FlowWaterLayout.h"

#define ITEM_SIZE 70
#define SPACE 3

@interface FlowWaterLayout()

@property (nonatomic, assign) NSInteger collectionViewHeight;

@end


@implementation FlowWaterLayout

@synthesize itemDOArray;
@synthesize cacheCellInfoArray;

/**
 * 调用布局对象的invalidateLayout 方法来明确地告诉集合视图更新其布局。
 * 该方法丢弃已经存在的布局信息并且强制布局对象生成新的布局信息
 */
-(void)invalidate{
    [super invalidateLayout];
}


// 1.使用 prepareLayout 方法来执行提供布局信息所需的各种前期计算。
-(void)prepareLayout
{
    [super prepareLayout];
    
    // init
    cacheCellInfoArray = [[NSMutableArray alloc] init];
    
    // cell 数量
    _cellCount = [[self collectionView] numberOfItemsInSection:0];

    
    // 取父view的宽 / 列  获取每列的宽度
    int const columnWidth = (self.collectionView.frame.size.width - SPACE * 3) / 2;
    
    // cell size
    for (NSInteger i=0; i<self.itemDOArray.count; i++) {
        
        ItemModel *itemModel = [self.itemDOArray objectAtIndex:i];
        
        // cell信息
        CellWHModel *cellInfo = [[CellWHModel alloc]init];

        // 图片原始尺寸
        double oraHeight = itemModel.imageHeight;
        double oraWidth = itemModel.imageWidth;
        
        // 初始化为等比
        long imageHeight = columnWidth;
        long imageWidth = columnWidth;
        
        // 判断是否是等比
        if (oraHeight == oraWidth) {
            cellInfo.size = CGSizeMake(columnWidth, columnWidth);
            // 将缩放后的尺寸保存
            [itemModel setImageHeight:columnWidth];
            [itemModel setImageWidth:columnWidth];
        } else {
            // 等比缩放
            double percent = oraWidth / (double)columnWidth;
            imageWidth = columnWidth;
            imageHeight = oraHeight / percent;
            cellInfo.size = CGSizeMake(imageWidth, imageHeight);
            // 将缩放后的尺寸保存
            [itemModel setImageHeight:imageWidth];
            [itemModel setImageWidth:imageHeight];
        }
        
        // 计算在父容器中的高度
        NSLog(@"cacheCellInfoArray.count = %d", self.cacheCellInfoArray.count);

        [cellInfo setImageWidth:imageWidth];
        [cellInfo setImageHeight:imageHeight];
        [self calcWhichColumn:i :cellInfo];
        
        NSInteger x = cellInfo.column == 1 ? SPACE : columnWidth + SPACE * 2;
        NSInteger y = cellInfo.columnCurrentHeight;
        
        cellInfo.frame = CGRectMake(x,
                                    y,
                                    imageWidth,
                                    imageHeight);
        
        NSLog(@"index = %d,  x = %d, y = %d, width = %ld, height = %ld",i, x, y, imageWidth, imageHeight);

        
        // 加入缓存数组
        [cellInfo setColumnCurrentHeight:cellInfo.columnCurrentHeight + imageHeight + SPACE];
        [cacheCellInfoArray addObject:cellInfo];
        
    }
    
    if(cacheCellInfoArray.count != itemDOArray.count){
        NSLog(@"初始化数组不匹配!");
    } else if(itemDOArray.count == 0 || cacheCellInfoArray.count == 0){
        // nodata
        return;
    }
    
    CellWHModel *lastCellInfo = [cacheCellInfoArray objectAtIndex:(cacheCellInfoArray.count - 1)];
    self.collectionViewHeight = lastCellInfo.columnCurrentHeight;
    NSLog(@"total Height:%d", lastCellInfo.columnCurrentHeight);
    
}


/**
 * 2.
 * 使用collectionViewContentSize 方法来返回基于你的初始计算的整个内容区的尺寸
 */
-(CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.frame.size.width,
     self.collectionViewHeight + self.collectionView.contentInset.top);
}




/**
 * 3.
 * 返回rect中的所有的元素的布局属性
 * 返回的是包含UICollectionViewLayoutAttributes的NSArray
 */
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 超出显示范围
    if (rect.origin.x < 0 || rect.origin.y < 0) {
        return nil;
    }
    
    NSInteger startRow = -1, endRow = 0;
    NSInteger rectHeight =  rect.size.height + rect.origin.y;
    NSLog(@"rect.size.height=%f", rect.size.height);
    NSLog(@"rect.origin.y=%f", rect.origin.y);

    for (NSInteger i=0; i< cacheCellInfoArray.count; i++) {
        CellWHModel *cellInfo = [cacheCellInfoArray objectAtIndex:i];
        if (startRow == -1 && rect.origin.y < cellInfo.columnCurrentHeight) {
            startRow = i;
        }
        
        if (cellInfo.columnCurrentHeight > rect.origin.y) {
            endRow = i;
        }
        
        if(cellInfo.columnCurrentHeight > rectHeight) {
            endRow = i;
            break;
        }
    }
    
    // 有在显示范围内
    if (startRow == -1 && endRow == 0) {
        return nil;
    }
    
    // 瀑布流是不规则的结构，要留有偏移量
    NSInteger temp =  startRow - 2;
    if (temp >= 0 ) {
        startRow = temp;
    } else {
        startRow = 0;
    }
    temp =  endRow + 2;
    if (temp <= (cacheCellInfoArray.count - 1) ) {
        endRow = temp;
    } else {
        endRow = (cacheCellInfoArray.count - 1);
    }
    
    // 根据上面计算结果取得cell属性
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i=startRow ; i <= endRow; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}




/*
 * 4.
 * 返回对应于indexPath的位置的cell的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    UICollectionViewLayoutAttributes* attributes =
                [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];


    CellWHModel *cellInfo = [cacheCellInfoArray objectAtIndex:path.row];
    attributes.size = cellInfo.size;
    attributes.frame = cellInfo.frame;
    NSLog(@"row = %d", path.row);

    return attributes;
}




-(CellWHModel *)calcWhichColumn:(NSInteger )index :(CellWHModel *)model{
    long leftHeightSum = 0;
    long rightHeightSum = 0;
    
    // 第一个位置
    if (index == 0 && self.cacheCellInfoArray.count == 0) {
        [model setColumnCurrentHeight:0];
        [model setColumn:1];
        return model;
    }
    
    // 做下校验
    if (self.cacheCellInfoArray.count != index) {
        NSLog(@"cache cell count 与 row不同步");
    }
    
    for (long i=0; i<self.cacheCellInfoArray.count; i++) {
        CellWHModel *cellWHModel = [self.cacheCellInfoArray objectAtIndex:i];
        if (cellWHModel.column == 1) {
            leftHeightSum = leftHeightSum + cellWHModel.imageHeight + SPACE;
        } else {
            rightHeightSum = rightHeightSum + cellWHModel.imageHeight + SPACE;
        }
    }
    
    if (leftHeightSum < rightHeightSum) {
        [model setColumnCurrentHeight:leftHeightSum ];
        [model setColumn:1];
    } else {
        [model setColumnCurrentHeight:rightHeightSum];
        [model setColumn:2];
    }
    
    return model;
}






- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    // Keep track of insert and delete index paths
    [super prepareForCollectionViewUpdates:updateItems];
}

- (void)finalizeCollectionViewUpdates
{
    [super finalizeCollectionViewUpdates];
}



- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
//    CGRect oldBounds = self.collectionView.bounds;
//    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
//        return YES;
//    }
    return NO;
}


// 当前item放大
//-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSArray *array = [super layoutAttributesForElementsInRect:rect];
//    CGRect visibleRect;
//    visibleRect.origin = self.collectionView.contentOffset;
//    visibleRect.size = self.collectionView.bounds.size;
//
//    for (UICollectionViewLayoutAttributes* attributes in array) {
//        if (CGRectIntersectsRect(attributes.frame, rect)) {
//            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
//            CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
//            if (ABS(distance) &lt; ACTIVE_DISTANCE) {
//                CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
//                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
//                attributes.zIndex = 1;
//            }
//        }
//    }
//    return array;
//}

@end
