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

@property (nonatomic, assign) BOOL panStart;

@property (nonatomic, strong) UICollectionViewLayoutAttributes *topLayoutAttribute;

@property (nonatomic, strong) UICollectionViewLayoutAttributes *bottomLayoutAttribute;

@property (nonatomic, assign) int endIndex;

@property (nonatomic, assign) int startIndex;

@property (nonatomic, assign) int numberOfCellInRect;

@end
