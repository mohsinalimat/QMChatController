//
//  TMessagesFactory.h
//  QMChatController
//
//  Created by Vitaliy Gorbachov on 6/27/16.
//  Copyright © 2016 Quickblox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMessagesFactory : NSObject

+ (NSArray <QBChatMessage *> *)messagesOfAmount:(NSUInteger)amount;
+ (NSArray <QBChatMessage *> *)messagesOfAmount:(NSUInteger)amount randomizedString:(BOOL)flag;

@end
