//
//  BaseTableViewController.h
//  ELA-iOS
//
//  Created by apple on 2019/7/30.
//  Copyright © 2019年 Jacob Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewController : UITableViewController


-(void)setNavigationBarImageLeft:(NSString *)image highlightedImage:(NSString *)highlightedimage withTarget:(id)target withAction:(SEL)action;


-(void)setNavigationBarReturnButtonText:(NSString *)title withTarget:(id)target withAction:(SEL)action;


-(void)setNavigationBarImageRight:(NSString *)image highlightedImage:(NSString *)highlightedimage withTarget:(id)target withAction:(SEL)action;


-(void)setNavigationBarRightButtonText:(NSString *)title withTarget:(id)target withAction:(SEL)action;


-(void)setNavigationBackgroundTransparent;


-(void)setNavigationBackgroundOpaque;




@end

NS_ASSUME_NONNULL_END
