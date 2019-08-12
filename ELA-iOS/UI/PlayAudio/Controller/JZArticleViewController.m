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

#import "ExtAudioConverter.h"



@interface JZArticleViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) JZArticleCustomHeader *headerView;

@property (strong, nonatomic) ZYTranslateView *translateView;

@property (nonatomic, strong) NSMutableArray<TextModel*> *datasource;

@property (nonatomic, assign) NSInteger playIndex;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign,getter=isDownloadCompltet) BOOL DownloadComplete;

@end

@implementation JZArticleViewController

- (ZYTranslateView *)translateView{
    
    if(!_translateView){
        
        _translateView = [ZYTranslateView loadXIBTranslateView];
        _translateView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.width, 200);
    }
    
    return _translateView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _datasource = [NSMutableArray arrayWithCapacity:0];
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"DownloadNotification", @"Downloading...")];
    
    [self setupTableView];
    
    [self setupTranslateView];
    
    [self downloadFile];
    
}

- (void)setupTranslateView{
    
    [self.view addSubview:self.translateView];
    
    [self.translateView showWithAnimated:YES];
}


- (void)downloadFile{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:self.model.data.url];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:URL];
    
    weakSelf(self);
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:req progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        NSString *filePath = [[documentsDirectoryURL absoluteString] stringByAppendingPathComponent:@"DownloadAudioFile"];
    
        return [NSURL URLWithString:[filePath stringByAppendingPathComponent:[response suggestedFilename]]];

    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        NSString  *downloadAudioFile = [[documentsDirectoryURL absoluteString] stringByAppendingPathComponent:@"DownloadAudioFile"];
    
        NSString  *fileName = [response.suggestedFilename componentsSeparatedByString:@"."].firstObject;
        
        NSString  *outputFile = [downloadAudioFile stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",fileName]];
        
        [weakself checkFilePatch:downloadAudioFile];
        
        
        ExtAudioConverter* converter = [[ExtAudioConverter alloc] init];
        converter.inputFile = [filePath absoluteString];
        converter.outputFile = outputFile;
        [converter convert];
        
        [weakself textToModelArray:outputFile];
        
        if(error) [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"DownloadError", @"Download Error")];
        
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

-(void)textToModelArray:(NSString *)audioFile{
    
    
    NSArray<NSString*> *textModel =  [self.model.data.text componentsSeparatedByString:@"\r\n"];
    
    for (NSString *text in textModel) {
        
        TextModel *model = [TextModel yy_modelWithJSON:text];

        [self.datasource addObject:model];
    }
    
    
    [self.tableView reloadData];
    
    __weak JZArticleViewController *weakSelf = self;

    [[JZAudioManager managerWithUrl:audioFile] play];

    [JZAudioManager manager].downloadBlock = ^(double progress) {
      
        if(progress >= 1){

            if(!weakSelf.DownloadComplete){
                [SVProgressHUD dismiss];
                weakSelf.DownloadComplete = YES;
               [weakSelf playWithTimer:weakSelf.datasource.firstObject.end.doubleValue];
            }

        }
    };
    
}

-(void)playWithTimer:(NSTimeInterval)Time{
    
    if(self.tableView.isDragging || self.tableView.isDecelerating){
        
    }else{
    
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.playIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
    }
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.playIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    self.playIndex++;
    if(self.playIndex >= self.datasource.count-1) self.playIndex = 0;
    
    __weak JZArticleViewController *weakSelf = self;
     NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:Time * 0.001 repeats:NO block:^(NSTimer * _Nonnull timer) {
        
        TextModel *model = weakSelf.datasource[weakSelf.playIndex];

        [weakSelf playWithTimer:model.end.doubleValue - model.start.doubleValue];
        
    }];
    
    self.timer = timer;
    
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.timer invalidate];
    
    self.playIndex = indexPath.row;
    
    [[JZAudioManager manager]pause];
    
    TextModel *model = self.datasource[indexPath.row];

    __weak JZArticleViewController *weakSelf = self;
    [[JZAudioManager manager] seekTo:model.start.floatValue * 0.001 completionHandler:^(BOOL finished) {
        [[JZAudioManager manager] play];
        [weakSelf playWithTimer:model.end.floatValue - model.start.floatValue];
    }];
    
}

- (void)dealloc{
    
    [_timer invalidate];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [[JZAudioManager manager] pause];

    [SVProgressHUD dismiss];
}

@end
