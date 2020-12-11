//
//  LCLPlanDetailController.m
//  MyPlan
//
//  Created by 云淡风轻 on 2020/11/9.
//

#import "LCLPlanDetailController.h"
#import "LCLPlanHistoryController.h"

@interface LCLPlanDetailController ()

@end

@implementation LCLPlanDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.model.name;
    
    UIBarButtonItem * okItem = [[UIBarButtonItem alloc] initWithTitle:@"统计记录" style:UIBarButtonItemStylePlain target:self action:@selector(planHistoryAction)];
    self.navigationItem.rightBarButtonItem = okItem;
    
    MyRelativeLayout * root = [MyRelativeLayout new];
    root.myTop = LCLNavBarHeight;
    root.myWidth = MyLayoutSize.fill;
    root.myHeight = MyLayoutSize.fill;
    [self.view addSubview:root];
    
    UILabel * nameLabel = [UILabel new];
    nameLabel.myTop = 20;
    nameLabel.myHeight = 50;
    nameLabel.myLeft = 15;
    nameLabel.myRight = 15;
    nameLabel.textColor = UIColor.blackColor;
    nameLabel.text = [NSString stringWithFormat:@"计划名称: %@", self.model.name];
    [root addSubview:nameLabel];
    
    UILabel * contentLabel = [UILabel new];
    contentLabel.numberOfLines = 0;
    contentLabel.topPos.equalTo(nameLabel.bottomPos).offset(10);
    contentLabel.myHeight = MyLayoutSize.wrap;
    contentLabel.myLeft = 15;
    contentLabel.myRight = 15;
    contentLabel.textColor = UIColor.blackColor;
    contentLabel.text = [NSString stringWithFormat:@"计划内容: %@", self.model.content];
    [root addSubview:contentLabel];
    
    UILabel * durationLabel = [UILabel new];
    durationLabel.topPos.equalTo(contentLabel.bottomPos).offset(10);
    durationLabel.myHeight = 50;
    durationLabel.myLeft = 15;
    durationLabel.myRight = 15;
    durationLabel.textColor = UIColor.blackColor;
    durationLabel.text = [NSString stringWithFormat:@"记录时长: %ld", self.model.totalMinutes];
    [root addSubview:durationLabel];
    
    UILabel * countLabel = [UILabel new];
    countLabel.topPos.equalTo(durationLabel.bottomPos).offset(10);
    countLabel.myHeight = 50;
    countLabel.myLeft = 15;
    countLabel.myRight = 15;
    countLabel.textColor = UIColor.blackColor;
    countLabel.text = [NSString stringWithFormat:@"记录次数: %ld", self.model.count];
    [root addSubview:countLabel];
}

- (void)planHistoryAction {
    LCLPlanHistoryController * vc = [LCLPlanHistoryController new];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
