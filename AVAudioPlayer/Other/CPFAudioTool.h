//
//  CPFAudioTool.h
//  AVAudioPlayer
//
//  Created by cuipengfei on 16/7/31.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "CPFMusic.h"

@interface CPFAudioTool : NSObject

+ (AVAudioPlayer *)playMusic:(__kindof CPFMusic *)music;

+ (void)stopPlayMusic:(__kindof CPFMusic *)music;

@end
