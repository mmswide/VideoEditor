//
//  ISAudio.h
//  InstaShot
//
//  Created by Liu Xiang on 11/28/14.
//  Copyright (c) 2014 Liu Xiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISAudio : NSObject

@property (strong, nonatomic) NSURL *audioURL;
@property (strong, nonatomic) NSString *fileName;
@property (assign, nonatomic) float duration;
@property (assign, nonatomic) float startTime;

@end
