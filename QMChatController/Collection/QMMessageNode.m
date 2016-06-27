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
        self.backgroundColor = [UIColor whiteColor];
        
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

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    [_titleNode measure:constrainedSize.max];
    [_textNode measure:constrainedSize.max];
    [_timeNode measure:constrainedSize.max];
    
    id<ASLayoutable> topRule = nil;
    
    if (_titleNode != nil) {
        
        topRule = [ASStackLayoutSpec
                   stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                   spacing:2.5f
                   justifyContent:ASStackLayoutJustifyContentStart
                   alignItems:ASStackLayoutAlignItemsStart
                   children:@[_titleNode, _textNode]];
    }
    else {
        
        topRule = _textNode;
    }
    
    ASLayoutSpec *finalSpec = nil;
    
    BOOL shouldStay = _titleNode != nil && (_titleNode.calculatedSize.width > _textNode.calculatedSize.width + _timeNode.calculatedSize.width);
    
    if (_textNode.lineCount > 1
        || shouldStay) {
        
        ASRelativeLayoutSpec *relativeSpec = [ASRelativeLayoutSpec
                                              relativePositionLayoutSpecWithHorizontalPosition:ASRelativeLayoutSpecPositionEnd
                                              verticalPosition:ASRelativeLayoutSpecPositionEnd
                                              sizingOption:ASRelativeLayoutSpecSizingOptionDefault
                                              child:_timeNode];
        
        finalSpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:topRule overlay:relativeSpec];
    }
    else {
        
        ASStackLayoutSpec *stackSpec = [ASStackLayoutSpec
                                        stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                        spacing:5.0f
                                        justifyContent:ASStackLayoutJustifyContentEnd
                                        alignItems:ASStackLayoutAlignItemsEnd
                                        children:@[topRule, _timeNode]];
        
        finalSpec = stackSpec;
    }
    
    ASInsetLayoutSpec *insetSpec = [ASInsetLayoutSpec
                                    insetLayoutSpecWithInsets:UIEdgeInsetsMake(2.0f, 4.0f, 2.0f, 4.0f)
                                    child:finalSpec];
    
    return insetSpec;
}

@end
