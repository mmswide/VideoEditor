//
//  ISVideoPlaybackView.h
//  InstaShot
//
//  Created by Liu Xiang on 11/24/14.
//  Copyright (c) 2014 Liu Xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVPlayer;

@interface ISVideoPlaybackView : UIView

@property (nonatomic, strong) AVPlayer* player;

- (void)setPlayer:(AVPlayer*)player;
- (void)setVideoFillMode:(NSString *)fillMode;
- (CGRect)videoRect;

@end
