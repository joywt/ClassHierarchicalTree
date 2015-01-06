//
//  CustomConnectLines.h
//  ClassHierarchicalTree
//
//  Created by JoyWang on 15/1/6.
//  Copyright (c) 2015年 joywt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomConnectLines : UIView
- (void)layoutLine:(BOOL)isFirst isEnd:(BOOL)isEnd hasBrother:(BOOL)hasBrother hasParent:(BOOL)hasParent;
@end
