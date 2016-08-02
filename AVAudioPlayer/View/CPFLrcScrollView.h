//
//  CPFLrcScrollView.h
//  AVAudioPlayer
//
//  Created by cuipengfei on 16/8/1.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPFLrcScrollView : UIScrollView

@property (nonatomic, copy) NSString *lrcName;

/** 当前播放时间 */
@property (nonatomic, assign) NSTimeInterval currentTime;

/** 播放总时长 */
@property (nonatomic, assign) NSTimeInterval duration;

@end
