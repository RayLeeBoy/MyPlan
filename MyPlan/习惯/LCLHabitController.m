//
//  LCLHabitController.m
//  MyPlan
//
//  Created by 云淡风轻 on 2020/11/10.
//

#import "LCLHabitController.h"
#import "LCLHabitCell.h"
#import "LCLHabitCreateController.h"

@interface LCLHabitController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UITableView * table;

@end

@implementation LCLHabitController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"习惯";
    
    UIBarButtonItem * okItem = [[UIBarButtonItem alloc] initWithTitle:@"新建习惯" style:UIBarButtonItemStylePlain target:self action:@selector(habitCreateAction)];
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
    [table registerClass:[LCLHabitCell class] forCellReuseIdentifier:@"cell"];
    [root addSubview:table];
    self.table = table;
    
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
//    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//        [self loadData];
//    }];
    
//    [table.mj_header beginRefreshing];
    
    LCLHabitModel * model = [LCLHabitModel new];
    model.name = @"喝水";
    model.color = @"#7FFFAA";
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    if ([ud objectForKey:model.name]) {
        model.count = [[ud objectForKey:model.name] integerValue];
    } else {
        [ud setObject:[NSString stringWithFormat:@"%ld", model.count] forKey:model.name];
    }
    
    [self.dataSource addObject:model];
    [table reloadData];
}

- (void)loadData {
    [LCLNetworkManager POST:@"/planListGet" parameters:nil success:^(id responseObject) {
        [self.table.mj_header endRefreshing];
        NSLog(@"%s - %@", __func__, responseObject);
        NSString * code = responseObject[@"code"];
        [SVProgressHUD setContainerView:self.view];
        if (code.integerValue == 0) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
            
            NSArray * modelArr = [LCLHabitModel mj_objectArrayWithKeyValuesArray:responseObject[@"habitList"]];
            
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

- (void)habitCreateAction {
    LCLHabitCreateController * vc = [LCLHabitCreateController new];
    [self presentViewController:vc animated:YES completion:NULL];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCLHabitCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (self.dataSource.count > 0) {
        LCLHabitModel * habit = self.dataSource[indexPath.row];
        cell.model = habit;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    LCLPlanModel * plan = self.dataSource[indexPath.row];
//    LCLPlanDetailController * vc = [LCLPlanDetailController new];
//    vc.model = plan;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCLHabitModel * model = self.dataSource[indexPath.row];
    UIContextualAction * action = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"+ 1" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSLog(@"%s - + 1", __func__);
        
        [self addTime:model];
    }];
    action.backgroundColor = [UIColor myColorWithHexString:model.color];
    
    UIContextualAction * clearAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"清除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSLog(@"%s - 0", __func__);
        
        [self clearTime:model];
    }];
    clearAction.backgroundColor = [UIColor redColor];
    
    UISwipeActionsConfiguration * config = [UISwipeActionsConfiguration configurationWithActions:@[clearAction, action]];
    config.performsFirstActionWithFullSwipe = NO;
    return config;
}

- (void)clearTime:(LCLHabitModel *)model {
    model.count = 0;
    model.updateTime = [NSString stringWithFormat:@"%@", [NSDate new]];
    [self.table reloadData];
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSString stringWithFormat:@"%ld", model.count] forKey:model.name];
}

- (void)addTime:(LCLHabitModel *)model {
    model.count += 1;
    model.updateTime = [NSString stringWithFormat:@"%@", [NSDate new]];
    [self.table reloadData];
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSString stringWithFormat:@"%ld", model.count] forKey:model.name];
    
//    NSDictionary * parameter = [plan mj_keyValues];
//    NSLog(@"%s - %@", __func__, parameter);
//    [LCLNetworkManager POST:@"/planAddTime" parameters:parameter success:^(id responseObject) {
//        [self.table.mj_header endRefreshing];
//        NSLog(@"%s - %@", __func__, responseObject);
//        NSString * code = responseObject[@"code"];
//        [SVProgressHUD setContainerView:self.view];
//        if (code.integerValue == 0) {
//            [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
//        } else {
//            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
//        }
//    } failure:^(NSError *error) {
//        [self.table.mj_header endRefreshing];
//        NSLog(@"%s - %@", __func__, error);
//    }];
}

@end
