//
//  XLPhotoModel.h
//  XLPhotoWall
//
//  Created by Sum123 on 2017/8/21.
//  Copyright © 2017年 HaoKan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLPhotoModel : NSObject

/// url
@property (copy, nonatomic) NSString *url;

/// 图片宽度
@property (copy, nonatomic) NSString *width;

/// 图片高度
@property (copy, nonatomic) NSString *height;

/// 照片布局之后的X
@property (assign, nonatomic) CGFloat itemX;

/// 照片布局之后的Y
@property (assign, nonatomic) CGFloat itemY;

/// 照片布局之后的W
@property (assign, nonatomic) CGFloat itemW;

/// 照片布局之后的H
@property (assign, nonatomic) CGFloat itemH;

@property (assign, nonatomic) CGFloat arrayHeight;

@end
