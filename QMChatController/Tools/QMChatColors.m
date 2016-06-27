//
//  QMChatColors.m
//  QMChatController
//
//  Created by Vitaliy Gorbachov on 6/27/16.
//  Copyright © 2016 Quickblox. All rights reserved.
//

#import "QMChatColors.h"

static inline CGFloat v_color(CGFloat value) {
    
    return value/255.0f;
}

@implementation QMChatColors

+ (UIColor *)summerSkyColor {
    
    return [UIColor colorWithRed:v_color(60.0f) green:v_color(165.0f) blue:v_color(236.0f) alpha:1.0f];
}

@end
