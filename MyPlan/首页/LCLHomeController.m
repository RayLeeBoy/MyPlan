//
//  LCLHomeController.m
//  MyPlan
//
//  Created by 云淡风轻 on 2020/10/29.
//

#import "LCLHomeController.h"
#import "LCLPlanCreateController.h"
#import "LCLPlanModel.h"
#import "LCLPlanDetailController.h"
#import "LCLPlanCell.h"
#import "LCLOngoingController.h"
#import "LCLFinishedController.h"

@interface LCLHomeController ()

@end

@implementation LCLHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页";
    
    UIBarButtonItem * okItem = [[UIBarButtonItem alloc] initWithTitle:@"新建计划" style:UIBarButtonItemStylePlain target:self action:@selector(planCreateAction)];
    self.navigationItem.rightBarButtonItem = okItem;
    
    LCLOngoingController * vc1 = [LCLOngoingController new];
    LCLFinishedController * vc2 = [LCLFinishedController new];
    
    MJCSegmentInterface * interface = [MJCSegmentInterface jc_initWithFrame:CGRectMake(0, 0, self.view.jc_width, self.view.jc_height - LCLSafeAreaHeight) titlesArray:@[@"进行中", @"已完成"] childControllerArray:@[vc1, vc2] interFaceStyleToolsBlock:^(MJCSegmentStylesTools *jc_tools) {
        jc_tools.jc_titleBarStyles(MJCTitlesScrollStyle).
        jc_indicatorColor(LCLMainColor).
        jc_childScollAnimalEnabled(NO).
        jc_childScollEnabled(NO).
        jc_itemTextNormalColor(LCLTextColor9).
        jc_itemTextSelectedColor(LCLMainColor).
        jc_itemTextFontSize(15).
        jc_itemTextBoldFontSizeSelected(15).
        jc_defaultItemShowCount(2).
        jc_titlesViewFrame(CGRectMake(0, LCLNavBarHeight, LCLScreenWidth, 50));
    } hostController:self];
    [self.view addSubview:interface];
}

- (void)planCreateAction {
    LCLPlanCreateController * vc = [LCLPlanCreateController new];
    [self presentViewController:vc animated:YES completion:NULL];
}

@end
