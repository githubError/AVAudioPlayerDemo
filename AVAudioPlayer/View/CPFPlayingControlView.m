//
//  CPFPlayingControlView.m
//  AVAudioPlayer
//
//  Created by cuipengfei on 16/7/30.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFPlayingControlView.h"
#import "CPFAudioTool.h"
#import "CPFMusicTool.h"
#import "NSString+CPFTimeIntervalFormatter.h"
#import "CPFLrcScrollView.h"

@interface CPFPlayingControlView () <AVAudioPlayerDelegate, UIScrollViewDelegate>

/*******************音乐控制台**************************/

/** 播放进度 */
@property (nonatomic, strong) UISlider *progressSlider;

/** 播放按钮 */
@property (nonatomic, strong) UIButton *playOrPauseBtn;

/** 上一曲按钮 */
@property (nonatomic, strong) UIButton *previousMusicBtn;

/** 下一曲按钮 */
@property (nonatomic, strong) UIButton *nextMusicBtn;

/** 当前时间 */
@property (nonatomic, strong) UILabel *currentTimeLabel;

/** 歌曲总时长 */
@property (nonatomic, strong) UILabel *durationTimeLabel;

/** 控制台 */
@property (nonatomic, strong) UIView *controlView;

/*******************音乐控制台**************************/



/** 背景图片 */
@property (nonatomic, strong) UIImageView *bgBlurImageView;

/** 歌曲Artwork */
@property (nonatomic, strong) UIImageView *iconImageView;

/** 歌曲名称 */
@property (nonatomic, strong) UILabel *musicNameLabel;

/** 歌手 */
@property (nonatomic, strong) UILabel *artistLabel;

/** 歌词滚动视图 */
@property (nonatomic, strong) CPFLrcScrollView *lrcScrollView;

/** 毛玻璃背景 */
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;

/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;

/** 定时器 */
@property (nonatomic, strong) CADisplayLink *displayLink;

@end


@implementation CPFPlayingControlView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // 初始化设置
        [self setup];
        
        // 添加音乐控制台视图
        [self setupControlView];
        
        // 开始播放
        [self startPlay];
    }
    return self;
}

#pragma mark - 播放控制
- (void)previousMusic {
    
    CPFMusic *previousMusic = [CPFMusicTool previousMusic];
    
    [self playMusicWithMusic:previousMusic];
}

- (void)playOrPause {
    
    [self updateCurrentMusic];
    
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.selected;
    if (self.playOrPauseBtn.selected) {
        [self.audioPlayer play];
    } else {
        [self.audioPlayer pause];
    }
}

- (void)nextMusic {
    
    CPFMusic *nextMusic = [CPFMusicTool nextMusic];
    
    [self playMusicWithMusic:nextMusic];
}

- (void)startPlay {
    CPFMusic *currentMusic = [CPFMusicTool currentPlayingMusic];
    
    [CPFMusicTool setCurrentPlayingMusic:currentMusic];
    
    self.audioPlayer = [CPFAudioTool playMusic:currentMusic];
    
    self.lrcScrollView.duration = self.audioPlayer.duration;
}

- (void)playMusicWithMusic:(CPFMusic *)music {
    
    [CPFMusicTool setCurrentPlayingMusic:music];
    [CPFAudioTool stopPlayMusic:self.currentMusic];
    
    self.currentMusic = music;
    self.audioPlayer = [CPFAudioTool playMusic:music];
    self.audioPlayer.delegate = self;
    [self.audioPlayer play];
    [self updateCurrentMusic];
    
    self.lrcScrollView.lrcName = self.currentMusic.lrcname;
}

#pragma mark - 设置相关内容
- (void)updateCurrentMusic {
    
    // 移除之前的定时器
    [self removeMusicTimer];
    
    // 添加定时器
    [self addMusicTimer];
    
    self.bgBlurImageView.image = [UIImage imageNamed:self.currentMusic.icon];
    self.iconImageView.image = [UIImage imageNamed:self.currentMusic.icon];
    self.musicNameLabel.text= self.currentMusic.name;
    self.artistLabel.text = self.currentMusic.singer;
    self.currentTimeLabel.text = [NSString stringFromNSTimeInterval:self.audioPlayer.currentTime];
    self.durationTimeLabel.text = [NSString stringFromNSTimeInterval:self.audioPlayer.duration];
    
    self.playOrPauseBtn.selected = self.audioPlayer.isPlaying;
}



#pragma mark - 定时器
- (void)addMusicTimer {
    [self updateProgressInfo];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateCurrentTime)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)removeMusicTimer {
    [self.timer invalidate];
    [self.displayLink invalidate];
    self.timer = nil;
    self.displayLink = nil;
}

- (void)updateProgressInfo {
    self.currentTimeLabel.text = [NSString stringFromNSTimeInterval:self.audioPlayer.currentTime];
    self.progressSlider.value = self.audioPlayer.currentTime / self.audioPlayer.duration;
}

- (void)updateCurrentTime {
    self.lrcScrollView.currentTime = self.audioPlayer.currentTime;
}

#pragma mark - progressSlider事件处理
- (void)startSlide {
    [self removeMusicTimer];
}

- (void)progressSlideValueChange {
    self.currentTimeLabel.text = [NSString stringFromNSTimeInterval:self.progressSlider.value * self.audioPlayer.duration];
}

- (void)endSlide {
    self.audioPlayer.currentTime = self.progressSlider.value * self.audioPlayer.duration;
    [self updateCurrentMusic];
}

- (void)sliderClick:(UITapGestureRecognizer *)sender {
    CGPoint piont = [sender locationInView:self.progressSlider];
    
    CGFloat scale = piont.x / self.progressSlider.frame.size.width;
    
    self.audioPlayer.currentTime = scale * self.audioPlayer.duration;
    
    [self updateCurrentMusic];
}

#pragma mark - AVAudioPlayerDelegate
// 播放结束
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        [self nextMusic];
    }
}



#pragma mark - UIScrollViewDelegate
// 根据scrollView的偏移改变imageView的透明度
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    
    self.iconImageView.alpha = 1 - offset.x / scrollView.frame.size.width;
}



#pragma mark - 初始化视图

- (void)setupMusicInfoLabel:(UILabel *)label withText:(NSString *)text andFontSize:(CGFloat)size{
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = text;
    label.font = [UIFont systemFontOfSize:size];
    label.contentMode = UIViewContentModeScaleAspectFit;
    label.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setup {
    self.bgBlurImageView = [[UIImageView alloc] init];
    
    // 毛玻璃背景
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.visualEffectView.alpha = 1.0;
    [self.bgBlurImageView addSubview:self.visualEffectView];
    [self addSubview:self.bgBlurImageView];
    
    // 设置iconImageView
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bgBlurImageView.image = [UIImage imageNamed:@"LaunchImage"];
    [self.bgBlurImageView addSubview:self.iconImageView];
    
    // 设置歌曲名、歌手名Label
    self.musicNameLabel = [[UILabel alloc] init];
    [self setupMusicInfoLabel:self.musicNameLabel withText:@"歌曲" andFontSize:20];
    [self addSubview:self.musicNameLabel];
    
    self.artistLabel = [[UILabel alloc] init];
    [self setupMusicInfoLabel:self.artistLabel withText:@"艺术家" andFontSize:14];
    [self addSubview:self.artistLabel];
    
    
    // 设置歌词滚动视图
    self.lrcScrollView = [[CPFLrcScrollView alloc] init];
    self.lrcScrollView.delegate = self;
    [self addSubview:self.lrcScrollView];
    
}

#pragma mark - 监听远程事件
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
            case UIEventSubtypeRemoteControlPause:
            NSLog(@"--------");
//            [self playOrPause];
            break;
            case UIEventSubtypeRemoteControlNextTrack:
//            [self nextMusic];
            break;
            case UIEventSubtypeRemoteControlPreviousTrack:
//            [self previousMusic];
            break;
        default:
            break;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bgBlurImageView.frame = self.bounds;
    self.visualEffectView.frame = self.bgBlurImageView.bounds;
    
    self.lrcScrollView.contentSize = CGSizeMake(self.bounds.size.width * 2, 0);
    // 设置约束
    NSDictionary *nameMap = @{@"iconImageView" : self.iconImageView,
                              @"controlView" : self.controlView,
                              @"currentTimeLabel" : self.currentTimeLabel ,
                              @"progressSlider" : self.progressSlider ,
                              @"durationTimeLabel" : self.durationTimeLabel ,
                              @"previousMusicBtn" : self.previousMusicBtn ,
                              @"playOrPauseBtn" : self.playOrPauseBtn ,
                              @"nextMusicBtn" : self.nextMusicBtn ,
                              @"musicNameLabel" : self.musicNameLabel ,
                              @"artistLabel" : self.artistLabel ,
                              @"lrcScrollView" : self.lrcScrollView};
    
    /** 设置歌词滚动区域约束*/
    
    NSArray *lrcScrollViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-130-[lrcScrollView]-160-|" options:0 metrics:nil views:nameMap];
    NSArray *lrcScrollHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[lrcScrollView]-10-|" options:0 metrics:nil views:nameMap];
    
    /** 设置歌曲名、歌手名Label约束 */
    NSArray *nameLabelVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[musicNameLabel(==25)]-5-[artistLabel(==20)]" options:0 metrics:nil views:nameMap];
    NSArray *nameLabelHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[musicNameLabel(==200)]" options:0 metrics:nil views:nameMap];
    
    NSLayoutConstraint *nameLabelWidthConstraint = [NSLayoutConstraint constraintWithItem:self.artistLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.musicNameLabel attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    NSLayoutConstraint *musicNameLabelCenterXConstraint = [NSLayoutConstraint constraintWithItem:self.musicNameLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    NSLayoutConstraint *artistNameLabelCenterXConstraint = [NSLayoutConstraint constraintWithItem:self.artistLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.musicNameLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    
    /** iconImageView约束 */
    NSArray *iconImageViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[iconImageView]-50-|" options:0 metrics:nil views:nameMap];
    NSArray *iconImageViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[iconImageView]-0-|" options:0 metrics:nil views:nameMap];
    
    /** controlView约束 */
    NSArray *controlViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[controlView(==120)]-0-|" options:0 metrics:nil views:nameMap];
    NSArray *controlViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[controlView]-0-|" options:0 metrics:nil views:nameMap];
    
    /** controlView子控件约束 */
    NSArray *subControlViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[currentTimeLabel(==50)]-5-[progressSlider]-5-[durationTimeLabel(==50)]-5-|" options:0 metrics:nil views:nameMap];
    NSArray *subControlViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[progressSlider(==20)]" options:0 metrics:nil views:nameMap];
    
    NSLayoutConstraint *currentTimeHeightLabelAspectConstraint = [NSLayoutConstraint constraintWithItem:self.currentTimeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.progressSlider attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *currentTimeLabelAspectConstraintV = [NSLayoutConstraint constraintWithItem:self.currentTimeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.progressSlider attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint *durationTimeLabelHeightLabelAspectConstraint = [NSLayoutConstraint constraintWithItem:self.durationTimeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.progressSlider attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *durationTimeLabelAspectConstraintV = [NSLayoutConstraint constraintWithItem:self.durationTimeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.progressSlider attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    
    NSArray *musicControlViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousMusicBtn(==60)]-20-[playOrPauseBtn(==60)]-20-[nextMusicBtn(==60)]" options:0 metrics:nil views:nameMap];
    NSArray *musicControlViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[playOrPauseBtn(==60)]" options:0 metrics:nil views:nameMap];
    NSLayoutConstraint *previousMusicBtnHeightLabelAspectConstraint = [NSLayoutConstraint constraintWithItem:self.previousMusicBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.playOrPauseBtn attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *previousMusicBtnAspectConstraintV = [NSLayoutConstraint constraintWithItem:self.previousMusicBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.playOrPauseBtn attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint *playOrPauseBtnCenterXLabelAspectConstraint = [NSLayoutConstraint constraintWithItem:self.playOrPauseBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.controlView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint *nextMusicBtnHeightLabelAspectConstraint = [NSLayoutConstraint constraintWithItem:self.nextMusicBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.playOrPauseBtn attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *nextMusicBtnAspectConstraintV = [NSLayoutConstraint constraintWithItem:self.nextMusicBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.playOrPauseBtn attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    
    [self addConstraints:iconImageViewHorizontalConstraints];
    [self addConstraints:iconImageViewVerticalConstraints];
    [self addConstraints:controlViewVerticalConstraints];
    [self addConstraints:controlViewHorizontalConstraints];
    [self addConstraints:subControlViewHorizontalConstraints];
    [self addConstraints:subControlViewVerticalConstraints];
    
    [self addConstraint:currentTimeHeightLabelAspectConstraint];
    [self addConstraint:currentTimeLabelAspectConstraintV];
    [self addConstraint:durationTimeLabelHeightLabelAspectConstraint];
    [self addConstraint:durationTimeLabelAspectConstraintV];
    
    [self addConstraints:musicControlViewHorizontalConstraints];
    [self addConstraints:musicControlViewVerticalConstraints];
    
    [self addConstraint:previousMusicBtnAspectConstraintV];
    [self addConstraint:previousMusicBtnHeightLabelAspectConstraint];
    [self addConstraint:nextMusicBtnAspectConstraintV];
    [self addConstraint:nextMusicBtnHeightLabelAspectConstraint];
    [self addConstraint:playOrPauseBtnCenterXLabelAspectConstraint];
    
    [self addConstraints:nameLabelHorizontalConstraints];
    [self addConstraints:nameLabelVerticalConstraints];
    [self addConstraint:musicNameLabelCenterXConstraint];
    [self addConstraint:artistNameLabelCenterXConstraint];
    [self addConstraint:nameLabelWidthConstraint];
    
    [self addConstraints:lrcScrollHorizontalConstraints];
    [self addConstraints:lrcScrollViewVerticalConstraints];
}

- (void)setupControlViewLabel:(UILabel *)label {
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"00:00";
    label.contentMode = UIViewContentModeScaleAspectFit;
    label.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setupControlView {
    self.controlView = [[UIView alloc] init];
    self.controlView.contentMode = UIViewContentModeScaleAspectFit;
    self.controlView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.controlView];
    
    self.currentTimeLabel = [[UILabel alloc] init];
    [self setupControlViewLabel:self.currentTimeLabel];
    
    self.durationTimeLabel = [[UILabel alloc] init];
    [self setupControlViewLabel:self.durationTimeLabel];
    
    self.progressSlider = [[UISlider alloc] init];
    self.progressSlider.contentMode = UIViewContentModeScaleAspectFit;
    self.progressSlider.translatesAutoresizingMaskIntoConstraints = NO;
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    [self.progressSlider setMinimumTrackTintColor:[UIColor colorWithRed:38/255.0 green:190/255.0 blue:100/255.0 alpha:1.0]];
    
    // progressSlider事件监听
    [self.progressSlider addTarget:self action:@selector(startSlide) forControlEvents:UIControlEventTouchDown];
    [self.progressSlider addTarget:self action:@selector(progressSlideValueChange) forControlEvents:UIControlEventValueChanged];
    [self.progressSlider addTarget:self action:@selector(endSlide) forControlEvents:UIControlEventTouchUpInside];
    // 监听progressSelider的点击手势
    [self.progressSlider addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderClick:)]];
    
    self.previousMusicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.previousMusicBtn.contentMode = UIViewContentModeScaleAspectFit;
    self.previousMusicBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.previousMusicBtn setImage:[UIImage imageNamed:@"player_btn_pre_normal"] forState:UIControlStateNormal];
    [self.previousMusicBtn setImage:[UIImage imageNamed:@"player_btn_pre_highlight"] forState:UIControlStateHighlighted];
    [self.previousMusicBtn addTarget:self action:@selector(previousMusic) forControlEvents:UIControlEventTouchUpInside];
    
    self.playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playOrPauseBtn.contentMode = UIViewContentModeScaleAspectFit;
    self.playOrPauseBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.playOrPauseBtn setImage:[UIImage imageNamed:@"player_btn_play_normal"] forState:UIControlStateNormal];
    [self.playOrPauseBtn setImage:[UIImage imageNamed:@"player_btn_pause_normal"] forState:UIControlStateSelected];
    [self.playOrPauseBtn addTarget:self action:@selector(playOrPause) forControlEvents:UIControlEventTouchUpInside];
    
    self.nextMusicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextMusicBtn.contentMode = UIViewContentModeScaleAspectFit;
    self.nextMusicBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nextMusicBtn setImage:[UIImage imageNamed:@"player_btn_next_normal"] forState:UIControlStateNormal];
    [self.nextMusicBtn setImage:[UIImage imageNamed:@"player_btn_next_highlight"] forState:UIControlStateHighlighted];
    [self.nextMusicBtn addTarget:self action:@selector(nextMusic) forControlEvents:UIControlEventTouchUpInside];
    
    [self.controlView addSubview:self.currentTimeLabel];
    [self.controlView addSubview:self.durationTimeLabel];
    [self.controlView addSubview:self.progressSlider];
    
    [self.controlView addSubview:self.previousMusicBtn];
    [self.controlView addSubview:self.playOrPauseBtn];
    [self.controlView addSubview:self.nextMusicBtn];
}


@end
