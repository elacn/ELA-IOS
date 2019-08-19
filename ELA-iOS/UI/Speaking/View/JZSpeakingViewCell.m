//
//  JZSpeakingViewCell.m
//  ELA-iOS
//
//  Created by apple on 2019/8/14.
//  Copyright © 2019年 Jacob Zhang. All rights reserved.
//

#import "JZSpeakingViewCell.h"
#import <YYText.h>

@interface JZSpeakingViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *gradeText;

@property (nonatomic, strong) YYLabel* englishText;

@property (nonatomic, strong) UILabel* chineseText;

@property (nonatomic, strong) UIStackView *controlStack;

@property (weak, nonatomic) IBOutlet UIView *maskView;


@end

@implementation JZSpeakingViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initUI];
}

-(void)initUI{
    
    self.gradeText.hidden = YES;
    
    
    
    YYLabel *englishText = [[YYLabel alloc]init];
    _englishText = englishText;
    
    englishText.text = @"In order to better see if the text works we should";

    englishText.font = [UIFont fontWithName:@"Georgia-BoldItalic" size:18];
    englishText.lineBreakMode = NSLineBreakByWordWrapping;
    englishText.numberOfLines = 0;
    englishText.textColor = [UIColor blackColor];
    englishText.preferredMaxLayoutWidth = self.width - 30;
    englishText.textAlignment = NSTextAlignmentCenter;
    
    
    
    [self.contentView insertSubview:englishText belowSubview:_maskView];
    
    [englishText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.gradeText.mas_bottom).offset(15);
        
        make.leading.equalTo(self.contentView).offset(15);
        
        make.trailing.equalTo(self.contentView).offset(-15);
        
    }];
    
    UILabel *chineseText = [[UILabel alloc]init];
    
    _chineseText = chineseText;
    
    chineseText.numberOfLines = 0;
    chineseText.text = @"美国直升飞机协会 ";
    chineseText.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView insertSubview:chineseText belowSubview:_maskView];
    
    [chineseText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(englishText.mas_bottom).offset(25);
        
        make.leading.trailing.equalTo(englishText);
    
    }];
    
    
    UIButton *playAudio = [[UIButton alloc]init];
    playAudio.tag = 0;
    playAudio.frame = CGRectMake(0, 0, 50, 50);
    [playAudio setImage:[UIImage imageNamed:@"video_pause"] forState:UIControlStateNormal];
    [playAudio setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateSelected];
    playAudio.imageView.contentMode = UIViewContentModeCenter;
    
    UIButton *recordVoice = [[UIButton alloc]init];
    playAudio.tag = 1;
    recordVoice.frame = CGRectMake(0, 0, 50, 50);
    [recordVoice setImage:[UIImage imageNamed:@"blackrecordicon"] forState:UIControlStateNormal];
    [recordVoice setImage:[UIImage imageNamed:@"greenrecordicon"] forState:UIControlStateSelected];
    recordVoice.imageView.contentMode = UIViewContentModeCenter;
    
    UIButton *playRecording = [[UIButton alloc]init];
    playAudio.tag = 2;
    playRecording.frame = CGRectMake(0, 0, 50, 50);
    [playRecording setImage:[UIImage imageNamed:@"greenplayicon"] forState:UIControlStateNormal];
    [playRecording setImage:[UIImage imageNamed:@"greenpauseicon"] forState:UIControlStateSelected];
    playRecording.imageView.contentMode = UIViewContentModeCenter;

    [playAudio addTarget:self action:@selector(clickControlStack:) forControlEvents:UIControlEventTouchUpInside];
    [recordVoice addTarget:self action:@selector(clickControlStack:) forControlEvents:UIControlEventTouchUpInside];
    [playRecording addTarget:self action:@selector(clickControlStack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIStackView *controlStack = [[UIStackView alloc]initWithArrangedSubviews:@[playAudio,recordVoice,playRecording]];
    
    _controlStack = controlStack;
    
    controlStack.axis = UILayoutConstraintAxisHorizontal;
    controlStack.alignment = UIStackViewAlignmentFill;
//    controlStack.distribution = UIStackViewDistributionFill;
    
    controlStack.spacing = 20;
    
    
    [self.contentView insertSubview:controlStack atIndex:0];
    
    [controlStack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(chineseText.mas_bottom).offset(15);
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        make.height.equalTo(@(50));
    }];
    
}


-(void)clickControlStack:(UIButton*)button{
    
    button.selected = !button.isSelected;
}


-(void)setTextData:(TextModel *)textData{
    _textData = textData;
    
    
    CGFloat height = self.isShowcontrolBar ? 50 : 0;

    self.maskView.hidden = self.isShowcontrolBar;
    
    [self.controlStack mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.chineseText.mas_bottom).offset(15);
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        make.height.equalTo(@(height));
    }];
    
    NSArray<NSString *> *stringArray = [textData.english componentsSeparatedByString:@" "];
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    [paragraphStyle setLineSpacing:10];
    
    NSMutableAttributedString *mastring = [[NSMutableAttributedString alloc] initWithString:textData.english attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Georgia-Bold" size:17]}];
    
    
    [mastring addAttribute:NSParagraphStyleAttributeName
     
                     value:paragraphStyle
     
                     range:NSMakeRange(0, [textData.english length])];
    
    NSInteger startInde = 0;
    
    for (int i = 0; i < stringArray.count; i++) {
        
        NSString *tempString = [stringArray objectAtIndex:i];
        
        [mastring yy_setTextHighlightRange:NSMakeRange(startInde, tempString.length) color:[UIColor blackColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            
            NSLog(@"%@",[text.string substringWithRange:range]);

            
        }];
        
        startInde+=tempString.length+1;
    }
    
    self.englishText.attributedText = mastring;
    
    
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle1.alignment = NSTextAlignmentCenter;
    
    [paragraphStyle1 setLineSpacing:10];
    
    NSMutableAttributedString *mastring1 = [[NSMutableAttributedString alloc] initWithString:textData.chinese attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Regular" size:14]}];
    
    
    
    [mastring1 addAttribute:NSParagraphStyleAttributeName
     
                      value:paragraphStyle
     
                      range:NSMakeRange(0, [textData.chinese length])];
    
    [mastring1 addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, [textData.chinese length])];
    
    self.chineseText.attributedText = mastring1;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


@end
