//
//  CPFLrcTool.m
//  AVAudioPlayer
//
//  Created by cuipengfei on 16/8/1.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFLrcTool.h"
#import "CPFLrc.h"

@implementation CPFLrcTool

+ (NSArray *)lrcsFromCurrentMusicLrcName:(NSString *)lrcname {
    if (!lrcname) return nil;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:lrcname ofType:nil];
    NSString *lrcString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *lrcArr = [lrcString componentsSeparatedByString:@"\n"];
    NSMutableArray *lrcsArray = [NSMutableArray array];
    for (NSString *lrcLineString in lrcArr) {
        // 过滤 [ti:] [ar:] [al:]
        if ([lrcLineString hasPrefix:@"[ti"]
            || [lrcLineString hasPrefix:@"[ar"]
            || [lrcLineString hasPrefix:@"[al"]
            || ![lrcLineString hasPrefix:@"["]) continue;
        CPFLrc *lrc = [CPFLrc lrcFromLrcLineString:lrcLineString];
        [lrcsArray addObject:lrc];
    }
    return lrcsArray;
}

@end
