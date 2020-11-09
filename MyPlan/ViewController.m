//
//  ViewController.m
//  MyPlan
//
//  Created by 云淡风轻 on 2020/10/29.
//

#import "ViewController.h"
#import "LCLHomeController.h"
#import "LCLMineController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    LCLHomeController * home = [[LCLHomeController alloc] init];
    [self setUpChildVC:home imageName:@"首页未选中" selectedImageName:@"首页选中"];

    LCLMineController * mine = [[LCLMineController alloc] init];
    [self setUpChildVC:mine imageName:@"我的未选中" selectedImageName:@"我的选中"];
}

#pragma mark 添加一个控制器
- (void)setUpChildVC:(UIViewController *)childVC imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    
    UINavigationController * nav =[[UINavigationController alloc]initWithRootViewController:childVC];

    UIImage * image = [UIImage imageNamed:imageName];
    UIImage * imaged = [UIImage imageNamed:selectedImageName];

    // 未选中图片
    childVC.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 选中图片
    childVC.tabBarItem.selectedImage = [imaged imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.title = imageName;
    
    // 未选中文字的颜色
    [childVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
       
    // 选中的文字的颜色
    [childVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColor.blackColor, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [self addChildViewController:nav];
}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [LCLNetworkManager POST:@"http://192.168.10.102:8080/parametersServlet" parameters:@{@"username":@"lisi", @"password":@"123456"} success:^(id responseObject) {
//        NSLog(@"%s - %@", __func__, responseObject);
//    } failure:^(NSError *error) {
//        NSLog(@"%s - %@", __func__, error);
//    }];
//}


@end
