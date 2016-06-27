//
//  QMChatHelpers.m
//  QMChatController
//
//  Created by Vitaliy Gorbachov on 6/24/16.
//  Copyright © 2016 Quickblox. All rights reserved.
//

#import "QMChatHelpers.h"

#include <sys/sysctl.h>

BOOL QMStringEqual(NSString *s1, NSString *s2) {
    
    if (s1.length == 0 && s2.length == 0) {
        
        return YES;
    }
    
    if ((s1 == nil) != (s2 == nil)) {
        
        return NO;
    }
    
    return s1 == nil || [s1 isEqualToString:s2];
}

NSInteger iosMajorVersion() {
    
    static NSInteger version = 0;
    
    if (version == 0) {
        
        version = [UIDevice currentDevice].systemVersion.integerValue;
    }
    
    return version;
}

int cpuCoreCount() {
    
    static int count = 0;
    if (count == 0) {
        
        size_t len;
        unsigned int ncpu;
        
        len = sizeof(ncpu);
        sysctlbyname("hw.ncpu", &ncpu, &len, NULL, 0);
        count = ncpu;
    }
    
    return count;
}

CGSize QMScreenSize() {
    
    static CGSize size;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        UIScreen *screen = [UIScreen mainScreen];
        
        if ([screen respondsToSelector:@selector(fixedCoordinateSpace)]) {
            
            size = [screen.coordinateSpace convertRect:screen.bounds toCoordinateSpace:screen.fixedCoordinateSpace].size;
        }
        else {
            
            size = screen.bounds.size;
        }

    });
    
    return size;
}
