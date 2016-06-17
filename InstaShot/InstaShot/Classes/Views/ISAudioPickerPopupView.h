//
//  ISAudioPickerPopupView.h
//  InstaShot
//
//  Created by Liu Xiang on 11/28/14.
//  Copyright (c) 2014 Liu Xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ISAudioPickerPopupViewDelegate;

@interface ISAudioPickerPopupView : UIView

@property (nonatomic, unsafe_unretained) id<ISAudioPickerPopupViewDelegate> delegate;

- (void)showOnView:(UIView *)view;

@end

@protocol ISAudioPickerPopupViewDelegate <NSObject>
@optional
- (void)audioPickerPopupView:(ISAudioPickerPopupView *)pickerPopupView selectedAtIndex:(NSInteger)index;
@end