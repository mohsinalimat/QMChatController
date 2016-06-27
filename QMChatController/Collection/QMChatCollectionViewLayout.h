//
//  QMChatCollectionViewLayout.h
//  QMChatController
//
//  Created by Vitaliy Gorbachov on 6/27/16.
//  Copyright © 2016 Quickblox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMChatDecorationViewAttributes : NSObject

@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) CGRect frame;

+ (instancetype)decorationAttributeForIndex:(NSInteger)index withFrame:(CGRect)frame;

@end

@interface QMChatCollectionViewLayout : UICollectionViewLayout

@end

@interface QMChatCollectionViewLayoutInspector : NSObject <ASCollectionViewLayoutInspecting>

@end

@protocol QMChatCollectionViewLayoutDelegate <NSObject>

- (NSArray *)items;

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(QMChatCollectionViewLayout *)layout
originalItemSizeAtIndexPath:(NSIndexPath *)indexPath;

@end
