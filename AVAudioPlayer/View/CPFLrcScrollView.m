//
//  CPFLrcScrollView.m
//  AVAudioPlayer
//
//  Created by cuipengfei on 16/8/1.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFLrcScrollView.h"
#import "CPFLrcTool.h"
#import "CPFMusicTool.h"
#import "CPFMusic.h"
#import "CPFLrc.h"
#import "CPFLrcCell.h"
#import <MediaPlayer/MediaPlayer.h>

@interface CPFLrcScrollView () <UITableViewDataSource, UITableViewDelegate>

/** 歌词数组 */
@property (nonatomic, strong) NSArray *lrcsArr;

/** 当前歌词下标 */
@property (nonatomic, assign) NSInteger currentIndex;

/** 当前行 */
@property (nonatomic, weak) NSIndexPath *currentIndexPath;

@property (nonatomic, strong) UITableView *tableView;

/** 外面的歌词 */
@property (nonatomic, strong) UILabel *currentLrcLabel;

@end

@implementation CPFLrcScrollView

- (UILabel *)currentLrcLabel {
    if (!_currentLrcLabel) {
        _currentLrcLabel = [[UILabel alloc] init];
    }
    return _currentLrcLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    CPFMusic *currentMusic = [CPFMusicTool currentPlayingMusic];
    self.lrcsArr = [CPFLrcTool lrcsFromCurrentMusicLrcName:currentMusic.lrcname];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    self.tableView.rowHeight = 30;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor clearColor];
    self.pagingEnabled = YES;
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self addSubview:self.tableView];
    
}

- (void)setLrcName:(NSString *)lrcName {
    
    // 初始化当前下标
    self.currentIndex = 0;
    
    _lrcName = [lrcName copy];
    
    self.lrcsArr = [CPFLrcTool lrcsFromCurrentMusicLrcName:lrcName];
    
    [self.tableView reloadData];
}

#pragma mark - tableView的dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lrcsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"LrcCell";
    
    CPFLrcCell *cell = [CPFLrcCell lrcCellWithTableView:tableView withIdentifier:ID];
    
    if (self.currentIndex == indexPath.row) {
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    } else {
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    }
    
    CPFLrc *lrc = self.lrcsArr[indexPath.row];
    
    cell.textLabel.text = lrc.lrcContent;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.currentIndexPath.row) {
        cell.textLabel.textColor = [UIColor colorWithRed:38/255.0 green:190/255.0 blue:100/255.0 alpha:1.0];
    }
}

// 获取当前播放时间滚动歌词
- (void)setCurrentTime:(NSTimeInterval)currentTime {
    _currentTime = currentTime;
    
    // 遍历歌词数组对比时间
    for (int i = 0; i < self.lrcsArr.count-1; i++) {
        // 当前歌词
        CPFLrc *currentLrc = self.lrcsArr[i];
        
        CPFLrc *nextLrc = self.lrcsArr[i + 1];
        
        if (self.currentIndex != i && self.currentTime > currentLrc.time && self.currentTime < nextLrc.time) {
            
            // 获取当前行号
            self.currentIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            // 获取前一行行号
            NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            
            // 更新当前行号
            self.currentIndex = i;
            
            self.currentLrcLabel.text = currentLrc.lrcContent;
            
            // 刷新行
            [self.tableView reloadRowsAtIndexPaths:@[self.currentIndexPath, previousIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            [self.tableView scrollToRowAtIndexPath:self.currentIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            
            [self createRemoteLockImage];
        }
        
    }
}

- (void)createRemoteLockImage{
    CPFMusic *currentMusic = [CPFMusicTool currentPlayingMusic];
    UIImage *currentImage = [UIImage imageNamed:currentMusic.icon];
    
    // 获取展示的三句歌词
    CPFLrc *currentLrc = self.lrcsArr[self.currentIndex];
    CPFLrc *previousLrc = nil;
    if (self.currentIndex > 0) {
        previousLrc = self.lrcsArr[self.currentIndex - 1];
    }
    CPFLrc *nextLrc = nil;
    if (self.currentIndex < self.lrcsArr.count - 1) {
        nextLrc = self.lrcsArr[self.currentIndex + 1];
    }
    
    // 生成图片
    UIGraphicsBeginImageContextWithOptions(currentImage.size, YES, 1.0);
    
    [currentImage drawInRect:CGRectMake(0, 0, currentImage.size.width, currentImage.size.height)];
    
    CGFloat textHeight = 30;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *previousAndNextLrcAttrDic = @{NSFontAttributeName : [UIFont systemFontOfSize:18],
                                                NSForegroundColorAttributeName : [UIColor whiteColor],
                                                NSParagraphStyleAttributeName : style};
    
    NSDictionary *currentLrcAttrDic = @{NSFontAttributeName : [UIFont systemFontOfSize:22],
                                                NSForegroundColorAttributeName : [UIColor colorWithRed:38/255.0 green:190/255.0 blue:100/255.0 alpha:1.0],
                                        NSParagraphStyleAttributeName : style};
    
    [previousLrc.lrcContent drawInRect:CGRectMake(0, currentImage.size.height - 3 * textHeight, currentImage.size.width, currentImage.size.height) withAttributes:previousAndNextLrcAttrDic];
    [nextLrc.lrcContent drawInRect:CGRectMake(0, currentImage.size.height - textHeight, currentImage.size.width, currentImage.size.height) withAttributes:previousAndNextLrcAttrDic];
    [currentLrc.lrcContent drawInRect:CGRectMake(0, currentImage.size.height - 2 * textHeight, currentImage.size.width, currentImage.size.height) withAttributes:currentLrcAttrDic];
    
    UIImage *lockImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    // 设置锁屏中心界面
    MPNowPlayingInfoCenter *nowPlayingCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    NSMutableDictionary *playingInfoDic = [NSMutableDictionary dictionary];
    [playingInfoDic setObject:currentMusic.name forKey:MPMediaItemPropertyTitle];
    [playingInfoDic setObject:currentMusic.singer forKey:MPMediaItemPropertyArtist];
    MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc] initWithImage:lockImage];
    [playingInfoDic setObject:artWork forKey:MPMediaItemPropertyArtwork];
    [playingInfoDic setObject:@(self.currentTime) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [playingInfoDic setObject:@(self.duration) forKey:MPMediaItemPropertyPlaybackDuration];
    nowPlayingCenter.nowPlayingInfo = playingInfoDic;
    
    // 让应用程序可以接受远程事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    UIGraphicsEndImageContext();
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.currentLrcLabel.textColor = [UIColor colorWithRed:38/255.0 green:190/255.0 blue:100/255.0 alpha:1.0];
    self.currentLrcLabel.textAlignment = NSTextAlignmentCenter;
    self.currentLrcLabel.contentMode = UIViewContentModeScaleAspectFit;
    self.currentLrcLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.currentLrcLabel];
    
    self.tableView.frame = CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
    self.tableView.contentInset = UIEdgeInsetsMake(self.bounds.size.height * 0.5, 0, self.bounds.size.height * 0.5, 0);
    
    NSDictionary *nameMap = @{@"currentLrcLabel" : self.currentLrcLabel ,
                              @"tableView" : self.tableView};
    
    NSArray *currentLrcLabelLayoutHorizontalConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[currentLrcLabel]-0-[tableView]" options:0 metrics:nil views:nameMap];
    
    if (self.bounds.size.height > 350) {
        NSArray *currentLrcLabelLayoutVerticalConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-350-[currentLrcLabel(==25)]" options:0 metrics:nil views:nameMap];
        [self addConstraints:currentLrcLabelLayoutVerticalConstraint];
    } else if (self.bounds.size.height > 0){
        
        NSArray *currentLrcLabelLayoutVerticalConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[currentLrcLabel(==25)]" options:0 metrics:nil views:nameMap];
        [self addConstraints:currentLrcLabelLayoutVerticalConstraint];
    }
    
    
    [self addConstraints:currentLrcLabelLayoutHorizontalConstraint];
}

@end
