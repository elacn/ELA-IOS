//
//  JZArticleCustomHeader.m
//  ELA-iOS
//
//  Created by apple on 2019/8/1.
//  Copyright © 2019年 Jacob Zhang. All rights reserved.
//

#import "JZArticleCustomHeader.h"
@interface JZArticleCustomHeader()


@end

@implementation JZArticleCustomHeader


+(instancetype)loadView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"JZArticleCustomHeader" owner:nil options:nil].lastObject;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
