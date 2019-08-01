//
//  ViewController.m
//  XHTabView
//
//  Created by shao xionghua on 2019/7/31.
//  Copyright © 2019 shao xionghua. All rights reserved.
//

#import "ViewController.h"
#import "XHTabView.h"

#define IS_IPhoneX_All ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)
#define KIsiPhoneX ((int)((SCREEN_HEIGHTL/SCREEN_WIDTHL)*100) == 216)?YES:NO
//状态栏、导航栏、标签栏高度
#define Height_StatusBar [[UIApplication sharedApplication] statusBarFrame].size.height
#define Height_NavBar 44.0f
#define Height_TopBar (Height_StatusBar + Height_NavBar)
#define Height_TapBar (IS_IPhoneX_All ? 83.0f:49.0f)
#define Height_BottomSafe (IS_IPhoneX_All? 34.0f:0.0f)

#define SCREEN_HEIGHTL [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTHL [UIScreen mainScreen].bounds.size.width
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,XHTabViewRequestDelegate>
@property (nonatomic , strong) XHTabView * tableView;
@property (nonatomic , strong) NSMutableArray * dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataArray = [NSMutableArray array];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"DEMO";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc]initWithTitle:@"清空数据" style:(UIBarButtonItemStylePlain) target:self action:@selector(ttt)];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil];
    [rightitem setTitleTextAttributes:dic forState:UIControlStateNormal];
    [rightitem setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightitem;
    //请求数据
    [self.tableView setUpWithUrl:@"/getData/getist" Parameters:@{@"pagesize":@(10),@"pageNum":@(1)} formController:self];
}
- (void)ttt
{
    self.dataArray = [NSMutableArray new];
    [self.tableView reloadData];
}
- (void)XHTabView:(XHTabView *)XHTabView requestFailed:(NSError *)error
{
    
}
-(void)XHTabView:(XHTabView *)XHTabView isPullDown:(BOOL)PullDown SuccessData:(id)SuccessData
{
    
    if (PullDown == NO) {
        [self.dataArray  addObjectsFromArray:SuccessData];
    }else{
        self.dataArray = @[@"",@"",@""].mutableCopy;
    }

    //处理返回的SuccessData 数据之后刷新table
    [self.tableView reloadData];
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell"];
    }
    cell.detailTextLabel.text = @(indexPath.row).stringValue;
    return cell;
}

- (XHTabView *)tableView
{
    if (!_tableView) {
        _tableView = [[XHTabView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTHL, SCREEN_HEIGHTL-Height_TapBar-Height_BottomSafe)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.RequestDelegate = self;
        //table是否有刷新
        _tableView.isHasHeaderRefresh = YES;
        _tableView.isRefreshNormal = NO;
        _tableView.defaultView.imageName = @"NoDataIcon";
        _tableView.defaultView.imageSize = CGSizeMake(100, 100);
        _tableView.defaultView.tostText = @"暂无数据";
        _tableView.defaultView.tostTextFont = [UIFont systemFontOfSize:15 weight:(UIFontWeightMedium)];
        _tableView.defaultView.tostTextColor = [UIColor redColor];
        
//        NSString *string = @"网络异常\n暂无数据";
//        NSString *at = @"网络异常";
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
//        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,at.length)];
//        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(at.length,string.length-at.length)];
//        _tableView.defaultView.hintAttributedText = str;
        
    }
    return _tableView;
}


@end
