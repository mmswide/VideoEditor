//
//  ISMainToolbar.h
//  InstaShot
//
//  Created by Liu Xiang on 10/28/14.
//  Copyright (c) 2014 Liu Xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ISMainToolbarDelegate;

@interface ISMainToolbar : UIView

@property (strong, nonatomic) UIButton *cutBtn;
@property (strong, nonatomic) UIButton *fitBtn;
@property (strong, nonatomic) UIButton *musicBtn;
@property (strong, nonatomic) UIButton *changeBgBtn;
@property (strong, nonatomic) UIButton *rotateBtn;
@property (strong, nonatomic) UIButton *flipBtn;
@property (nonatomic, unsafe_unretained) id<ISMainToolbarDelegate> delegate;

@end

@protocol ISMainToolbarDelegate <NSObject>
@optional
- (void)mainToolbar:(ISMainToolbar *)toolbar clickedButtonAtIndex:(NSInteger)buttonIndex;
@end    