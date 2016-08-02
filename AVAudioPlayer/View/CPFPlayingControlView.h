//
//  CPFPlayingControlView.h
//  AVAudioPlayer
//
//  Created by cuipengfei on 16/7/30.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPFMusic.h"
#import <AVFoundation/AVFoundation.h>

@interface CPFPlayingControlView : UIView

/* 当前播放的音乐 */
@property (nonatomic, strong) CPFMusic *currentMusic;

/** 播放器 */
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end
