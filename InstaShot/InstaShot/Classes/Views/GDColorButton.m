//
//  GDColorButton.m
//  Goddess
//
//  Created by Liu Xiang on 4/24/14.
//  Copyright (c) 2014 mokun. All rights reserved.
//

#import "GDColorButton.h"

@interface GDColorButton ()

@property(nonatomic, strong, readwrite) UIColor *normalColor;
@property(nonatomic, strong, readwrite) UIColor *highlightedColor;

@end

//*****************************************************************************
// public interface implementation
//*****************************************************************************

@implementation GDColorButton


#pragma mark Settings

- (void)setNormalColor:(UIColor *)normalColor {
    [self setBackgroundColor:normalColor];
    _normalColor = normalColor;
}

- (void)setHighlightedColor:(UIColor *)highlightedColor {
    _highlightedColor = highlightedColor;
}

#pragma mark Actions

- (void)didTapButtonForHighlight:(UIButton *)sender {
    [self setBackgroundColor:_highlightedColor];
}

- (void)didUnTapButtonForHighlight:(UIButton *)sender {
    [self setBackgroundColor:_normalColor];
}

#pragma mark Initialization

- (void)setupButton {
    [self addTarget:self action:@selector(didTapButtonForHighlight:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(didUnTapButtonForHighlight:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(didUnTapButtonForHighlight:) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(didUnTapButtonForHighlight:) forControlEvents:UIControlEventTouchCancel];
}

- (id)init {
    self = [super init];
    if (self) {
        [self setupButton];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupButton];
    }
    return self;
}


@end
