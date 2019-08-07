//
//  DataModel.h
//  ELA-iOS
//
//  Created by apple on 2019/8/5.
//  Copyright © 2019年 Jacob Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageModel.h"
#import "PostModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataModel : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) ImageModel *image;

@property (nonatomic, strong) PostModel *post;

@end

NS_ASSUME_NONNULL_END
