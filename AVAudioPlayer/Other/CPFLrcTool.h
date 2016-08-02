//
//  CPFLrcTool.h
//  AVAudioPlayer
//
//  Created by cuipengfei on 16/8/1.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPFLrcTool : NSObject

/** 获取歌词 */
+ (NSArray *)lrcsFromCurrentMusicLrcName:(NSString *)lrcname;

@end
