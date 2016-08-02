//
//  NSString+CPFTimeIntervalFormatter.m
//  AVAudioPlayer
//
//  Created by cuipengfei on 16/7/31.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "NSString+CPFTimeIntervalFormatter.h"

@implementation NSString (CPFTimeIntervalFormatter)

+ (NSString *)stringFromNSTimeInterval:(NSTimeInterval)timeInterval {
    NSInteger min = timeInterval / 60;
    NSInteger second = (NSInteger)timeInterval % 60;
    
    return [NSString stringWithFormat:@"%02ld:%02ld", min, second];
}


@end
