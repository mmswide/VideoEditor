//
//  ISAudioPickerPopupView.m
//  InstaShot
//
//  Created by Liu Xiang on 11/28/14.
//  Copyright (c) 2014 Liu Xiang. All rights reserved.
//

#import "ISAudioPickerPopupView.h"
#import "GDColorButton.h"

#define ISAUDIOPICKERPOPUPVIEW_LEFT_PADDING         10

@interface ISAudioPickerPopupView ()
{
    UIView *bgView;
    UIView *contentView;
    UILabel *titleLabel;
    GDColorButton *chooseFromThemeBtn;
    GDColorButton *chooseFromLibraryBtn;
    UIImageView *chooseFromThemeImageView;
    UIImageView *chooseFromLibraryImageView;
    UILabel *chooseFromThemeLabel;
    UILabel *chooseFromLibraryLabel;
}

@end

@implementation ISAudioPickerPopupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    if (self) {
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
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280,163)];
    contentView.center = CGPointMake(window.frame.size.width/2, window.frame.size.height/2 - 32);
    contentView.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1];
    contentView.alpha = 1.0;
    contentView.clipsToBounds = YES;
    [self addSubview:contentView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ISAUDIOPICKERPOPUPVIEW_LEFT_PADDING, 0, contentView.frame.size.width - ISAUDIOPICKERPOPUPVIEW_LEFT_PADDING*2, 60)];
    titleLabel.text = STRING_CHOOSE_MUSIC_ACTION_SHEET_TITLE;
    titleLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:190.0/255.0 blue:255.0/255.0 alpha:1];
    titleLabel.font = [UIFont systemFontOfSize:18.f];
    titleLabel.backgroundColor = [UIColor clearColor];
    [contentView addSubview:titleLabel];
    
    UIView *separateLine = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.frame.origin.y + titleLabel.frame.size.height, contentView.frame.size.width, 2)];
    separateLine.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:190.0/255.0 blue:255.0/255.0 alpha:1];
    [contentView addSubview:separateLine];
    
    chooseFromThemeBtn = [GDColorButton buttonWithType:UIButtonTypeCustom];
    chooseFromThemeBtn.tag = 0;
    chooseFromThemeBtn.frame = CGRectMake(0, 62, contentView.frame.size.width, 50);
    [chooseFromThemeBtn setNormalColor:[UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1]];
    [chooseFromThemeBtn setHighlightedColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1]];
    [chooseFromThemeBtn addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:chooseFromThemeBtn];
    
    chooseFromThemeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ISAUDIOPICKERPOPUPVIEW_LEFT_PADDING, chooseFromThemeBtn.frame.size.height/2 - 32/2, 32, 32)];
    chooseFromThemeImageView.image = [UIImage imageNamed:@"icon_disk"];
    [chooseFromThemeBtn addSubview:chooseFromThemeImageView];
    
    chooseFromThemeLabel = [[UILabel alloc] initWithFrame:CGRectMake(chooseFromThemeImageView.frame.size.width +ISAUDIOPICKERPOPUPVIEW_LEFT_PADDING*2, 0, chooseFromThemeBtn.frame.size.width - chooseFromThemeImageView.frame.size.width - ISAUDIOPICKERPOPUPVIEW_LEFT_PADDING*2, chooseFromThemeBtn.frame.size.height)];
    chooseFromThemeLabel.backgroundColor = [UIColor clearColor];
    chooseFromThemeLabel.textColor = [UIColor grayColor];
    chooseFromThemeLabel.text = STRING_CHOOSE_MUSIC_FROM_THEME;
    [chooseFromThemeBtn addSubview:chooseFromThemeLabel];
    
    UIView *separateLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, chooseFromThemeBtn.frame.origin.y + chooseFromThemeBtn.frame.size.height, contentView.frame.size.width, 1)];
    separateLine2.backgroundColor = [UIColor grayColor];
    [contentView addSubview:separateLine2];
    
    chooseFromLibraryBtn = [GDColorButton buttonWithType:UIButtonTypeCustom];
    chooseFromLibraryBtn.tag = 1;
    chooseFromLibraryBtn.frame = CGRectMake(0, 113, contentView.frame.size.width, 50);
    [chooseFromLibraryBtn setNormalColor:[UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1]];
    [chooseFromLibraryBtn setHighlightedColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1]];
    [chooseFromLibraryBtn addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:chooseFromLibraryBtn];
    
    chooseFromLibraryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ISAUDIOPICKERPOPUPVIEW_LEFT_PADDING, chooseFromLibraryBtn.frame.size.height/2 - 32/2, 32, 32)];
    chooseFromLibraryImageView.image = [UIImage imageNamed:@"icon_music"];
    [chooseFromLibraryBtn addSubview:chooseFromLibraryImageView];
    
    chooseFromLibraryLabel = [[UILabel alloc] initWithFrame:CGRectMake(chooseFromLibraryImageView.frame.size.width +ISAUDIOPICKERPOPUPVIEW_LEFT_PADDING*2, 0, chooseFromLibraryBtn.frame.size.width - chooseFromLibraryImageView.frame.size.width - ISAUDIOPICKERPOPUPVIEW_LEFT_PADDING*2, chooseFromLibraryBtn.frame.size.height)];
    chooseFromLibraryLabel.backgroundColor = [UIColor clearColor];
    chooseFromLibraryLabel.textColor = [UIColor grayColor];
    chooseFromLibraryLabel.text = STRING_CHOOSE_MUSIC_FROM_LIBRARY;
    [chooseFromLibraryBtn addSubview:chooseFromLibraryLabel];
}

- (void)showOnView:(UIView *)view
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

- (void)actionButtonPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [_delegate audioPickerPopupView:self selectedAtIndex:btn.tag];
    [self hide];
}

@end
