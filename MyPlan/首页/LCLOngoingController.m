//
//  LCLOngoingController.m
//  MyPlan
//
//  Created by 云淡风轻 on 2020/12/7.
//

#import "LCLOngoingController.h"

@interface LCLOngoingController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UITableView * table;

@end

@implementation LCLOngoingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITableView * table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.showsVerticalScrollIndicator = NO;
    table.showsHorizontalScrollIndicator = NO;
    table.frame = CGRectMake(0, 0, LCLScreenWidth, LCLScreenHeight - LCLNavBarHeight - LCLTabBarHeight);
    [table registerClass:[LCLPlanCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:table];
    self.table = table;
    
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadData];
    }];
    
    [table.mj_header beginRefreshing];
}

- (void)loadData {
    [LCLNetworkManager POST:@"/planListGet" parameters:nil success:^(id responseObject) {
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCLPlanCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (self.dataSource.count > 0) {
        LCLPlanModel * plan = self.dataSource[indexPath.row];
        cell.model = plan;
        
        //configure left buttons
        cell.leftButtons = @[
            [MGSwipeButton buttonWithTitle:@"完成" backgroundColor:[UIColor myColorWithHexString:plan.color] callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
                [self finishedPaln:plan];
                return YES;
            }]
        ];
        cell.leftSwipeSettings.transition = MGSwipeTransition3D;

        //configure right buttons
        cell.rightButtons = @[
            [MGSwipeButton buttonWithTitle:@"+30分钟" backgroundColor:[UIColor myColorWithHexString:plan.color] callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
                [self addTime:plan];
                return YES;
            }]
        ];
        cell.rightSwipeSettings.transition = MGSwipeTransition3D;
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCLPlanModel * plan = self.dataSource[indexPath.row];
    LCLPlanDetailController * vc = [LCLPlanDetailController new];
    vc.model = plan;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCLPlanModel * plan = self.dataSource[indexPath.row];
    UIContextualAction * action = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"+30分钟" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSLog(@"%s - +30分钟", __func__);
        
        [self addTime:plan];
    }];
    action.backgroundColor = [UIColor myColorWithHexString:plan.color];
    
    UISwipeActionsConfiguration * config = [UISwipeActionsConfiguration configurationWithActions:@[action]];
    config.performsFirstActionWithFullSwipe = NO;
    return config;
}

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

- (void)finishedPaln:(LCLPlanModel *)plan {
    NSLog(@"%s", __func__);
    plan.status = 1;
    NSDictionary * parameter = [plan mj_keyValues];
    NSLog(@"%s - %@", __func__, parameter);
    [LCLNetworkManager POST:@"/planFinished" parameters:parameter success:^(id responseObject) {
        [self.table.mj_header endRefreshing];
        NSLog(@"%s - %@", __func__, responseObject);
        [SVProgressHUD setContainerView:self.view];
        [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
//        NSString * code = responseObject[@"code"];
//        if (code.integerValue == 0) {
//            [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
//        } else {
//            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
//        }
    } failure:^(NSError *error) {
        [self.table.mj_header endRefreshing];
        NSLog(@"%s - %@", __func__, error);
    }];
}

@end
