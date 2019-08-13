//
//  ControlBar.m
//  ELA-iOS
//
//  Created by apple on 2019/8/13.
//  Copyright © 2019年 Jacob Zhang. All rights reserved.
//

#import "ControlBar.h"

@interface ControlBar ()
@property (weak, nonatomic) IBOutlet UILabel *timeLeft;

@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@property (weak, nonatomic) IBOutlet UILabel *timeRight;

@property (weak, nonatomic) IBOutlet UIButton *speedButton;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIButton *playpauseButton;

@property (weak, nonatomic) IBOutlet UIButton *skipButton;

@property (weak, nonatomic) IBOutlet UIButton *translateButton;


@end

@implementation ControlBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+(instancetype)loadControlBar{
    
    return [[NSBundle mainBundle] loadNibNamed:@"ControlBar" owner:nil options:nil].lastObject;
}


- (IBAction)clickButtonAction:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    
    if([self.delegate respondsToSelector:@selector(clickAction:)]){
        [self.delegate clickAction:sender];
    }
}

-(void)updateProgressView:(float)value{
    [_progressBar setProgress:value animated:YES];
}

-(void)setLeftTitle:(NSString *)leftTitle{
 
    _leftTitle = leftTitle;
    
    [_timeLeft setText:leftTitle];
    
    
}

-(void)setRightTitle:(NSString *)rightTitle{
    _rightTitle = rightTitle;
    
    [_timeRight setText:rightTitle];

}

@end
