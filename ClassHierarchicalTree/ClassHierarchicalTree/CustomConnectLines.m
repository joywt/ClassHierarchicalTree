//
//  CustomConnectLines.m
//  ClassHierarchicalTree
//
//  Created by JoyWang on 15/1/6.
//  Copyright (c) 2015年 joywt. All rights reserved.
//

#import "CustomConnectLines.h"

@interface CustomConnectLines ()
@property (nonatomic,assign)BOOL isFirst;
@property (nonatomic,assign)BOOL isEnd;
@property (nonatomic,assign)BOOL hasBrother;
@property (nonatomic,assign)BOOL hasParent;
@end

@implementation CustomConnectLines


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)layoutLine:(BOOL)isFirst isEnd:(BOOL)isEnd hasBrother:(BOOL)hasBrother hasParent:(BOOL)hasParent;{
    self.isFirst = isFirst;
    self.isEnd = isEnd;
    self.hasBrother = hasBrother;
    self.hasParent = hasParent;
    
    [self layoutIfNeeded];
    //    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    NSLog(@"%s",__PRETTY_FUNCTION__);
    if (self.hasParent) {
        CGRect frame = self.frame;
        CGContextRef  context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:(CGFloat)0 green:(CGFloat)125/255 blue:1 alpha:1.0].CGColor);
        CGContextSetLineWidth(context, 2);
        if (self.hasBrother) {
            if (self.isFirst) {
                CGContextMoveToPoint(context, 0, (60-2)/2);
                CGContextAddLineToPoint(context, frame.size.width, (60-2)/2);
                CGContextMoveToPoint(context, (frame.size.width-2)/2, (60-2)/2);
                CGContextAddLineToPoint(context,  (frame.size.width-2)/2, frame.size.height);
            }else if(self.isEnd){
                CGContextMoveToPoint(context, (frame.size.width-2)/2, 0);
                CGContextAddLineToPoint(context,  (frame.size.width-2)/2, (60-2)/2);
                CGContextMoveToPoint(context, (frame.size.width-2)/2, (60-2)/2);
                CGContextAddLineToPoint(context,  frame.size.width, (60-2)/2);
            }
            else{
                CGContextMoveToPoint(context, (frame.size.width-2)/2, 0);
                CGContextAddLineToPoint(context, (frame.size.width-2)/2, frame.size.height);
                CGContextMoveToPoint(context, (frame.size.width-2)/2, (60-2)/2);
                CGContextAddLineToPoint(context,  frame.size.width, (60-2)/2);
            }
            
        }else{
            CGContextMoveToPoint(context,  0, (60-2)/2);
            CGContextAddLineToPoint(context, frame.size.width, (60-2)/2);
        }
        
        CGContextStrokePath(context);
    }
    

}


@end
