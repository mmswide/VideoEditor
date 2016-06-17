//
//  ISVideoEditViewController.h
//  InstaShot
//
//  Created by Liu Xiang on 11/24/14.
//  Copyright (c) 2014 Liu Xiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISVideoPlaybackView.h"
#import <AVFoundation/AVFoundation.h>
#import "ISAudio.h"

@interface ISVideoEditViewController : UIViewController
{
@private
    IBOutlet UIView *mPlayView;
    IBOutlet UIView *mPlayBorderView;
    IBOutlet ISVideoPlaybackView *mPlaybackView;
    IBOutlet UIProgressView *mScrubber;
    IBOutlet UIButton *mPlayButton;
    IBOutlet UIButton *mRestartButton;
    
    float mRestoreAfterScrubbingRate;
    BOOL seekToZeroBeforePlay;
    id mTimeObserver;
    
    NSURL* mURL;
    
    AVPlayer* mPlayer;
    AVPlayerItem * mPlayerItem;
}

@property (nonatomic, copy) NSURL* URL;
@property (readwrite, strong, setter=setPlayer:, getter=player) AVPlayer* mPlayer;
@property (strong) AVPlayerItem* mPlayerItem;
@property (nonatomic, strong) IBOutlet UIView *mPlayView;
@property (nonatomic, strong) IBOutlet UIView *mPlayBorderView;
@property (nonatomic, strong) IBOutlet ISVideoPlaybackView *mPlaybackView;
@property (nonatomic, strong) IBOutlet UIButton *mPlayButton;
@property (nonatomic, strong) IBOutlet UIButton *mRestartButton;
@property (nonatomic, strong) IBOutlet UIProgressView* mScrubber;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) ISAudio *audio;

@property AVMutableComposition *composition;
@property AVMutableVideoComposition *videoComposition;
@property AVMutableAudioMix *audioMix;

@end
