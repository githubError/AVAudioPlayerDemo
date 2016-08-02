//
//  CPFMusicTool.h
//  AVAudioPlayer
//
//  Created by cuipengfei on 16/7/31.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPFMusic.h"

@interface CPFMusicTool : NSObject

+ (NSMutableArray *)allMusics;

+ (CPFMusic *)currentPlayingMusic;

+ (void)setCurrentPlayingMusic:(CPFMusic *)playingMusic;

+ (CPFMusic *)previousMusic;

+ (CPFMusic *)nextMusic;

@end
