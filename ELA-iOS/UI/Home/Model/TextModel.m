//
//  TextModel.m
//  ELA-iOS
//
//  Created by apple on 2019/8/5.
//  Copyright © 2019年 Jacob Zhang. All rights reserved.
//

#import "TextModel.h"

@implementation TextModel

- (NSString *)start{
    
    NSArray<NSString*> *time = [_start componentsSeparatedByString:@":"];
    
    NSInteger date = 0;
    
    date +=  [time[0] integerValue] * 3600000;
    
    date +=  [time[1] integerValue] * 60000;
    
    date +=  [time[2] integerValue] * 1000;
    
    return [NSString stringWithFormat:@"%ld",date];
}

- (NSString *)end{
    
    NSArray<NSString*> *time = [_end componentsSeparatedByString:@":"];
    
    NSInteger date = 0;
    
    date +=  [time[0] integerValue] * 3600000;
    
    date +=  [time[1] integerValue] * 60000;
    
    date +=  [time[2] integerValue] * 1000;
    
    return [NSString stringWithFormat:@"%ld",date];
}

@end
