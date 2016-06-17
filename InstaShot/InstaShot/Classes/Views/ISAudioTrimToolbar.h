//
//  ISAudioTrimToolbar.h
//  InstaShot
//
//  Created by Liu Xiang on 11/28/14.
//  Copyright (c) 2014 Liu Xiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISConfirmToolbar.h"

@protocol ISAudioTrimToolbarDelegate;

@interface ISAudioTrimToolbar : UIView <ISConfirmToolbarDelegate,UIActionSheetDelegate>
{
    ISConfirmToolbar *confirmToolbar;
    UILabel *startTimeLabel;
    UILabel *musicNameLabel;
    UISlider *startTimeSlider;
    UIButton *menuBtn;
    float lastStartTime;
}

@property (nonatomic, assign) float duraction;
@property (nonatomic, assign) float startTime;
@property (nonatomic, unsafe_unretained) id<ISAudioTrimToolbarDelegate> delegate;

- (void)setStartTime:(float)startTime andMaxTime:(float)maxTime andMusicName:(NSString *)musicName;

@end

@protocol ISAudioTrimToolbarDelegate <NSObject>
@optional
- (void)audioTrimToolbar:(ISAudioTrimToolbar *)toolbar previewStartTimeDidSelectedAt:(float)startTime;
- (void)audioTrimToolbar:(ISAudioTrimToolbar *)toolbar isChangesCancelled:(BOOL)isCancelled;
- (void)deleteMusic:(ISAudioTrimToolbar *)toolbar;
- (void)reselectMusic:(ISAudioTrimToolbar *)toolbar;
- (void)editVolume:(ISAudioTrimToolbar *)toolbar;

@end
