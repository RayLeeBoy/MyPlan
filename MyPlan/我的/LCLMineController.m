//
//  LCLMineController.m
//  MyPlan
//
//  Created by 云淡风轻 on 2020/10/29.
//

#import "LCLMineController.h"
#import "LCLRegistController.h"
#import "LCLLoginController.h"

@interface LCLMineController ()

@end

@implementation LCLMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人中心";
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(loginAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)registAction {
    LCLRegistController * vc = [LCLRegistController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loginAction {
    LCLLoginController * vc = [LCLLoginController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
