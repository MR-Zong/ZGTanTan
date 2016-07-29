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
            break;
        case 2:
            cell.backgroundColor = [UIColor orangeColor];
            break;
        case 3:
            cell.backgroundColor = [UIColor grayColor];
            [cell addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)]];
            break;
        default:
            cell.backgroundColor = [UIColor whiteColor];
            break;
    }
    
    return cell;
}

- (void)didPan:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateEnded){
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionNone animations:^{
            pan.view.center = self.originalCenter;
        } completion:nil];
        return;
    }
    if (self.originalCenter.x == 0 && self.originalCenter.y == 0) {
        self.originalCenter = pan.view.center;
    }
    CGPoint point = [pan translationInView:self.collectionView];
    pan.view.center = CGPointMake(pan.view.center.x + point.x, pan.view.center.y + point.y);
    [pan setTranslation:CGPointMake(0, 0) inView:self.view];
    
    CGFloat distanceX = pan.view.center.x - self.originalCenter.x;
    CGFloat distanceY = pan.view.center.y - self.originalCenter.y;
    self.currentDistance = sqrt(distanceX * distanceX + distanceY * distanceY);
    ZGTanTanLayout *layout = (ZGTanTanLayout *)self.collectionView.collectionViewLayout;
    CGFloat distRate = self.currentDistance / self.maxDistance;
    layout.distanceRate = distRate > 1.0 ? 1 : distRate ;
    layout.panCell = (UICollectionViewCell *)pan.view;
    // 处理tanLayout
    [self.collectionView.collectionViewLayout invalidateLayout];
}

@end
