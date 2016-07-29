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
    attr.frame = CGRectMake(100, 300, 250, 250);
//    attr.zIndex = indexPath.item * 2;
    // y,z轴，scale要变
    CGFloat translationY = (indexPath.item + self.distanceRate) * -20;
    CGFloat translationZ = (indexPath.item + self.distanceRate) * 10;
    attr.transform3D = CATransform3DMakeTranslation(0, translationY, translationZ);
    
    CGFloat scaleX = (0.6 + (indexPath.item + self.distanceRate)* 0.1);
    CGFloat scaleY = scaleX;
    attr.transform3D = CATransform3DScale(attr.transform3D, scaleX, scaleY, 1);
    return attr;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSIndexPath *invalidIndexPath = [self.collectionView indexPathForCell:self.panCell];
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i=0; i<5; i++) {
        NSIndexPath *validIndexPath = [NSIndexPath indexPathForItem:i inSection:0];
        if ( invalidIndexPath && i == invalidIndexPath.item) {
            [mArray addObject:self.panLayoutAttribute];
        }else {
            UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:validIndexPath];
            if (i == 4) {
                self.panLayoutAttribute = attr;
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

@end
