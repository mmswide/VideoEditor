//
//  ISVideoTrimToolbar.m
//  InstaShot
//
//  Created by Liu Xiang on 10/28/14.
//  Copyright (c) 2014 Liu Xiang. All rights reserved.
//

#import "ISVideoTrimToolbar.h"

#define ISVIDEOTRIMTOOLBAR_LEFT_PADDING         30
#define ISVIDEOTRIMTOOLBAR_TIME_LABEL_WIDTH     50
#define ISVIDEOTRIMTOOLBAR_TIME_LABEL_HEIGHT    20

@implementation ISVideoTrimToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        confirmToolbar = [[ISConfirmToolbar alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 44, self.bounds.size.width, 44)];
        confirmToolbar.delegate = self;
        confirmToolbar.title = @"Cut Video";
        confirmToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [self addSubview:confirmToolbar];
        
        fromTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ISVIDEOTRIMTOOLBAR_LEFT_PADDING, 0, ISVIDEOTRIMTOOLBAR_TIME_LABEL_WIDTH, ISVIDEOTRIMTOOLBAR_TIME_LABEL_HEIGHT)];
        fromTimeLabel.backgroundColor = [UIColor clearColor];
        fromTimeLabel.textColor = [UIColor whiteColor];
        fromTimeLabel.font = [UIFont systemFontOfSize:12.0f];
        fromTimeLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:fromTimeLabel];
        fromTimeLabel.hidden = YES;
        
        endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - ISVIDEOTRIMTOOLBAR_LEFT_PADDING - ISVIDEOTRIMTOOLBAR_TIME_LABEL_WIDTH, 0, ISVIDEOTRIMTOOLBAR_TIME_LABEL_WIDTH, ISVIDEOTRIMTOOLBAR_TIME_LABEL_HEIGHT)];
        endTimeLabel.backgroundColor = [UIColor clearColor];
        endTimeLabel.textColor = [UIColor whiteColor];
        endTimeLabel.font = [UIFont systemFontOfSize:12.0f];
        endTimeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:endTimeLabel];
        endTimeLabel.hidden = YES;
        
        totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(fromTimeLabel.frame.origin.x + fromTimeLabel.frame.size.width, 0, frame.size.width - fromTimeLabel.frame.size.width - endTimeLabel.frame.size.width - ISVIDEOTRIMTOOLBAR_LEFT_PADDING*2, ISVIDEOTRIMTOOLBAR_TIME_LABEL_HEIGHT)];
        totalTimeLabel.backgroundColor = [UIColor clearColor];
        totalTimeLabel.textColor = [UIColor redColor];
        totalTimeLabel.font = [UIFont systemFontOfSize:12.0f];
        totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:totalTimeLabel];
        
        rangePickSlider = [[NMRangeSlider alloc] initWithFrame:CGRectMake(ISVIDEOTRIMTOOLBAR_LEFT_PADDING, ISVIDEOTRIMTOOLBAR_TIME_LABEL_HEIGHT, frame.size.width - ISVIDEOTRIMTOOLBAR_LEFT_PADDING*2, frame.size.height - confirmToolbar.frame.size.height - ISVIDEOTRIMTOOLBAR_TIME_LABEL_HEIGHT)];
        [rangePickSlider addTarget:self action:@selector(sliderValueDidChanged:) forControlEvents:UIControlEventValueChanged];
        [rangePickSlider addTarget:self action:@selector(sliderValueDidSelected:) forControlEvents:UIControlEventTouchUpOutside];
        [rangePickSlider addTarget:self action:@selector(sliderValueDidSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage* image = nil;
        
        image = [UIImage imageNamed:@"slider-metal-trackBackground"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
        rangePickSlider.trackBackgroundImage = image;
        
        image = [UIImage imageNamed:@"slide_trim_bg"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 2.0)];
        rangePickSlider.trackImage = image;
        
        image = [UIImage imageNamed:@"btn_trimleft"];
        rangePickSlider.lowerHandleImageNormal = image;
        rangePickSlider.lowerHandleImageHighlighted = image;
        
        image = [UIImage imageNamed:@"btn_trimright"];
        rangePickSlider.upperHandleImageNormal = image;
        rangePickSlider.upperHandleImageHighlighted = image;
        
        rangePickSlider.lowerValue = 0.0;
        rangePickSlider.upperValue = 1.0;
        lastMinValue = 0.0;
        lastMaxValue = 1.0;
        [self addSubview:rangePickSlider];
    }
    return self;
}

- (void)setMinValue:(float)minValue andMaxValue:(float)maxValue andDuration:(float)duration
{
    _minValue = minValue;
    _maxValue = maxValue;
    _duraction = duration;
    totalTimeLabel.text = [NSString stringWithFormat:@"TOTAL: %@",[ISHelper timeFormatter:(int)duration]];
    rangePickSlider.lowerValue = _minValue/_duraction;
    rangePickSlider.upperValue = _maxValue/_duraction;
    lastMinValue = _minValue;
    lastMaxValue = _maxValue;
}

- (void)sliderValueDidChanged:(id)sender
{
    NMRangeSlider *slider = (NMRangeSlider *)sender;
    if (slider.lowerValue != lastMinValue) {
        if (fromTimeLabel.hidden == YES) {
            fromTimeLabel.hidden = NO;
            endTimeLabel.hidden = YES;
        }
        fromTimeLabel.text = [ISHelper timeFormatter:(int)(slider.lowerValue*self.maxValue)];
        [_delegate videoTrimToolbar:self rangeSliderValueDidChangedAtMinValue:slider.lowerValue*self.maxValue andMaxValue:slider.upperValue*self.maxValue isMaxValueChanged:NO];
    }else if (slider.upperValue != lastMaxValue){
        if (endTimeLabel.hidden == YES) {
            endTimeLabel.hidden = NO;
            fromTimeLabel.hidden = YES;
        }
        endTimeLabel.text = [ISHelper timeFormatter:(int)(slider.upperValue*self.maxValue)];
        [_delegate videoTrimToolbar:self rangeSliderValueDidChangedAtMinValue:slider.lowerValue*self.maxValue andMaxValue:slider.upperValue*self.maxValue isMaxValueChanged:YES];
    }
    lastMinValue = slider.lowerValue;
    lastMaxValue = slider.upperValue;
}

- (void)sliderValueDidSelected:(id)sender
{

}

#pragma mark--
#pragma mark-- ISConfirmToolbar Delegate
- (void)confirmToolbar:(ISConfirmToolbar *)toolbar clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //cancel
        [_delegate videoTrimToolbar:self rangeSliderDidSelectedAtMinValue:self.minValue andMaxValue:self.maxValue];
    }else{
        [_delegate videoTrimToolbar:self rangeSliderDidSelectedAtMinValue:lastMinValue*self.duraction andMaxValue:lastMaxValue*self.duraction];
    }
}

@end
    
