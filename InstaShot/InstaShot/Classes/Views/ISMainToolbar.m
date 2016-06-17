//
//  ISMainToolbar.m
//  InstaShot
//
//  Created by Liu Xiang on 10/28/14.
//  Copyright (c) 2014 Liu Xiang. All rights reserved.
//

#import "ISMainToolbar.h"

@implementation ISMainToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cutBtn.tag = 0;
        _cutBtn.showsTouchWhenHighlighted = YES;
        _cutBtn.frame = CGRectMake(10+8, 6, 32, 32);
        [_cutBtn setImage:[UIImage imageNamed:@"icon_trim"] forState:UIControlStateNormal];
        [_cutBtn addTarget:self action:@selector(activeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cutBtn];
        
        _fitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fitBtn.tag = 1;
        _fitBtn.showsTouchWhenHighlighted = YES;
        _fitBtn.frame = CGRectMake(10+50+8, 6, 32, 32);
        [_fitBtn setImage:[UIImage imageNamed:@"icon_fitb"] forState:UIControlStateNormal];
        [_fitBtn addTarget:self action:@selector(activeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_fitBtn];
        
        _musicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _musicBtn.tag = 2;
        _musicBtn.showsTouchWhenHighlighted = YES;
        _musicBtn.frame = CGRectMake(10+100+8, 6, 32, 32);
        [_musicBtn setImage:[UIImage imageNamed:@"icon_music"] forState:UIControlStateNormal];
        [_musicBtn addTarget:self action:@selector(activeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_musicBtn];
        
        _changeBgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeBgBtn.tag = 3;
        _changeBgBtn.showsTouchWhenHighlighted = YES;
        _changeBgBtn.frame = CGRectMake(10+150+8, 6, 32, 32);
        [_changeBgBtn setImage:[UIImage imageNamed:@"icon_color"] forState:UIControlStateNormal];
        [_changeBgBtn addTarget:self action:@selector(activeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_changeBgBtn];
        
        _rotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rotateBtn.tag = 4;
        _rotateBtn.showsTouchWhenHighlighted = YES;
        _rotateBtn.frame = CGRectMake(10+200+8, 6, 32, 32);
        [_rotateBtn setImage:[UIImage imageNamed:@"icon_rotate"] forState:UIControlStateNormal];
        [_rotateBtn addTarget:self action:@selector(activeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rotateBtn];
        
        _flipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _flipBtn.tag = 5;
        _flipBtn.showsTouchWhenHighlighted = YES;
        _flipBtn.frame = CGRectMake(10+250+8, 6, 32, 32);
        [_flipBtn setImage:[UIImage imageNamed:@"icon_flip"] forState:UIControlStateNormal];
        [_flipBtn addTarget:self action:@selector(activeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_flipBtn];
    }
    return self;
}

- (void)activeAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [_delegate mainToolbar:self clickedButtonAtIndex:btn.tag];
}

@end
