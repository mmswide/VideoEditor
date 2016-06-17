//
//  ISHelper.h
//  InstaShot
//
//  Created by Liu Xiang on 10/23/14.
//  Copyright (c) 2014 Liu Xiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISHelper : NSObject

+ (UIColor *)getColor:(NSString *)colorStr withAlpha:(CGFloat)alpha;
//Time format: "hh:mm:ss"
//if hh=00, return:"mm:ss"
+ (NSString *)timeFormatter:(int)timeOnSecond;

@end
