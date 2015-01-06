//
//  CustomLayout.m
//  ClassHierarchicalTree
//
//  Created by JoyWang on 15/1/6.
//  Copyright (c) 2015年 joywt. All rights reserved.
//

#import "CustomLayout.h"
#import "MyCustomAttributes.h"
#define INSET_TOP  5
#define INSET_LEFT  5
#define INSET_BOTTOM  5
#define INSET_RIGHT  5
#define ITEM_WIDTH 150
#define ITEM_HEIGHT 60
#define CELL_SEC_SPACE  40
#define CELL_ROW_SPACE  20

@interface CustomLayout ()
@property (nonatomic,strong) NSDictionary *layoutInformation;
@property (nonatomic,assign) NSInteger maxNumRows;
@property (nonatomic,assign) UIEdgeInsets insets;
@end

@implementation CustomLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.insets = UIEdgeInsetsMake(INSET_TOP, INSET_LEFT, INSET_BOTTOM, INSET_RIGHT);
    }
    return self;
}
- (CGRect)frameForCellAtIndexPath:(NSIndexPath *)indexPath withHeight:(NSInteger)height{
    NSLog(@"%s . %d",__PRETTY_FUNCTION__,(int)height);
    CGRect rect = CGRectZero;
    rect.origin.x = indexPath.section *(CELL_SEC_SPACE + ITEM_WIDTH) + CELL_SEC_SPACE;
    rect.origin.y = height *(CELL_ROW_SPACE + ITEM_HEIGHT) + CELL_ROW_SPACE;
    rect.size.width = ITEM_WIDTH;
    rect.size.height = ITEM_HEIGHT;
    return rect;
}


- (CGRect)frameForSupplementaryViewOfKind:(NSString *)kind AtIndexPath:(NSIndexPath *)indexPath withHeight:(NSInteger)height numsRowOfChildren:(NSInteger)nums{
    
    NSLog(@"... row:%d , ... height:%d ",(int)indexPath.row,(int)height);
    CGRect rect= CGRectZero;
    rect.origin.x = indexPath.section *( ITEM_WIDTH +CELL_SEC_SPACE );
    rect.origin.y = height*(ITEM_HEIGHT + CELL_ROW_SPACE) + CELL_ROW_SPACE;
    rect.size.width = 40;
    rect.size.height = (ITEM_HEIGHT + CELL_ROW_SPACE)*nums;
    return rect;
}

- (void)prepareLayout{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    /********** 遍历所有cell，记录cell 子cell的indexPath *************/
    NSMutableDictionary *layoutInformation = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellInformation = [NSMutableDictionary dictionary];
    
    /** 补充视图集合 **/
    NSMutableDictionary *supplementaryInfo = [NSMutableDictionary dictionary];
    NSIndexPath *indexPath;
    NSInteger numSections = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < numSections; section++) {
        NSInteger numItems = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < numItems; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            MyCustomAttributes *attributes = [self attributesWithChildrenForIndexPath:indexPath];
            [cellInformation setObject:attributes forKey:indexPath];
            
            UICollectionViewLayoutAttributes *supplementaryAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:@"ConnectionViewKind" withIndexPath:indexPath];
            [supplementaryInfo setObject:supplementaryAttributes forKey:indexPath];
            //            if (section==0) {
            //                UICollectionViewLayoutAttributes *aa = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:@"HelloKind" withIndexPath:indexPath];
            //                [supplementaryInfo setObject:aa
            //                                      forKey:indexPath];
            //            }else{
            //                MyCustomSuppleAttributes *supplementaryAttributes = [MyCustomSuppleAttributes layoutAttributesForSupplementaryViewOfKind:@"ConnectionViewKind" withIndexPath:indexPath];
            //                supplementaryAttributes.indexPath = indexPath;
            //                [supplementaryInfo setObject:supplementaryAttributes forKey:indexPath];
            //            }
            
        }
        
    }
    
    /************* 记录每一个cell 的frame ********************************/
    
    //降序遍历section
    for (NSInteger section = numSections-1; section>=0; section--) {
        NSInteger numItems = [self.collectionView numberOfItemsInSection:section];
        NSInteger totalHeight = 0;
        for (NSInteger item = 0; item < numItems; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            MyCustomAttributes *attributes = [cellInformation objectForKey:indexPath];
            attributes.frame = [self  frameForCellAtIndexPath:indexPath withHeight:totalHeight];
            //            [self adjustFrameOfChildrenAndConnectorsForClassAtIndexPath:indexPath];
            cellInformation[indexPath] = attributes;
            
            UICollectionViewLayoutAttributes *supplementaryAttributes = [supplementaryInfo objectForKey:indexPath];
            NSInteger rows =  [self.customDataSource numRowsForClassAndChildrenAtIndexPath:indexPath];
            supplementaryAttributes.frame = [self frameForSupplementaryViewOfKind: @"ConnectionViewKind" AtIndexPath:indexPath withHeight:totalHeight numsRowOfChildren:rows];
            [supplementaryInfo setObject:supplementaryAttributes forKey:indexPath];
            
            if (attributes.children != nil  && indexPath.section == 1) {
                [attributes.children enumerateObjectsUsingBlock:^(NSIndexPath *obj, NSUInteger idx, BOOL *stop) {
                    MyCustomAttributes *needUpdateAttributes = [cellInformation objectForKey:obj];
                    CGRect frame= needUpdateAttributes.frame;
                    frame.origin.y = attributes.frame.origin.y + idx * (attributes.frame.size.height+CELL_ROW_SPACE);
                    needUpdateAttributes.frame = frame;
                    cellInformation[obj] = needUpdateAttributes;
                    
                    UICollectionViewLayoutAttributes *supplementaryAttributes = [supplementaryInfo objectForKey:obj];
                    CGRect rect= supplementaryAttributes.frame;
                    rect.origin.y = attributes.frame.origin.y + idx * (attributes.frame.size.height+CELL_ROW_SPACE);
                    supplementaryAttributes.frame = rect;
                    supplementaryInfo[obj] = supplementaryAttributes;
                }];
            }
            
            totalHeight += [self.customDataSource numRowsForClassAndChildrenAtIndexPath:indexPath];
        }
        NSLog(@"%s , totalHeight :%d",__PRETTY_FUNCTION__,(int)totalHeight);
        if (self.maxNumRows<=totalHeight) {
            self.maxNumRows = totalHeight;
        }
    }
    [layoutInformation setObject:cellInformation forKey:@"MyCellKind"];
    [layoutInformation setObject:supplementaryInfo forKey:@"ConnectionViewKind"];
    self.layoutInformation = layoutInformation;
}


- (CGSize)collectionViewContentSize{
    NSLog(@"%s. maxNum :%d",__PRETTY_FUNCTION__,(int)self.maxNumRows);
    CGFloat width = self.collectionView.numberOfSections * (ITEM_WIDTH + self.insets.left + self.insets.right+ CELL_SEC_SPACE);
    CGFloat height = self.maxNumRows * (ITEM_HEIGHT +CELL_ROW_SPACE)+CELL_ROW_SPACE;
    return CGSizeMake(width, height);
}
/** layoutAttributesForElementsInRect  请求遍历所有被存储的属性并把它们收集到一个单一数组并返回给调用者。 **/

/** 代码遍历所有子字典，这些子字典包含了主字典_layoutInformation中的特定类型的视图所需要的布局属性对象。如果在子字典中检查的属性被包含在给定矩形中，它们将被添加到一个数组中，该数组存储了那个矩形中的所有属性，它将在所有被存储的属性都被检查完成后返回 **/

/** 备注：layoutAttributesForElementsInRect: 方法的实现从未引用一个给定属性的视图，不管它是否可见。 请记住，该方法提供的矩形没有必要是可见矩形，不管你怎么实现，也绝不应该假设它返回的属性是给可见视图的。关于layoutAttributesForElementsInRect:方法的进一步讨论 **/
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *myAttributes = [NSMutableArray arrayWithCapacity:self.layoutInformation.count];
    for (NSString *key in self.layoutInformation) {
        NSDictionary *attributesDict = [self.layoutInformation objectForKey:key];
        for (NSIndexPath *key in attributesDict) {
            UICollectionViewLayoutAttributes *attributes = [attributesDict objectForKey:key];
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [myAttributes addObject:attributes];
            }
        }
    }
    return myAttributes;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    return self.layoutInformation[@"MyCellKind"][indexPath];
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    return self.layoutInformation[elementKind][indexPath];
}

- (MyCustomAttributes *)attributesWithChildrenForIndexPath:(NSIndexPath *)indexPath{
    MyCustomAttributes *attributes = [MyCustomAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSAssert(_customDataSource, @"customDataSource must not be nil");
    attributes.children = [_customDataSource childrenAtIndexPath:indexPath];
    return attributes;
}

@end
