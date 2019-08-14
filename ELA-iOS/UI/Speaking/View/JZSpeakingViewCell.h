//
//  JZSpeakingViewCell.h
//  ELA-iOS
//
//  Created by apple on 2019/8/14.
//  Copyright © 2019年 Jacob Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JZSpeakingViewCell : UITableViewCell

@property (nonatomic, strong) TextModel* textData;

@property (nonatomic, assign,getter=isShowcontrolBar) BOOL showControlBar;

@end

NS_ASSUME_NONNULL_END
