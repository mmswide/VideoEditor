//
//  ISCommand.h
//  InstaShot
//
//  Created by Liu Xiang on 10/23/14.
//  Copyright (c) 2014 Liu Xiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

extern NSString* const ISEditCommandCompletionNotification;
extern NSString* const ISExportCommandCompletionNotification;

@interface ISCommand : NSObject

@property AVMutableComposition *mutableComposition;
@property AVMutableVideoComposition *mutableVideoComposition;
@property AVMutableAudioMix *mutableAudioMix;
@property CALayer *watermarkLayer;

- (id)initWithComposition:(AVMutableComposition*)composition videoComposition:(AVMutableVideoComposition*)videoComposition audioMix:(AVMutableAudioMix*)audioMix;
- (void)performWithAsset:(AVAsset*)asset;
@end
