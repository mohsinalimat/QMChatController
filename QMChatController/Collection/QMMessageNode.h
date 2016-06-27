//
//  QMMessageNode.h
//  QMChatController
//
//  Created by Vitaliy Gorbachov on 6/27/16.
//  Copyright © 2016 Quickblox. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface QMMessageNode : ASCellNode

- (instancetype)initWithTitle:(nullable NSAttributedString *)title
                         text:(NSAttributedString *)text
                         time:(NSAttributedString *)time NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
