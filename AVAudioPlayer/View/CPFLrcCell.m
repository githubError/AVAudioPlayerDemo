//
//  CPFLrcCell.m
//  AVAudioPlayer
//
//  Created by cuipengfei on 16/8/1.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFLrcCell.h"

@implementation CPFLrcCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.textLabel];
    }
    return self;
}
+ (instancetype)lrcCellWithTableView:(UITableView *)tableView withIdentifier:(NSString *)identifier
{
    CPFLrcCell *cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = self.bounds;
}


@end
