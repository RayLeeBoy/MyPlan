//
//  ViewController.m
//  MyPlan
//
//  Created by 云淡风轻 on 2020/10/29.
//

#import "ViewController.h"
#import "LCLHomeController.h"
#import "LCLMineController.h"
#import "LCLHabitController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    LCLHomeController * home = [[LCLHomeController alloc] init];
    home.title = @"首页";
    [self setUpChildVC:home imageName:@"" selectedImageName:@""];
    
    LCLHabitController * habit = [LCLHabitController new];
    habit.title = @"习惯";
    [self setUpChildVC:habit imageName:@"" selectedImageName:@""];

    LCLMineController * mine = [[LCLMineController alloc] init];
    mine.title = @"我的";
    [self setUpChildVC:mine imageName:@"" selectedImageName:@""];
}

#pragma mark 添加一个控制器
- (void)setUpChildVC:(UIViewController *)childVC imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {
    
    UINavigationController * nav =[[UINavigationController alloc] initWithRootViewController:childVC];

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
//    [LCLNetworkManager POST:@"/parametersServlet" parameters:@{@"username":@"lisi", @"password":@"123456"} success:^(id responseObject) {
//        NSLog(@"%s - %@", __func__, responseObject);
//    } failure:^(NSError *error) {
//        NSLog(@"%s - %@", __func__, error);
//    }];
//}


@end
