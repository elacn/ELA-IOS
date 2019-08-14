//
//  ControlBar.h
//  ELA-iOS
//
//  Created by apple on 2019/8/13.
//  Copyright © 2019年 Jacob Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ControlBarButtonDelegate <NSObject>

-(void)clickAction:(UIButton*)button;

@end

@interface ControlBar : UIView

+(instancetype)loadControlBar;

@property (nonatomic, strong) NSString *leftTitle;

@property (nonatomic, strong) NSString *rightTitle;

@property (nonatomic, weak) id<ControlBarButtonDelegate> delegate;

-(void)updateProgressView:(float)value;

-(void)resetButtons;
@end

NS_ASSUME_NONNULL_END
