//
//  ZYTranslateView.h
//  ELA-iOS
//
//  Created by Calvin on 2019/8/9.
//  Copyright © 2019 Jacob Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYTranslateView : UIView

+ (instancetype)loadXIBTranslateView;

- (void)showWithAnimated:(BOOL)animated;

- (void)hiddenWithAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
