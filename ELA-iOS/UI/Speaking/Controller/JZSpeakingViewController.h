//
//  JZSpeakingViewController.h
//  ELA-iOS
//
//  Created by apple on 2019/8/14.
//  Copyright © 2019年 Jacob Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlowModel.h"
#import "TextModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JZSpeakingViewController : UIViewController

@property (nonatomic,strong) SlowModel *model;

@property (nonatomic, strong) NSMutableArray<TextModel*> *textData;

@end

NS_ASSUME_NONNULL_END
