//
//  ViewController.m
//  StickyViews
//
//  Created by derrick on 6/4/13.
//  Copyright (c) 2013 derrh. All rights reserved.
//

#import "ViewController.h"
#import "MyHeaderOrFooterView.h"


@interface ViewController ()

@end

@implementation ViewController

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 94;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        view.backgroundColor = [UIColor orangeColor];
    } else {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:indexPath];
        view.backgroundColor = [UIColor blueColor];
    }
    return view;
}

@end
