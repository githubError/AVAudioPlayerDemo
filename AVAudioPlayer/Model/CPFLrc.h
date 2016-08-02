//
//  CPFLrc.h
//  AVAudioPlayer
//
//  Created by cuipengfei on 16/8/1.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPFLrc : NSObject

/** 出现时间 */
@property (nonatomic, assign) NSTimeInterval time;

/** 歌词内容 */
@property (nonatomic, copy) NSString *lrcContent;

+ (__kindof CPFLrc *)lrcFromLrcLineString:(NSString *)lrcLineString;

- (__kindof CPFLrc *)initWithLrcLineString:(NSString *)lrcLineString;

@end
