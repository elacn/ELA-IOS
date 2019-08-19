//
//  JZArticleViewController.m
//  ELA-iOS
//
//  Created by apple on 2019/7/31.
//  Copyright © 2019年 Jacob Zhang. All rights reserved.
//

#import "JZArticleViewController.h"
#import "JZArticleCustomHeader.h"
#import "JZArticleTableViewCell.h"

#import "JZAudioManager.h"
#import "TextModel.h"
#import "ZYTranslateView.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <YYModel.h>
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import "ControlBar.h"
#import "JZSpeakingViewController.h"

#import "ExtAudioConverter.h"
typedef NS_ENUM(NSUInteger, ShowLanguage) {
    ShowLanguageAll,
    ShowLanguageEnglish,
    ShowLanguageChinese
};


@interface JZArticleViewController ()<UITableViewDataSource,UITableViewDelegate,ArticleClickTextDelegate,ControlBarButtonDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) JZArticleCustomHeader *headerView;

@property (strong, nonatomic) ZYTranslateView *translateView;

@property (strong, nonatomic) ControlBar *controlbar;

@property (nonatomic, strong) NSMutableArray<TextModel*> *datasource;

@property (nonatomic, assign) NSInteger playIndex;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign,getter=isDownloadCompltet) BOOL DownloadComplete;

@property (nonatomic, assign) NSTimeInterval timerRemaining;

@property (nonatomic, assign) ShowLanguage showType;

@end

@implementation JZArticleViewController

- (NSInteger)playIndex{
    
    if(_playIndex <0) _playIndex = self.datasource.count - 1;
    if(_playIndex >= self.datasource.count) _playIndex = 0;

    return _playIndex;
}

- (ZYTranslateView *)translateView{
    
    if(!_translateView){
        
        _translateView = [ZYTranslateView loadXIBTranslateView];
        _translateView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.width, 200);
        _translateView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        _translateView.layer.shadowOpacity = 0.3;
    }
    
    return _translateView;
}

-(ControlBar*)controlbar{
    
    if(!_controlbar){
        
        _controlbar = [ControlBar loadControlBar];
        _controlbar.delegate = self;
        _controlbar.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        _controlbar.layer.shadowOpacity = 0.3;

    }
    return _controlbar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _datasource = [NSMutableArray arrayWithCapacity:0];
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"DownloadNotification", @"Downloading...")];
    
    [self setupNavigationBar];
    
    [self setupControlBar];
    
    [self setupTableView];
    
    [self setupTranslateView];
    
    [self textToModelArray];
    
    [self checkDownloadMP3];
    
}


-(void)setupNavigationBar{
    UIBarButtonItem *speakingButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"blackplayicon"] style:UIBarButtonItemStylePlain target:self action:@selector(clickBarButton:)];
    speakingButton.tag = 0;
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"blackplayicon"] style:UIBarButtonItemStylePlain target:self action:@selector(clickBarButton:)];
    shareButton.tag = 1;
    UIBarButtonItem *favoriteButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"blackplayicon"] style:UIBarButtonItemStylePlain target:self action:@selector(clickBarButton:)];
    favoriteButton.tag = 2;
    self.navigationItem.rightBarButtonItems = @[speakingButton,favoriteButton,shareButton];
    
}

-(void)clickBarButton:(UIBarButtonItem*)button{
    if(button.tag == 0){
        
        TextModel *model = self.datasource[self.playIndex];
        
        CGFloat value = model.end.floatValue - model.start.floatValue;
        
        self.timerRemaining = value * [JZAudioManager manager].speed;
        [[JZAudioManager manager]pause];
        [[JZAudioManager manager] seekTo:model.start.floatValue/ 1000 completionHandler:^(BOOL finished) {
            
        }];
        [self.timer invalidate];
        [self.controlbar resetButtons];
        
        
        JZSpeakingViewController *speakingVC = [[JZSpeakingViewController alloc]init];
        
        speakingVC.title = self.title;
        
        speakingVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"BackBarButton", @"Back") style:UIBarButtonItemStylePlain target:nil action:nil];
        
        speakingVC.model = self.model;
        
        speakingVC.textData = self.datasource;
        
        
        [self.navigationController pushViewController:speakingVC animated:YES];
        
    }
    else if(button.tag == 1){
        
    }
    else{
        
    }
    
}

- (void)checkDownloadMP3{
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    
    NSURL *mp3URL = [NSURL URLWithString:self.model.data.url];
    
    NSString *fileName = [mp3URL.lastPathComponent componentsSeparatedByString:@"."].firstObject;
    
    NSURL  *inputFile = [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",fileName]];
    
    NSURL  *outputFile = [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",fileName]];
    
    BOOL isDirectory = NO;
    
    BOOL isExis = [[NSFileManager defaultManager] fileExistsAtPath:[inputFile path] isDirectory:&isDirectory];
    
    if(isExis){
    
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
           
            ExtAudioConverter* converter = [[ExtAudioConverter alloc] init];
            converter.inputFile = inputFile;
            converter.outputFile = outputFile;
            converter.outputFileType = kAudioFileWAVEType;
            [converter convert];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                [self playAudioWithPath:[outputFile path]];
            });

        });
        
    }else{
        
        [self downloadFile];
    }
}

- (void)setupTranslateView{
    
    [self.view addSubview:self.translateView];
}

-(void)setupControlBar{
    
    [self.view addSubview:self.controlbar];
    
    [self.controlbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_offset(0);
        make.height.equalTo(@(100));
    }];
}


- (void)downloadFile{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:self.model.data.url];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:URL];
    
    weakSelf(self);
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:req progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        NSString *filePath = [[documentsDirectoryURL absoluteString] stringByAppendingPathComponent:@""];
    
        return [NSURL URLWithString:[filePath stringByAppendingPathComponent:[response suggestedFilename]]];

    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if(error || filePath == nil){
            
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"DownloadError", @"Download Error")];
            
        }else{
        
        NSLog(@"File downloaded to: %@", filePath);
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    
        NSString  *fileName = [response.suggestedFilename componentsSeparatedByString:@"."].firstObject;
        NSURL  *filePath = [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",fileName]];
        NSURL  *outputFile = [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",fileName]];
        
        ExtAudioConverter* converter = [[ExtAudioConverter alloc] init];
        converter.inputFile = filePath;
        converter.outputFile = outputFile;
        converter.outputFileType = kAudioFileWAVEType;
        [converter convert];
        
        [weakself playAudioWithPath:[outputFile path]];
            
        }
        
    }];
    
    [downloadTask resume];
}

- (void)checkFilePatch:(NSString *)rarFilePath{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:rarFilePath isDirectory:&isDir];

    if (!(isDir == YES && existed == YES) ) {//如果文件夹不存在
        NSError *err;
        
        [fileManager createDirectoryAtPath:rarFilePath withIntermediateDirectories:YES attributes:nil error:&err];
        
        if(err){
            
            NSLog(@"%@",err);
        }
    }
}

-(void)textToModelArray{
    
    
    NSArray<NSString*> *textModel =  [self.model.data.text componentsSeparatedByString:@"\r\n"];
    
    for (NSString *text in textModel) {
        
        TextModel *model = [TextModel yy_modelWithJSON:text];

        [self.datasource addObject:model];
    }
    
    [self.tableView reloadData];
    

}

- (void)playAudioWithPath:(NSString *)audioFile{
    
    __weak JZArticleViewController *weakSelf = self;
    
    [[JZAudioManager managerWithUrl:audioFile] play];
    
    self.title = [NSString stringWithFormat:@"%@ %.2fX",NSLocalizedString(@"AudioSpeedString", @"Audio Speed"),[JZAudioManager manager].speed];
    
    [JZAudioManager manager].downloadBlock = ^(double progress) {
        
        if(progress >= 1){
            
            if(!weakSelf.DownloadComplete){
                [SVProgressHUD dismiss];
                NSInteger seconds = [NSNumber numberWithDouble:[JZAudioManager manager].totalTime].integerValue;
                //format of minute
                NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds % 3600)/60];
                //format of second
                NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds % 60];
                //format of time
                NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
                
                weakSelf.controlbar.rightTitle = format_time;
                weakSelf.DownloadComplete = YES;
                [weakSelf playWithTimer:weakSelf.datasource.firstObject.end.doubleValue];
            }
        }
    };
    
    [JZAudioManager manager].timeBlock = ^(NSTimeInterval scale) {
      
        NSInteger seconds = [NSNumber numberWithDouble:scale].integerValue;
        
        //format of minute
        NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds % 3600)/60];
        //format of second
        NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds % 60];
        //format of time
        NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
        
        weakSelf.controlbar.leftTitle = format_time;
        NSTimeInterval value = scale / [JZAudioManager manager].totalTime;
        [weakSelf.controlbar updateProgressView:value];
    };
}

-(void)playWithTimer:(NSTimeInterval)Time{
    
   
    if(self.playIndex < self.datasource.count && self.playIndex >= 0){
        
        if(!self.tableView.isDragging || !self.tableView.isDecelerating){
            
            if(self.timerRemaining == 0) [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.playIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        
        if(self.timerRemaining == 0){
            
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.playIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        
        if(self.playIndex>=self.datasource.count-1){
            
            Time = Time + 5 * 1000;
        }
    
        __weak JZArticleViewController *weakSelf = self;
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:Time * 0.001 repeats:NO block:^(NSTimer * _Nonnull timer) {
            
            if(weakSelf.playIndex == weakSelf.datasource.count - 1){
                weakSelf.playIndex = 0;
                [weakSelf seekWithIndex:0];
            }else{
                weakSelf.playIndex++;
                TextModel *model = weakSelf.datasource[weakSelf.playIndex];
                [weakSelf playWithTimer:(model.end.doubleValue - model.start.doubleValue) / [JZAudioManager manager].speed];
            }
        }];
        
        self.timer = timer;
    }else{
        
        self.playIndex = 0;
        [self seekWithIndex:self.playIndex];
    }
}


-(void)setupTableView{
    
    self.headerView = [JZArticleCustomHeader loadView];
    self.headerView.headerTitleLabel.text = self.model.data.title;
    
    [self.headerView.headerTitleLabel sizeToFit];
    
    NSString *str = self.model.data.title;
    
    self.headerView.headerTitleLabel.text = str;
    
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:str];
    NSRange range = NSMakeRange(0, attrStr.length);
    // 获取该段attributedString的属性字典
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(self.view.width - 30, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                        attributes:dic
                                        context:nil].size;// 文字的属性

    
    self.headerView.frame = CGRectMake(self.headerView.x, self.headerView.y, self.headerView.width, self.headerView.height + size.height + 1);
    
    [self.headerView.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.model.data.image.url]];
    
    self.tableView.tableHeaderView = self.headerView;
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[JZArticleTableViewCell class] forCellReuseIdentifier:@"ArticleCell"];
    
    [self.tableView reloadData];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JZArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = self.datasource[indexPath.row];
    
    cell.clickdelegate = self;
    
    cell.tag = indexPath.row;
    
    switch (self.showType) {
        case ShowLanguageAll:
            cell.englishMaskView.alpha = 0;
            cell.chineseMaskView.alpha = 0;
            break;
        case ShowLanguageEnglish:
            cell.englishMaskView.alpha = 0;
            cell.chineseMaskView.alpha = 1;
            break;
        case ShowLanguageChinese:
            cell.englishMaskView.alpha = 1;
            cell.chineseMaskView.alpha = 0;
            break;
        default:
            break;
    }
    
    return cell;
}


- (void)clickText:(NSString *)word andCell:(nonnull UITableViewCell *)cell{
    
    
    if(cell.isSelected){
     
          [self.translateView showWithAnimated:YES];
        
    }else{
        
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:cell.tag inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        
        [self seekWithIndex:cell.tag];
    }
    
}

-(void)clickAction:(UIButton*)button{
    
    switch (button.tag) {
        case 0:
            [self chooseSpeed];
            break;
            
        case 1:
            [self seekWithIndex:self.playIndex - 1];
            break;
        
        case 2:
            
            if(button.isSelected){
                
                [[JZAudioManager manager] pause];
                NSTimeInterval value = [[NSDate date] timeIntervalSinceDate:self.timer.fireDate];
                self.timerRemaining = fabs(value) * 1000 * [JZAudioManager manager].speed;
                [self.timer invalidate];
            }
            else{
                [[JZAudioManager manager] seekTo:self.datasource[self.playIndex].start.floatValue / 1000 completionHandler:^(BOOL finished) {
                   
                    [[JZAudioManager manager] play];
                    [self playWithTimer:self.timerRemaining];
                    self.timerRemaining = 0;
                    
                }];
            }
            break;
        case 3:
            [self seekWithIndex:self.playIndex + 1];
            break;
        
        case 4:
            [self chooseLanguage];
            break;
            
        default:
            break;
    }
    
    
}

- (void)chooseSpeed{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"AudioSpeedString", @"Audio SpeedS") message:NSLocalizedString(@"AudioSpeedInfo", @"Select the speed you want your audio to play at") preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"0.75x" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self setSpeed:0.75];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"1.00x" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setSpeed:1.0];
    }];
    
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"1.25x" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setSpeed:1.25];
    }];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"1.5x" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setSpeed:1.5];
    }];
    
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    
    [alert addAction:action1];
    
    [alert addAction:action2];
    
    [alert addAction:action3];
    
    [alert addAction:action4];
    
    [alert addAction:action5];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)chooseLanguage{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ChooseLanguage", @"Choose Language") message:NSLocalizedString(@"ChooseLanguageDetail", @"Choose which language to show") preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"English" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.showType = ShowLanguageEnglish;
        [self.tableView reloadData];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.playIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"中文" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.showType = ShowLanguageChinese;
        [self.tableView reloadData];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.playIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }];
    
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"English + 中文" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.showType = ShowLanguageAll;
        [self.tableView reloadData];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.playIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    
    [alert addAction:action1];
    
    [alert addAction:action2];
    
    [alert addAction:action3];
    
    [alert addAction:action4];
    
    [self presentViewController:alert animated:YES completion:nil];
}



-(void)setSpeed:(float)speed{
    NSTimeInterval value = [[NSDate date] timeIntervalSinceDate:self.timer.fireDate];
    self.timerRemaining = fabs(value) * 1000 * [JZAudioManager manager].speed / speed;
    [self.timer invalidate];
    [[JZAudioManager manager] setSpeed:speed];
    [self playWithTimer:self.timerRemaining];
    self.timerRemaining = 0;
    self.title = [NSString stringWithFormat:@"%@ %.2fX",NSLocalizedString(@"AudioSpeedString", @"Audio Speed"),speed];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self seekWithIndex:indexPath.row];
}

- (void)seekWithIndex:(NSInteger)index{
    
    if(index <0) index = self.datasource.count - 1;
    if(index >= self.datasource.count) index = 0;
    
    [self.timer invalidate];
    
    self.playIndex = index;
    
    [[JZAudioManager manager] pause];
    
     TextModel *model = self.datasource[self.playIndex];
    
    __weak JZArticleViewController *weakSelf = self;
    [[JZAudioManager manager] seekTo:model.start.floatValue * 0.001 completionHandler:^(BOOL finished) {
        [[JZAudioManager manager] play];
        [weakSelf playWithTimer:(model.end.floatValue - model.start.floatValue) / [JZAudioManager manager].speed];
    }];
}

- (void)dealloc{
    
    [_timer invalidate];
    
    NSLog(@"%s",__func__);
}

-(void)viewWillDisappear:(BOOL)animated{
    [[JZAudioManager manager] pause];
    [SVProgressHUD dismiss];
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    
    NSURL *mp3URL = [NSURL URLWithString:self.model.data.url];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.wav",[mp3URL.lastPathComponent componentsSeparatedByString:@"."].firstObject];
    
    NSString *filePath = [[documentsDirectoryURL URLByAppendingPathComponent:fileName] path];
    
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

@end
