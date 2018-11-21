//
//  XLCollectionViewCell.m
//  XLPhotoWall
//
//  Created by Sum123 on 2017/8/21.
//  Copyright © 2017年 HaoKan. All rights reserved.
//

#import "XLCollectionViewCell.h"

@interface XLCollectionViewCell ()

@end

@implementation XLCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.lab];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.lab.frame = self.bounds;
}

- (UILabel *)lab {
    if (!_lab) {
        _lab = [[UILabel alloc] init];
        _lab.textAlignment = NSTextAlignmentCenter;
    }
    return _lab;
}

@end
