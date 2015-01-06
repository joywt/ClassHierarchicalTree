//
//  CustomLayout.h
//  ClassHierarchicalTree
//
//  Created by JoyWang on 15/1/6.
//  Copyright (c) 2015年 joywt. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyCustomProtocol <NSObject>

- (NSArray *)childrenAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numRowsForClassAndChildrenAtIndexPath:(NSIndexPath *)indexPath;
@end
@interface CustomLayout : UICollectionViewLayout
@property (nonatomic,weak) id<MyCustomProtocol> customDataSource;
@end
