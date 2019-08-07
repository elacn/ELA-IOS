//
//  CustomScrollView.m
//  ELA-iOS
//
//  Created by apple on 2019/7/31.
//  Copyright © 2019年 Jacob Zhang. All rights reserved.
//

#import "CustomScrollView.h"

@interface CustomScrollView ()<UIGestureRecognizerDelegate>

@end

@implementation CustomScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
