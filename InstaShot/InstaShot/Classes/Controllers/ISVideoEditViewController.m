//
//  ISVideoEditViewController.h
//  InstaShot
//
//  Created by Liu Xiang on 11/24/14.
//  Copyright (c) 2014 Liu Xiang. All rights reserved.
//

#import "ISVideoEditViewController.h"
#import "ISMainToolbar.h"
#import "ISVideoFitToolbar.h"
#import "ISVideoTrimToolbar.h"
#import "ISAudioTrimToolbar.h"
#import "ISColorPicker.h"
#import "ISAudioVolumePoupView.h"
#import "ISAudioPickerPopupView.h"
#import <MediaPlayer/MediaPlayer.h>

#define ISVIDEO_PLAYBACK_VIEW_BORDER_WIDTH_PER   10

typedef void (^ShowEditModeFinishResponseBlock)(BOOL success);

@interface ISVideoEditViewController ()<UIGestureRecognizerDelegate,ISMainToolbarDelegate,ISVideoTrimToolbarDelegate,ISColorPickerDelegate,ISVideoFitToolbarDelegate,ISAudioVolumePoupViewDelegate,ISAudioPickerPopupViewDelegate,ISAudioTrimToolbarDelegate,MPMediaPickerControllerDelegate>
{
    UIPanGestureRecognizer *panGestureRecognizer;
    UITapGestureRecognizer *tapGestureRecognizer;
    ISMainToolbar *mainToolbar;
    ISVideoFitToolbar *videoFitToolbar;
    ISVideoTrimToolbar *videoTrimToolbar;
    ISAudioTrimToolbar *audioTrimToolbar;
    ISColorPicker *videoColorPicker;
    AVURLAsset *movieAsset;
}
- (void)play;
- (void)restart;
- (void)initScrubberTimer;
- (void)syncScrubber;
- (void)syncPlayPauseButtons;
- (void)setURL:(NSURL*)URL;
- (NSURL*)URL;
@end

@interface ISVideoEditViewController (Player)
- (void)removePlayerTimeObserver;
- (CMTime)playerItemDuration;
- (BOOL)isPlaying;
- (float)duration;
- (float)currentTime;
- (void)playerItemDidReachEnd:(NSNotification *)notification ;
- (void)observeValueForKeyPath:(NSString*) path ofObject:(id)object change:(NSDictionary*)change context:(void*)context;
- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys;
@end

static void *AVPlayerDemoPlaybackViewControllerRateObservationContext = &AVPlayerDemoPlaybackViewControllerRateObservationContext;
static void *AVPlayerDemoPlaybackViewControllerStatusObservationContext = &AVPlayerDemoPlaybackViewControllerStatusObservationContext;
static void *AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext = &AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext;

#pragma mark -
@implementation ISVideoEditViewController

@synthesize mPlayView, mPlayBorderView, mPlaybackView, mPlayer, mPlayerItem, mPlayButton, mRestartButton, mScrubber;

#pragma mark
#pragma mark View Controller
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        [self setPlayer:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    CGRect titleBarBtnFrame = CGRectMake(0, 0, 32, 32);
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = titleBarBtnFrame;
    [saveBtn setImage:[UIImage imageNamed:@"icon_save"] forState:UIControlStateNormal];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = titleBarBtnFrame;
    [shareBtn setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    
    UIButton *instagramBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    instagramBtn.frame = titleBarBtnFrame;
    [instagramBtn setImage:[UIImage imageNamed:@"icon_share_instagram"] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithCustomView:instagramBtn],[[UIBarButtonItem alloc] initWithCustomView:shareBtn],[[UIBarButtonItem alloc] initWithCustomView:saveBtn], nil];
    
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                   action:@selector(handlePan:)];
    panGestureRecognizer.delegate = self;
    
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                   action:@selector(handleTap:)];
    tapGestureRecognizer.delegate = self;
    [self.mPlaybackView addGestureRecognizer:panGestureRecognizer];
    [self.mPlaybackView addGestureRecognizer:tapGestureRecognizer];
    [panGestureRecognizer setEnabled:NO];
    
    mainToolbar = [[ISMainToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height -44, self.view.bounds.size.width, 44)];
    mainToolbar.delegate = self;
    mainToolbar.backgroundColor = [UIColor clearColor];
    mainToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:mainToolbar];
    
    [self setPlayer:nil];
    [self initScrubberTimer];
    [self syncPlayPauseButtons];
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.mPlayView setBackgroundColor:[[ISVideoManager sharedInstance] videoBgColor]];
    if (self.mPlayerItem != nil) {
        [self.mPlayerItem addObserver:self
                           forKeyPath:@"status"
                              options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                              context:AVPlayerDemoPlaybackViewControllerStatusObservationContext];
    }
    if (self.mPlayer != nil) {
        [self.player addObserver:self
                      forKeyPath:@"rate"
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:AVPlayerDemoPlaybackViewControllerRateObservationContext];
    }
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self pause];
    [self removePlayerTimeObserver];
    [self.mPlayer removeObserver:self forKeyPath:@"rate"];
    [self.mPlayer.currentItem removeObserver:self forKeyPath:@"status"];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    self.mPlaybackView = nil;
    self.mPlayButton = nil;
    self.mRestartButton = nil;
    self.mScrubber = nil;
    
    [super viewDidUnload];
}

#pragma mark Asset URL
- (void)setAudio:(ISAudio *)audio
{
    self.audioPlayer = nil;
    NSError *error = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audio.audioURL error:&error];
    [self.audioPlayer setNumberOfLoops:-1];
    audio.duration = [self.audioPlayer duration];
    _audio = audio;
}

- (void)setURL:(NSURL*)URL
{
    if (mURL != URL)
    {
        mURL = [URL copy];
        
        /*
         Create an asset for inspection of a resource referenced by a given URL.
         Load the values for the asset key "playable".
         */
        movieAsset = [AVURLAsset URLAssetWithURL:mURL options:nil];
        
        NSArray *requestedKeys = @[@"playable"];
        
        /* Tells the asset to load the values of any of the specified keys that are not already loaded. */
        [movieAsset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:
         ^{
             dispatch_async( dispatch_get_main_queue(),
                            ^{
                                /* IMPORTANT: Must dispatch to main queue in order to operate on the AVPlayer and AVPlayerItem. */
                                [self prepareToPlayAsset:movieAsset withKeys:requestedKeys];
                            });
         }];
    }
}

- (NSURL*)URL
{
    return mURL;
}

#pragma mark
#pragma mark Button Action Methods
- (IBAction)playToggle:(id)sender
{
    [self play];
}

- (IBAction)restartToggle:(id)sender
{
    [self restart];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:self.view];
}

- (void)handleTap:(UIPanGestureRecognizer *)recognizer
{
    if (![self isPlaying]) {
        [self play];
    } else {
        [self pause];
    }
}

- (void)play
{
    [self.mScrubber setHidden:NO];
    if (YES == seekToZeroBeforePlay)
    {
        seekToZeroBeforePlay = NO;
        [self.mPlayer seekToTime:CMTimeMakeWithSeconds([[ISVideoManager sharedInstance] videoStartTime], 3) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        [self.audioPlayer setCurrentTime:self.audio.startTime];
    }
    [self.mPlayer play];
    [self.audioPlayer play];
    [self syncPlayPauseButtons];
}

- (void)pause
{
    [self.mPlayer pause];
    [self.audioPlayer pause];
    [self syncPlayPauseButtons];
}

- (void)restart
{
    [self.mScrubber setHidden:NO];
    [self.mPlayer seekToTime:CMTimeMakeWithSeconds([[ISVideoManager sharedInstance] videoStartTime], 3) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.mPlayer play];
    [self.audioPlayer setCurrentTime:self.audio.startTime];
    [self.audioPlayer play];
    [self syncPlayPauseButtons];
}

- (void)syncPlayPauseButtons
{
    if ([self isPlaying])
    {
        [self.mPlayButton setHidden:YES];
        [self.mRestartButton setHidden:YES];
    }
    else
    {
        if (YES == seekToZeroBeforePlay) {
            [self.mRestartButton setHidden:YES];
        }else{
            [self.mRestartButton setHidden:NO];
        }
        [self.mPlayButton setHidden:NO];
    }
}

- (void)updateVideoLayoutByFitAndBorderType:(VideoFitType)fitType andBorderType:(VideoBorderType)borderType andBackgroundColor:(UIColor *)color
{
    CGPoint borderViewCenter = self.mPlayBorderView.center;
    self.mPlayBorderView.frame = CGRectMake(0, 0, self.mPlayView.frame.size.width - ISVIDEO_PLAYBACK_VIEW_BORDER_WIDTH_PER*borderType*2, self.mPlayView.frame.size.height - ISVIDEO_PLAYBACK_VIEW_BORDER_WIDTH_PER*borderType*2);
    self.mPlayBorderView.center = borderViewCenter;
    
    switch (fitType) {
        case VideoFitTypeOriginal:
        {
            [self.mPlaybackView setVideoFillMode:AVLayerVideoGravityResizeAspect];
            self.mPlayView.backgroundColor = [UIColor clearColor];
            self.mPlayBorderView.frame = CGRectMake(0, 0, self.mPlayView.frame.size.width, self.mPlayView.frame.size.height);
            self.mPlaybackView.frame = CGRectMake(0, 0, self.mPlayBorderView.frame.size.width, self.mPlayBorderView.frame.size.height);
            break;
        }
        case VideoFitTypeFit:
        {
            [self.mPlaybackView setVideoFillMode:AVLayerVideoGravityResizeAspect];
            self.mPlayView.backgroundColor = color;
            self.mPlaybackView.frame = CGRectMake(0, 0, self.mPlayBorderView.frame.size.width, self.mPlayBorderView.frame.size.height);
            break;
        }
        case VideoFitTypeFull:
        {
            [self.mPlaybackView setVideoFillMode:AVLayerVideoGravityResizeAspectFill];
            self.mPlayView.backgroundColor = color;
            self.mPlaybackView.frame = CGRectMake(0, 0, self.mPlayBorderView.frame.size.width, self.mPlayBorderView.frame.size.height);
            break;
        }
        case VideoFitTypeLeft:
        {
            [self.mPlaybackView setVideoFillMode:AVLayerVideoGravityResizeAspect];
            self.mPlayView.backgroundColor = color;
            CGRect rect = [self.mPlaybackView videoRect];
            if ([[ISVideoManager sharedInstance] videoRotateType] == VideoRotateTypeOriginal || [[ISVideoManager sharedInstance] videoRotateType] == VideoRotateTypeRotate180) {
                self.mPlaybackView.frame = CGRectMake(-(self.mPlaybackView.frame.size.width - rect.size.width)/2, 0, self.mPlaybackView.frame.size.width, self.mPlaybackView.frame.size.height);
            }else{
                self.mPlaybackView.frame = CGRectMake(-(self.mPlaybackView.frame.size.width - rect.size.height)/2, 0, self.mPlaybackView.frame.size.width, self.mPlaybackView.frame.size.height);
            }
            break;
        }
        case VideoFitTypeRight:
        {
            [self.mPlaybackView setVideoFillMode:AVLayerVideoGravityResizeAspect];
            self.mPlayView.backgroundColor = color;
            CGRect rect = [self.mPlaybackView videoRect];
            if ([[ISVideoManager sharedInstance] videoRotateType] == VideoRotateTypeOriginal || [[ISVideoManager sharedInstance] videoRotateType] == VideoRotateTypeRotate180) {
                self.mPlaybackView.frame = CGRectMake((self.mPlaybackView.frame.size.width - rect.size.width)/2, 0, self.mPlaybackView.frame.size.width, self.mPlaybackView.frame.size.height);
            }else{
                self.mPlaybackView.frame = CGRectMake((self.mPlaybackView.frame.size.width - rect.size.height)/2, 0, self.mPlaybackView.frame.size.width, self.mPlaybackView.frame.size.height);
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark Movie scrubber control

/* ---------------------------------------------------------
 **  Methods to handle manipulation of the movie scrubber control
 ** ------------------------------------------------------- */

/* Requests invocation of a given block during media playback to update the movie scrubber control. */
-(void)initScrubberTimer
{
    double interval = .1f;
    
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))
    {
        return;
    }
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration))
    {
        CGFloat width = CGRectGetWidth([self.mScrubber bounds]);
        interval = 0.5f * duration / width;
    }
    
    /* Update the scrubber during normal playback. */
    __weak ISVideoEditViewController *weakSelf = self;
    mTimeObserver = [self.mPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)
                                                               queue:NULL /* If you pass NULL, the main queue is used. */
                                                          usingBlock:^(CMTime time)
                     {
                         [weakSelf syncScrubber];
                     }];
}

/* Set the scrubber based on the player current time. */
- (void)syncScrubber
{
    CGFloat currentSecond = (float)self.mPlayerItem.currentTime.value/(float)self.mPlayerItem.currentTime.timescale;
    if (currentSecond >= [[ISVideoManager sharedInstance] videoEndTime]) {
        [self pause];
        seekToZeroBeforePlay = YES;
    }
    [self.mScrubber setProgress:(currentSecond - [[ISVideoManager sharedInstance] videoStartTime])/([[ISVideoManager sharedInstance] videoEndTime] - [[ISVideoManager sharedInstance] videoStartTime]) animated:NO];
}

#pragma mark--
#pragma mark-- Animation Implementation
- (void)showSubToolbar:(UIView *)toolbar onCompletion:(ShowEditModeFinishResponseBlock)codeBlock
{
    [UIView animateWithDuration:0.3f animations:^{
        mainToolbar.center = CGPointMake(mainToolbar.center.x, mainToolbar.center.y + mainToolbar.frame.size.height);
    } completion:^(BOOL finished) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [UIView animateWithDuration:0.3f delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            toolbar.center = CGPointMake(toolbar.center.x, toolbar.center.y - toolbar.frame.size.height);
        } completion:^(BOOL finished) {
            codeBlock(finished);
        }];
    }];
}

- (void)hideSubToolbar:(UIView *)toolbar onCompletion:(ShowEditModeFinishResponseBlock)codeBlock
{
    [UIView animateWithDuration:0.3f animations:^{
        toolbar.center = CGPointMake(toolbar.center.x, toolbar.center.y + toolbar.frame.size.height);
    } completion:^(BOOL finished) {
        [toolbar removeFromSuperview];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        mainToolbar.center = CGPointMake(mainToolbar.center.x, mainToolbar.center.y - mainToolbar.frame.size.height);
        codeBlock(finished);
    }];
}

- (void)showAudioEditToolbar
{
    if (audioTrimToolbar == nil || audioTrimToolbar.superview == nil) {
        audioTrimToolbar = [[ISAudioTrimToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 104)];
        audioTrimToolbar.delegate = self;
        audioTrimToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:audioTrimToolbar];
    }
    [audioTrimToolbar setStartTime:self.audio.startTime andMaxTime:self.audio.duration andMusicName:self.audio.fileName];
    [self showSubToolbar:audioTrimToolbar onCompletion:^(BOOL success) {
        [self restart];
        ISAudioVolumePoupView *volumePopupView = [[ISAudioVolumePoupView alloc] initWithVideoVolume:self.mPlayer.volume musicVolume:self.audioPlayer.volume delegate:self];
        [volumePopupView showAtView:self.view];
    }];
}

#pragma mark--
#pragma mark-- ISMainToolbar Delegate
- (void)mainToolbar:(ISMainToolbar *)toolbar clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.mScrubber setHidden:YES];
    [self pause];
    switch (buttonIndex) {
        case 0:
        {
            if (videoTrimToolbar == nil || videoTrimToolbar.superview == nil) {
                videoTrimToolbar = [[ISVideoTrimToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 104)];
                videoTrimToolbar.delegate = self;
                videoTrimToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
                [self.view addSubview:videoTrimToolbar];
            }
            [videoTrimToolbar setMinValue:[[ISVideoManager sharedInstance] videoStartTime] andMaxValue:[[ISVideoManager sharedInstance] videoEndTime] andDuration:self.duration];
            [self showSubToolbar:videoTrimToolbar onCompletion:^(BOOL success) {
                
            }];
            break;
        }
        case 1:
        {
            if (videoFitToolbar == nil || videoFitToolbar.superview == nil) {
                videoFitToolbar = [[ISVideoFitToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 104)];
                videoFitToolbar.delegate = self;
                videoFitToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
                [self.view addSubview:videoFitToolbar];
            }
            [videoFitToolbar setFitType:[[ISVideoManager sharedInstance] videoFitType] andBorderType:[[ISVideoManager sharedInstance] videoBorderType]];
            [self showSubToolbar:videoFitToolbar onCompletion:^(BOOL success) {
                if ([[ISVideoManager sharedInstance] videoFitType] == VideoFitTypeOriginal) {
                    [panGestureRecognizer setEnabled:NO];
                }else{
                    [panGestureRecognizer setEnabled:YES];
                }
            }];
            break;
        }
        case 2:
        {
            if ([[ISVideoManager sharedInstance] audioURL] == nil) {
                ISAudioPickerPopupView *audioPickerPopupView = [[ISAudioPickerPopupView alloc] init];
                audioPickerPopupView.delegate = self;
                [audioPickerPopupView showOnView:self.view];
            }else{
                [self showAudioEditToolbar];
            }
            break;
        }
        case 3:
        {
            if (videoColorPicker == nil || videoColorPicker.superview == nil) {
                videoColorPicker = [[ISColorPicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 104)];
                videoColorPicker.delegate = self;
                videoColorPicker.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
                [self.view addSubview:videoColorPicker];
            }
            videoColorPicker.orgColor = [[ISVideoManager sharedInstance] videoBgColor];
            [self showSubToolbar:videoColorPicker onCompletion:^(BOOL success) {
                
            }];
            break;
        }
        case 4:
        {
            VideoRotateType curRotateType = [[ISVideoManager sharedInstance] videoRotateType];
            if (curRotateType == VideoRotateTypeRotate270) {
                [ISVideoManager sharedInstance].videoRotateType = VideoRotateTypeOriginal;
            }else{
                [ISVideoManager sharedInstance].videoRotateType ++;
            }
            NSLog(@"%f:%f",self.mPlayBorderView.frame.size.width/2,self.mPlayBorderView.frame.size.height/2);
//            self.mPlaybackView.layer.anchorPoint = CGPointMake(self.mPlayBorderView.frame.size.width/2, self.mPlayBorderView.frame.size.height/2);
            VideoFlipType curFlipType = [[ISVideoManager sharedInstance] videoFlipType];
            if (curFlipType == VideoFlipTypeOriginal) {
                self.mPlaybackView.transform = CGAffineTransformRotate(self.mPlaybackView.transform, 90.0 *M_PI / 180.0);
            }else{
                self.mPlaybackView.transform = CGAffineTransformRotate(self.mPlaybackView.transform, -90.0 *M_PI / 180.0);
            }
            NSLog(@"%f:%f",self.mPlaybackView.frame.origin.x,self.mPlaybackView.frame.origin.y);
            break;
        }
        case 5:
        {
            VideoFlipType curFlipType = [[ISVideoManager sharedInstance] videoFlipType];
            if (curFlipType == VideoFlipTypeOriginal) {
                [ISVideoManager sharedInstance].videoFlipType = VideoFlipTypeFlip;
            }else{
                [ISVideoManager sharedInstance].videoFlipType = VideoFlipTypeOriginal;
            }
            VideoRotateType curRotateType = [[ISVideoManager sharedInstance] videoRotateType];
            if (curRotateType == VideoRotateTypeOriginal || curRotateType == VideoRotateTypeRotate180) {
                self.mPlaybackView.transform = CGAffineTransformScale(self.mPlaybackView.transform, -1, 1);
            }else{
                self.mPlaybackView.transform = CGAffineTransformScale(self.mPlaybackView.transform, 1, -1);
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark--
#pragma mark-- ISVideoTrimToolbar Delegate
- (void)videoTrimToolbar:(ISVideoTrimToolbar *)toolbar rangeSliderDidSelectedAtMinValue:(float)minValue andMaxValue:(float)maxValue
{
    [self hideSubToolbar:toolbar onCompletion:^(BOOL success) {
        
    }];
    [[ISVideoManager sharedInstance] setVideoStartTime:minValue];
    [[ISVideoManager sharedInstance] setVideoEndTime:maxValue];
}

- (void)videoTrimToolbar:(ISVideoTrimToolbar *)toolbar rangeSliderValueDidChangedAtMinValue:(float)minValue andMaxValue:(float)maxValue isMaxValueChanged:(BOOL)yes
{
    [self.mScrubber setHidden:YES];
    if (!yes) {
        [[ISVideoManager sharedInstance] setVideoStartTime:minValue];
        [self.mPlayer seekToTime:CMTimeMakeWithSeconds(minValue, 10) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    }else{
        [[ISVideoManager sharedInstance] setVideoEndTime:maxValue];
        seekToZeroBeforePlay = YES;
        [self.mPlayer seekToTime:CMTimeMakeWithSeconds(maxValue, 10) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    }
}
#pragma mark--
#pragma mark-- ISVideoFitToolbar delegate
- (void)videoFitToolbar:(ISVideoFitToolbar *)toolbar reviewAtFitType:(VideoFitType)fitType andBorderType:(VideoBorderType)borderType isFinishEditing:(BOOL)isFinishEditing
{
    if (isFinishEditing) {
        [[ISVideoManager sharedInstance] setVideoFitType:fitType];
        [[ISVideoManager sharedInstance] setVideoBorderType:borderType];
        [self hideSubToolbar:toolbar onCompletion:^(BOOL success) {
            [panGestureRecognizer setEnabled:NO];
        }];
    }else{
        if (fitType == VideoFitTypeOriginal) {
            [panGestureRecognizer setEnabled:NO];
        }else{
            [panGestureRecognizer setEnabled:YES];
        }
    }
    [self updateVideoLayoutByFitAndBorderType:fitType andBorderType:borderType andBackgroundColor:[[ISVideoManager sharedInstance] videoBgColor]];
}

#pragma mark--
#pragma mark-- ISColorPicker Delegate
- (void)colorPicker:(ISColorPicker *)colorPicker selectedAtColor:(UIColor *)color isFinishEditing:(BOOL)isFinishEditing
{
    if (isFinishEditing) {
        [[ISVideoManager sharedInstance] setVideoBgColor:color];
        [self hideSubToolbar:colorPicker onCompletion:^(BOOL success) {
            
        }];
    }
    [[ISVideoManager sharedInstance] setVideoFitType:VideoFitTypeFit];
    [self updateVideoLayoutByFitAndBorderType:[[ISVideoManager sharedInstance] videoFitType] andBorderType:[[ISVideoManager sharedInstance] videoBorderType] andBackgroundColor:color];
}

#pragma mark--
#pragma mark-- ISAudioVolumePopupView delegate
- (void)volumePopupView:(ISAudioVolumePoupView *)volumePopupView videoVolumeChangedTo:(float)videoVolume musicVolumeChangedTo:(float)musicVolume
{
    self.mPlayer.volume = videoVolume;
    self.audioPlayer.volume = musicVolume;
    if (![self isPlaying]) {
        [self restart];
    }
}

#pragma mark--
#pragma mark-- ISAudioPickerPopupView delegate
- (void)audioPickerPopupView:(ISAudioPickerPopupView *)pickerPopupView selectedAtIndex:(NSInteger)index
{
    if (index == 0) {
        //choose from theme
        ISAudio *audio = [[ISAudio alloc] init];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"audio"
                                                             ofType:@"mp3"];
        audio.audioURL = [NSURL fileURLWithPath:filePath];
        audio.fileName = [NSString stringWithFormat:@"audio.mp3"];
        audio.startTime = 0.f;
        self.audio = audio;
        if (audioTrimToolbar.superview != nil) {
            [audioTrimToolbar setStartTime:self.audio.startTime andMaxTime:self.audio.duration andMusicName:self.audio.fileName];
            [self restart];
        }else{
            [self showAudioEditToolbar];
        }
    }else{
        //choose from library
        MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
        mediaPicker.delegate = self;
        mediaPicker.allowsPickingMultipleItems = NO; // this is the default
        [self presentViewController:mediaPicker animated:YES completion:nil];
    }
}

#pragma mark--
#pragma mark-- ISAudioTrimToolbar delegate
- (void)audioTrimToolbar:(ISAudioTrimToolbar *)toolbar isChangesCancelled:(BOOL)isCancelled
{
    if (isCancelled) {
        ISAudio *audio = [[ISAudio alloc] init];
        audio.audioURL = [[ISVideoManager sharedInstance] audioURL];
        audio.fileName = [[ISVideoManager sharedInstance] audioFileName];
        audio.startTime = [[ISVideoManager sharedInstance] audioStartTime];
        audio.duration = [[ISVideoManager sharedInstance] audioDuration];
        self.audio = audio;
        self.audioPlayer.volume = [[ISVideoManager sharedInstance] audioVolume];
        self.mPlayer.volume = [[ISVideoManager sharedInstance] videoVolume];
    }else{
        [[ISVideoManager sharedInstance] setAudioURL:self.audio.audioURL];
        [[ISVideoManager sharedInstance] setAudioFileName:self.audio.fileName];
        [[ISVideoManager sharedInstance] setAudioStartTime:self.audio.startTime];
        [[ISVideoManager sharedInstance] setAudioDuration:self.audio.duration];
        [[ISVideoManager sharedInstance] setAudioVolume:self.audioPlayer.volume];
        [[ISVideoManager sharedInstance] setVideoVolume:self.mPlayer.volume];
    }
    [self hideSubToolbar:toolbar onCompletion:^(BOOL success) {
        [self restart];
    }];
}

- (void)audioTrimToolbar:(ISAudioTrimToolbar *)toolbar previewStartTimeDidSelectedAt:(float)startTime
{
    self.audio.startTime = startTime;
    self.audioPlayer.currentTime = startTime;
    [self restart];
}

- (void)deleteMusic:(ISAudioTrimToolbar *)toolbar
{
    self.audio = nil;
    [[ISVideoManager sharedInstance] setAudioURL:nil];
    [[ISVideoManager sharedInstance] setAudioFileName:nil];
    [[ISVideoManager sharedInstance] setAudioStartTime:0];
    [[ISVideoManager sharedInstance] setAudioDuration:0];
    [self hideSubToolbar:toolbar onCompletion:^(BOOL success) {
        self.mPlayer.volume = 1;
        [[ISVideoManager sharedInstance] setVideoVolume:1];
        [self restart];
    }];
}

- (void)reselectMusic:(ISAudioTrimToolbar *)toolbar
{
    ISAudioPickerPopupView *audioPickerPopupView = [[ISAudioPickerPopupView alloc] init];
    audioPickerPopupView.delegate = self;
    [audioPickerPopupView showOnView:self.view];
}

- (void)editVolume:(ISAudioTrimToolbar *)toolbar
{
    ISAudioVolumePoupView *volumePopupView = [[ISAudioVolumePoupView alloc] initWithVideoVolume:self.mPlayer.volume musicVolume:self.audioPlayer.volume delegate:self];
    [volumePopupView showAtView:self.view];
}

#pragma mark--
#pragma mark-- MPMediaPickerControllerDelegate
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
    MPMediaItem *musicItem = [mediaItemCollection.items objectAtIndex:0];
    
    ISAudio *audio = [[ISAudio alloc] init];
    audio.audioURL = [musicItem valueForProperty:MPMediaItemPropertyAssetURL];
    audio.fileName = musicItem.title;
    audio.startTime = 0.f;
    self.audio = audio;
    if (audioTrimToolbar.superview != nil) {
        [audioTrimToolbar setStartTime:self.audio.startTime andMaxTime:self.audio.duration andMusicName:self.audio.fileName];
        [self restart];
    }else{
        [self showAudioEditToolbar];
    }
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

@end

@implementation ISVideoEditViewController (Player)

#pragma mark Player Item

- (BOOL)isPlaying
{
    return [self.mPlayer rate] != 0.f;
}

- (float)duration
{
    AVPlayerItem *playerItem = [self.mPlayer currentItem];
    if ([playerItem status] == AVPlayerItemStatusReadyToPlay)
        return CMTimeGetSeconds([[playerItem asset] duration]);
    else
        return 0.f;
}

- (float)currentTime
{
    return CMTimeGetSeconds([[self mPlayerItem] currentTime]);
}

/* ---------------------------------------------------------
 **  Get the duration for a AVPlayerItem.
 ** ------------------------------------------------------- */

- (CMTime)playerItemDuration
{
    AVPlayerItem *playerItem = [self.mPlayer currentItem];
    if (playerItem.status == AVPlayerItemStatusReadyToPlay)
    {
        return([playerItem duration]);
    }
    
    return(kCMTimeInvalid);
}

/* Called when the player item has played to its end time. */
- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    /* After the movie has played to its end time, seek back to time zero
     to play it again. */
    seekToZeroBeforePlay = YES;
}

/* Cancels the previously registered time observer. */
-(void)removePlayerTimeObserver
{
    if (mTimeObserver)
    {
        [self.mPlayer removeTimeObserver:mTimeObserver];
        mTimeObserver = nil;
    }
}

#pragma mark -
#pragma mark Loading the Asset Keys Asynchronously

#pragma mark -
#pragma mark Error Handling - Preparing Assets for Playback Failed

/* --------------------------------------------------------------
 **  Called when an asset fails to prepare for playback for any of
 **  the following reasons:
 **
 **  1) values of asset keys did not load successfully,
 **  2) the asset keys did load successfully, but the asset is not
 **     playable
 **  3) the item did not become ready to play.
 ** ----------------------------------------------------------- */

-(void)assetFailedToPrepareForPlayback:(NSError *)error
{
    [self removePlayerTimeObserver];
    [self syncScrubber];
    
    /* Display the error. */
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                        message:[error localizedFailureReason]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}


#pragma mark Prepare to play asset, URL

/*
 Invoked at the completion of the loading of the values for all keys on the asset that we require.
 Checks whether loading was successfull and whether the asset is playable.
 If so, sets up an AVPlayerItem and an AVPlayer to play the asset.
 */
- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
    /* Make sure that the value of each key has loaded successfully. */
    for (NSString *thisKey in requestedKeys)
    {
        NSError *error = nil;
        AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
        if (keyStatus == AVKeyValueStatusFailed)
        {
            [self assetFailedToPrepareForPlayback:error];
            return;
        }
        /* If you are also implementing -[AVAsset cancelLoading], add your code here to bail out properly in the case of cancellation. */
    }
    
    /* Use the AVAsset playable property to detect whether the asset can be played. */
    if (!asset.playable)
    {
        /* Generate an error describing the failure. */
        NSString *localizedDescription = NSLocalizedString(@"Item cannot be played", @"Item cannot be played description");
        NSString *localizedFailureReason = NSLocalizedString(@"The assets tracks were loaded, but could not be made playable.", @"Item cannot be played failure reason");
        NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   localizedDescription, NSLocalizedDescriptionKey,
                                   localizedFailureReason, NSLocalizedFailureReasonErrorKey,
                                   nil];
        NSError *assetCannotBePlayedError = [NSError errorWithDomain:@"StitchedStreamPlayer" code:0 userInfo:errorDict];
        
        /* Display the error to the user. */
        [self assetFailedToPrepareForPlayback:assetCannotBePlayedError];
        
        return;
    }
    
    /* At this point we're ready to set up for playback of the asset. */
    
    /* Stop observing our prior AVPlayerItem, if we have one. */
    if (self.mPlayerItem)
    {
        /* Remove existing player item key value observers and notifications. */
        
        [self.mPlayerItem removeObserver:self forKeyPath:@"status"];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:self.mPlayerItem];
    }
    
    /* Create a new instance of AVPlayerItem from the now successfully loaded AVAsset. */
    self.mPlayerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    /* Observe the player item "status" key to determine when it is ready to play. */
    [self.mPlayerItem addObserver:self
                       forKeyPath:@"status"
                          options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                          context:AVPlayerDemoPlaybackViewControllerStatusObservationContext];
    
    /* When the player item has played to its end time we'll toggle
     the movie controller Pause button to be the Play button */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.mPlayerItem];
    
    seekToZeroBeforePlay = NO;
    
    /* Create new player, if we don't already have one. */
    if (!self.mPlayer)
    {
        /* Get a new AVPlayer initialized to play the specified player item. */
        [self setPlayer:[AVPlayer playerWithPlayerItem:self.mPlayerItem]];
        
        /* Observe the AVPlayer "currentItem" property to find out when any
         AVPlayer replaceCurrentItemWithPlayerItem: replacement will/did
         occur.*/
        [self.player addObserver:self
                      forKeyPath:@"currentItem"
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext];
        
        /* Observe the AVPlayer "rate" property to update the scrubber control. */
        [self.player addObserver:self
                      forKeyPath:@"rate"
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:AVPlayerDemoPlaybackViewControllerRateObservationContext];
    }
    
    /* Make our new AVPlayerItem the AVPlayer's current item. */
    if (self.player.currentItem != self.mPlayerItem)
    {
        /* Replace the player item with a new player item. The item replacement occurs
         asynchronously; observe the currentItem property to find out when the
         replacement will/did occur
         
         If needed, configure player item here (example: adding outputs, setting text style rules,
         selecting media options) before associating it with a player
         */
        [self.mPlayer replaceCurrentItemWithPlayerItem:self.mPlayerItem];
        
        [self syncPlayPauseButtons];
    }
    self.mPlayer.volume = [[ISVideoManager sharedInstance] videoVolume];
    [self.mScrubber setProgress:0.f];
    [self play];
}

#pragma mark -
#pragma mark Asset Key Value Observing
#pragma mark

#pragma mark Key Value Observer for player rate, currentItem, player item status

/* ---------------------------------------------------------
 **  Called when the value at the specified key path relative
 **  to the given object has changed.
 **  Adjust the movie play and pause button controls when the
 **  player item "status" value changes. Update the movie
 **  scrubber control when the player item is ready to play.
 **  Adjust the movie scrubber control when the player item
 **  "rate" value changes. For updates of the player
 **  "currentItem" property, set the AVPlayer for which the
 **  player layer displays visual output.
 **  NOTE: this method is invoked on the main queue.
 ** ------------------------------------------------------- */

- (void)observeValueForKeyPath:(NSString*) path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
    /* AVPlayerItem "status" property value observer. */
    if (context == AVPlayerDemoPlaybackViewControllerStatusObservationContext)
    {
        [self syncPlayPauseButtons];
        
        AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status)
        {
                /* Indicates that the status of the player is not yet known because
                 it has not tried to load new media resources for playback */
            case AVPlayerItemStatusUnknown:
            {
                [self removePlayerTimeObserver];
                [self syncScrubber];
            }
                break;
                
            case AVPlayerItemStatusReadyToPlay:
            {
                /* Once the AVPlayerItem becomes ready to play, i.e.
                 [playerItem status] == AVPlayerItemStatusReadyToPlay,
                 its duration can be fetched from the item. */
                
                [self initScrubberTimer];
                [[ISVideoManager sharedInstance] setVideoEndTime:[self duration]];
            }
                break;
                
            case AVPlayerItemStatusFailed:
            {
                AVPlayerItem *playerItem = (AVPlayerItem *)object;
                [self assetFailedToPrepareForPlayback:playerItem.error];
            }
                break;
        }
    }
    /* AVPlayer "rate" property value observer. */
    else if (context == AVPlayerDemoPlaybackViewControllerRateObservationContext)
    {
        [self syncPlayPauseButtons];
    }
    /* AVPlayer "currentItem" property observer. 
     Called when the AVPlayer replaceCurrentItemWithPlayerItem: 
     replacement will/did occur. */
    else if (context == AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext)
    {
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        
        /* Is the new player item null? */
        if (newPlayerItem == (id)[NSNull null])
        {

        }
        else /* Replacement of player currentItem has occurred */
        {
            /* Set the AVPlayer for which the player layer displays visual output. */
            [self.mPlaybackView setPlayer:mPlayer];
            
            /* Specifies that the player should preserve the video’s aspect ratio and 
             fit the video within the layer’s bounds. */
            [self.mPlaybackView setVideoFillMode:AVLayerVideoGravityResizeAspect];
            
            [self syncPlayPauseButtons];
        }
    }
    else
    {
        [super observeValueForKeyPath:path ofObject:object change:change context:context];
    }
}

@end

