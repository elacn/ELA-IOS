//
//  JZArticleTableViewCell.h
//  ELA-iOS
//
//  Created by apple on 2019/8/1.
//  Copyright © 2019年 Jacob Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextModel.h"

#import "JZArticleViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ArticleClickTextDelegate <NSObject>

-(void)clickText:(NSString*)word andCell:(UITableViewCell *)cell;

@end

@interface JZArticleTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *englishMaskView;

@property (nonatomic, strong) UIView *chineseMaskView;

@property (nonatomic, strong) TextModel *model;

@property (nonatomic, weak)id<ArticleClickTextDelegate> clickdelegate;

@end

NS_ASSUME_NONNULL_END
