//
//  LCLPlanCreateController.m
//  MyPlan
//
//  Created by 云淡风轻 on 2020/11/9.
//

#import "LCLPlanCreateController.h"

@interface LCLPlanCreateController ()

@property (nonatomic, strong) UITextField * nameTf;
@property (nonatomic, strong) UITextField * descTf;

@end

@implementation LCLPlanCreateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"计划创建";
    
    MyRelativeLayout * root = [MyRelativeLayout new];
    root.myTop = 0;
    root.myWidth = MyLayoutSize.fill;
    root.myHeight = MyLayoutSize.fill;
    [self.view addSubview:root];
    
    UIButton * okBtn = [UIButton new];
    okBtn.myTop = 0;
    okBtn.myHeight = 50;
    okBtn.myRight = 0;
    okBtn.myWidth = 50;
    [okBtn setTitle:@"提交" forState:UIControlStateNormal];
    [okBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    [root addSubview:okBtn];
    
    MyRelativeLayout * nameLayout = [self addTextFieldWithTitle:@"计划名称" placeholder:@"请填入计划名称"];
    nameLayout.myTop = 70;
    nameLayout.myHeight = 50;
    nameLayout.myLeft = 0;
    nameLayout.myRight = 0;
    [root addSubview:nameLayout];
    
    MyRelativeLayout * descLayout = [self addTextFieldWithTitle:@"计划描述" placeholder:@"请填入计划描述"];
    descLayout.topPos.equalTo(nameLayout.bottomPos).offset(10);
    descLayout.myHeight = 50;
    descLayout.myLeft = 0;
    descLayout.myRight = 0;
    [root addSubview:descLayout];
}

- (void)okAction {
    if (self.nameTf.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:self.nameTf.placeholder];
        return;
    }
    
    if (self.descTf.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:self.descTf.placeholder];
        return;
    }
    
    [LCLNetworkManager POST:@"http://192.168.10.102:8080/planCreate" parameters:@{@"name":self.nameTf.text, @"content":self.descTf.text} success:^(id responseObject) {
        NSLog(@"%s - %@", __func__, responseObject);
        NSString * code = responseObject[@"code"];
        [SVProgressHUD setContainerView:self.view];
        if (code.integerValue == 0) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
            [self dismissViewControllerAnimated:YES completion:NULL];
        } else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%s - %@", __func__, error);
    }];
}

- (MyRelativeLayout *)addTextFieldWithTitle:(NSString *)title placeholder:(NSString *)placeholder {
    MyRelativeLayout * root = [MyRelativeLayout new];
    root.myHeight = 50;
    root.myWidth = ZTScreenWidth;
    
    UILabel * label = [UILabel new];
    label.myTop = 0;
    label.myHeight = 50;
    label.myLeft = 15;
    label.myWidth = 80;
    label.textColor = UIColor.blackColor;
    label.text = title;
    [root addSubview:label];
    
    UITextField * tf = [UITextField new];
    tf.leftPos.equalTo(label.rightPos);
    tf.myTop = 0;
    tf.myHeight = 50;
    tf.myRight = 15;
    tf.backgroundColor = UIColor.lightGrayColor;
    tf.placeholder = placeholder;
    [root addSubview:tf];
    
    if ([title isEqualToString:@"计划名称"]) {
        self.nameTf = tf;
    } else if ([title isEqualToString:@"计划描述"]) {
        self.descTf = tf;
    }
    
    return root;
}

@end
