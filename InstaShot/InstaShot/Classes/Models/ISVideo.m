//
//  ISVideo.m
//  InstaShot
//
//  Created by Liu Xiang on 10/30/14.
//  Copyright (c) 2014 Liu Xiang. All rights reserved.
//

#import "ISVideo.h"

@implementation ISVideo

- (id)init
{
    self = [super init];
    if (self) {
        self.bgColor = [UIColor whiteColor];
        self.fitType = VideoFitTypeFit;
        self.borderType = VideoBorderTypeOriginal;
        self.rotateType = VideoRotateTypeOriginal;
        self.flipType = VideoFlipTypeOriginal;
        self.startTime = 0;
        self.endTime = 0;
        self.volume = 1;
        self.audioStartTime = 0;
        self.audioVolume = 1;
    }
    return self;
}

@end
