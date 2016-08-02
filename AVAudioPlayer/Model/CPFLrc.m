//
//  CPFLrc.m
//  AVAudioPlayer
//
//  Created by cuipengfei on 16/8/1.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFLrc.h"

@implementation CPFLrc

- (CPFLrc *)initWithLrcLineString:(NSString *)lrcLineString {
    if (self = [super init]) {
        
        // [00:33.20]只是因为在人群中多看了你一眼
        if (!lrcLineString) return nil;
        
        NSArray *subLrcArr = [lrcLineString componentsSeparatedByString:@"]"];
        self.lrcContent = [subLrcArr lastObject];
        
        // [00:33.20
        NSString *tempTimeString = [subLrcArr firstObject];
        NSString *timeString = [tempTimeString substringFromIndex:1];
        
        self.time = [self timeStringWithString:timeString];
    }
    
    return self;
}

+ (CPFLrc *)lrcFromLrcLineString:(NSString *)lrcLineString {
    return [[self alloc] initWithLrcLineString:lrcLineString];
}

#pragma mark - 私有方法
- (NSTimeInterval)timeStringWithString:(NSString *)timeString
{
    // 00:33.20
    NSInteger min = [[timeString componentsSeparatedByString:@":"][0] integerValue];
    NSInteger second = [[timeString substringWithRange:NSMakeRange(3, 2)] integerValue];
    NSInteger haomiao = [[timeString componentsSeparatedByString:@"."][1] integerValue];
    
    return (min * 60 + second + haomiao * 0.01);
}

@end
