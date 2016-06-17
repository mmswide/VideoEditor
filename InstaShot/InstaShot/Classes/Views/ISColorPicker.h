//
//  ISColorPicker.h
//  InstaShot
//
//  Created by Liu Xiang on 10/28/14.
//  Copyright (c) 2014 Liu Xiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISScrollView.h"
#import "ISConfirmToolbar.h"

@protocol ISColorPickerDelegate;

@interface ISColorPicker : UIView <ISConfirmToolbarDelegate>
{
    ISConfirmToolbar *confirmToolbar;
    ISScrollView *scrollView;
    NSMutableArray *colorArr;
    UIColor *selectedColor;
}

@property (nonatomic, unsafe_unretained) id<ISColorPickerDelegate> delegate;
@property (nonatomic, strong) UIColor *orgColor;

@end

@protocol ISColorPickerDelegate <NSObject>
@optional
- (void)colorPicker:(ISColorPicker *)colorPicker selectedAtColor:(UIColor *)color isFinishEditing:(BOOL)isFinishEditing;
@end
