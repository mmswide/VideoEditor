//
//  ISRotateCommand.h
//  InstaShot
//
//  Created by Liu Xiang on 10/23/14.
//  Copyright (c) 2014 Liu Xiang. All rights reserved.
//

#import "ISCommand.h"

@interface ISRotateCommand : ISCommand

- (void)performWithAsset:(AVAsset*)asset andRotate:(float)degrees;

@end

