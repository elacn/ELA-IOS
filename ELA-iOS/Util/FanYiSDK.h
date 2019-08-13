//
//  FanYiSDK.h
//  FanYiSDK
//
//  Created by 白静 on 11/18/16.
//  Copyright © 2016 网易有道. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordHelper : NSObject
+ (NSURL *)getDeepLink:(NSString *)word;//获取有道词典deeplink
+ (BOOL)openDeepLink:(NSString *)word;//打开有道词典deeplink
+ (NSURL *)getDetailUrl:(NSString *)word;//获取有道词典webUrl
+ (void)openWordBrowser:(NSString *)word;//打开有道词典webUrl
+ (void)openMore:(NSString *)word;//查看更多，若有词典，则跳转到词典，否则打开web页
@end

@class YDTranslate;
@class YDTranslateRequest;
@class YDTranslateParameters;


#pragma mark - 在线查词
typedef void(^YDTranslateRequestHandler)(YDTranslateRequest *request,
                                         YDTranslate *translte,
                                         NSError *error) ;

@interface YDTranslateRequest : NSObject

@property (nonatomic, strong) YDTranslateParameters *translateParameters;
@property (nonatomic, strong) NSArray *supportLanguages;

+ (YDTranslateRequest *)request;

//查询
- (void)lookup:(NSString *) input WithCompletionHandler:(YDTranslateRequestHandler)handler;
//词库初始化，词库放工程中
- (BOOL) initOffline;
//词库初始化，指定词库目录
- (BOOL) initOfflineWithPath:(NSString *)path;
@end

@class CLLocation;

/**
 * The `YDTranslateParameters` class is used to attach targeting information to
 * `YDTranslateRequest` objects.
 */

@interface YDTranslateParameters : NSObject

typedef NS_ENUM(NSInteger, YDLanguageType) {
    YDLanguageTypeAuto = 0,
    YDLanguageTypeChinese, //中文
    YDLanguageTypeEnglish, //英文
    YDLanguageTypeJapanese, //日文
    YDLanguageTypeKorean, //韩文
    YDLanguageTypeFrench, //法文
    YDLanguageTypeRussian, //俄文
    YDLanguageTypePortuguese, //葡萄牙文
    YDLanguageTypeSpanish, //西班牙文
    YDLanguageTypeVietnamese, //越南文
    YDLanguageTypeChineseT, //中文繁体
    YDLanguageTypeGerman, //德文
    YDLanguageTypeArabic, //阿拉伯文
    YDLanguageTypeIndonesian //印尼文
};

/** @name Creating a Targeting Object */

/**
 * Creates and returns an empty YDTranslateParameters object.
 *
 * @return A newly initialized YDTranslateParameters object.
 */
+ (YDTranslateParameters *)targeting;

@property (nonatomic, copy) NSString *source;

@property (nonatomic, assign) YDLanguageType from;

@property (nonatomic, assign) YDLanguageType to;

@property (nonatomic, assign) BOOL offLine;

@end

@interface YDTranslate : NSObject

@property (retain,nonatomic)NSString *query;
@property (retain,nonatomic)NSString *usPhonetic;
@property (retain,nonatomic)NSString *ukPhonetic;
@property (retain,nonatomic)NSString *phonetic;

@property (retain,nonatomic)NSArray *translation;
@property (retain,nonatomic)NSArray *explains;
@property (retain,nonatomic)NSArray *webExplains;

@property (retain,nonatomic)NSString *from;
@property (retain,nonatomic)NSString *to;
@property (retain,nonatomic)NSString *l; //针对国内请求，服务器新增l字段（查询from和to）
@property (retain,nonatomic)NSDictionary *webdict;//针对海外请求，服务器新增webdict字段（词典海外web页面）
@property (retain,nonatomic)NSDictionary *dict;
@property (retain,nonatomic)NSString *tspeakurl;
@property (retain,nonatomic)NSString *speakurl;

@property (assign,atomic)int errorCodes;

- (void)openMore;
- (void)formData;

@end

@interface YDWebExplain : NSObject

@property (retain,nonatomic)NSArray *value;
@property (retain,nonatomic)NSString *key;

- (void)formData:(NSDictionary *) dict;
@end

#pragma mark - 离线查词
@class YDTranslate;
@class YDWordOfflineTranslate;

typedef void(^YDWordOfflineTranslateHandler)(YDWordOfflineTranslate *request,
                                             YDTranslate *translte,
                                             NSError *error) ;

@interface YDWordOfflineTranslate : NSObject


+ (YDWordOfflineTranslate *)request;

//查询
- (void)lookup:(NSString *) input WithCompletionHandler:(YDWordOfflineTranslateHandler)handler;
//词库初始化，词库放工程中
- (BOOL) initOffline;
//词库初始化，指定词库目录
- (BOOL) initOfflineWithPath:(NSString *)path;
@end


#pragma mark - 全局设置
@interface YDTranslateInstance : NSObject

+ (YDTranslateInstance*)sharedInstance;

@property (nonatomic, copy) NSString *appKey;
/**
 有道SDK的数据库存储路径，默认为document路径
 */
@property (nonatomic, copy) NSString *ydDBPath;
@property (nonatomic, assign) BOOL isHaiWai;
@property (nonatomic, assign) BOOL isTestMode;
@end



#pragma mark - 汉语词典
@class YDTranslate;
@class YDHanyucidianOfflineTranslate;

typedef void(^YDHanyucidianOfflineTranslateHandler)(YDHanyucidianOfflineTranslate *request,
                                                    NSArray *translte,
                                                    NSError *error) ;

@interface YDHanyucidianOfflineTranslate : NSObject


+ (YDHanyucidianOfflineTranslate *)request;

//查询
- (void)lookup:(NSString *)input WithCompletionHandler:(YDHanyucidianOfflineTranslateHandler)handler;
//词库初始化，指定词库目录
- (BOOL) initOfflineWithPath:(NSString *)path;

@end


@interface YDChDictMeans : NSObject

@property (retain,nonatomic)NSArray *examLines;
@property (retain,nonatomic)NSString *translate;

@end

@interface YDChDictTranslate : NSObject

@property (retain,nonatomic)NSString *query;
@property (retain,nonatomic)NSString *phonetic;

@property (retain,nonatomic)NSArray *translations;

@property (assign,atomic)int errorCodes;

- (void)openMore;
@end

@interface YDExamLine : NSObject

@property (nonatomic, assign)BOOL highlight;
@property (retain,nonatomic)NSString *text;

@end



#pragma mark - 离线句子翻译
@class YDTranslate;
@class YDSentenceOfflineTranslate;

typedef void(^YDSentenceOfflineTranslateHandler)(YDSentenceOfflineTranslate *request,
                                                 YDTranslate *translte,
                                                 NSError *error) ;

@interface YDSentenceOfflineTranslate : NSObject


+ (YDSentenceOfflineTranslate *)request;

//查询
- (void)lookup:(NSString *) input WithCompletionHandler:(YDSentenceOfflineTranslateHandler)handler;
//词库初始化，指定词库目录
- (BOOL) initOfflineSenWithPath:(NSString *)path;
@end

#pragma mark - 在线语音翻译
@class YDSpeechOnlineParam, YDSpeechOnlineRequest;

typedef void(^YDSpeechOnlineRequestHandler)(YDSpeechOnlineRequest *request,NSDictionary *info, NSError *error) ;

@interface YDSpeechOnlineRequest : NSObject
@property (nonatomic, strong) YDSpeechOnlineParam *param;
+ (instancetype)request;
//查询
- (void)lookup:(NSString *)input WithCompletionHandler:(YDSpeechOnlineRequestHandler)handler;
@end

@interface YDSpeechOnlineParam : NSObject
/* 源语言 */
@property (nonatomic, copy) NSString *from;
/* 目标语言 */
@property (nonatomic, copy) NSString *to;
/* 采样率 */
@property (nonatomic, copy) NSString *rate;
/* 声道数，仅支持单声道，请填写固定值1 */
@property (nonatomic, copy) NSString *channel;
/* 翻译结果发音 */
@property (nonatomic, copy) NSString *voice;
+ (instancetype)param;
@end

#pragma mark - 在线语音识别

@class YDSpeechRecognitionParam, YDSpeechRecognitionRequest;

typedef void(^YDSpeechRecognitionRequestHandler)(YDSpeechRecognitionRequest *request,NSDictionary *info, NSError *error) ;

@interface YDSpeechRecognitionRequest : NSObject
@property (nonatomic, strong) YDSpeechRecognitionParam *param;
+ (instancetype)request;
//查询
- (void)lookup:(NSString *)input WithCompletionHandler:(YDSpeechRecognitionRequestHandler)handler;
@end

@interface YDSpeechRecognitionParam : NSObject
/* 源语言类型 */
@property (nonatomic, copy) NSString *langType;
/* 采样率 */
@property (nonatomic, copy) NSString *rate;
/* 声道数，仅支持单声道，请填写固定值1 */
@property (nonatomic, copy) NSString *channel;
/* 类别，固定值1 */
@property (nonatomic, copy) NSString *type;
+ (instancetype)param;
@end

#pragma mark - 在线图片翻译
@interface YDOCRTransParameter : NSObject
/* 文件上传类型，目前支持base64（1）和图片上传方式（2） */
@property (nonatomic, copy) NSString *type;
/* 源语言 */
@property (nonatomic, copy) NSString *from;
/* 目标语言 */
@property (nonatomic, copy) NSString *to;
+ (instancetype)param;
@end

@class YDOCRTransRequest, YDOCRTransParameter;

typedef void(^YDOCRTransRequestHandler)(YDOCRTransRequest *request,NSDictionary *result, NSError *error) ;

@interface YDOCRTransRequest : NSObject
@property (nonatomic, strong) YDOCRTransParameter *param;
+ (instancetype)request;
//查询
- (void)lookup:(NSString *)input WithCompletionHandler:(YDOCRTransRequestHandler)handler;
@end

#pragma mark - 在线流式语音识别
@interface YDSpeechRecognizerParam : NSObject
/* 源语言类型,目前支持两种,中文:@"zh-CHS",英文:@"en" */
@property (nonatomic, copy) NSString *langType;
/* 语音文件格式,pcm、wav;默认wav */
@property (nonatomic, copy) NSString *format;
/* 采样率 默认16000 */
@property (nonatomic, copy) NSString *rate;
/*
 前端点静音检测时长: 即开启识别后用户一直不说话持续多长时间判定为前端点；
 单位为 ms，默认值为 2000
 要求设置为 200 的倍数
 最小值为 1000
 检测到前端点时通过 `- (void)onConstantlyQuietIsBOS:(BOOL)isBOS;` 方法回调
 */
@property (nonatomic, assign) NSInteger vadBOS;
/*
 后端点静音检测时长: 即用户停止说话持续多长时间判定为后端点；
 单位为 ms，默认值为 2000
 要求设置为 200 的倍数
 最小值为 1000
 检测到后端点时通过 `- (void)onConstantlyQuietIsBOS:(BOOL)isBOS;` 方法回调
 */
@property (nonatomic, assign) NSInteger vadEOS;
+ (instancetype)param;
@end

@class YDSpeechRecognizerParam;
@protocol YDSpeechRecognizerDelegate;

@interface YDSpeechRecognizer : NSObject

/* 参数 */
@property (nonatomic, strong) YDSpeechRecognizerParam *param;

/* 接收识别回调的代理对象 */
@property (nonatomic, weak) id<YDSpeechRecognizerDelegate> delegate;

/* 是否正在识别 */
@property (nonatomic, readonly, assign) BOOL isListening;

/**
 获取 YDSR 单例
 
 @return YDSR 单例
 */
+ (instancetype)sharedRecognizer;

/**
 设置代理回调队列，建议设置为串行队列。
 不设置的话默认主队列回调。
 */
- (void)setDelegateOperationQueue:(NSOperationQueue *)delegateOperationQueue;

/**
 开始识别
 涉及网络连接等过程，此处为同步方法，会快速返回
 是否成功开启的结果在代理中接收
 */
- (void)startListening;

/**
 停止识别
 主动结束当前会话时使用，未来得及返回的结果仍然会后续返回
 */
- (void)stopListening;

/**
 取消本次识别
 未来得及返回的识别结果不再继续返回
 */
- (void)cancel;

/**
 销毁识别单例，长时间不使用应调用此销毁方法
 */
- (void)destory;

@end


/**
 语音识别代理协议，回调语音识别过程中各种状态、数据
 */
@protocol YDSpeechRecognizerDelegate <NSObject>

@required

/**
 开始录音回调
 调用了`startListening`之后，正常开始录音则回调此方法，否则回调`onCompleted:`
 */
- (void)onBeginOfSpeech;

/**
 识别结束回调
 
 @param speechError error为空时表示用户调用 cancel 正常结束，否则发生错误
 错误码： 1201 ： 网络连接失败
 1202 ： 音频录制开启失败
 1203 ： 网络断开
 */
- (void)onCompleted:(nullable NSError *)speechError;

/**
 识别结果的回调
 
 在识别过程中会回调多次
 
 @param result 识别结果
 @param isLast 是否是本句最终结果
 */
- (void)onResults:(NSDictionary *)result isLast:(BOOL)isLast;

@optional

/**
 音量变化回调
 
 @param volume 音量数值
 */
- (void)onVolumeChanged:(double)volume;

/**
 正常结束录音回调
 调用了`stopListening` 正常结束则回调此方法，否则回调`onCompleted:`
 */
- (void)onEndOfSpeech;

/**
 
 取消识别回调
 调用了`cancel`之后，会回调此方法，在调用了 cancel 方法和回调 onCompleted 之前会有一个短暂
 间隔，您可以在此方法中实现对这段时间的界面显示。
 */
- (void)onCancel;

/**
 检测到连续静音的回调
 
 @param isBOS 此次连续静音是否是前端点（开启识别后就一直静音）
 否则是后端点（用户自上一次说话后已经多久没说话）
 */
- (void)onConstantlyQuietIsBOS:(BOOL)isBOS;

@end

#pragma mark - 在线语音评测
NS_ASSUME_NONNULL_BEGIN
@interface YDSpeechEvaluationParam : NSObject
/* 源语言类型 */
@property (nonatomic, copy) NSString *langType;
/* 语音文件格式，pcm、wav、amr，推荐pcm */
@property (nonatomic, copy) NSString *format;
/* 采样率 */
@property (nonatomic, copy) NSString *rate;
/* 声道数，仅支持单声道，请填写固定值1 */
@property (nonatomic, copy) NSString *channel;
/* 类别，固定值1 */
@property (nonatomic, copy) NSString *type;
+ (instancetype)param;
@end

@class YDSpeechEvaluationParam, YDSpeechEvaluationRequest;
typedef void(^YDSpeechEvaluationRequestHandler)(YDSpeechEvaluationRequest *request,NSDictionary *result, NSError *error) ;
@interface YDSpeechEvaluationRequest : NSObject
@property (nonatomic, strong) YDSpeechEvaluationParam *param;
+ (instancetype)request;
//查询
- (void)lookup:(NSString *)speech text:(NSString *)text completionHandler:(YDSpeechEvaluationRequestHandler)handler;
@end
NS_ASSUME_NONNULL_END
