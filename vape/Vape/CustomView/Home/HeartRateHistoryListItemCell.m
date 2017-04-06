//
//  HeartRateHistoryListItemCell.m
//  Vape
//
//  Created by WestWood on 2017/3/13.
//  Copyright © 2017年 YZH. All rights reserved.
//

#import "HeartRateHistoryListItemCell.h"
#import "Utility.h"

@interface HeartRateHistoryListItemCell ()

@property (strong, nonatomic) HeartRate *pHeartRate;
@property (assign, nonatomic) NSInteger valueFontSize;
@property (assign, nonatomic) NSInteger unitFontSize;

@end

@implementation HeartRateHistoryListItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.dateTimeBackView setBackgroundColor:kHeartRate_Normal_BgColor];
    if (kiPhone_Version == kiPhone_4 || kiPhone_Version == kiPhone_3_5) {
        self.valueFontSize = 25;
        self.unitFontSize = 10;
    }
    else {
        self.valueFontSize = 30;
        self.unitFontSize = 12;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setHeartRate:(HeartRate *)heartRate {
    self.pHeartRate = heartRate;
    if (heartRate != nil) {
        [self.heartRateBackView setBackgroundColor:([heartRate isNormalByHeartRateValue]?kHeartRate_Normal_BgColor:kHeartRate_Abnormal_BgColor)];
        [self.bloodOxygenBackView setBackgroundColor:([heartRate isNormalByBloodOxygenValue]?kHeartRate_Normal_BgColor:kHeartRate_Abnormal_BgColor)];
        
        
        
        
        NSDictionary *valueStyleDict = @{NSFontAttributeName: [UIFont fontWithName:kNumber_Font_Name_Regular size:self.valueFontSize],
                                         NSForegroundColorAttributeName: [UIColor whiteColor]};
        NSDictionary *unitStyleDict = @{NSFontAttributeName: [UIFont systemFontOfSize:self.unitFontSize],
                                        NSForegroundColorAttributeName: [UIColor whiteColor]};
        
        //显示心率
        NSString *unitString = LOCALIZED_STRING(keyTimesPerSecond);
        NSString *heartRateValueString = [NSString stringWithFormat:@"%ld%@", (long)heartRate.heartRate, unitString];
        NSMutableAttributedString *heartRateAttributedString = [[NSMutableAttributedString alloc] initWithString:heartRateValueString];
        [heartRateAttributedString addAttributes:valueStyleDict range:NSMakeRange(0, heartRateValueString.length-unitString.length)];
        [heartRateAttributedString addAttributes:unitStyleDict range:NSMakeRange(heartRateValueString.length-unitString.length, unitString.length)];
        self.heartRateValueLabel.attributedText = heartRateAttributedString;
        
        //显示血氧
        NSString *bloodOxygenValueString = [NSString stringWithFormat:@"%ld%@", (long)heartRate.bloodOxygen, @"%"];
        NSMutableAttributedString *bloodOxygenAttributedString = [[NSMutableAttributedString alloc] initWithString:bloodOxygenValueString];
        [bloodOxygenAttributedString addAttributes:valueStyleDict range:NSMakeRange(0, bloodOxygenValueString.length-1)];
        [bloodOxygenAttributedString addAttributes:unitStyleDict range:NSMakeRange(bloodOxygenValueString.length-1, 1)];
        self.bloodOxygenValueLabel.attributedText = bloodOxygenAttributedString;
        
        //显示日期时间
        self.dayLabel.text = [heartRate.heartRateDt stringWithFormat:@"yyyy-MM-dd"];
        self.timeLabel.text = [heartRate.heartRateDt stringWithFormat:@"HH:mm"];
    }
}

@end
