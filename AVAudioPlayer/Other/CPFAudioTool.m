//
//  CPFAudioTool.m
//  AVAudioPlayer
//
//  Created by cuipengfei on 16/7/31.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFAudioTool.h"

/** 缓存播放器 */
static NSMutableDictionary *_players;

@implementation CPFAudioTool

+ (AVAudioPlayer *)playMusic:(__kindof CPFMusic *)music {
    if (!music) return nil;
    
    AVAudioPlayer *player = nil;
    
    player = _players[music.filename];
    
    if (player == nil) {
        
        // 取文件
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:music.filename withExtension:nil];
        if (!fileURL) return nil;
        
        // 创建播放器
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        
        // 将播放器缓存
        [_players setObject:player forKey:music.filename];
        // 准备播放
        [player prepareToPlay];
    }
    return player;
}

+ (void)stopPlayMusic:(__kindof CPFMusic *)music {
    if (!music) return;
    
    AVAudioPlayer *player = _players[music.filename];
    
    if (player) {
        [player stop];
        [_players removeObjectForKey:music.filename];
        player = nil;
    }
}

@end
