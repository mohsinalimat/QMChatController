//
//  QMMessageViewModel.m
//  QMChatController
//
//  Created by Vitaliy Gorbachov on 6/27/16.
//  Copyright © 2016 Quickblox. All rights reserved.
//

#import "QMMessageViewModel.h"

// tools
#import "QMChatHelpers.h"
#import "QMChatFonts.h"
#import "QMChatDateUtils.h"
#import "QMChatColors.h"

CGFloat textFontSize() {
    
    static CGFloat textFontSize = 0.0f;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        CGFloat minTextFontSize = 0.0f;
        CGFloat maxTextFontSize = 0.0f;
        CGFloat defaultTextFontSize = 0.0f;
        
        CGSize screenSize = QMScreenSize();
        CGFloat screenSide = MAX(screenSize.width, screenSize.height);
        BOOL isLargeScreen = screenSide >= 667.0f - FLT_EPSILON;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            
            minTextFontSize = 12.0f;
            maxTextFontSize = 24.0f;
            
            if (isLargeScreen) {
                
                defaultTextFontSize = 17.0f;
            }
            else {
                
                defaultTextFontSize = 16.0f;
            }
            
            CGFloat fontSize = [UIFont preferredFontForTextStyle:UIFontTextStyleBody].pointSize - (isLargeScreen ? 0 : 1.0f);
            textFontSize = MAX(minTextFontSize, MIN(maxTextFontSize, fontSize));
        }
        else {
            
            minTextFontSize = 13.0f;
            maxTextFontSize = 25.0f;
            defaultTextFontSize = 17.0f;
            
            // TODO: font calcs for ipads
            textFontSize = defaultTextFontSize;
        }
    });
    
    return textFontSize;
}

@interface QMMessageViewModel ()

@end

@implementation QMMessageViewModel

- (instancetype)initWithMessage:(QBChatMessage *)message {
    
    self = [super init];
    if (self != nil) {
        
        _message = message;
        
        NSString *title = @"Vitaliy Gorbachov";
        if (true) {
            
            _attributedTitle = [[NSAttributedString alloc]
                               initWithString:title
                               attributes:@{NSFontAttributeName : QMSystemFontOfSize(14.0f),
                                            NSForegroundColorAttributeName : [QMChatColors summerSkyColor]}];
        }
        
        NSString *messageText = message.text;
        if (messageText != nil) {
            
            _attributedText = [[NSAttributedString alloc]
                               initWithString:messageText
                               attributes:@{NSFontAttributeName : QMSystemFontOfSize(textFontSize()),
                                            NSForegroundColorAttributeName : [UIColor blackColor]}];
        }
        
        NSDate *messageDate = message.dateSent;
        if (messageDate != nil) {
            
            NSString *time = [QMChatDateUtils formatDateForTimeRange:messageDate];
            
            _attributedTime = [[NSAttributedString alloc]
                               initWithString:time
                               attributes:@{NSFontAttributeName : QMSystemFontOfSize(11.0f),
                                            NSForegroundColorAttributeName : [UIColor grayColor]}];
        }
    }
    
    return self;
}

@end
