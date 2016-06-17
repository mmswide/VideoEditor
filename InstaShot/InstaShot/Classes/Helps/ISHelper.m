//
//  ISHelper.m
//  InstaShot
//
//  Created by Liu Xiang on 10/23/14.
//  Copyright (c) 2014 Liu Xiang. All rights reserved.
//

#import "ISHelper.h"

@implementation ISHelper

+(UIColor *)getColor:(NSString *)colorStr withAlpha:(CGFloat)alpha;
{
    NSString * str_r = [colorStr substringWithRange:NSMakeRange(0,2)];
    NSString * str_g = [colorStr substringWithRange:NSMakeRange(2,2)];
    NSString * str_b = [colorStr substringWithRange:NSMakeRange(4,2)];
    
    return [UIColor colorWithRed:[ISHelper ToHex:str_r]/255.0f green:[ISHelper ToHex:str_g]/255.0f blue:[ISHelper ToHex:str_b]/255.0f alpha:alpha];
}

+(int)ToHex:(NSString*)tmpid
{
    int int_ch;
    
    unichar hex_char1 = [tmpid characterAtIndex:0];
    int int_ch1;
    if(hex_char1 >= '0'&& hex_char1 <='9')
        int_ch1 = (hex_char1-48)*16;
    else if(hex_char1 >= 'A'&& hex_char1 <='F')
        int_ch1 = (hex_char1-55)*16;
    else
        int_ch1 = (hex_char1-87)*16;
    
    unichar hex_char2 = [tmpid characterAtIndex:1];
    int int_ch2;
    if(hex_char2 >= '0'&& hex_char2 <='9')
        int_ch2 = (hex_char2-48);
    else if(hex_char2 >= 'A'&& hex_char2 <='F')
        int_ch2 = hex_char2-55;
    else
        int_ch2 = hex_char2-87;
    int_ch = int_ch1+int_ch2;
    
    return int_ch;
}

//Time format: "hh:mm:ss"
//if hh=00, return:"mm:ss"
+ (NSString *)timeFormatter:(int)timeOnSecond
{
    int hour = timeOnSecond/3600;
    int minute = (timeOnSecond - hour*3600)/60;
    int second = timeOnSecond - hour*3600 - minute*60;
    if (hour != 0) {
        return [NSString stringWithFormat:@"%02d:%o2d:%02d",hour,minute,second];
    }else{
        return [NSString stringWithFormat:@"%02d:%02d",minute,second];
    }
}

@end
