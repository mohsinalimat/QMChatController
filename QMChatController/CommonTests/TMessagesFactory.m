//
//  TMessagesFactory.m
//  QMChatController
//
//  Created by Vitaliy Gorbachov on 6/27/16.
//  Copyright © 2016 Quickblox. All rights reserved.
//

#import "TMessagesFactory.h"

static const int minChars = 10;
static const int maxChars = 200;

@interface NSString (Random)

+ (id)t_randomizedString;

@end

#include <stdlib.h>

@implementation NSString (Random)

static NSString * const pAlphabet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";

int rand() {
    
    return arc4random_uniform(maxChars - minChars) + minChars;
}

+ (id)t_randomizedString {
    
    return [[self alloc] initWithAlphabet:pAlphabet length:rand()];
}

#pragma GCC diagnostic ignored "-Wobjc-designated-initializers"

- (id)initWithAlphabet:(NSString *)alphabet length:(NSUInteger)len {
    
    NSMutableString *s = [NSMutableString stringWithCapacity:len];
    
    for (NSUInteger i = 0U; i < len; i++) {
        
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    
    return [s copy];
}

@end

@implementation TMessagesFactory

+ (NSArray *)messagesOfAmount:(NSUInteger)amount {
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:amount];
    
    for (NSUInteger i = 0; i < amount; ++i) {
        
        QBChatMessage *message = [QBChatMessage message];
        message.text = [NSString t_randomizedString];
        message.dateSent = [NSDate date];
        
        [array addObject:message];
    }
    
    return [array copy];
}

@end
