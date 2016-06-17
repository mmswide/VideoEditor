//
//  ISConfirmToolbar.m
//  InstaShot
//
//  Created by Liu Xiang on 10/28/14.
//  Copyright (c) 2014 Liu Xiang. All rights reserved.
//

#import "ISConfirmToolbar.h"

#define ISCONFIRMTOOLBAR_CANCEL_BTN_WIDTH       32
#define ISCONFIRMTOOLBAR_CANCEL_BTN_HEIGHT      ISCONFIRMTOOLBAR_CANCEL_BTN_WIDTH

@implementation ISConfirmToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(10, (frame.size.height-ISCONFIRMTOOLBAR_CANCEL_BTN_HEIGHT)/2, ISCONFIRMTOOLBAR_CANCEL_BTN_WIDTH, ISCONFIRMTOOLBAR_CANCEL_BTN_HEIGHT);
        [cancelBtn setImage:[UIImage imageNamed:@"icon_cancel"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame = CGRectMake(frame.size.width - 10 - ISCONFIRMTOOLBAR_CANCEL_BTN_WIDTH, (frame.size.height-ISCONFIRMTOOLBAR_CANCEL_BTN_HEIGHT)/2, ISCONFIRMTOOLBAR_CANCEL_BTN_WIDTH, ISCONFIRMTOOLBAR_CANCEL_BTN_HEIGHT);
        [confirmBtn setImage:[UIImage imageNamed:@"icon_apply"] forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirmBtn];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    titleLabel.text = title;
}

- (void)cancelBtnPressed:(id)sender
{
    [_delegate confirmToolbar:self clickedButtonAtIndex:0];
}

- (void)confirmBtnPressed:(id)sender
{
    [_delegate confirmToolbar:self clickedButtonAtIndex:1];
}

@end
