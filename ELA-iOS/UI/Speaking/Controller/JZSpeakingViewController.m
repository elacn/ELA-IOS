//
//  JZSpeakingViewController.m
//  ELA-iOS
//
//  Created by apple on 2019/8/14.
//  Copyright © 2019年 Jacob Zhang. All rights reserved.
//

#import "JZSpeakingViewController.h"
#import "JZspeakingViewCell.h"

@interface JZSpeakingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *speakingTableView;


@property (nonatomic, assign) NSInteger selectedIndex;
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
    return 10;
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
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
