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

#import "QMChatHelpers.h"

@interface QMChatCollectionViewLayout ()
{
    NSMutableArray <UICollectionViewLayoutAttributes *> *_layoutAttributes;
    CGSize _contentSize;
    UIDynamicAnimator *_dynamicAnimator; // WIP: https://www.objc.io/issues/5-ios7/collection-views-and-uidynamics/
    
    NSMutableArray <NSIndexPath *> *_insertIndexPaths;
    NSMutableArray <NSIndexPath *> *_deleteIndexPaths;
    
    NSMutableArray <QMChatDecorationViewAttributes *> *_decorationAttributes;
}

@end

@implementation QMChatDecorationViewAttributes

+ (instancetype)decorationAttributeForIndex:(NSInteger)index withFrame:(CGRect)frame {
    
    QMChatDecorationViewAttributes *pAttributes = [[[self class] alloc] init];
    pAttributes.index = index;
    pAttributes.frame = frame;
    
    return pAttributes;
}

@end

@implementation QMChatCollectionViewLayout

#pragma mark - Construction

- (instancetype)init {
    
    self = [super init];
    if (self != nil) {
        
        _layoutAttributes = [[NSMutableArray alloc] init];
        _decorationAttributes = [[NSMutableArray alloc] init];
        
        if (cpuCoreCount() > 1) {
            // WIP: https://www.objc.io/issues/5-ios7/collection-views-and-uidynamics/
            _dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        }
    }
    
    return self;
}

#pragma mark - UIUpdateSupportHooks

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems {
    
    // Keep track of insert and delete index paths
    [super prepareForCollectionViewUpdates:updateItems];
    
    _deleteIndexPaths = [NSMutableArray array];
    _insertIndexPaths = [NSMutableArray array];
    
    for (UICollectionViewUpdateItem *update in updateItems) {
        
        if (update.updateAction == UICollectionUpdateActionDelete) {
            
            [_deleteIndexPaths addObject:update.indexPathBeforeUpdate];
        }
        else if (update.updateAction == UICollectionUpdateActionInsert) {
            
            [_insertIndexPaths addObject:update.indexPathAfterUpdate];
        }
    }
}

- (void)finalizeCollectionViewUpdates {
    [super finalizeCollectionViewUpdates];
    
    // release the insert and delete index paths
    _deleteIndexPaths = nil;
    _insertIndexPaths = nil;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    
    // Must call super
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    if ([_insertIndexPaths containsObject:itemIndexPath]) {
        
        // only change attributes on inserted cells
        if (attributes == nil) {
            
            attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        }
        
        attributes = [attributes copy];
        
        attributes.transform3D = CATransform3DMakeTranslation(0.0f, -attributes.frame.size.height - 4.0f, 0.0f);
        
        if (itemIndexPath.item != 0 || iosMajorVersion() < 7 || self.collectionView.contentOffset.y < -self.collectionView.contentInset.top - FLT_EPSILON) {
            
            attributes.alpha = 0.0f;
        }
        else {
            
            attributes.alpha = 1.0f;
            attributes.bounds = CGRectMake(0, 0, attributes.frame.size.width, 24.0);
        }
    }
    
    return attributes;
}

// Note: this gets called for all visible cells (not just the deleted ones) and
// even gets called when inserting cells!
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    
    // So far, calling super hasn't been strictly necessary here, but leaving it in
    // for good measure
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    
    if ([_deleteIndexPaths containsObject:itemIndexPath]) {
        
        // only change attributes on deleted cells
        if (attributes == nil) {
            
            //attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        }
        
        attributes = [attributes copy];
        
        // Configure attributes ...
        attributes.alpha = 0.0;
    }
    
    return attributes;
}

#pragma mark - Decorations

static inline CGFloat addDate(CGFloat currentHeight, CGFloat containerWidth, NSInteger index, NSMutableArray <QMChatDecorationViewAttributes *> *pAttributes) {
    
    if (pAttributes != nil) {
        
        [pAttributes addObject:[QMChatDecorationViewAttributes decorationAttributeForIndex:index withFrame:CGRectMake(0, currentHeight, containerWidth, 27.0f)]];
    }
    
    return 27.0f;
}

#pragma mark - Layout calcs

- (NSArray *)layoutAttributesForItems:(NSArray *)items
                       containerWidth:(CGFloat)containerWidth
                            maxHeight:(CGFloat)maxHeight
             decorationViewAttributes:(NSMutableArray <QMChatDecorationViewAttributes *> *)decorationViewAttributes
                        contentHeight:(CGFloat *)contentHeight {
    
    NSMutableArray *layoutAttributes = [[NSMutableArray alloc] init];
    
    CGFloat bottomInset = 0.0f;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        bottomInset = 4.0f;
    }
    else {
        
        bottomInset = 14.0f;
    }
    
    CGFloat currentHeight = bottomInset;
    NSInteger lastMessageDay = NSIntegerMin;
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    NSInteger index = 0;
    
    currentHeight += addDate(currentHeight, containerWidth, index, decorationViewAttributes);
    
    for (index = 0; index < count; index++) {
        
        QMMessageItem *messageItem = items[index];

        NSInteger currentMessageDay = (((NSInteger)messageItem.message.dateSent.timeIntervalSince1970)) / (24 * 60 * 60);
        
        if (lastMessageDay != NSIntegerMin
            && currentMessageDay != lastMessageDay) {
            
            currentHeight += addDate(currentHeight, containerWidth, index, decorationViewAttributes);
        }
        
        lastMessageDay = currentMessageDay;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        
        CGSize itemSize = [self _itemSizeAtIndexPath:indexPath];
        
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectMake(10.0f, currentHeight, itemSize.width, itemSize.height);
        [layoutAttributes addObject:attributes];
        
        currentHeight += itemSize.height;
        if (currentHeight >= maxHeight) {
            
            break;
        }
        
        currentHeight += 4.0f;
    }
    
    currentHeight += 4.0f;
    
    if (contentHeight != NULL) {
        
        *contentHeight = currentHeight;
    }
    
    return layoutAttributes;
}

#pragma mark - UISubclassingHooks

- (void)prepareLayout {
    
    // TODO: complete redo calcilactions
    // this is just test and is not good at all
    
    if ([self.collectionView numberOfSections] == 0) {
        
        return;
    }
    
//    if ([self.collectionView numberOfItemsInSection:0] == 0) {
//        
//        return;
//    }
    
    [_layoutAttributes removeAllObjects];
    [_decorationAttributes removeAllObjects];
    
    CGFloat contentHeight = 0.0f;
    
    NSArray *items = [(id<QMChatCollectionViewLayoutDelegate>)[(ASCollectionView *)self.collectionView asyncDelegate] items];
    
    NSArray *layoutAttributes = [self layoutAttributesForItems:items
                                                containerWidth:CGRectGetWidth(self.collectionView.bounds)
                                                     maxHeight:CGFLOAT_MAX
                                      decorationViewAttributes:_decorationAttributes
                                                 contentHeight:&contentHeight];
    [_layoutAttributes addObjectsFromArray:layoutAttributes];
    
    _contentSize = CGSizeMake(self.collectionView.bounds.size.width, contentHeight);
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

    return [(id<QMChatCollectionViewLayoutDelegate>)[(ASCollectionView *)self.collectionView asyncDelegate] collectionView:self.collectionView layout:self originalItemSizeAtIndexPath:indexPath];
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
