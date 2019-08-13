//
//  JZAudioManager.h
//  03-音频播放
//
//  Created by apple on 2019/8/6.
//  Copyright © 2019年 itteacher. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PeriodicTimeBlock)(NSTimeInterval scale);

typedef void(^DownloadProgressBlock)(double progress);

typedef NS_ENUM(NSUInteger, JZAudioState) {
    JZAudioStateUnknown,
    JZAudioStatePlaying,
    JZAudioStatePaused,
    JZAudioStateFailed,
    JZAudioStatePrepared
};

@interface JZAudioManager : NSObject

@property (nonatomic, assign) float speed;

@property (nonatomic, assign) float volume;

@property (nonatomic ,assign, readonly) JZAudioState state;

@property (nonatomic, assign, readonly) long long currentTime;

@property (nonatomic, assign, readonly) NSTimeInterval totalTime;

@property (nonatomic, copy) PeriodicTimeBlock timeBlock;

@property (nonatomic, copy) DownloadProgressBlock downloadBlock;


+ (instancetype)manager;

+ (instancetype)managerWithUrl:(NSString *)url;

- (void)play;

- (void)pause;

- (void)nextWithUrl:(NSString *)url;

- (void)seekTo:(float)time completionHandler:(void(^)(BOOL finished))handler;


@end

NS_ASSUME_NONNULL_END
