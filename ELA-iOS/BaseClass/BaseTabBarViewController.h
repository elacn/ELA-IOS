//
//  BaseTabBarViewController.h
//  ELA-iOS
//
//  Created by apple on 2019/7/30.
//  Copyright © 2019年 Jacob Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTabBarViewController : UITabBarController


/**
 returns viewcontroller given parameters for tabbar and navigationbar

 @param clsName Name not Required
 @param title Navigation Head Title
 @param normalImage address for tabbar image -Must include a title_selected extension for '_selected' file
 @param isStoryboard are you using a storyboard?
 @param StoryboardIdentifier If you are using a storyboard, identify which storyboard you are using
 @param isNavigation Do you want navigation bar?
 @return return NavigationController or ViewController
 */
-(UIViewController*)addChildControllerWith:(nullable NSString *)clsName title:(nullable NSString*)title
                               normalImage:(nullable NSString*)normalImage isStoryboard:(BOOL)isStoryboard
                      StoryboardIdentifier:(nullable NSString*)StoryboardIdentifier isNavigation:(BOOL)isNavigation;



@end

NS_ASSUME_NONNULL_END
