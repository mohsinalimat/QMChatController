//
//  QMMessageItem.h
//  QMChatController
//
//  Created by Vitaliy Gorbachov on 6/27/16.
//  Copyright © 2016 Quickblox. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QMMessageViewModel;
@class QMMessageNode;

NS_ASSUME_NONNULL_BEGIN

@interface QMMessageItem : NSObject

@property (strong, nonatomic, readonly) QBChatMessage *message;
@property (strong, nonatomic, readonly) QMMessageViewModel *viewModel;
@property (strong, nonatomic, readonly) QMMessageNode *messageNode;

- (instancetype)initWithMessage:(QBChatMessage *)message;

- (CGSize)sizeForContainerSize:(CGSize)containerSize;

@end

NS_ASSUME_NONNULL_END
