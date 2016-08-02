//
//  CPFPlayingViewController.m
//  AVAudioPlayer
//
//  Created by cuipengfei on 16/7/30.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFPlayingViewController.h"
#import "CPFPlayingControlView.h"
#import "CPFAudioTool.h"
#import "CPFMusicTool.h"
#import "CPFMusic.h"

@interface CPFPlayingViewController ()

@end

@implementation CPFPlayingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CPFPlayingControlView *playingCtrView = [[CPFPlayingControlView alloc] init];
    
    playingCtrView.frame = self.view.bounds;
    
    [self.view addSubview:playingCtrView];
    
    CPFMusic *currentPlayingMusic = [CPFMusicTool currentPlayingMusic];
    
    AVAudioPlayer *player = [CPFAudioTool playMusic:currentPlayingMusic];
    
    playingCtrView.audioPlayer = player;
    playingCtrView.currentMusic = currentPlayingMusic;
}

@end
