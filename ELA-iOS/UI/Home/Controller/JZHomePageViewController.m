//
//  JZHomePageViewController.m
//  ELA-iOS
//
//  Created by apple on 2019/7/30.
//  Copyright © 2019年 Jacob Zhang. All rights reserved.
//

#import "JZHomePageViewController.h"
#import "JZArticleViewController.h"

#import "JZHomeTableViewCell.h"
#import "SlowModel.h"
#import <YYModel.h>
#import <MJRefresh.h>


@interface JZHomePageViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *PageControl;

@property (weak, nonatomic) IBOutlet UIScrollView *pageScrollView;

@property (nonatomic, strong) NSMutableArray *datasourceSlow;

@property (nonatomic, strong) UITableView *tableViewSlow;

@property (nonatomic, strong) UITableView *tableViewFast;

@property (nonatomic, strong) NSMutableArray *datasourceFast;

@property (nonatomic, assign) NSInteger maxIdslow;

@property (nonatomic, assign) NSInteger maxIdfast;

@end

@implementation JZHomePageViewController


- (IBAction)pageControlCliciAction:(id)sender {
    
    if(self.PageControl.selectedSegmentIndex == 0){
        
        [self.pageScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else{
        [self.pageScrollView setContentOffset:CGPointMake(self.view.width, 0) animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _datasourceSlow = [NSMutableArray arrayWithCapacity:0];

    _datasourceFast = [NSMutableArray arrayWithCapacity:0];
//
    [self addTableView];

    // Do any additional setup after loading the view.

}

-(void)loadSlowData{
    
    NSString *URL = [NSString stringWithFormat:@"http://english.leanapp.cn/feed?limit=10&s=voaspecial&syncText=1&maxId=%ld",self.maxIdslow];
    
    URL = [URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *rURL = [NSURL URLWithString:URL];
    
    
    __weak JZHomePageViewController* weakself = self;
    
    [[[NSURLSession sharedSession] dataTaskWithURL:rURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
        
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSArray<SlowModel *> *modelArray = [NSArray yy_modelArrayWithClass:[SlowModel class] json:jsonString];
            
            [weakself.datasourceSlow addObjectsFromArray:modelArray];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
                [weakself.tableViewSlow reloadData];
                [weakself.tableViewSlow.mj_header endRefreshing];
                [weakself.tableViewSlow.mj_footer endRefreshing];
                
            }];
        }
        
    }] resume];
    
 
    
}

-(void)loadFastData{
    
    NSString *URL = [NSString stringWithFormat:@"http://english.leanapp.cn/feed?limit=10&s=voastandard&syncText=1&maxId=%ld",self.maxIdfast];
    
    URL = [URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *rURL = [NSURL URLWithString:URL];
    
    __weak JZHomePageViewController *weakself = self;
    [[[NSURLSession sharedSession] dataTaskWithURL:rURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSArray<SlowModel *> *modelArray = [NSArray yy_modelArrayWithClass:[SlowModel class] json:jsonString];
            
            [weakself.datasourceFast addObjectsFromArray:modelArray];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [weakself.tableViewFast reloadData];
                [weakself.tableViewFast.mj_header endRefreshing];
                [weakself.tableViewFast.mj_footer endRefreshing];
                
            }];
            
            
        }
        
    }] resume];

}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

    [self.tableViewSlow mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.pageScrollView);
    }];

    [self.tableViewFast mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.pageScrollView);
    }];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(!scrollView.contentOffset.y){
    
        CGFloat offset = scrollView.contentOffset.x;
        
        if(offset == 0){
            self.PageControl.selectedSegmentIndex = 0;
        }else if(offset == self.view.width){
            self.PageControl.selectedSegmentIndex = 1;
        }
    }
}


-(void)addTableView{

    
    UITableView *tableViewSlow = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableViewSlow = tableViewSlow;
    tableViewSlow.dataSource = self;
    
    tableViewSlow.delegate = self;
    
    tableViewSlow.estimatedRowHeight = 100;
    tableViewSlow.estimatedSectionFooterHeight = 0;
    tableViewSlow.estimatedSectionHeaderHeight = 0;
    tableViewSlow.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    tableViewSlow.tag = 1;
    
    [tableViewSlow registerNib:[UINib nibWithNibName:@"JZHomeCell" bundle:nil] forCellReuseIdentifier:@"JZHomeCell"];
    
    [self.pageScrollView addSubview: tableViewSlow];
    
    [tableViewSlow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self.pageScrollView);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(self.pageScrollView);
    }];

    UITableView *tableViewFast = [[UITableView alloc] initWithFrame:CGRectMake(self.view.width, 0, self.view.width, self.pageScrollView.height) style:UITableViewStylePlain];
    _tableViewFast = tableViewFast;
    tableViewFast.dataSource = self;
    tableViewFast.delegate = self;
    
    tableViewFast.tag = 2;
    
    tableViewFast.estimatedRowHeight = 100;
    
    [tableViewFast registerNib:[UINib nibWithNibName:@"JZHomeCell" bundle:nil] forCellReuseIdentifier:@"JZHomeCell"];
    
    [self.pageScrollView addSubview: tableViewFast];

    [tableViewFast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(tableViewSlow.mas_trailing);
        make.top.equalTo(self.pageScrollView);
        make.height.mas_equalTo(self.pageScrollView);
        make.width.mas_equalTo(self.view.width);

    }];
    
    self.pageScrollView.contentSize = CGSizeMake(self.view.width * 2, 0);
    self.pageScrollView.delegate = self;
    
    __weak JZHomePageViewController *weakself = self;
    
    self.tableViewSlow.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.maxIdslow = 0;
        [weakself loadSlowData];
    }];
    
    self.tableViewSlow.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        SlowModel *model = weakself.datasourceSlow.lastObject;
        weakself.maxIdslow = model.messageId-1;
        [weakself loadSlowData];
    }];
    
    self.tableViewFast.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.maxIdfast = 0;
        [weakself loadFastData];
    }];
    
    self.tableViewFast.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        SlowModel *model = weakself.datasourceFast.lastObject;
        weakself.maxIdfast = model.messageId-1;
        [weakself loadFastData];
    }];
    
    [self.tableViewSlow.mj_header beginRefreshing];
    
    
    [self loadFastData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(tableView.tag == 1) return self.datasourceSlow.count;
    
    return self.datasourceFast.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JZHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JZHomeCell" forIndexPath:indexPath];
    
    if (tableView.tag == 1) {
        cell.model = self.datasourceSlow[indexPath.row];
    }
    else{
        cell.model = self.datasourceFast[indexPath.row];
    }

    return cell;
}


#pragma mark -- TableViewDelegate --

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    JZArticleViewController *newView = [sb instantiateViewControllerWithIdentifier:@"JZArticleViewController"];
    newView.hidesBottomBarWhenPushed = YES;
    
    newView.model =  tableView.tag == 1 ? self.datasourceSlow[indexPath.row] : self.datasourceFast[indexPath.row];
    
    [self.navigationController pushViewController:newView animated:YES];
    
 
}

- (void)dealloc{
    
    NSLog(@"%s",__func__);
}

@end
