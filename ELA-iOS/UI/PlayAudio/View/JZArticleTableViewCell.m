//
//  JZArticleTableViewCell.m
//  ELA-iOS
//
//  Created by apple on 2019/8/1.
//  Copyright © 2019年 Jacob Zhang. All rights reserved.
//

#import "JZArticleTableViewCell.h"
#import <YYText.h>
#import <SVProgressHUD.h>

@interface JZArticleTableViewCell ()

@property (nonatomic, strong) YYLabel *englishYYLabel;

@property (nonatomic, strong) UILabel *chineseLabel;

@end

@implementation JZArticleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        _englishYYLabel.textColor = [UIColor greenColor];
        
        _chineseLabel.textColor = [UIColor greenColor];
    
    }
    
    else{
        _englishYYLabel.textColor = [UIColor blackColor];
        
        _chineseLabel.textColor = [UIColor blackColor];
    }
    
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        [self initUI];
    }
    
    return self;
}

- (void)initUI{
    
    YYLabel *englishYYLabel = [YYLabel new];
    _englishYYLabel = englishYYLabel;
    englishYYLabel.font = [UIFont fontWithName:@"Georgia-BoldItalic" size:14];
    englishYYLabel.lineBreakMode = NSLineBreakByWordWrapping;
    englishYYLabel.numberOfLines = 0;
    englishYYLabel.preferredMaxLayoutWidth = self.width - 30;
    
    [self.contentView addSubview:englishYYLabel];
    
    [englishYYLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.offset(15);
        make.trailing.offset(-15);
    }];
    
    UILabel *chinesLabel = [UILabel new];
    _chineseLabel = chinesLabel;
    chinesLabel.numberOfLines = 0;

    
    [self.contentView addSubview:chinesLabel];
    
    [chinesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.trailing.equalTo(englishYYLabel);
        make.top.equalTo(englishYYLabel.mas_bottom).offset(15);
        make.bottom.equalTo(self.contentView).offset(-15);
        
    }];
    
}


- (void)setModel:(TextModel *)model{
    
    _model = model;
    
    NSArray<NSString *> *stringArray = [model.english componentsSeparatedByString:@" "];
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    [paragraphStyle setLineSpacing:10];
    
    NSMutableAttributedString *mastring = [[NSMutableAttributedString alloc] initWithString:model.english attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Georgia" size:17]}];
    
    
    [mastring addAttribute:NSParagraphStyleAttributeName
     
                          value:paragraphStyle
     
                          range:NSMakeRange(0, [model.english length])];
    
    
    NSInteger startInde = 0;
    
    for (int i = 0; i < stringArray.count; i++) {
        
        NSString *tempString = [stringArray objectAtIndex:i];
        
        [mastring yy_setTextHighlightRange:NSMakeRange(startInde, tempString.length) color:[UIColor blackColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            
            NSLog(@"%@",[text.string substringWithRange:range]);
            
        }];
        
        startInde+=tempString.length+1;
    }
    
    self.englishYYLabel.attributedText = mastring;
    
    
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc]init];
    
    [paragraphStyle1 setLineSpacing:10];
    
    NSMutableAttributedString *mastring1 = [[NSMutableAttributedString alloc] initWithString:model.chinese attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Regular" size:17]}];
    
    
    [mastring1 addAttribute:NSParagraphStyleAttributeName
     
                     value:paragraphStyle
     
                     range:NSMakeRange(0, [model.chinese length])];
    
    self.chineseLabel.attributedText = mastring1;
    
}

@end
