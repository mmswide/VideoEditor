//
//  GDColorButton.h
//  Goddess
//
//  Created by Liu Xiang on 4/24/14.
//  Copyright (c) 2014 mokun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDColorButton : UIButton

@property (nonatomic, strong, readonly) UIColor *normalColor;
@property (nonatomic, strong, readonly) UIColor *highlightedColor;

- (void)setNormalColor:(UIColor *)normalColor;
- (void)setHighlightedColor:(UIColor *)highlightedColor;

@end