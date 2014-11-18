#import <UIKit/UIKit.h>
#import "ItemModel.h"
#import "CellWHModel.h"

@interface FlowWaterLayout : UICollectionViewLayout

@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) NSInteger cellCount;

@property (strong, nonatomic) NSMutableArray *itemDOArray;
@property (strong, nonatomic) NSMutableArray *cacheCellInfoArray;

@end
