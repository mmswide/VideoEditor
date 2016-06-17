//
//  ISVideoManager.h
//  InstaShot
//
//  Created by Liu Xiang on 10/30/14.
//  Copyright (c) 2014 Liu Xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISVideo.h"

@interface ISVideoManager : NSObject

@property (strong, nonatomic) ISVideo *video;

+ (ISVideoManager *)sharedInstance;

- (VideoFitType)videoFitType;
- (VideoBorderType)videoBorderType;
- (VideoRotateType)videoRotateType;
- (VideoFlipType)videoFlipType;
- (UIColor *)videoBgColor;
- (float)videoStartTime;
- (float)videoEndTime;
- (float)videoVolume;
- (NSURL *)audioURL;
- (float)audioStartTime;
- (float)audioDuration;
- (float)audioVolume;
- (NSString *)audioFileName;

- (void)setVideoDuration:(float)duration;
- (void)setVideoFitType:(VideoFitType)fitType;
- (void)setVideoBorderType:(VideoBorderType)boardType;
- (void)setVideoRotateType:(VideoRotateType)rorateType;
- (void)setVideoFlipType:(VideoFlipType)flipType;
- (void)setVideoBgColor:(UIColor *)color;
- (void)setVideoStartTime:(float)startTime;
- (void)setVideoEndTime:(float)endTime;
- (void)setVideoVolume:(float)volume;
- (void)setAudioURL:(NSURL *)audioURL;
- (void)setAudioStartTime:(float)startTime;
- (void)setAudioDuration:(float)audioDuration;
- (void)setAudioVolume:(float)audioVolume;
- (void)setAudioFileName:(NSString *)audioFileName;

- (void)reset;

@end
