//
//  CPFMusicTool.m
//  AVAudioPlayer
//
//  Created by cuipengfei on 16/7/31.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFMusicTool.h"
#import "NSObject+getModel.h"

static NSMutableArray *_musics;
static CPFMusic *_currentMusic;

@implementation CPFMusicTool


+ (void)initialize {
    
    if (!_musics) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Musics" ofType:@"plist"];
        
        NSArray *musicArr = [NSArray arrayWithContentsOfFile:filePath];
        _musics = [NSMutableArray array];
        for (NSDictionary *dic in musicArr) {
            
            CPFMusic *music = [CPFMusic getModelFromDict:dic];
            
            [_musics addObject:music];
        }
    }
    if (!_currentMusic) {
        _currentMusic = _musics[1];
    }
}

+ (NSMutableArray *)allMusics {
    
    return _musics;
}

+ (CPFMusic *)currentPlayingMusic {
    return _currentMusic;
}

+ (void)setCurrentPlayingMusic:(CPFMusic *)playingMusic {
    _currentMusic = playingMusic;
}

+ (CPFMusic *)previousMusic {
    NSInteger currentMusicIndex = [_musics indexOfObject:_currentMusic];
    
    NSInteger previousMusicIndex = --currentMusicIndex;
    
    if (previousMusicIndex < 0) {
        previousMusicIndex = _musics.count - 1;
    }
    return _musics[previousMusicIndex];
}

+ (CPFMusic *)nextMusic {
    NSInteger currentMusicIndex = [_musics indexOfObject:_currentMusic];
    
    NSInteger nextMusicIndex = ++currentMusicIndex;
    
    if (nextMusicIndex > _musics.count - 1) {
        nextMusicIndex = 0;
    }
    return _musics[nextMusicIndex];
}

@end
