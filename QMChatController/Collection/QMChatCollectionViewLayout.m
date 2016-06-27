//
//  QMChatCollectionViewLayout.m
//  QMChatController
//
//  Created by Vitaliy Gorbachov on 6/27/16.
//  Copyright © 2016 Quickblox. All rights reserved.
//

// TODO:
// Redo calculaction, right now this class is complete mess %)

#import "QMChatCollectionViewLayout.h"

#import "QMMessageItem.h"

@interface QMChatCollectionViewLayout ()
{
    NSMutableArray <UICollectionViewLayoutAttributes *> *_layoutAttributes;
    CGSize _contentSize;
}

@end

@implementation QMChatCollectionViewLayout

#pragma mark - Construction

- (instancetype)init {
    
    self = [super init];
    if (self != nil) {
        
        _layoutAttributes = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark - UISubclassingHooks

- (void)prepareLayout {
    
    // TODO: complete redo calcilactions
    // this is just test and is not good at all
    
    if ([self.collectionView numberOfSections] == 0) {
        
        return;
    }
    
    [_layoutAttributes removeAllObjects];
    
    CGFloat currentHeight = 0.0f;
    
    currentHeight += 10.0f; // top inset
    
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger index = 0; index < numberOfItems; index++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        
        CGSize itemSize = [self _itemSizeAtIndexPath:indexPath];
        
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectMake(10.0f, currentHeight, itemSize.width, itemSize.height);
        [_layoutAttributes addObject:attributes];
        
        currentHeight += itemSize.height;
        currentHeight += 10.0f; // THIS IS HARDCODED INSET :D
    }
    
    _contentSize = CGSizeMake(self.collectionView.bounds.size.width, currentHeight);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (UICollectionViewLayoutAttributes *attributes in _layoutAttributes) {
        
        if (!CGRectIsNull(CGRectIntersection(rect, attributes.frame)))
            [array addObject:attributes];
    }
    
    return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row >= (NSInteger)_layoutAttributes.count) {
        
        return nil;
    }
    
    return _layoutAttributes[indexPath.row];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    if (!CGSizeEqualToSize(self.collectionView.bounds.size, newBounds.size)) {
        
        return YES;
    }
    
    return NO;
}

- (CGSize)collectionViewContentSize {
    
    return _contentSize;
}

#pragma mark - Private methods

- (CGSize)_itemSizeAtIndexPath:(NSIndexPath *)indexPath {
    
    // TODO: refactor this using own data source implementation to ask controller for item node size
    
    NSArray *items = [(id<QMChatCollectionViewLayoutDelegate>)[(ASCollectionView *)self.collectionView asyncDelegate] items];
    
    QMMessageItem *messageItem = items[indexPath.item];
    
    CGFloat maxWidth = CGRectGetWidth([UIScreen mainScreen].bounds) * 0.8; // 80% of screen max, TODO: normal insets
    CGSize itemSize = [messageItem sizeForContainerSize:CGSizeMake(maxWidth, CGFLOAT_MAX)];
    
    return itemSize;
}

@end

@implementation QMChatCollectionViewLayoutInspector

- (ASSizeRange)collectionView:(ASCollectionView *)collectionView constrainedSizeForNodeAtIndexPath:(NSIndexPath *)indexPath {
    
    QMChatCollectionViewLayout *layout = (QMChatCollectionViewLayout *)[collectionView collectionViewLayout];
    return ASSizeRangeMake(CGSizeZero, [layout _itemSizeAtIndexPath:indexPath]);
}

- (ASSizeRange)collectionView:(ASCollectionView *)collectionView constrainedSizeForSupplementaryNodeOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    return ASSizeRangeMake(CGSizeZero, CGSizeZero);
}

/**
 * Asks the inspector for the number of supplementary sections in the collection view for the given kind.
 */
- (NSUInteger)collectionView:(ASCollectionView *)collectionView numberOfSectionsForSupplementaryNodeOfKind:(NSString *)kind {
    
    return 0;
}

/**
 * Asks the inspector for the number of supplementary views for the given kind in the specified section.
 */
- (NSUInteger)collectionView:(ASCollectionView *)collectionView supplementaryNodesOfKind:(NSString *)kind inSection:(NSUInteger)section {
    
    return 0;
}

@end
