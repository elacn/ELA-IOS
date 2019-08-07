//
//  BaseTableViewController.m
//  ELA-iOS
//
//  Created by apple on 2019/7/30.
//  Copyright © 2019年 Jacob Zhang. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}




#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

-(void)setNavigationBarImageLeft:(NSString *)image highlightedImage:(NSString *)highlightedimage withTarget:(id)target withAction:(SEL)action{
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [navButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [navButton setImage:[UIImage imageNamed:highlightedimage] forState:UIControlStateHighlighted];
    
    [navButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navButton];
}


-(void)setNavigationBarReturnButtonText:(NSString *)title withTarget:(id)target withAction:(SEL)action{
    
    UIBarButtonItem *navBarButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    
    self.navigationItem.leftBarButtonItem = navBarButton;
    
}


-(void)setNavigationBarImageRight:(NSString *)image highlightedImage:(NSString *)highlightedimage  withTarget:(id)target withAction:(SEL)action{
    
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [navButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [navButton setImage:[UIImage imageNamed:highlightedimage] forState:UIControlStateHighlighted];
    
    [navButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navButton];

}


-(void)setNavigationBarRightButtonText:(NSString *)title withTarget:(id)target withAction:(SEL)action{
    
    UIBarButtonItem *navBarButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    
    self.navigationItem.rightBarButtonItem = navBarButton;

}


-(void)setNavigationBackgroundTransparent{
    self.navigationController.navigationBar.translucent = YES;
}


-(void)setNavigationBackgroundOpaque{
    self.navigationController.navigationBar.translucent = NO;
}

  
  
@end
