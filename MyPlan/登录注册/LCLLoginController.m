//
//  LCLLoginController.m
//  MyPlan
//
//  Created by 云淡风轻 on 2020/10/30.
//

#import "LCLLoginController.h"

@interface LCLLoginController ()

@property (nonatomic, strong) UITextField * accountTf;
@property (nonatomic, strong) UITextField * passwordTf;

@end

@implementation LCLLoginController

- (void)viewDidLoad {
    
    self.title = @"登录";
    
    MyRelativeLayout * root = [MyRelativeLayout new];
    root.backgroundColor = UIColor.whiteColor;
    root.myMargin = 0;
    self.view = root;
    
    UITextField * accountTf = [UITextField new];
    accountTf.myTop = 100;
    accountTf.myLeft = accountTf.myRight = 50;
    accountTf.myHeight = 50;
    accountTf.backgroundColor = UIColor.lightGrayColor;
    [self.view addSubview:accountTf];
    self.accountTf = accountTf;
    
    UITextField * passwordTf = [UITextField new];
    passwordTf.topPos.equalTo(accountTf.bottomPos).offset(20);
    passwordTf.myLeft = passwordTf.myRight = 50;
    passwordTf.myHeight = 50;
    passwordTf.backgroundColor = UIColor.lightGrayColor;
    [self.view addSubview:passwordTf];
    self.passwordTf = passwordTf;
    
    UIButton * loginBtn = [UIButton new];
    loginBtn.topPos.equalTo(passwordTf.bottomPos).offset(20);
    loginBtn.myLeft = loginBtn.myRight = 50;
    loginBtn.myHeight = 50;
    loginBtn.backgroundColor = UIColor.blackColor;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}

- (void)loginAction {
    [LCLNetworkManager POST:@"http://192.168.10.102:8080/login" parameters:@{@"username":self.accountTf.text, @"password":self.passwordTf.text} success:^(id responseObject) {
        NSLog(@"%s - %@", __func__, responseObject);
        NSString * code = responseObject[@"code"];
        [SVProgressHUD setContainerView:self.view];
        if (code.integerValue == 0) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
        } else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%s - %@", __func__, error);
    }];
}

@end
