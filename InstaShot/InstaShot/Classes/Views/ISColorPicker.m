//
//  ISColorPicker.m
//  InstaShot
//
//  Created by Liu Xiang on 10/28/14.
//  Copyright (c) 2014 Liu Xiang. All rights reserved.
//

#import "ISColorPicker.h"
#import "GDColorButton.h"

#define ISCOLORPICKER_ITEM_HEIGHT   40
#define ISCOLORPICKER_ITEM_WIDTH    15
#define ISCOLORPICKER_TOP_PADDING   10

@implementation ISColorPicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        confirmToolbar = [[ISConfirmToolbar alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 44, self.bounds.size.width, 44)];
        confirmToolbar.delegate = self;
        confirmToolbar.title = @"Background Color";
        confirmToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [self addSubview:confirmToolbar];
        
        colorArr = [[NSMutableArray alloc] init];
        [colorArr addObject:[ISHelper getColor:@"FFFFFF" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"BBBBBB" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"4E4E4E" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"212121" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"030303" withAlpha:1.0f]];
        
        [colorArr addObject:[ISHelper getColor:@"FFD4CB" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"FFA498" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"FD3D55" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"DB0036" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"DE0000" withAlpha:1.0f]];
        
        [colorArr addObject:[ISHelper getColor:@"FFF4C8" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"FEE868" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"FBAD4C" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"FF7120" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"FF0000" withAlpha:1.0f]];
        
        [colorArr addObject:[ISHelper getColor:@"FFF0F1" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"FFDEE3" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"FF97B6" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"FF3E9A" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"FF0070" withAlpha:1.0f]];
        
        [colorArr addObject:[ISHelper getColor:@"EBD2E7" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"DD9CD8" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"C850AF" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"B3008D" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"71008D" withAlpha:1.0f]];
        
        [colorArr addObject:[ISHelper getColor:@"8ED2FC" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"7CAAED" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"255BAC" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"1D1B8B" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"270084" withAlpha:1.0f]];
        
        [colorArr addObject:[ISHelper getColor:@"95EAF8" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"5BE6FF" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"00B3D3" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"008BC3" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"003F80" withAlpha:1.0f]];
        
        [colorArr addObject:[ISHelper getColor:@"DAF0E9" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"ACD3C6" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"03B59F" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"008E7E" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"006B4F" withAlpha:1.0f]];
        
        [colorArr addObject:[ISHelper getColor:@"CCEAA4" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"9ED586" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"9CB62F" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"648826" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"226631" withAlpha:1.0f]];
        
        [colorArr addObject:[ISHelper getColor:@"E5DABF" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"D7C58F" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"A78056" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"78422A" withAlpha:1.0f]];
        [colorArr addObject:[ISHelper getColor:@"403028" withAlpha:1.0f]];
        
        scrollView = [[ISScrollView alloc] initWithFrame:CGRectMake(0, ISCOLORPICKER_TOP_PADDING, frame.size.width, ISCOLORPICKER_ITEM_HEIGHT)];
        scrollView.bounces = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delaysContentTouches = NO;
        scrollView.contentSize = CGSizeMake(ISCOLORPICKER_ITEM_WIDTH*colorArr.count, ISCOLORPICKER_ITEM_HEIGHT);
        [self addSubview:scrollView];
        
        for (int i=0; i<colorArr.count; i++) {
            GDColorButton *colorBtn = [GDColorButton buttonWithType:UIButtonTypeCustom];
            colorBtn.tag = i;
            colorBtn.frame = CGRectMake(i*ISCOLORPICKER_ITEM_WIDTH, 0, ISCOLORPICKER_ITEM_WIDTH, ISCOLORPICKER_ITEM_HEIGHT);
            [colorBtn setNormalColor:[colorArr objectAtIndex:i]];
            [colorBtn setHighlightedColor:[UIColor whiteColor]];
            [colorBtn addTarget:self action:@selector(colorButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:colorBtn];
        }
    }
    return self;
}

- (void)colorButtonAction:(id)sender
{
    GDColorButton *btn = (GDColorButton *)sender;
    selectedColor = [colorArr objectAtIndex:btn.tag];
    [_delegate colorPicker:self selectedAtColor:selectedColor isFinishEditing:NO];
}

#pragma mark--
#pragma mark-- ISConfirmToolbar Delegate
- (void)confirmToolbar:(ISConfirmToolbar *)toolbar clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //cancel
        [_delegate colorPicker:self selectedAtColor:self.orgColor isFinishEditing:YES];
    }else{
        [_delegate colorPicker:self selectedAtColor:selectedColor isFinishEditing:YES];
    }
}

@end
