//
//  JZArticleTableViewCell.h
//  ELA-iOS
//
//  Created by apple on 2019/8/1.
//  Copyright © 2019年 Jacob Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JZArticleTableViewCell : UITableViewCell

@property (nonatomic, strong) TextModel *model;

@end

NS_ASSUME_NONNULL_END
