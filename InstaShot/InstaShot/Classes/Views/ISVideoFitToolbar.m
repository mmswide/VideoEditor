//
//  ISVideoFitToolbar.m
//  InstaShot
//
//  Created by Liu Xiang on 10/28/14.
//  Copyright (c) 2014 Liu Xiang. All rights reserved.
//

#import "ISVideoFitToolbar.h"

#define ISVIDEOFITTOOLBAR_LEFT_PADDING      10
#define ISVIDEOFITTOOLBAR_TOP_PADDING       10
#define ISVIDEOFITTOOLBAR_ITEM_PER_WIDTH    50
#define ISVIDEOFITTOOLBAR_BTN_WIDTH         32
#define ISVIDEOFITTOOLBAR_BTN_HEIGHT        ISVIDEOFITTOOLBAR_BTN_WIDTH
#define ISVIDEOFITTOOLBAR_LABEL_WIDTH       21

@implementation ISVideoFitToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        confirmToolbar = [[ISConfirmToolbar alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 44, self.bounds.size.width, 44)];
        confirmToolbar.delegate = self;
        confirmToolbar.title = @"Cut Video";
        confirmToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [self addSubview:confirmToolbar];
        
        UIButton *originalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        originalBtn.tag = VideoFitTypeOriginal;
        originalBtn.frame = CGRectMake((ISVIDEOFITTOOLBAR_ITEM_PER_WIDTH - ISVIDEOFITTOOLBAR_BTN_WIDTH)/2, ISVIDEOFITTOOLBAR_TOP_PADDING, ISVIDEOFITTOOLBAR_BTN_WIDTH, ISVIDEOFITTOOLBAR_BTN_HEIGHT);
        [originalBtn setImage:[UIImage imageNamed:@"icon_fitoriginal"] forState:UIControlStateNormal];
        [originalBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:originalBtn];
        
        UILabel *originalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ISVIDEOFITTOOLBAR_TOP_PADDING + ISVIDEOFITTOOLBAR_BTN_HEIGHT, ISVIDEOFITTOOLBAR_ITEM_PER_WIDTH, ISVIDEOFITTOOLBAR_LABEL_WIDTH)];
        originalLabel.backgroundColor = [UIColor clearColor];
        originalLabel.textColor = [UIColor whiteColor];
        originalLabel.font = [UIFont systemFontOfSize:10.0f];
        originalLabel.textAlignment = NSTextAlignmentCenter;
        originalLabel.text = @"Original";
        [self addSubview:originalLabel];
        
        UIButton *fitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        fitBtn.tag = VideoFitTypeFit;
        fitBtn.frame = CGRectMake(ISVIDEOFITTOOLBAR_LEFT_PADDING + ISVIDEOFITTOOLBAR_ITEM_PER_WIDTH + (ISVIDEOFITTOOLBAR_ITEM_PER_WIDTH - ISVIDEOFITTOOLBAR_BTN_WIDTH)/2, ISVIDEOFITTOOLBAR_TOP_PADDING, ISVIDEOFITTOOLBAR_BTN_WIDTH, ISVIDEOFITTOOLBAR_BTN_HEIGHT);
        [fitBtn setImage:[UIImage imageNamed:@"icon_fit"] forState:UIControlStateNormal];
        [fitBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:fitBtn];
        
        UILabel *fitLabel = [[UILabel alloc] initWithFrame:CGRectMake(ISVIDEOFITTOOLBAR_LEFT_PADDING + ISVIDEOFITTOOLBAR_ITEM_PER_WIDTH, ISVIDEOFITTOOLBAR_TOP_PADDING + ISVIDEOFITTOOLBAR_BTN_HEIGHT, ISVIDEOFITTOOLBAR_ITEM_PER_WIDTH, ISVIDEOFITTOOLBAR_LABEL_WIDTH)];
        fitLabel.backgroundColor = [UIColor clearColor];
        fitLabel.textColor = [UIColor whiteColor];
        fitLabel.font = [UIFont systemFontOfSize:10.0f];
        fitLabel.textAlignment = NSTextAlignmentCenter;
        fitLabel.text = @"Fit";
        [self addSubview:fitLabel];
        
        UIButton *fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        fullBtn.tag = VideoFitTypeFull;
        fullBtn.frame = CGRectMake(ISVIDEOFITTOOLBAR_LEFT_PADDING + ISVIDEOFITTOOLBAR_ITEM_PER_WIDTH*2 + (ISVIDEOFITTOOLBAR_ITEM_PER_WIDTH - ISVIDEOFITTOOLBAR_BTN_WIDTH)/2, ISVIDEOFITTOOLBAR_TOP_PADDING, ISVIDEOFITTOOLBAR_BTN_WIDTH, ISVIDEOFITTOOLBAR_BTN_HEIGHT);
        [fullBtn setImage:[UIImage imageNamed:@"icon_full"] forState:UIControlStateNormal];
        [fullBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:fullBtn];
        
        UILabel *fullLabel = [[UILabel alloc] initWithFrame:CGRectMake(ISVIDEOFITTOOLBAR_LEFT_PADDING + ISVIDEOFITTOOLBAR_ITEM_PER_WIDTH*2, ISVIDEOFITTOOLBAR_TOP_PADDING + ISVIDEOFITTOOLBAR_BTN_HEIGHT, ISVIDEOFITTOOLBAR_ITEM_PER_WIDTH, ISVIDEOFITTOOLBAR_LABEL_WIDTH)];
        fullLabel.backgroundColor = [UIColor clearColor];
        fullLabel.textColor = [UIColor whiteColor];
        fullLabel.font = [UIFont systemFontOfSize:10.0f];
        fullLabel.textAlignment = NSTextAlignmentCenter;
        fullLabel.text = @"Full";
        [self addSubview:fullLabel];
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.tag = VideoFitTypeLeft;
        leftBtn.frame = CGRectMake(ISVIDEOFITTOOLBAR_LEFT_PADDING + ISVIDEOFITTOOLBAR_ITEM_PER_WIDTH*3 + (ISVIDEOFITTOOLBAR_ITEM_PER_WIDTH - ISVIDEOFITTOOLBAR_BTN_WIDTH)/2, ISVIDEOFITTOOLBAR_TOP_PADDING, ISVIDEOFITTOOLBAR_BTN_WIDTH, ISVIDEOFITTOOLBAR_BTN_HEIGHT);
        [leftBtn setImage:[UIImage imageNamed:@"icon_fitleft"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftBtn];
        
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(ISVIDEOFITTOOLBAR_LEFT_PADDING + ISVIDEOFITTOOLBAR_ITEM_PER_WIDTH*3, ISVIDEOFITTOOLBAR_TOP_PADDING + ISVIDEOFITTOOLBAR_BTN_HEIGHT, ISVIDEOFITTOOLBAR_ITEM_PER_WIDTH, ISVIDEOFITTOOLBAR_LABEL_WIDTH)];
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.textColor = [UIColor whiteColor];
        leftLabel.font = [UIFont systemFontOfSize:10.0f];
        leftLabel.textAlignment = NSTextAlignmentCenter;
        leftLabel.text = @"Left";
        [self addSubview:leftLabel];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.tag = VideoFitTypeRight;
        rightBtn.frame = CGRectMake(ISVIDEOFITTOOLBAR_LEFT_PADDING + ISVIDEOFITTOOLBAR_ITEM_PER_WIDTH*4 + (ISVIDEOFITTOOLBAR_ITEM_PER_WIDTH - ISVIDEOFITTOOLBAR_BTN_WIDTH)/2, ISVIDEOFITTOOLBAR_TOP_PADDING, ISVIDEOFITTOOLBAR_BTN_WIDTH, ISVIDEOFITTOOLBAR_BTN_HEIGHT);
        [rightBtn setImage:[UIImage imageNamed:@"icon_fitright"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightBtn];
        
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(ISVIDEOFITTOOLBAR_LEFT_PADDING + ISVIDEOFITTOOLBAR_ITEM_PER_WIDTH*4, ISVIDEOFITTOOLBAR_TOP_PADDING + ISVIDEOFITTOOLBAR_BTN_HEIGHT, ISVIDEOFITTOOLBAR_ITEM_PER_WIDTH, ISVIDEOFITTOOLBAR_LABEL_WIDTH)];
        rightLabel.backgroundColor = [UIColor clearColor];
        rightLabel.textColor = [UIColor whiteColor];
        rightLabel.font = [UIFont systemFontOfSize:10.0f];
        rightLabel.textAlignment = NSTextAlignmentCenter;
        rightLabel.text = @"Right";
        [self addSubview:rightLabel];
        
        borderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        borderBtn.frame = CGRectMake(ISVIDEOFITTOOLBAR_LEFT_PADDING*2 + ISVIDEOFITTOOLBAR_ITEM_PER_WIDTH*5 + (ISVIDEOFITTOOLBAR_ITEM_PER_WIDTH - ISVIDEOFITTOOLBAR_BTN_WIDTH)/2, ISVIDEOFITTOOLBAR_TOP_PADDING, ISVIDEOFITTOOLBAR_BTN_WIDTH, ISVIDEOFITTOOLBAR_BTN_HEIGHT);
        [borderBtn setImage:[UIImage imageNamed:@"icon_border0"] forState:UIControlStateNormal];
        [borderBtn addTarget:self action:@selector(borderChooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:borderBtn];
        
        borderLabel = [[UILabel alloc] initWithFrame:CGRectMake(ISVIDEOFITTOOLBAR_LEFT_PADDING*2 + ISVIDEOFITTOOLBAR_ITEM_PER_WIDTH*5, ISVIDEOFITTOOLBAR_TOP_PADDING + ISVIDEOFITTOOLBAR_BTN_HEIGHT, ISVIDEOFITTOOLBAR_ITEM_PER_WIDTH, ISVIDEOFITTOOLBAR_LABEL_WIDTH)];
        borderLabel.backgroundColor = [UIColor clearColor];
        borderLabel.textColor = [UIColor whiteColor];
        borderLabel.font = [UIFont systemFontOfSize:10.0f];
        borderLabel.textAlignment = NSTextAlignmentCenter;
        borderLabel.text = @"Border";
        [self addSubview:borderLabel];
        
        UIView *seperateLineLeft = [[UIView alloc] initWithFrame:CGRectMake(ISVIDEOFITTOOLBAR_ITEM_PER_WIDTH + ISVIDEOFITTOOLBAR_LEFT_PADDING/2, ISVIDEOFITTOOLBAR_TOP_PADDING, 1, ISVIDEOFITTOOLBAR_BTN_HEIGHT + ISVIDEOFITTOOLBAR_LABEL_WIDTH - 5)];
        seperateLineLeft.backgroundColor = [UIColor grayColor];
        [self addSubview:seperateLineLeft];
        
        UIView *seperateLineRight = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width - ISVIDEOFITTOOLBAR_ITEM_PER_WIDTH - ISVIDEOFITTOOLBAR_LEFT_PADDING/2, ISVIDEOFITTOOLBAR_TOP_PADDING, 1, ISVIDEOFITTOOLBAR_BTN_HEIGHT + ISVIDEOFITTOOLBAR_LABEL_WIDTH - 5)];
        seperateLineRight.backgroundColor = [UIColor grayColor];
        [self addSubview:seperateLineRight];
    }
    return self;
}

- (void)setFitType:(VideoFitType)fitType
{
    _fitType = fitType;
}

- (void)setBorderType:(VideoBorderType)borderType
{
    _borderType = borderType;
    if (borderType == VideoBorderType1) {
        [borderBtn setImage:[UIImage imageNamed:@"icon_border1"] forState:UIControlStateNormal];
        borderLabel.text = @"Border 1/3";
    }else if (borderType == VideoBorderType2){
        [borderBtn setImage:[UIImage imageNamed:@"icon_border2"] forState:UIControlStateNormal];
        borderLabel.text = @"Border 2/3";
    }else if (borderType == VideoBorderType3){
        [borderBtn setImage:[UIImage imageNamed:@"icon_border3"] forState:UIControlStateNormal];
        borderLabel.text = @"Border 3/3";
    }else{
        [borderBtn setImage:[UIImage imageNamed:@"icon_border0"] forState:UIControlStateNormal];
        borderLabel.text = @"Border";
    }
}

- (void)setFitType:(VideoFitType)fitType andBorderType:(VideoBorderType)borderType
{
    self.fitType = fitType;
    self.borderType = borderType;
    orgFitType = fitType;
    orgBorderType = borderType;
}

- (void)borderChooseAction:(id)sender
{
    if (self.fitType == VideoFitTypeOriginal) return;
    if (self.borderType == VideoBorderType1) {
        [self setBorderType:VideoBorderType2];
        [_delegate videoFitToolbar:self reviewAtFitType:self.fitType andBorderType:VideoBorderType2 isFinishEditing:NO];
    }else if (self.borderType == VideoBorderType2){
        [self setBorderType:VideoBorderType3];
        [_delegate videoFitToolbar:self reviewAtFitType:self.fitType andBorderType:VideoBorderType3 isFinishEditing:NO];
    }else if (self.borderType == VideoBorderType3){
        [self setBorderType:VideoBorderTypeOriginal];
        [_delegate videoFitToolbar:self reviewAtFitType:self.fitType andBorderType:VideoBorderTypeOriginal isFinishEditing:NO];
    }else{
        [self setBorderType:VideoBorderType1];
        [_delegate videoFitToolbar:self reviewAtFitType:self.fitType andBorderType:VideoBorderType1 isFinishEditing:NO];
    }
}

- (void)buttonAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    self.fitType = (VideoFitType)btn.tag;
    [_delegate videoFitToolbar:self reviewAtFitType:self.fitType andBorderType:self.borderType isFinishEditing:NO];
}

#pragma mark--
#pragma mark-- ISConfirmToolbar Delegate
- (void)confirmToolbar:(ISConfirmToolbar *)toolbar clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //cancel
        [_delegate videoFitToolbar:self reviewAtFitType:orgFitType andBorderType:orgBorderType isFinishEditing:YES];
    }else{
        [_delegate videoFitToolbar:self reviewAtFitType:self.fitType andBorderType:self.borderType isFinishEditing:YES];
    }
}

@end
