//
//  ViewController.m
//  XLPhotoWall
//
//  Created by 夏磊 on 2018/11/21.
//  Copyright © 2018 夏磊. All rights reserved.
//

#import "ViewController.h"
#import "XLPhotoModel.h"
#import "XLPhotoLayout.h"
#import "XLCollectionViewCell.h"

#define iPhoneX ([UIApplication sharedApplication].statusBarFrame.size.height > 20 ? YES : NO)
#define XLScreenW [[UIScreen mainScreen] bounds].size.width
#define XLScreenH [[UIScreen mainScreen] bounds].size.height
#define XLStatusBarH (iPhoneX ? 44.0f : 20.0f)
#define XLNavBarH 44.0f
#define XLTopH (XLStatusBarH + XLNavBarH)
#define XLBottomH (iPhoneX ? 34.0f : 0.0f)

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) XLPhotoLayout *layout;

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *testData;

@end

@implementation ViewController

// MARK: - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    
    self.layout = [[XLPhotoLayout alloc] initWithModelArray:self.testData];
    [self.collectionView reloadData];
    [self.collectionView setCollectionViewLayout:self.layout animated:NO];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.testData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XLCollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed: arc4random() % 256 /255.0 green: arc4random() % 256 /255.0 blue: arc4random() % 256 /255.0 alpha:1.0];
    cell.lab.text = [NSString stringWithFormat:@"%zd", indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.testData removeAllObjects];
    self.testData = nil;
    self.layout = [[XLPhotoLayout alloc] initWithModelArray:self.testData];
    
    [self.collectionView reloadData];
    [self.collectionView setCollectionViewLayout:self.layout animated:YES];
}


// MARK: - Lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, XLTopH, XLScreenW, XLScreenH - XLTopH - XLBottomH) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[XLCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([XLCollectionViewCell class])];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (XLPhotoLayout *)layout {
    if (!_layout) {
        _layout = [XLPhotoLayout new];
    }
    return _layout;
}

- (NSMutableArray *)testData {
    if (!_testData) {
        NSMutableArray *mArray = [NSMutableArray array];
        for (int i = 0; i < 50; i++) {
            
            XLPhotoModel *model = [XLPhotoModel new];
            
            NSInteger randomW = 200 + arc4random() % 801; // (500 - 1000)
            NSInteger randomH = 200 + arc4random() % 801; // (500 - 1000)
            
            model.width     = [NSString stringWithFormat:@"%zd", randomW];
            model.height    = [NSString stringWithFormat:@"%zd", randomH];
            
            [mArray addObject:model];
        }
        _testData = [NSMutableArray arrayWithArray:mArray.copy];
    }
    return _testData;
}

@end
