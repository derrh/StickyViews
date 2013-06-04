** Making Supplementary Views Float **

This example will be using a subclass of `UICollectionViewFlowLayout`. You can achieve a similar effect with a purely custom `UICollectionViewLayout` subclass, but for simplicity we will be using flow layout.

First you will need to make sure that your `UICollectionView` instance is using your custom layout. You can do this by selecting the layout object in your nib or storyboard within the collection view object, or by setting the `collectionViewLayout` property on your collection view in your view controller's `viewDidLoad:` method.

Next add a prototype header or footer view, or register a class for the `kind` of supplementary view you wish to float with the appropriate reuse identifier. If you provide a header or footer view in your nib or storyboard file, then the kind will be `UICollectionElementKindSectionHeader` or `UICollectionElementKindSectionFooter` respectively.

Then subclass `UICollectionViewFlowLayout` and override the following methods:

You should override this so that as the view scrolls you will get a chance to update the position of the floating view(s). This gets queried every time the bounds changes.

    - (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
    {
        return YES;
    }

 
This method is the master list of all elements that should be visible in your collection view. Make sure that it contains a UICollectionViewLayoutAttributes object for each of your floating views.

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

 
Finally, override this method to make sure that you provide the correct layout attributes for a single supplementary view (also, if you were paying close attention we used this method in `layoutAttributesForElementsInRect:`).

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

 
And then implement the following helper methods

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

