//
//  LCLFinishedController.m
//  MyPlan
//
//  Created by 云淡风轻 on 2020/12/7.
//

#import "LCLFinishedController.h"

@interface LCLFinishedController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UITableView * table;

@end

@implementation LCLFinishedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    table.frame = CGRectMake(0, 0, LCLScreenWidth, LCLScreenHeight - LCLNavBarHeight - LCLTabBarHeight);
    [table registerClass:[LCLPlanCell class] forCellReuseIdentifier:@"cell"];
    [root addSubview:table];
    self.table = table;
    
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadData];
    }];
    
    [table.mj_header beginRefreshing];
}

- (void)loadData {
    [LCLNetworkManager POST:@"/planGetFinishedList" parameters:nil success:^(id responseObject) {
        [self.table.mj_header endRefreshing];
        NSLog(@"%s - %@", __func__, responseObject);
        NSString * code = responseObject[@"code"];
        [SVProgressHUD setContainerView:self.view];
        if (code.integerValue == 0) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
            
            NSArray * modelArr = [LCLPlanModel mj_objectArrayWithKeyValuesArray:responseObject[@"planList"]];
            
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
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCLPlanCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (self.dataSource.count > 0) {
        LCLPlanModel * plan = self.dataSource[indexPath.row];
        cell.model = plan;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCLPlanModel * plan = self.dataSource[indexPath.row];
    LCLPlanDetailController * vc = [LCLPlanDetailController new];
    vc.model = plan;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//
//- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
//    LCLPlanModel * plan = self.dataSource[indexPath.row];
//    UIContextualAction * action = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"+30分钟" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
//        NSLog(@"%s - +30分钟", __func__);
//        
//        [self addTime:plan];
//    }];
//    action.backgroundColor = [UIColor myColorWithHexString:plan.color];
//    
//    UISwipeActionsConfiguration * config = [UISwipeActionsConfiguration configurationWithActions:@[action]];
//    config.performsFirstActionWithFullSwipe = NO;
//    return config;
//}

- (void)addTime:(LCLPlanModel *)plan {
    plan.duration = 30;
    plan.totalMinutes += 30;
    plan.count += 1;
    NSDictionary * parameter = [plan mj_keyValues];
    NSLog(@"%s - %@", __func__, parameter);
    [LCLNetworkManager POST:@"/planAddTime" parameters:parameter success:^(id responseObject) {
        [self.table.mj_header endRefreshing];
        NSLog(@"%s - %@", __func__, responseObject);
        NSString * code = responseObject[@"code"];
        [SVProgressHUD setContainerView:self.view];
        if (code.integerValue == 0) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
        } else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.table.mj_header endRefreshing];
        NSLog(@"%s - %@", __func__, error);
    }];
}

@end
