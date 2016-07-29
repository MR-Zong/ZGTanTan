//
//  ZGTanTanLayout.h
//  ZGTestTanTan
//
//  Created by Zong on 16/7/26.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZGTanTanLayout : UICollectionViewLayout

@property (nonatomic, assign) CGFloat distanceRate;

@property (nonatomic, weak) UICollectionViewCell *panCell;

@property (nonatomic, strong) UICollectionViewLayoutAttributes *panLayoutAttribute;

@end
