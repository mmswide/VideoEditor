//
//  ISConfirmToolbar.h
//  InstaShot
//
//  Created by Liu Xiang on 10/28/14.
//  Copyright (c) 2014 Liu Xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ISConfirmToolbarDelegate;

@interface ISConfirmToolbar : UIView
{
    UIButton *cancelBtn;
    UIButton *confirmBtn;
    UILabel *titleLabel;
}

@property (nonatomic, strong) NSString *title;
@property (nonatomic, unsafe_unretained) id<ISConfirmToolbarDelegate> delegate;

@end

@protocol ISConfirmToolbarDelegate <NSObject>
@optional
- (void)confirmToolbar:(ISConfirmToolbar *)toolbar clickedButtonAtIndex:(NSInteger)buttonIndex;
@end