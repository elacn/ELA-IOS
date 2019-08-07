//
//  JZHomeTableViewCell.m
//  ELA-iOS
//
//  Created by apple on 2019/7/30.
//  Copyright © 2019年 Jacob Zhang. All rights reserved.
//

#import "JZHomeTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface JZHomeTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cardImage;

@property (weak, nonatomic) IBOutlet UILabel *publishDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *viewCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *articleTitle;

@end


@implementation JZHomeTableViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(SlowModel *)model{
    _model = model;
    
    NSURL *url = [NSURL URLWithString:model.data.image.url];
    
    [_cardImage sd_setImageWithURL:url placeholderImage:[UIImage new]];
    
    self.articleTitle.text = model.data.title;
    
    self.publishDateLabel.text = [model.createdAt componentsSeparatedByString:@"T"].firstObject;
    
    self.viewCountLabel.text = [NSString stringWithFormat:@"%ld %@",model.data.post.pageviews,NSLocalizedString(@"ViewString", @"views")];
    
    
}

@end
