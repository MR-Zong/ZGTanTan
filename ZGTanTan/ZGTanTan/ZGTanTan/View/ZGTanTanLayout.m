//
//  ZGTanTanLayout.m
//  ZGTestTanTan
//
//  Created by Zong on 16/7/26.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import "ZGTanTanLayout.h"

@implementation ZGTanTanLayout

- (void)prepareLayout
{
    [super prepareLayout];
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    
    attr.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 250) / 2.0, 250, 250, 250);
//    attr.zIndex = indexPath.item * 2;
    
    NSInteger tmpItem = indexPath.item;
    if (tmpItem == self.startIndex) {
        tmpItem = 1;
    }else {
        for (int i=1; i<self.numberOfCellInRect; i++) {
            if (tmpItem == self.startIndex + i) {
                tmpItem = i;
            }
        }
    }

    // y,z轴，scale要变
    CGFloat translationY = (tmpItem + self.distanceRate) * -17;
    CGFloat translationZ = (tmpItem + self.distanceRate) * 1;
    attr.transform3D = CATransform3DMakeTranslation(0, translationY, translationZ);
    
    CGFloat scaleX = (0.7 + (tmpItem + self.distanceRate)* 0.1);
    CGFloat scaleY = scaleX;
    attr.transform3D = CATransform3DScale(attr.transform3D, scaleX, scaleY, 1);
    return attr;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 可显示Rect中总是要有self.numberOfCellInRect(4)个cell
        NSMutableArray *mArray = [NSMutableArray array];
    
    for (int i=self.startIndex; i<=self.endIndex; i++) { // 返回界面上的4个cell
        NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        if ( self.panStart == YES) {
            if(i == self.startIndex){
                [mArray addObject:self.bottomLayoutAttribute];
            }else if (i == self.endIndex) {
                [mArray addObject:self.topLayoutAttribute];
            } else {
                UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:tmpIndexPath];
                [mArray addObject:attr];
            }
            
        }else {
            UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:tmpIndexPath];
            if (i == self.startIndex) {
                self.bottomLayoutAttribute = attr;
            }else if (i == self.endIndex) {
                self.topLayoutAttribute = attr;
            }
            [mArray addObject:attr];
        }

    }

    return mArray.copy;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
}

#pragma mark - setter
- (void)setEndIndex:(int)endIndex
{
    _endIndex = endIndex;
    _startIndex = (int)((endIndex - self.numberOfCellInRect + 1) >= 0 ? (endIndex - self.numberOfCellInRect + 1) : 0 );
}

@end
