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
#import <SDWebImage/UIImageView+WebCache.h>
#import <YYModel.h>
#import "TextModel.h"
#import "JZAudioManager.h"
#import <SVProgressHUD.h>

@interface JZArticleViewController ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) JZArticleCustomHeader *headerView;

@property (nonatomic, strong) NSMutableArray<TextModel*> *datasource;

@property (nonatomic, assign) NSInteger playIndex;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign,getter=isDownloadCompltet) BOOL DownloadComplete;

@end

@implementation JZArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _datasource = [NSMutableArray arrayWithCapacity:0];
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"DownloadNotification", @"Downloading...")];
    
    [self setupTableView];
    
    [self textToModelArray];
    
}

-(void)textToModelArray{
    
    
    NSArray<NSString*> *textModel =  [self.model.data.text componentsSeparatedByString:@"\r\n"];
    
    for (NSString *text in textModel) {
        
        TextModel *model = [TextModel yy_modelWithJSON:text];

        [self.datasource addObject:model];
    }
    
    
    [self.tableView reloadData];
    
    __weak JZArticleViewController *weakSelf = self;
    
    [[JZAudioManager managerWithUrl:weakSelf.model.data.url] play];

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
    
    self.playIndex++;
    if(self.playIndex >= self.datasource.count-1) self.playIndex = 0;
    
    
    __weak JZArticleViewController *weakSelf = self;
     NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:Time * 0.001 repeats:NO block:^(NSTimer * _Nonnull timer) {
        
        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.playIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
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
    
    [self.tableView registerClass:[JZArticleTableViewCell class] forCellReuseIdentifier:@"ArticleCell"];
    
    [self.tableView reloadData];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JZArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleCell" forIndexPath:indexPath];
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = self.datasource[indexPath.row];
    
    return cell;
}


- (void)dealloc{
    
    [_timer invalidate];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [[JZAudioManager manager] pause];

    [SVProgressHUD dismiss];
}

@end
