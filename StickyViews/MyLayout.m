//
//  MyLayout.m
//  StickyViews
//
//  Created by derrick on 6/4/13.
//  Copyright (c) 2013 derrh. All rights reserved.
//

#import "MyLayout.h"

@implementation MyLayout


/* in order to make the header and footer float (or stick to the
   top and bottom of the screen), we need to invalidate the layout
   on bounds change (when scrolling).
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

/* override this method so that you can add your header and footer
   to the list of UICollectionReusableView's that will be requested
   from your dataSource.
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allItems = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    __block BOOL headerFound = NO;
    __block BOOL footerFound = NO;
    [allItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj representedElementKind] isEqualToString:UICollectionElementKindSectionHeader]) {
            headerFound = YES;
            [self updateHeaderAttributes:obj];
        } else if ([[obj representedElementKind] isEqualToString:UICollectionElementKindSectionFooter]) {
            footerFound = YES;
            [self updateFooterAttributes:obj];
        }
    }];
    
    
    // Flow layout will remove items from the list if they are supposed to be off screen, so we add them
    // back in in those cases.
    if (!headerFound) {
        [allItems addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:[allItems count] inSection:0]]];
    }
    if (!footerFound) {
        [allItems addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:[allItems count] inSection:0]]];
    }
    
    return allItems;
}

/* now provide the layout attributes for your floating header/footer. */
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    attributes.size = CGSizeMake(self.collectionView.bounds.size.width, 44);
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        [self updateHeaderAttributes:attributes];
    } else {
        [self updateFooterAttributes:attributes];
    }
    return attributes;
}

#pragma mark - make things stick

- (void)updateHeaderAttributes:(UICollectionViewLayoutAttributes *)attributes
{
    CGRect currentBounds = self.collectionView.bounds;
    attributes.zIndex = 1;
    attributes.hidden = NO;
    CGFloat yCenterOffset = currentBounds.origin.y + attributes.size.height/2.f;
    attributes.center = CGPointMake(CGRectGetMidX(currentBounds), yCenterOffset);
}

- (void)updateFooterAttributes:(UICollectionViewLayoutAttributes *)attributes
{
    CGRect currentBounds = self.collectionView.bounds;
    attributes.zIndex = 1;
    attributes.hidden = NO;
    CGFloat yCenterOffset = currentBounds.origin.y + currentBounds.size.height - attributes.size.height/2.0f;
    attributes.center = CGPointMake(CGRectGetMidX(currentBounds), yCenterOffset);
}
@end
