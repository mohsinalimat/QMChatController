//
//  QMMessageViewModel.h
//  QMChatController
//
//  Created by Vitaliy Gorbachov on 6/27/16.
//  Copyright © 2016 Quickblox. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMMessageViewModel : NSObject

@property (strong, nonatomic, readonly) QBChatMessage *message;

@property (strong, nonatomic, readonly, nullable) NSAttributedString *attributedTitle;
@property (strong, nonatomic, readonly, nullable) NSAttributedString *attributedText;
@property (strong, nonatomic, readonly, nullable) NSAttributedString *attributedTime;

- (instancetype)initWithMessage:(QBChatMessage *)message;

@end

NS_ASSUME_NONNULL_END
