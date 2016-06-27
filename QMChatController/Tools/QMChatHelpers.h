//
//  QMChatHelpers.h
//  QMChatController
//
//  Created by Vitaliy Gorbachov on 6/24/16.
//  Copyright © 2016 Quickblox. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#ifdef __cplusplus
extern "C" {
#endif
    
    BOOL QMStringEqual(NSString *s1, NSString *s2);
    
    NSInteger iosMajorVersion();
    int cpuCoreCount();
    
    CGSize QMScreenSize();
    
#ifdef __cplusplus
}
#endif

#ifdef __LP64__
#   define CGFloor floor
#else
#   define CGFloor floorf
#endif

#define CGRectOfSize(size) \
(CGRect) {CGPointZero, size};
