//
//  ZYTranslateView.m
//  ELA-iOS
//
//  Created by Calvin on 2019/8/9.
//  Copyright © 2019 Jacob Zhang. All rights reserved.
//

#import "ZYTranslateView.h"

@interface ZYTranslateView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIStackView *StackView;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;


@end

@implementation ZYTranslateView

+ (instancetype)loadXIBTranslateView{
 
    return [[NSBundle mainBundle] loadNibNamed:@"ZYTranslateView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

- (void)showWithAnimated:(BOOL)animated{
    
    [UIView animateWithDuration:0.25 animations:^{
    
        self.transform = CGAffineTransformMakeTranslation(0, -self.height);
        
    }];
}

- (void)hiddenWithAnimated:(BOOL)animated{
    
    [UIView animateWithDuration:0.25 animations:^{
       
        self.transform = CGAffineTransformIdentity;
        
    }];
}

- (IBAction)closeTranslateAction:(UIButton *)sender {
    [self hiddenWithAnimated:YES];
}


@end
