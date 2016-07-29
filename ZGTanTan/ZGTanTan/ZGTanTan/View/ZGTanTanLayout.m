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
    attr.frame = CGRectMake(100, 250, 250, 250);
//    attr.zIndex = indexPath.item * 2;
    
    NSInteger tmpItem = indexPath.item;
    if (tmpItem == 0 || tmpItem == 1) {
        tmpItem = 1;
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
    NSIndexPath *panIndexPath = [self.collectionView indexPathForCell:self.panCell];
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        if ( panIndexPath) {
            if (i == panIndexPath.item) {
                [mArray addObject:self.topLayoutAttribute];
            }else if(i == 0){
                [mArray addObject:self.bottomLayoutAttribute];
            }else {
                UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:tmpIndexPath];
                [mArray addObject:attr];
            }
            
        }else {
            UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:tmpIndexPath];
            if (i == 0) {
                self.bottomLayoutAttribute = attr;
            }else if (i == 3) {
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

@end
