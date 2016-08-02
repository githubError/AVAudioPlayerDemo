//
//  NSString+CPFTimeIntervalFormatter.h
//  AVAudioPlayer
//
//  Created by cuipengfei on 16/7/31.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CPFTimeIntervalFormatter)

+ (NSString *)stringFromNSTimeInterval:(NSTimeInterval)timeInterval;

@end
