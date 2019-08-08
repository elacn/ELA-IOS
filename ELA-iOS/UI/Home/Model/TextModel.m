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
    
    NSArray<NSString *> *millisecond = [time[2] componentsSeparatedByString:@"."];
    
    float date = 0;
    
    date +=  [time[0] floatValue] * 60 * 60 * 1000;
    
    date +=  [time[1] floatValue] * 60 * 1000;
    
    date +=  [millisecond.firstObject floatValue] * 1000;
    
    date += [millisecond.lastObject floatValue] * 10;
    
    return [NSString stringWithFormat:@"%f",date];
}

- (NSString *)end{
    
    NSArray<NSString*> *time = [_end componentsSeparatedByString:@":"];
    
    NSArray<NSString *> *millisecond = [time[2] componentsSeparatedByString:@"."];
    
    float date = 0;
    
    date +=  [time[0] floatValue] * 3600000;
    
    date +=  [time[1] floatValue] * 60000;
    
    date +=  [millisecond.firstObject floatValue] * 1000;
    
    date += [millisecond.lastObject floatValue] * 10;
    
    return [NSString stringWithFormat:@"%f",date];
}

@end
