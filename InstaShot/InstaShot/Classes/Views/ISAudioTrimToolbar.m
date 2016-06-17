//
//  ISAudioTrimToolbar.m
//  InstaShot
//
//  Created by Liu Xiang on 11/28/14.
//  Copyright (c) 2014 Liu Xiang. All rights reserved.
//

#import "ISAudioTrimToolbar.h"

#define ISAUDIOTRIMTOOLBAR_LEFT_PADDING         20
#define ISAUDIOTRIMTOOLBAR_TIME_LABEL_WIDTH     80
#define ISAUDIOTRIMTOOLBAR_TIME_LABEL_HEIGHT    21

@implementation ISAudioTrimToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        confirmToolbar = [[ISConfirmToolbar alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 44, self.bounds.size.width, 44)];
        confirmToolbar.delegate = self;
        confirmToolbar.title = @"Music";
        confirmToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [self addSubview:confirmToolbar];
        
        startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ISAUDIOTRIMTOOLBAR_LEFT_PADDING, 0, ISAUDIOTRIMTOOLBAR_TIME_LABEL_WIDTH, ISAUDIOTRIMTOOLBAR_TIME_LABEL_HEIGHT)];
        startTimeLabel.backgroundColor = [UIColor clearColor];
        startTimeLabel.textColor = [UIColor redColor];
        startTimeLabel.font = [UIFont systemFontOfSize:12.0f];
        startTimeLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:startTimeLabel];
        
        musicNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 140, ISAUDIOTRIMTOOLBAR_TIME_LABEL_HEIGHT)];
        musicNameLabel.backgroundColor = [UIColor clearColor];
        musicNameLabel.textColor = [UIColor redColor];
        musicNameLabel.font = [UIFont systemFontOfSize:12.0f];
        musicNameLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:musicNameLabel];
        
        startTimeSlider = [[UISlider alloc] initWithFrame:CGRectMake(ISAUDIOTRIMTOOLBAR_LEFT_PADDING, ISAUDIOTRIMTOOLBAR_TIME_LABEL_HEIGHT + 10, 230, 20)];
        startTimeSlider.tag = 1;
        startTimeSlider.minimumTrackTintColor = [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:87.0/255.0 alpha:1];
        [startTimeSlider setThumbImage:[UIImage imageNamed:@"btn_trimleft"] forState:UIControlStateNormal];
        [startTimeSlider setThumbImage:[UIImage imageNamed:@"btn_trimleft"] forState:UIControlStateHighlighted];
        [startTimeSlider addTarget:self action:@selector(sliderValueDidChanged:) forControlEvents:UIControlEventValueChanged];
        [startTimeSlider addTarget:self action:@selector(sliderDidTouchDown:) forControlEvents:UIControlEventTouchDown];
        [startTimeSlider addTarget:self action:@selector(sliderDidTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        [startTimeSlider addTarget:self action:@selector(sliderDidTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
        [startTimeSlider addTarget:self action:@selector(sliderDidTouchUp:) forControlEvents:UIControlEventTouchCancel];
        [self addSubview:startTimeSlider];
        
        menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        menuBtn.frame = CGRectMake(self.frame.size.width - ISAUDIOTRIMTOOLBAR_LEFT_PADDING - 32, ISAUDIOTRIMTOOLBAR_TIME_LABEL_HEIGHT, 32, 32);
        [menuBtn setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
        [menuBtn addTarget:self action:@selector(menuDidPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuBtn];
        
    }
    return self;
}

- (void)setStartTime:(float)startTime andMaxTime:(float)maxTime andMusicName:(NSString *)musicName
{
    self.startTime = startTime;
    lastStartTime = startTime;
    self.duraction = maxTime;
    musicNameLabel.text = musicName;
    
    startTimeSlider.minimumValue = 0;
    startTimeSlider.maximumValue = maxTime;
    startTimeSlider.value = startTime;
    [self setStartTimeLabelText:startTime];
}

- (void)setStartTimeLabelText:(float)startTime
{
    startTimeLabel.text = [NSString stringWithFormat:@"START: %@",[ISHelper timeFormatter:(int)startTime]];
}

- (void)menuDidPressed:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:STRING_CANCEL destructiveButtonTitle:nil otherButtonTitles:STRING_EDIT_VOLUME, STRING_RESELECT_MUSIC, STRING_DELETE_MUSIC,nil];
    [actionSheet showInView:self];
}

- (void)sliderDidTouchUp:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    self.startTime = slider.value;
    [_delegate audioTrimToolbar:self previewStartTimeDidSelectedAt:self.startTime];
}

- (void)sliderDidTouchDown:(id)sender
{
    
}

- (void)sliderValueDidChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    [self setStartTimeLabelText:slider.value];
}

#pragma mark--
#pragma mark-- UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [_delegate editVolume:self];
    }else if(buttonIndex == 1){
        [_delegate reselectMusic:self];
    }else if(buttonIndex == 2){
        [_delegate deleteMusic:self];
    }
}

#pragma mark--
#pragma mark-- ISConfirmToolbar Delegate
- (void)confirmToolbar:(ISConfirmToolbar *)toolbar clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //cancel
        [_delegate audioTrimToolbar:self isChangesCancelled:YES];
    }else{
        [_delegate audioTrimToolbar:self isChangesCancelled:NO];
    }
}

@end
