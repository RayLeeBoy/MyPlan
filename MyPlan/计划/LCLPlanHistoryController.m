//
//  LCLPlanHistoryController.m
//  MyPlan
//
//  Created by 云淡风轻 on 2020/11/12.
//

#import "LCLPlanHistoryController.h"

@interface LCLPlanHistoryController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UITableView * table;

@end

@implementation LCLPlanHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.model.name;
    
    MyRelativeLayout * root = [MyRelativeLayout new];
    root.topPos.equalTo(self.view.safeAreaLayoutGuide.topAnchor);
    root.bottomPos.equalTo(self.view.safeAreaLayoutGuide.bottomAnchor);
    root.myWidth = MyLayoutSize.fill;
    [self.view addSubview:root];
    
    UITableView * table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.showsVerticalScrollIndicator = NO;
    table.showsHorizontalScrollIndicator = NO;
    table.myTop = table.myBottom = 0;
    table.myLeft = table.myRight = 0;
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [root addSubview:table];
    self.table = table;
    
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadData];
    }];
    
    [table.mj_header beginRefreshing];
}

- (void)loadData {
    NSDictionary * dic = @{
        @"planName":self.model.name
    };
    NSLog(@"%s - %@", __func__, dic);
    [LCLNetworkManager POST:@"/planHistoryGet" parameters:dic success:^(id responseObject) {
        [self.table.mj_header endRefreshing];
        NSLog(@"%s - %@", __func__, responseObject);
        NSString * code = responseObject[@"code"];
        [SVProgressHUD setContainerView:self.view];
        if (code.integerValue == 0) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
            
            NSArray * modelArr = [LCLPlanModel mj_objectArrayWithKeyValuesArray:responseObject[@"planHistory"]];
            
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:modelArr];
            [self.table reloadData];
            
        } else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.table.mj_header endRefreshing];
        NSLog(@"%s - %@", __func__, error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (self.dataSource.count > 0) {
        LCLPlanModel * plan = self.dataSource[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"时长 %ld   时间 %@", plan.duration, plan.createTime];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
@end
