//
//  UIView+FrameView.m
//  ELA-iOS
//
//  Created by apple on 2019/7/31.
//  Copyright © 2019年 Jacob Zhang. All rights reserved.
//

#import "UIView+FrameView.h"

@implementation UIView (FrameView)

- (CGFloat)x{
    
    return self.frame.origin.x;
}

-(CGFloat)y{
    return self.frame.origin.y;
}

-(CGFloat)width{
    
    return self.frame.size.width;
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (void)setX:(CGFloat)x{
    
    CGRect tempRect = self.frame;
    tempRect.origin.x = x;
    
    self.frame = tempRect;
}

- (void)setY:(CGFloat)y{
    CGRect tempRect = self.frame;
    tempRect.origin.y = y;
    
    self.frame = tempRect;
}

-(void)setWidth:(CGFloat)width{
    CGRect tempRect = self.frame;
    tempRect.size.width = width;
    
    self.frame = tempRect;
}

-(void)setHeight:(CGFloat)height{
    CGRect tempRect = self.frame;
    tempRect.size.height = height;
    
    self.frame = tempRect;
}

@end
