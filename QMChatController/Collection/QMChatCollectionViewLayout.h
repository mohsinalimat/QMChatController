//
//  QMChatCollectionViewLayout.h
//  QMChatController
//
//  Created by Vitaliy Gorbachov on 6/27/16.
//  Copyright © 2016 Quickblox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMChatCollectionViewLayout : UICollectionViewLayout

@end

@interface QMChatCollectionViewLayoutInspector : NSObject <ASCollectionViewLayoutInspecting>

@end

@protocol QMChatCollectionViewLayoutDelegate <NSObject>

- (NSArray *)items;

@end
