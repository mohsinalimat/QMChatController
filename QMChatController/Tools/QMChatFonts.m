//
//  QMChatFonts.m
//  QMChatController
//
//  Created by Vitaliy Gorbachov on 6/24/16.
//  Copyright © 2016 Quickblox. All rights reserved.
//

#import "QMChatFonts.h"

// helpers
#import "QMChatHelpers.h"

UIFont *QMSystemFontOfSize(CGFloat size) {
    
    static BOOL useSystem = NO;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        useSystem = iosMajorVersion() >= 9;
    });
    
    
    if (useSystem) {
        
        return [UIFont systemFontOfSize:size];
    }
    else {
        
        return [UIFont fontWithName:@"HelveticaNeue" size:size];
    }
}

UIFont *QMMediumSystemFontOfSize(CGFloat size) {
    
    static BOOL useSystem = NO;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        useSystem = iosMajorVersion() >= 9;
    });
    
    if (useSystem) {
        
        return [UIFont systemFontOfSize:size weight:UIFontWeightMedium];
    }
    else {
        
        return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
    }
}
