//
//  MyCustomAttributes.m
//  ClassHierarchicalTree
//
//  Created by JoyWang on 15/1/6.
//  Copyright (c) 2015年 joywt. All rights reserved.
//

#import "MyCustomAttributes.h"

@implementation MyCustomAttributes
- (BOOL)isEqual:(id)object{
    MyCustomAttributes *otherAttributes = (MyCustomAttributes *)object;
    if ([self.children isEqualToArray:otherAttributes.children]) {
        return [super isEqual:object];
    }
    return NO;
}

@end
