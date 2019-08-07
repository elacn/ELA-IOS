//
//  JZArticleCustomHeader.h
//  ELA-iOS
//
//  Created by apple on 2019/8/1.
//  Copyright © 2019年 Jacob Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JZArticleCustomHeader : UIView

@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

+(instancetype)loadView;
@end

NS_ASSUME_NONNULL_END
