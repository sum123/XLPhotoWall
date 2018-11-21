//
//  XLPhotoLayout.h
//  XLPhotoWall
//
//  Created by Sum123 on 2017/8/21.
//  Copyright © 2017年 HaoKan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLPhotoLayout : UICollectionViewLayout

/// 初始化layout
- (instancetype)initWithModelArray:(NSArray *)modelArray;

/// 排列图之后的总高度
@property (assign, nonatomic, readonly) CGFloat modelArrayHeight;

@end
