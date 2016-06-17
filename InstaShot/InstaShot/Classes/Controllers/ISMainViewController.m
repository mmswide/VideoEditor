//
//  ISMainViewController.m
//  InstaShot
//
//  Created by Liu Xiang on 11/24/14.
//  Copyright (c) 2014 Liu Xiang. All rights reserved.
//

#import "ISMainViewController.h"
#import "GDColorButton.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ISVideoEditViewController.h"

@interface ISMainViewController ()
{
    IBOutlet GDColorButton *videoPickBtn;
    IBOutlet GDColorButton *videoTakeBtn;
    IBOutlet GDColorButton *photoPickBtn;
    IBOutlet GDColorButton *photoTakeBtn;
    IBOutlet GDColorButton *recentPhotoPickBtn;
    IBOutlet UIImageView *recentPhotoImageView;
}

@end

@implementation ISMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.translucent = NO;
    if (isOverIOS6) {
        self.navigationController.navigationBar.barTintColor = COLOR_BTN_NORMAL_BLUE;
    }else{
        self.navigationController.navigationBar.tintColor = COLOR_BTN_NORMAL_BLUE;
    }
    
    CGRect titleBarBtnFrame = CGRectMake(0, 0, 32, 32);
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:titleBarBtnFrame];
    logoImageView.image = [UIImage imageNamed:@"icon_actionbar"];
    
    UILabel *logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 32)];
    logoLabel.backgroundColor = [UIColor clearColor];
    logoLabel.textColor = [UIColor whiteColor];
    logoLabel.text = @"InstaShot";
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithCustomView:logoImageView],[[UIBarButtonItem alloc] initWithCustomView:logoLabel], nil];
    
    UIButton *listBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    listBtn.frame = titleBarBtnFrame;
    [listBtn setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    //    [listBtn addTarget:self action:@selector(showOrHideRightViewBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:listBtn];
    
    videoPickBtn.layer.cornerRadius = 5;
    videoPickBtn.clipsToBounds = YES;
    [videoPickBtn setNormalColor:COLOR_BTN_NORMAL_BLUE];
    [videoPickBtn setHighlightedColor:COLOR_BTN_HIGHLIGHT_BLUE];
    
    videoTakeBtn.layer.cornerRadius = 5;
    videoTakeBtn.clipsToBounds = YES;
    [videoTakeBtn setNormalColor:COLOR_BTN_NORMAL_BLUE];
    [videoTakeBtn setHighlightedColor:COLOR_BTN_HIGHLIGHT_BLUE];
    
    photoPickBtn.layer.cornerRadius = 5;
    photoPickBtn.clipsToBounds = YES;
    [photoPickBtn setNormalColor:COLOR_BTN_NORMAL_BLUE];
    [photoPickBtn setHighlightedColor:COLOR_BTN_HIGHLIGHT_BLUE];
    
    photoTakeBtn.layer.cornerRadius = 5;
    photoTakeBtn.clipsToBounds = YES;
    [photoTakeBtn setNormalColor:COLOR_BTN_NORMAL_BLUE];
    [photoTakeBtn setHighlightedColor:COLOR_BTN_HIGHLIGHT_BLUE];
    
    recentPhotoPickBtn.layer.cornerRadius = 5;
    recentPhotoPickBtn.clipsToBounds = YES;
    [recentPhotoPickBtn setNormalColor:COLOR_BTN_NORMAL_BLUE];
    [recentPhotoPickBtn setHighlightedColor:COLOR_BTN_HIGHLIGHT_BLUE];
    
    recentPhotoImageView.image = [UIImage imageNamed:@"pic_index.png"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)videoPickerDidPressed:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

- (IBAction)videoTakeDidPressed:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

- (IBAction)photoPickerDidPressed:(id)sender
{
    NSString *videoURL = [[NSBundle mainBundle] pathForResource:@"Movie" ofType:@"m4v"];
    NSURL *sourceMovieURL = [NSURL fileURLWithPath:videoURL];
    ISVideo *video = [[ISVideo alloc] init];
    video.videoURL = sourceMovieURL;
    [ISVideoManager sharedInstance].video = video;
    ISVideoEditViewController *videoEditViewCtrl = [[ISVideoEditViewController alloc] init];
    [videoEditViewCtrl setURL:sourceMovieURL];
    [self.navigationController pushViewController:videoEditViewCtrl animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    NSURL *videoUrl;
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
        ISVideo *video = [[ISVideo alloc] init];
        video.videoURL = videoUrl;
        [ISVideoManager sharedInstance].video = video;
        
        //save video
        //        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
        //            UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
        //        }
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        ISVideoEditViewController *videoEditViewCtrl = [[ISVideoEditViewController alloc] init];
        [videoEditViewCtrl setURL:videoUrl];
        [self.navigationController pushViewController:videoEditViewCtrl animated:YES];
    }];
}

@end
