//
//  LCLPlanModel.h
//  MyPlan
//
//  Created by 云淡风轻 on 2020/11/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCLPlanModel : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, assign) NSInteger totalMinutes;
@property (nonatomic, assign) NSInteger count;

@end

NS_ASSUME_NONNULL_END
