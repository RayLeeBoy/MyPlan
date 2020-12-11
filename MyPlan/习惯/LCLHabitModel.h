//
//  LCLHabitModel.h
//  MyPlan
//
//  Created by 云淡风轻 on 2020/11/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCLHabitModel : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * color;
@property (nonatomic, strong) NSString * updateTime;
@property (nonatomic, assign) NSInteger count;

@end

NS_ASSUME_NONNULL_END
