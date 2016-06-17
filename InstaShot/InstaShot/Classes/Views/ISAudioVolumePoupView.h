//
//  ISAudioVolumePoupView.h
//  InstaShot
//
//  Created by Liu Xiang on 9/16/14.
//  Copyright (c) 2014 mokun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ISAudioVolumePoupViewDelegate;

@interface ISAudioVolumePoupView : UIView

- (id)initWithVideoVolume:(float)currentVideoVolume
              musicVolume:(float)currentMusicVolume
                 delegate:(id)delegate;

- (void)showAtView:(UIView *)view;

@end

@protocol ISAudioVolumePoupViewDelegate <NSObject>
@optional
- (void)volumePopupView:(ISAudioVolumePoupView *)volumePopupView
   videoVolumeChangedTo:(float)videoVolume
   musicVolumeChangedTo:(float)musicVolume;
@end