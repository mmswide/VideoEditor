//
//  ISVideoTrimToolbar.h
//  InstaShot
//
//  Created by Liu Xiang on 10/28/14.
//  Copyright (c) 2014 Liu Xiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMRangeSlider.h"
#import "ISConfirmToolbar.h"

@protocol ISVideoTrimToolbarDelegate;

@interface ISVideoTrimToolbar : UIView <ISConfirmToolbarDelegate>
{
    ISConfirmToolbar *confirmToolbar;
    UILabel *totalTimeLabel;
    UILabel *fromTimeLabel;
    UILabel *endTimeLabel;
    NMRangeSlider *rangePickSlider;
    float lastMinValue;
    float lastMaxValue;
}

@property (nonatomic, assign) float duraction;
@property (nonatomic, assign) float minValue;
@property (nonatomic, assign) float maxValue;
@property (nonatomic, unsafe_unretained) id<ISVideoTrimToolbarDelegate> delegate;

- (void)setMinValue:(float)minValue andMaxValue:(float)maxValue andDuration:(float)duration;

@end

@protocol ISVideoTrimToolbarDelegate <NSObject>
@optional
- (void)videoTrimToolbar:(ISVideoTrimToolbar *)toolbar rangeSliderDidSelectedAtMinValue:(float)minValue andMaxValue:(float)maxValue;
- (void)videoTrimToolbar:(ISVideoTrimToolbar *)toolbar rangeSliderValueDidChangedAtMinValue:(float)minValue andMaxValue:(float)maxValue isMaxValueChanged:(BOOL)yes;
@end
