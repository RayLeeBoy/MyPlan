//
//  LCLHomeController.m
//  MyPlan
//
//  Created by 云淡风轻 on 2020/10/29.
//

#import "LCLHomeController.h"
#import "MyLayout.h"
#import "LCLPlanCreateController.h"
#import "LCLPlanModel.h"
#import "LCLPlanDetailController.h"

@interface LCLHomeController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UITableView * table;

@end

@implementation LCLHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页";
    
    UIBarButtonItem * okItem = [[UIBarButtonItem alloc] initWithTitle:@"新建计划" style:UIBarButtonItemStylePlain target:self action:@selector(planCreateAction)];
    self.navigationItem.rightBarButtonItem = okItem;
    
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
    [LCLNetworkManager POST:@"http://192.168.10.102:8080/planListGet" parameters:nil success:^(id responseObject) {
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

- (void)planCreateAction {
    LCLPlanCreateController * vc = [LCLPlanCreateController new];
    [self presentViewController:vc animated:YES completion:NULL];
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
        cell.textLabel.text = [NSString stringWithFormat:@"%@   时长: %ld分钟", plan.name, plan.totalMinutes];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIContextualAction * action = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"+30分钟" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSLog(@"%s - +30分钟", __func__);
        LCLPlanModel * plan = self.dataSource[indexPath.row];
        [self addTime:plan];
    }];
    action.backgroundColor = UIColor.greenColor;
    
    UISwipeActionsConfiguration * config = [UISwipeActionsConfiguration configurationWithActions:@[action]];
    config.performsFirstActionWithFullSwipe = NO;
    return config;
}

- (void)addTime:(LCLPlanModel *)plan {
    plan.totalMinutes += 30;
    plan.count += 1;
    NSDictionary * parameter = [plan mj_keyValues];
    NSLog(@"%s - %@", __func__, parameter);
    [LCLNetworkManager POST:@"http://192.168.10.102:8080/planAddTime" parameters:parameter success:^(id responseObject) {
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
