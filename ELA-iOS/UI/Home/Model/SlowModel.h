//
//  SlowModel.h
//  ELA-iOS
//
//  Created by apple on 2019/8/5.
//  Copyright © 2019年 Jacob Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SlowModel : NSObject

@property (nonatomic, assign) NSInteger messageId;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) DataModel *data;
@end

NS_ASSUME_NONNULL_END
