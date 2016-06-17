//
//  ISVideo.h
//  InstaShot
//
//  Created by Liu Xiang on 10/30/14.
//  Copyright (c) 2014 Liu Xiang. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    VideoFitTypeFit = 0,
    VideoFitTypeOriginal = 1,
    VideoFitTypeFull = 2,
    VideoFitTypeLeft = 3,
    VideoFitTypeRight = 4,
};
typedef UInt32 VideoFitType;

enum {
    VideoBorderTypeOriginal = 0,
    VideoBorderType1 = 1,
    VideoBorderType2 = 2,
    VideoBorderType3 = 3,
};
typedef UInt32 VideoBorderType;

enum {
    VideoRotateTypeOriginal = 0,
    VideoRotateTypeRotate90 = 1,
    VideoRotateTypeRotate180 = 2,
    VideoRotateTypeRotate270 = 3,
};
typedef UInt32 VideoRotateType;

enum {
    VideoFlipTypeOriginal = 0,
    VideoFlipTypeFlip = 1,
};
typedef UInt32 VideoFlipType;

@interface ISVideo : NSObject

@property (strong, nonatomic) NSURL *videoURL;
@property (assign, nonatomic) float duration;
@property (strong, nonatomic) UIColor *bgColor;
@property (assign, nonatomic) VideoFitType fitType;
@property (assign, nonatomic) VideoBorderType borderType;
@property (assign, nonatomic) VideoRotateType rotateType;
@property (assign, nonatomic) VideoFlipType flipType;
@property (assign, nonatomic) float startTime;
@property (assign, nonatomic) float endTime;
@property (assign, nonatomic) float volume;

@property (strong, nonatomic) NSURL *audioURL;
@property (strong, nonatomic) NSString *audioFileName;
@property (assign, nonatomic) float audioStartTime;
@property (assign, nonatomic) float audioDuration;
@property (assign, nonatomic) float audioVolume;

@end
