//
//  BaseTabBarViewController.m
//  ELA-iOS
//
//  Created by apple on 2019/7/30.
//  Copyright © 2019年 Jacob Zhang. All rights reserved.
//

#import "BaseTabBarViewController.h"

@interface BaseTabBarViewController ()

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(UIViewController*)addChildControllerWith:(NSString *)clsName title:(NSString*)title
        normalImage:(NSString*)normalImage isStoryboard:(BOOL)isStoryboard
                      StoryboardIdentifier:(NSString*)StoryboardIdentifier isNavigation:(BOOL)isNavigation{
    
    Class cls = NSClassFromString(clsName);
    
    UIViewController *controller;
    
    if(isStoryboard){
     
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        controller = [storyboard instantiateViewControllerWithIdentifier:StoryboardIdentifier];
    
    }
    else{
        
        controller = [[cls alloc]init];
    }
    
    
    controller.title = title;
    
    controller.tabBarItem.image = [[UIImage imageNamed:normalImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSString *selectedstr = [NSString stringWithFormat:@"%@_selected",normalImage];
    
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectedstr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
    if(isNavigation){
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        
        return navigationController;
    }
    
    
    return controller;
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
