//
//  LCLPlanCell.m
//  MyPlan
//
//  Created by 云淡风轻 on 2020/11/10.
//

#import "LCLPlanCell.h"

@interface LCLPlanCell ()

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * durationLabel;
@property (nonatomic, strong) UILabel * countLabel;
@property (nonatomic, strong) UILabel * updateTimeLabel;
@property (nonatomic, strong) UILabel * colorLabel;

@end

@implementation LCLPlanCell

- (void)setModel:(LCLPlanModel *)model {
    _model = model;
    self.nameLabel.text = [NSString stringWithFormat:@"计划名称 %@", model.name];
    self.durationLabel.text = [NSString stringWithFormat:@"记录时长 %ld分钟", model.totalMinutes];
    self.countLabel.text = [NSString stringWithFormat:@"记录次数 %ld", model.count];
    self.updateTimeLabel.text = [NSString stringWithFormat:@"最近更新 %@", model.updateTime];
    self.colorLabel.backgroundColor = [UIColor myColorWithHexString:model.color];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        MyRelativeLayout * root = [MyRelativeLayout new];
        root.myMargin = 0;
        root.myHeight = MyLayoutSize.fill;
        [self.contentView addSubview:root];
        
        // #ADFF2F
        UILabel * colorLabel = [UILabel new];
        colorLabel.myTop = 0;
        colorLabel.myLeft = 0;
        colorLabel.myBottom = 0;
        colorLabel.myWidth = 5;
        [root addSubview:colorLabel];
        self.colorLabel = colorLabel;
        
        UILabel * nameLabel = [UILabel new];
        nameLabel.myTop = 0;
        nameLabel.myLeft = 15;
        nameLabel.myHeight = 30;
        nameLabel.myRight = 15;
        [root addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UILabel * timeLabel = [UILabel new];
        timeLabel.myTop = 30;
        timeLabel.myLeft = 15;
        timeLabel.myHeight = 30;
        timeLabel.myRight = 15;
        [root addSubview:timeLabel];
        self.durationLabel = timeLabel;
        
        UILabel * countLabel = [UILabel new];
        countLabel.myTop = 60;
        countLabel.myLeft = 15;
        countLabel.myHeight = 30;
        countLabel.myRight = 15;
        [root addSubview:countLabel];
        self.countLabel = countLabel;
        
        UILabel * updateLabel = [UILabel new];
        updateLabel.myTop = 90;
        updateLabel.myLeft = 15;
        updateLabel.myHeight = 30;
        updateLabel.myRight = 15;
        [root addSubview:updateLabel];
        self.updateTimeLabel = updateLabel;
    }
    return self;
}

@end
