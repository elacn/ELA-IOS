//
//  JZSpeakingViewController.m
//  ELA-iOS
//
//  Created by apple on 2019/8/14.
//  Copyright © 2019年 Jacob Zhang. All rights reserved.
//

#import "JZSpeakingViewController.h"
#import "JZspeakingViewCell.h"
#import "JZAudioManager.h"

@interface JZSpeakingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *speakingTableView;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation JZSpeakingViewController



-(UITableView *)speakingTableView{
    
    if(!_speakingTableView){
        _speakingTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _speakingTableView.dataSource = self;
        _speakingTableView.delegate = self;
        _speakingTableView.estimatedRowHeight = 100;
        [_speakingTableView registerNib:[UINib nibWithNibName:@"JZSpeakingViewCell" bundle:nil] forCellReuseIdentifier:@"SpeakingViewCell"];
    }
    
    return _speakingTableView;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.textData.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JZSpeakingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpeakingViewCell" forIndexPath:indexPath];
    
    cell.showControlBar = self.selectedIndex == indexPath.row ? YES : NO;
    
    cell.textData = self.textData[indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath *oldIndex = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
    
    self.selectedIndex = indexPath.row;
    
    [tableView reloadRowsAtIndexPaths:@[indexPath,oldIndex] withRowAnimation:UITableViewRowAnimationFade];
    
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [self playAudioWithIndex:indexPath.row];
    
}

- (void)playAudioWithIndex:(NSInteger)index{
 
    [self.timer invalidate];
    
    TextModel *model = [self.textData objectAtIndex:index];
    
    [[JZAudioManager manager] pause];
    
    [[JZAudioManager manager] seekTo:model.start.floatValue / 1000 completionHandler:^(BOOL finished) {
        [[JZAudioManager manager] play];
    }];
    
    CGFloat vlaue = (model.end.doubleValue - model.start.doubleValue) / [JZAudioManager manager].speed;
    
    if(index >= self.textData.count-1){
        
        vlaue = vlaue + 5 * 1000;
    }
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:vlaue * 0.001 repeats:NO block:^(NSTimer * _Nonnull timer) {
        
        [[JZAudioManager manager] pause];
       
    }];
    
    self.timer = timer;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTableView];
    
}

-(void)setupTableView{
 
    [self.view addSubview:self.speakingTableView];
    
    [self.speakingTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.speakingTableView reloadData];
    
    [self playAudioWithIndex:0];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillDisappear:(BOOL)animated{
 
    [[JZAudioManager manager] pause];
}

- (void)dealloc{
 
    [self.timer invalidate];
    
    NSLog(@"%s",__func__);
}

@end
