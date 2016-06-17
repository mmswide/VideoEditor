//
//  GDAlertView.m
//  Goddess
//
//  Created by Liu Xiang on 9/16/14.
//  Copyright (c) 2014 mokun. All rights reserved.
//

#import "ISAudioVolumePoupView.h"
#import "GDColorButton.h"

#define ISAUDIOVOLUMEPOPUPVIEW_CONTENT_VIEW_WIDTH   280
#define ISAUDIOVOLUMEPOPUPVIEW_CONTENT_VIEW_HEIGHT  200
#define ISAUDIOVOLUMEPOPUPVIEW_LEFT_PADDING         20
#define ISAUDIOVOLUMEPOPUPVIEW_INTERVAL_PADDING     10

@interface ISAudioVolumePoupView ()
{
    UIView *bgView;
    UIView *contentView;
    UILabel *videoVolumeLabel;
    UILabel *musicVolumeLabel;
    UIImageView *videoImageView;
    UIImageView *musicImageView;
    UISlider *videoVolumeSlider;
    UISlider *musicVolumeSlider;
    GDColorButton *cancelBtn;
    GDColorButton *confirmBtn;
    float orgVideoVolume;
    float orgMusicVolune;
}

@property (assign, nonatomic) float currentVideoVolume;
@property (assign, nonatomic) float currentMusicVolume;
@property (nonatomic, unsafe_unretained) id<ISAudioVolumePoupViewDelegate> delegate;

@end

@implementation ISAudioVolumePoupView

- (id)initWithVideoVolume:(float)currentVideoVolume
              musicVolume:(float)currentMusicVolume
                 delegate:(id)delegate
{
    self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    if (self) {
        _currentVideoVolume = currentVideoVolume;
        _currentMusicVolume = currentMusicVolume;
        _delegate = delegate;
        orgVideoVolume = currentVideoVolume;
        orgMusicVolune = currentMusicVolume;
        [self performLayout];
    }
    return self;
}

- (void)performLayout
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    bgView = [[UIView alloc] initWithFrame:window.frame];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.0;
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewTapped:)]];
    [self addSubview:bgView];
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ISAUDIOVOLUMEPOPUPVIEW_CONTENT_VIEW_WIDTH,ISAUDIOVOLUMEPOPUPVIEW_CONTENT_VIEW_HEIGHT)];
    contentView.center = CGPointMake(window.frame.size.width/2, window.frame.size.height/2 - 32);
    contentView.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1];
    contentView.alpha = 1.0;
    contentView.clipsToBounds = YES;
    [self addSubview:contentView];
    
    videoVolumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ISAUDIOVOLUMEPOPUPVIEW_LEFT_PADDING, ISAUDIOVOLUMEPOPUPVIEW_LEFT_PADDING, contentView.frame.size.width - ISAUDIOVOLUMEPOPUPVIEW_LEFT_PADDING*2, 21)];
    videoVolumeLabel.textAlignment = NSTextAlignmentLeft;
    videoVolumeLabel.text = @"Video Volume";
    videoVolumeLabel.textColor = [UIColor grayColor];
    [contentView addSubview:videoVolumeLabel];
    
    videoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ISAUDIOVOLUMEPOPUPVIEW_LEFT_PADDING, videoVolumeLabel.frame.origin.y + videoVolumeLabel.frame.size.height + ISAUDIOVOLUMEPOPUPVIEW_INTERVAL_PADDING, 20, 20)];
    videoImageView.image = [UIImage imageNamed:@"icon_volume"];
    [contentView addSubview:videoImageView];
    
    videoVolumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(videoImageView.frame.origin.x + videoImageView.frame.size.width + ISAUDIOVOLUMEPOPUPVIEW_INTERVAL_PADDING, videoImageView.frame.origin.y, contentView.frame.size.width - ISAUDIOVOLUMEPOPUPVIEW_INTERVAL_PADDING*2 - videoImageView.frame.origin.x - videoImageView.frame.size.width - ISAUDIOVOLUMEPOPUPVIEW_LEFT_PADDING, 20)];
    videoVolumeSlider.tag = 0;
    videoVolumeSlider.minimumTrackTintColor = [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:87.0/255.0 alpha:1];
    [videoVolumeSlider setThumbImage:[UIImage imageNamed:@"slide_volume"] forState:UIControlStateNormal];
    [videoVolumeSlider setThumbTintColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:87.0/255.0 alpha:1]];
    videoVolumeSlider.minimumValue = 0.f;
    videoVolumeSlider.maximumValue = 1.f;
    videoVolumeSlider.value = self.currentVideoVolume;
    [videoVolumeSlider addTarget:self action:@selector(sliderValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    [contentView addSubview:videoVolumeSlider];
    
    musicVolumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ISAUDIOVOLUMEPOPUPVIEW_LEFT_PADDING, videoVolumeSlider.frame.origin.x + videoVolumeSlider.frame.size.height + ISAUDIOVOLUMEPOPUPVIEW_INTERVAL_PADDING, contentView.frame.size.width - ISAUDIOVOLUMEPOPUPVIEW_LEFT_PADDING*2, 21)];
    musicVolumeLabel.textAlignment = NSTextAlignmentLeft;
    musicVolumeLabel.text = @"Music Volume";
    musicVolumeLabel.textColor = [UIColor grayColor];
    [contentView addSubview:musicVolumeLabel];
    
    musicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ISAUDIOVOLUMEPOPUPVIEW_LEFT_PADDING, musicVolumeLabel.frame.origin.y + musicVolumeLabel.frame.size.height + ISAUDIOVOLUMEPOPUPVIEW_INTERVAL_PADDING, 20, 20)];
    musicImageView.image = [UIImage imageNamed:@"icon_volume"];
    [contentView addSubview:musicImageView];
    
    musicVolumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(musicImageView.frame.origin.x + musicImageView.frame.size.width + ISAUDIOVOLUMEPOPUPVIEW_INTERVAL_PADDING, musicImageView.frame.origin.y, contentView.frame.size.width - ISAUDIOVOLUMEPOPUPVIEW_INTERVAL_PADDING*2 - musicImageView.frame.origin.x - musicImageView.frame.size.width - ISAUDIOVOLUMEPOPUPVIEW_LEFT_PADDING, 20)];
    musicVolumeSlider.tag = 1;
    musicVolumeSlider.minimumTrackTintColor = [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:87.0/255.0 alpha:1];
    [musicVolumeSlider setThumbImage:[UIImage imageNamed:@"slide_volume"] forState:UIControlStateNormal];
    [musicVolumeSlider setThumbTintColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:87.0/255.0 alpha:1]];
    musicVolumeSlider.minimumValue = 0.f;
    musicVolumeSlider.maximumValue = 1.f;
    musicVolumeSlider.value = self.currentMusicVolume;
    [musicVolumeSlider addTarget:self action:@selector(sliderValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    [contentView addSubview:musicVolumeSlider];
    
    UIView *seperateLineView = [[UIView alloc] initWithFrame:CGRectMake(0, contentView.frame.size.height - 41, contentView.frame.size.width, 1)];
    seperateLineView.backgroundColor = [UIColor grayColor];
    [contentView addSubview:seperateLineView];
    
    cancelBtn = [GDColorButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, contentView.frame.size.height - 40, contentView.frame.size.width/2, 40);
    [cancelBtn setNormalColor:[UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1]];
    [cancelBtn setHighlightedColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1]];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelBtn];
    
    confirmBtn = [GDColorButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(contentView.frame.size.width/2+1, contentView.frame.size.height - 40, contentView.frame.size.width/2, 40);
    [confirmBtn setNormalColor:[UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1]];
    [confirmBtn setHighlightedColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1]];
    [confirmBtn setTitle:@"OK" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:confirmBtn];
    
    UIView *seperateLineView1 = [[UIView alloc] initWithFrame:CGRectMake(contentView.frame.size.width/2, contentView.frame.size.height - 40, 1, 40)];
    seperateLineView1.backgroundColor = [UIColor grayColor];
    [contentView addSubview:seperateLineView1];
}

- (void)sliderValueDidChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    if (slider.tag == 0) {
        //video volume
        self.currentVideoVolume = slider.value;
        [_delegate volumePopupView:self videoVolumeChangedTo:self.currentVideoVolume musicVolumeChangedTo:self.currentMusicVolume];
    }else{
        //music volume
        self.currentMusicVolume = slider.value;
        [_delegate volumePopupView:self videoVolumeChangedTo:self.currentVideoVolume musicVolumeChangedTo:self.currentMusicVolume];
    }
}

- (void)showAtView:(UIView *)view
{
    [view addSubview:self];
    [view bringSubviewToFront:self];
    
    contentView.layer.opacity = 0.5f;
    contentView.layer.transform = CATransform3DMakeScale(1.1f, 1.1f, 1.0);
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 bgView.alpha = 0.3;
                         contentView.layer.opacity = 1.0f;
                         contentView.layer.transform = CATransform3DMakeScale(1, 1, 1);
					 }
					 completion:NULL
     ];
}

- (void)hide
{
    [self removeFromSuperview];
}

- (void)backgroundViewTapped:(id)sender
{
    [self hide];
}

- (void)cancelButtonPressed:(id)sender
{
    [_delegate volumePopupView:self videoVolumeChangedTo:orgVideoVolume musicVolumeChangedTo:orgMusicVolune];
    [self hide];
}

- (void)confirmButtonPressed:(id)sender
{
    [_delegate volumePopupView:self videoVolumeChangedTo:self.currentVideoVolume musicVolumeChangedTo:self.currentMusicVolume];
    [self hide];
}

@end
