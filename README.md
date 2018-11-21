# XLPhotoWall
模仿500px、图虫之类的图片自动布局展示（自定义每行展示数量，item最小间距）

![iOS 9.0+](https://img.shields.io/badge/iOS-9.0%2B-blue.svg)
![MIT](https://img.shields.io/github/license/mashape/apistatus.svg)

XLPhotoWall是一个用于展示图片宽高自动布局的库。

![](https://github.com/Sum123/XLPhotoWall/blob/master/Snip20181121_3.png?raw=true)
![](https://github.com/Sum123/XLPhotoWall/blob/master/demo.gif?raw=true)

## Example
    self.layout = [[XLPhotoLayout alloc] initWithModelArray:self.testData];
    [self.collectionView reloadData];
    [self.collectionView setCollectionViewLayout:self.layout animated:NO];
        
    
## Features
1. 可以设置每个item的间隔大小。
2. 每行最多容许几张图片。
3. 过滤异常尺寸图片，特别扁的图片的最小高度， 特别长的图片的最小宽度。

## Requirements

- iOS 9.0+
- Swift 4