//
//  QMMessageItem.m
//  QMChatController
//
//  Created by Vitaliy Gorbachov on 6/27/16.
//  Copyright © 2016 Quickblox. All rights reserved.
//

#import "QMMessageItem.h"

#import "QMMessageViewModel.h"
#import "QMMessageNode.h"

@implementation QMMessageItem

#pragma mark - Construction

- (instancetype)initWithMessage:(QBChatMessage *)message {
    
    self = [super init];
    if (self != nil) {
        
        _message = message;
        _viewModel = [[QMMessageViewModel alloc] initWithMessage:message];
        _messageNode = [[QMMessageNode alloc] initWithTitle:_viewModel.attributedTitle
                                                       text:_viewModel.attributedText
                                                       time:_viewModel.attributedTime];
    }
    
    return self;
}

#pragma mark - Methods

- (CGSize)sizeForContainerSize:(CGSize)containerSize {
    
    return [self.messageNode measure:containerSize];
}

@end
