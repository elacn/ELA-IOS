//
//  TextModel.h
//  ELA-iOS
//
//  Created by apple on 2019/8/5.
//  Copyright © 2019年 Jacob Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextModel : NSObject

@property (nonatomic, strong) NSString *start;

@property (nonatomic, strong) NSString *end;

@property (nonatomic, strong) NSString *english;

@property (nonatomic, strong) NSString *chinese;

@end

NS_ASSUME_NONNULL_END
