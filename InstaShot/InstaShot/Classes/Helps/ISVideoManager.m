//
//  ISVideoManager.m
//  InstaShot
//
//  Created by Liu Xiang on 10/30/14.
//  Copyright (c) 2014 Liu Xiang. All rights reserved.
//

#import "ISVideoManager.h"

@interface ISVideoManager ()

@end

@implementation ISVideoManager

+ (ISVideoManager *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (ISVideoManager *)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setVideo:(ISVideo *)video
{
    _video = video;
}

- (VideoFitType)videoFitType
{
    return self.video.fitType;
}

- (VideoBorderType)videoBorderType
{
    return self.video.borderType;
}

- (VideoRotateType)videoRotateType
{
    return self.video.rotateType;
}

- (VideoFlipType)videoFlipType
{
    return self.video.flipType;
}

- (UIColor *)videoBgColor
{
    return self.video.bgColor;
}

- (float)videoStartTime
{
    return self.video.startTime;
}

- (float)videoEndTime
{
    return self.video.endTime;
}

- (NSURL *)audioURL
{
    return self.video.audioURL;
}

- (float)audioStartTime
{
    return self.video.audioStartTime;
}

- (float)audioDuration
{
    return self.video.audioDuration;
}

- (float)videoVolume
{
    return self.video.volume;
}

- (float)audioVolume
{
    return self.video.audioVolume;
}

- (NSString *)audioFileName
{
    return self.video.audioFileName;
}

- (void)setVideoDuration:(float)duration
{
    self.video.duration = duration;
}

- (void)setVideoFitType:(VideoFitType)fitType
{
    self.video.fitType = fitType;
}

- (void)setVideoBorderType:(VideoBorderType)boardType
{
    self.video.borderType = boardType;
}
- (void)setVideoRotateType:(VideoRotateType)rorateType
{
    self.video.rotateType = rorateType;
}

- (void)setVideoFlipType:(VideoFlipType)flipType
{
    self.video.flipType = flipType;
}

- (void)setVideoBgColor:(UIColor *)color
{
    self.video.bgColor = color;
}

- (void)setVideoStartTime:(float)startTime
{
    self.video.startTime = startTime;
}

- (void)setVideoEndTime:(float)endTime
{
    self.video.endTime = endTime;
}

- (void)setAudioURL:(NSURL *)audioURL
{
    self.video.audioURL = audioURL;
}

- (void)setAudioStartTime:(float)startTime
{
    self.video.audioStartTime = startTime;
}

- (void)setAudioDuration:(float)audioDuration
{
    self.video.audioDuration = audioDuration;
}

- (void)setVideoVolume:(float)volume
{
    self.video.volume = volume;
}

- (void)setAudioVolume:(float)audioVolume
{
    self.video.audioVolume = audioVolume;
}

- (void)setAudioFileName:(NSString *)audioFileName
{
    self.video.audioFileName = audioFileName;
}

- (void)reset
{
    self.video.fitType = VideoFitTypeOriginal;
    self.video.borderType = VideoBorderTypeOriginal;
    self.video.rotateType = VideoRotateTypeOriginal;
    self.video.flipType = VideoFlipTypeOriginal;
    self.video.bgColor = [UIColor clearColor];
    self.video.startTime = 0.f;
    self.video.endTime = self.video.duration;
}

@end
