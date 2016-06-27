//
//  QMMessageNode.m
//  QMChatController
//
//  Created by Vitaliy Gorbachov on 6/27/16.
//  Copyright © 2016 Quickblox. All rights reserved.
//

#import "QMMessageNode.h"

@interface QMMessageNode ()
{
    ASTextNode *_titleNode;
    ASTextNode *_textNode;
    ASTextNode *_timeNode;
}

@end

@implementation QMMessageNode

#pragma mark - Construction

- (instancetype)initWithTitle:(NSAttributedString *)title
                         text:(NSAttributedString *)text
                         time:(NSAttributedString *)time {
    
    self = [super init];
    if (self != nil) {
        
        // temp color
        self.backgroundColor = [UIColor greenColor];
        
        if (title.length > 0) {
            
            _titleNode = [[ASTextNode alloc] init];
            _titleNode.attributedText = title;
            _titleNode.layerBacked = YES;
            _titleNode.maximumNumberOfLines = 1;
            _titleNode.flexShrink = YES;
            _titleNode.truncationMode = NSLineBreakByTruncatingTail;
            [self addSubnode:_titleNode];
        }
        
        _textNode = [[ASTextNode alloc] init];
        _textNode.attributedText = text;
        _textNode.layerBacked = YES;
        _textNode.flexShrink = YES;
        [self addSubnode:_textNode];
        
        _timeNode = [[ASTextNode alloc] init];
        _timeNode.attributedText = time;
        _timeNode.layerBacked = YES;
        [self addSubnode:_timeNode];
    }
    
    return self;
}

#pragma mark - Layout

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)__unused constrainedSize {
    
    ASStackLayoutSpec *mainStack = [ASStackLayoutSpec
                                    stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                    spacing:6.0
                                    justifyContent:ASStackLayoutJustifyContentStart
                                    alignItems:ASStackLayoutAlignItemsEnd
                                    children:@[_textNode, _timeNode]];
    
    // set sizeRange to make max width fixed
    //    ASRelativeSize min = ASRelativeSizeMake(ASRelativeDimensionMakeWithPoints(0.0f), ASRelativeDimensionMakeWithPoints(0.0f));
    //    ASRelativeSize max = ASRelativeSizeMake(ASRelativeDimensionMakeWithPoints(200.0f), ASRelativeDimensionMakeWithPoints(CGFLOAT_MAX));
    //    mainStack.sizeRange = ASRelativeSizeRangeMake(min,max);
    
    ASStaticLayoutSpec *staticSpec = [ASStaticLayoutSpec staticLayoutSpecWithChildren:@[mainStack]];
    
    ASInsetLayoutSpec *insetSpec = nil;
    
    if (_titleNode != nil) {
        
        ASStackLayoutSpec *vStack = [ASStackLayoutSpec
                                     stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                     spacing:2.5f
                                     justifyContent:ASStackLayoutJustifyContentStart
                                     alignItems:ASStackLayoutAlignItemsStart
                                     children:@[_titleNode, staticSpec]];
        
        insetSpec = [ASInsetLayoutSpec
                     insetLayoutSpecWithInsets:UIEdgeInsetsMake(2.0f, 4.0f, 2.0f, 4.0f)
                     child:vStack];
    }
    else {
        
        insetSpec = [ASInsetLayoutSpec
                     insetLayoutSpecWithInsets:UIEdgeInsetsMake(2.0f, 4.0f, 2.0f, 4.0f)
                     child:staticSpec];
    }
    
    return insetSpec;
}

@end
