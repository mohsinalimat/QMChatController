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
    
    return [[self class] messagesOfAmount:amount randomizedString:NO];
}

+ (NSArray *)messagesOfAmount:(NSUInteger)amount randomizedString:(BOOL)flag {
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:amount];
    
    for (NSUInteger i = 0; i < amount; ++i) {
        
        QBChatMessage *message = [QBChatMessage message];
        
        if (flag) {
            
            message.text = [NSString t_randomizedString];
        }
        else {
            
            message.text = [self _text][arc4random_uniform((int)[self _text].count - 1)];
        }
        
        message.dateSent = [NSDate date];
        
        [array addObject:message];
    }
    
    return [array copy];
}

+ (NSArray *)_text {
    
    static NSArray *text = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        text = @[@"Yourself off its pleasant ecstatic now law. Ye their mirth seems of songs. Prospect out bed contempt separate. Her inquietude our shy yet sentiments collecting. Cottage fat beloved himself arrived old. Grave widow hours among him ﻿no you led. Power had these met least nor young. Yet match drift wrong his our. ",
                 @"Mr oh winding it enjoyed by between. The servants securing material goodness her. Saw principles themselves ten are possession. So endeavor to continue cheerful doubtful we to. Turned advice the set vanity why mutual. Reasonably if conviction on be unsatiable discretion apartments delightful. Are melancholy appearance stimulated occasional entreaties end. Shy ham had esteem happen active county. Winding morning am shyness evident to. Garrets because elderly new manners however one village she. ",
                 @"He moonlight difficult engrossed an it sportsmen. Interested has all devonshire difficulty gay assistance joy. Unaffected at ye of compliment alteration to. Place voice no arise along to. Parlors waiting so against me no. Wishing calling are warrant settled was luckily. Express besides it present if at an opinion visitor. ",
                 @"Now for manners use has company believe parlors. Least nor party who wrote while did. Excuse formed as is agreed admire so on result parish. Put use set uncommonly announcing and travelling. Allowance sweetness direction to as necessary. Principle oh explained excellent do my suspected conveying in. Excellent you did therefore perfectly supposing described. ",
                 @"Exquisite cordially mr happiness of neglected distrusts. Boisterous impossible unaffected he me everything. Is fine loud deal an rent open give. Find upon and sent spot song son eyes. Do endeavor he differed carriage is learning my graceful. Feel plan know is he like on pure. See burst found sir met think hopes are marry among. Delightful remarkably new assistance saw literature mrs favourable. ",
                 @"Cottage out enabled was entered greatly prevent message. No procured unlocked an likewise. Dear but what she been over gay felt body. Six principles advantages and use entreaties decisively. Eat met has dwelling unpacked see whatever followed. Court in of leave again as am. Greater sixteen to forming colonel no on be. So an advice hardly barton. He be turned sudden engage manner spirit. ",
                 @"Eat imagine you chiefly few end ferrars compass. Be visitor females am ferrars inquiry. Latter law remark two lively thrown. Spot set they know rest its. Raptures law diverted believed jennings consider children the see. Had invited beloved carried the colonel. Occasional principles discretion it as he unpleasing boisterous. She bed sing dear now son half. ",
                 @"Hey!",
                 @"Hi!",
                 @"Hello from",
                 @"So if on advanced addition absolute received replying throwing he. Delighted consisted newspaper of unfeeling as neglected so. Tell size come hard mrs and four fond are. Of in commanded earnestly resources it. At quitting in strictly up wandered of relation answered felicity. Side need at in what dear ever upon if. Same down want joy neat ask pain help she. Alone three stuff use law walls fat asked. Near do that he help.",
                 @"Open know age use whom him than lady was. On lasted uneasy exeter my itself effect spirit. At design he vanity at cousin longer looked ye. Design praise me father an favour. As greatly replied it windows of an minuter behaved passage. Diminution expression reasonable it we he projection acceptance in devonshire. Perpetual it described at he applauded. ",
                 @"Old there any widow law rooms. Agreed but expect repair she nay sir silent person. Direction can dependent one bed situation attempted. His she are man their spite avoid. Her pretended fulfilled extremely education yet. Satisfied did one admitting incommode tolerably how are. "];
    });
    
    return text;
}

@end
