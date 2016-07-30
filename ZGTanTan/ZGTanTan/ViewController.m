//
//  ViewController.m
//  ZGTestTanTan
//
//  Created by Zong on 16/7/26.
//  Copyright © 2016年 Zong. All rights reserved.
//

#import "ViewController.h"
#import "ZGTanTanLayout.h"

@interface ViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) CGFloat maxDistance;

@property (nonatomic, assign) CGFloat currentDistance;

@property (nonatomic, assign) CGPoint originalCenter;

@property (nonatomic, weak) UICollectionViewCell *cell1;

@property (nonatomic, weak) UICollectionViewCell *cell2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    [self setupViews];
}

- (void)initialize
{
    self.maxDistance = 200.0;
}

- (void)setupViews
{
    ZGTanTanLayout *tanLayout = [[ZGTanTanLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:tanLayout];
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"tanCollectionViewCell"];
    [self.view addSubview:self.collectionView];
    
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tanCollectionViewCell" forIndexPath:indexPath];
    switch (indexPath.item) {
        case 0:
            cell.backgroundColor = [UIColor redColor];
            break;
        case 1:
            cell.backgroundColor = [UIColor yellowColor];
            self.cell1 = cell;
            break;
        case 2:
            cell.backgroundColor = [UIColor orangeColor];
            self.cell2 = cell;
            break;
        case 3:
            cell.backgroundColor = [UIColor grayColor];
            break;
        default:
            cell.backgroundColor = [UIColor whiteColor];
            break;
    }
    [cell addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)]];
    
//    cell.backgroundColor =  [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    
    return cell;
}

- (void)didPan:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateEnded){
        
        // 判断弹回原来位置，还是弹出屏幕
        if (pan.view.center.x <= 0 || pan.view.center.x >= [UIScreen mainScreen].bounds.size.width) { // 弹出屏幕
            [UIView animateWithDuration:0.25 animations:^{
                CGFloat targetX = pan.view.frame.origin.x > 0 ? CGRectGetMaxX(pan.view.frame) : pan.view.frame.origin.x;
                pan.view.center = CGPointMake(targetX, pan.view.center.y);
            }completion:^(BOOL finished) {
                if (finished == YES) {
                    
                    [self.collectionView removeFromSuperview];
                    [self setupViews];
                }
            }];
            
        }else { // 弹回原来位置
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
                pan.view.center = self.originalCenter;
            } completion:nil];
            
            [UIView animateWithDuration:0.5 animations:^{
                self.cell1.layer.transform = [self transform3DWith:[NSIndexPath indexPathForItem:1 inSection:0] distanceRate:0];
                self.cell2.layer.transform = [self transform3DWith:[NSIndexPath indexPathForItem:2 inSection:0] distanceRate:0];
            }];
        }
        return;
    }
    
    
    if (self.originalCenter.x == 0 && self.originalCenter.y == 0) {
        self.originalCenter = pan.view.center;
    }
    CGPoint point = [pan translationInView:self.collectionView];
    pan.view.center = CGPointMake(pan.view.center.x + point.x, pan.view.center.y + point.y);
    [pan setTranslation:CGPointMake(0, 0) inView:self.view];
    
    [self changeLayoutWithView:pan.view OriginalPoint:self.originalCenter currentPoint:pan.view.center];
}


- (void)changeLayoutWithView:(UIView *)view OriginalPoint:(CGPoint)originalPoint currentPoint:(CGPoint)currentPoint
{
    // 计算两点距离
    CGFloat distanceX = currentPoint.x - self.originalCenter.x;
    CGFloat distanceY = currentPoint.y - self.originalCenter.y;
    self.currentDistance = sqrt(distanceX * distanceX + distanceY * distanceY);
    ZGTanTanLayout *layout = (ZGTanTanLayout *)self.collectionView.collectionViewLayout;
    CGFloat distRate = self.currentDistance / self.maxDistance;
    layout.distanceRate = distRate > 1.0 ? 1 : distRate ;
    layout.panCell = (UICollectionViewCell *)view;
    // 处理tanLayout
    [self.collectionView.collectionViewLayout invalidateLayout];

}


- (CATransform3D)transform3DWith:(NSIndexPath *)indexPath distanceRate:(CGFloat)distanceRate
{
    CGFloat translationY = (indexPath.item + distanceRate) * -17;
    CGFloat translationZ = (indexPath.item + distanceRate) * 1;
     CATransform3D transform3D = CATransform3DMakeTranslation(0, translationY, translationZ);
    
    CGFloat scaleX = (0.7 + (indexPath.item + distanceRate)* 0.1);
    CGFloat scaleY = scaleX;
    transform3D = CATransform3DScale(transform3D, scaleX, scaleY, 1);
    return transform3D;

}

@end
