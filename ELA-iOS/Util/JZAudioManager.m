//
//  JZAudioManager.m
//  03-音频播放
//
//  Created by apple on 2019/8/6.
//  Copyright © 2019年 itteacher. All rights reserved.
//

#import "JZAudioManager.h"
#import <AVFoundation/AVFoundation.h>

@interface JZAudioManager()

@property(nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) NSURL *URL;


@end

@implementation JZAudioManager

+ (instancetype)manager{
    
    static JZAudioManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

+(instancetype)managerWithUrl:(NSString *)url{
  
    JZAudioManager * sharedInstance = [self manager];
    
    NSURL *URL;
    
    URL = [NSURL fileURLWithPath:url];
    if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
        URL = [NSURL URLWithString:url];
    }
    sharedInstance.URL = URL;
    [sharedInstance setupPlayer];
    return sharedInstance;
}
- (void)setupPlayer{
    
    #warning there is a leak here, Need to fix.
    self.player = [AVPlayer playerWithPlayerItem:[[AVPlayerItem alloc] initWithURL:self.URL]];
    
    
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
}

-(void)play{


    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];

    [self.player play];
}

-(void)pause{
    
    [self.player pause];
}

- (void)nextWithUrl:(NSString *)url{
    
    self.URL = [NSURL fileURLWithPath:url];
    if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
        self.URL = [NSURL URLWithString:url];
    }
    [self setupPlayer];
    [self play];
}

-(void)seekTo:(float)time completionHandler:(void(^)(BOOL finished))handler{
    
//    CMTime startTime =  CMTimeMake(time * asset.duration.timescale, asset.duration.timescale);
    
//    CGFloat f = self.player.currentItem.asset.duration.timescale;
    
    CMTime startTime = CMTimeMakeWithSeconds(time, 2);
    
    [self.player seekToTime:startTime toleranceBefore:CMTimeMake(1, self.player.currentItem.asset.duration.timescale) toleranceAfter:kCMTimeZero completionHandler:handler];
   
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"status"]) {
        // 取出status的新值
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] intValue];
        switch (status) {
            case AVPlayerItemStatusFailed: {
                _state = JZAudioStateFailed;
            } break;
            case AVPlayerItemStatusReadyToPlay: {
                _state = JZAudioStateFailed;
            } break;
            case AVPlayerItemStatusUnknown: {
                _state = JZAudioStateFailed;
            } break;
            default: break;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *array = self.player.currentItem.loadedTimeRanges;
        // 本次缓冲的时间范围
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        // 缓冲总长度
        NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
        // 音乐的总时间
        NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
        // 计算缓冲百分比例
        NSTimeInterval scale = totalBuffer / duration;
        //
        NSLog(@"总时长：%f, 已缓冲：%f, 总进度：%f", duration, totalBuffer, scale);
        
        if(self.downloadBlock) self.downloadBlock(scale);
    }
}

- (void)setVolume:(float)volume{
    _volume = volume;
    
    self.player.volume = volume;
}
- (void)setSpeed:(float)speed{
    
    _speed = speed;
    
    self.player.rate = speed;

  
}

- (void)setTimeBlock:(PeriodicTimeBlock)timeBlock{
    _timeBlock = timeBlock;
    
    __weak JZAudioManager *weakself = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 10.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        CGFloat current = CMTimeGetSeconds(time);
        
        if(weakself.timeBlock) weakself.timeBlock(current);
        
    }];
}


@end
