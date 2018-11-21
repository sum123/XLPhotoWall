//
//  XLPhotoLayout.m
//  XLPhotoWall
//
//  Created by Sum123 on 2017/8/21.
//  Copyright © 2017年 HaoKan. All rights reserved.
//

#import "XLPhotoLayout.h"
#import "XLPhotoModel.h"

#define XLScreenWidth [UIScreen mainScreen].bounds.size.width

/// 预定的基准高度
#define kBaseHeight 130.0

/// 间隔大小
#define kMargin 1

/// 每行最多容许几张图片
#define kMaxCountInRowItems 3

/// 特别扁的图片的最小高度
#define kMinItemH 40.0

/// 特别长的图片的最小宽度
#define kMinItemW 30.0

@interface XLPhotoLayout ()

/// 模型数组
@property (strong, nonatomic) NSArray *modelArray;

/// 存放所有的布局属性
@property (nonatomic, strong) NSMutableArray *attrsArray;

@end

@implementation XLPhotoLayout

- (instancetype)initWithModelArray:(NSArray *)modelArray {
    self = [super init];
    if (self) {
        if (modelArray != nil && modelArray.count > 0) {
            self.modelArray = modelArray;
            [self setupLayoutWithModelArray:modelArray];
        }
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    //    NSLog(@"%@", self.attrsArray);
}

- (void)setupLayoutWithModelArray:(NSArray *)modelArray {
    
    // 没数据
    if (modelArray.count <= 0) {
        _modelArrayHeight = 0;
        [self.attrsArray removeAllObjects];
        return;
    }
    
    /// 当前行的最右坐标
    CGFloat currentRowRight = 0;
    
    /// 当前行的最顶坐标
    CGFloat currentRowTop = 0;
    
    /// 是否新起一行
    BOOL isNewLine = YES;
    
    /// 当前行的图片数组
    NSMutableArray *rowItmesArray = [NSMutableArray array];
    
    
    for (NSInteger i = 0; i < modelArray.count; i++) {
        
        // 是否是新开一行
        if (isNewLine) {
            isNewLine = NO;
            currentRowRight = 0;
        }
        
        // 取出图片模型
        XLPhotoModel *model = modelArray[i];
        
        // 根据基准高度计算一个基准宽度
        CGFloat photoBaseWidth = (CGFloat)[model.width floatValue] * kBaseHeight / [model.height floatValue];
        
        // 计算当前行加入新的item之后右边剩余宽度
        CGFloat rightMargin = XLScreenWidth - (currentRowRight + photoBaseWidth);
        
        if (rightMargin > 0) {
            
            // 右边还有剩余间隙
            [rowItmesArray addObject:model];
            currentRowRight += (photoBaseWidth + kMargin);
            
            // 如果超过一行最大数量 直接换行
            if (rowItmesArray.count >= kMaxCountInRowItems) {
                
                currentRowRight -= kMargin;
                currentRowTop = [self rowItemsWithItems:rowItmesArray CurrentRowTop:currentRowTop CurrentRowRight:currentRowRight];
                // 新开一行
                isNewLine = YES;
            }
            
        }else {
            
            // 右边没有剩余间隙 看超过多少 超过1/2基准高就不添加当前行
            CGFloat absRightMargin = fabs(rightMargin);
            
            if (absRightMargin <= kBaseHeight * 0.5) {
                // 不超过1/2基准高 添加到当前行  当前行已完成
                [rowItmesArray addObject:model];
                currentRowRight += photoBaseWidth;
                currentRowTop = [self rowItemsWithItems:rowItmesArray CurrentRowTop:currentRowTop CurrentRowRight:currentRowRight];
                
                // 新开一行
                isNewLine = YES;
            }else {
                // 右边间隙超过1/2基准高
                // rowItems中至少有一张图片，才可以展示
                if (rowItmesArray.count > 0) {
                    
                    currentRowRight -= kMargin;
                    currentRowTop = [self rowItemsWithItems:rowItmesArray CurrentRowTop:currentRowTop CurrentRowRight:currentRowRight];
                    
                    i--;
                    // 新开一行
                    isNewLine = YES;
                }else {
                    /* rowItems中一张图片都没有，这张图片又太扁且宽，
                     * 所以导致仅把这一张图片高度放到sBaseH时，宽度已经超出屏幕太多，这种情况需要特殊处理
                     * 若还是原比例展示，则需要把宽度缩小到屏幕宽度，高度此时可能很小，影响视觉，所以需要规定一个
                     * 最小的高度，让图片剪裁显示
                     */
                    [rowItmesArray addObject:model];
                    CGFloat itemH = [model.height floatValue] * (XLScreenWidth / [model.width floatValue]);
                    if (itemH < kMinItemH) {
                        itemH = kMinItemH;
                    }
                    
                    model.itemX = 0;
                    model.itemY = currentRowTop;
                    model.itemW = XLScreenWidth;
                    model.itemH = itemH;
                    
                    currentRowTop = currentRowTop + itemH + kMargin;
                    // 新开一行
                    isNewLine = YES;
                    
                    [rowItmesArray removeAllObjects];
                }
            }
        }
    }
    
    // 如果遍历结束 行数组中还有item说明 最后一行还有数据，但是不够了，直接完成。
    if (rowItmesArray.count > 0) {
        currentRowRight -= kMargin;
        [self rowItemsWithItems:rowItmesArray CurrentRowTop:currentRowTop CurrentRowRight:currentRowRight];
        [rowItmesArray removeAllObjects];
    }
    
    
    // 遍历出计算好的frame 设置成布局属性
    for (NSInteger i = 0; i < modelArray.count; i++) {
        
        XLPhotoModel *model = modelArray[i];
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        attr.frame = CGRectMake(model.itemX, model.itemY, model.itemW, model.itemH);
        [self.attrsArray addObject:attr];
        
        // 最后一个计算总高度
        if (i == modelArray.count - 1) {
            _modelArrayHeight = model.itemY + model.itemH;
        }
    }
}

/// 所有图的size
- (CGSize)collectionViewContentSize {
    return CGSizeMake(0, self.modelArrayHeight);
}

/// 返回rect范围内的布局属性
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrsArray;
}

- (NSMutableArray *)attrsArray {
    if (!_attrsArray) {
        self.attrsArray = [[NSMutableArray alloc] init];
    }
    return _attrsArray;
}

/// 当前行完成 返回下一行的的顶部坐标
- (CGFloat)rowItemsWithItems:(NSMutableArray *)items CurrentRowTop:(CGFloat)top CurrentRowRight:(CGFloat)rowRight {
    
    // 所有间隙的总宽度
    CGFloat totailMarginW = MAX(0, items.count -1) * kMargin;
    
    // 通过估值计算出的总宽度计算真实高度
    CGFloat realRowHeight = (XLScreenWidth - totailMarginW) * kBaseHeight / (rowRight - totailMarginW);
    
    /// 当前行中最右边的坐标
    CGFloat itemRight = 0;
    
    /// 宽度的溢出量，因为有些条目可能太窄且长，放在行中就特别窄，我们只能取规定的最小宽度，所以最后条目总宽度就会溢出
    CGFloat overflowW = 0;
    
    // 此条目中宽度最宽的图片，万一有宽度溢出时，用来吸收溢出的宽度
    XLPhotoModel *maxWidthModel = [XLPhotoModel new];
    maxWidthModel.itemW = 0;
    CGFloat maxWidthModelInx = 0;
    
    // 计算每一行里itme的frame
    for (NSInteger i = 0; i < items.count; i++) {
        
        XLPhotoModel *model = items[i];
        
        // 通过计算得出的真实宽度
        CGFloat realRowWidth = realRowHeight * ([model.width floatValue] / [model.height floatValue]);
        
        // 这张图片太窄太长了，最小宽度有限制
        if (realRowWidth < kMinItemW) {
            overflowW = overflowW + (kMinItemW - realRowWidth);
            realRowWidth = kMinItemW;
        }
        
        model.itemX = itemRight;
        model.itemY = top;
        model.itemH = realRowHeight;
        model.itemW = realRowWidth;
        
        // 找出最宽的图片
        if (maxWidthModel.itemW < model.itemW) {
            maxWidthModel = model;
            maxWidthModelInx = i;
        }
        
        itemRight += (model.itemW + kMargin);
    }
    
    // 有溢出的宽度，重新计算
    if (overflowW > 0) {
        maxWidthModel.itemW = (maxWidthModel.itemW - overflowW);
        
        // 最大宽度的坐标之后的item需要重新排列一下
        CGFloat newRight = 0;
        for (NSInteger i = 0; i < items.count; i++) {
            if (maxWidthModelInx == i && i != items.count - 1) {
                XLPhotoModel *model = items[i];
                newRight = model.itemX + model.itemW + kMargin;
            }else if (i > maxWidthModelInx) {
                XLPhotoModel *model = items[i];
                model.itemX = newRight;
                newRight += (model.itemW + kMargin);
            }
        }
    }
    
    // 完成的时候清理当前行数据
    [items removeAllObjects];
    return top + realRowHeight + kMargin;
}

- (NSArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

@end
