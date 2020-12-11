//
//  LCLPlanCell.h
//  MyPlan
//
//  Created by 云淡风轻 on 2020/11/10.
//

#import <UIKit/UIKit.h>
#import "LCLPlanModel.h"
#import "MGSwipeTableCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface LCLPlanCell : MGSwipeTableCell

@property (nonatomic, strong) LCLPlanModel * model;

@end

NS_ASSUME_NONNULL_END
