//
//  JZTabBarController.m
//  ELA-iOS
//
//  Created by apple on 2019/7/30.
//  Copyright © 2019年 Jacob Zhang. All rights reserved.
//

#import "JZTabBarController.h"

@interface JZTabBarController ()

@end

@implementation JZTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIViewController *first = [self addChildControllerWith:@"HomeNavVC" title:NSLocalizedString(@"HomeTabBarTitle", @"Home") normalImage:@"home" isStoryboard:YES StoryboardIdentifier:@"HomeNavVC" isNavigation:NO];

    
    UIViewController *second = [self addChildControllerWith:@"UIViewController" title:NSLocalizedString(@"MineTabBarTitle", @"Mine") normalImage:@"profile" isStoryboard:NO StoryboardIdentifier:nil isNavigation:YES];
    
    self.viewControllers = @[first,second];
    
}



@end
