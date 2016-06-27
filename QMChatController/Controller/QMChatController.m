//
//  QMChatController.m
//  QMChatController
//
//  Created by Vitaliy Gorbachov on 6/27/16.
//  Copyright © 2016 Quickblox. All rights reserved.
//

#import "QMChatController.h"

// tests
#import "TMessagesFactory.h"

// collection
#import "QMChatCollectionViewLayout.h"
#import "QMMessageNode.h"
#import "QMMessageItem.h"

@interface QMChatController ()
<
ASCollectionDelegate,
ASCollectionDataSource,
QMChatCollectionViewLayoutDelegate
>
{
    // collection
    ASCollectionNode *_collectionNode;
    QMChatCollectionViewLayout *_collectionLayout;
    QMChatCollectionViewLayoutInspector *_layoutInspector;
    
    // items
    NSMutableArray *_items;
}

@end

@implementation QMChatController

#pragma mark - Construction

- (void)dealloc {
    
    _collectionNode.dataSource = nil;
    _collectionNode.delegate = nil;
}

- (instancetype)init {
    
    _items = [self _messageItemsOfAmount:50]; // testing
    
    _collectionLayout = [[QMChatCollectionViewLayout alloc] init];
    _collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:_collectionLayout];
    
    //temp color
    _collectionNode.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:230.0f/255.0f blue:211.0f/255.0f alpha:1.0f];
    
    self = [super initWithNode:_collectionNode];
    if (self != nil) {
        
        // collection setup
        _collectionNode.dataSource = self;
        _collectionNode.delegate = self;
        
        _layoutInspector = [[QMChatCollectionViewLayoutInspector alloc] init];
        _collectionNode.view.layoutInspector = _layoutInspector;
        
        // items setup
        //        _items = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark - _test

- (NSMutableArray *)_messageItemsOfAmount:(NSUInteger)amount {
    
    NSArray *messages = [TMessagesFactory messagesOfAmount:50];
    
    NSMutableArray *messageItems = [[NSMutableArray alloc] initWithCapacity:amount];
    
    for (QBChatMessage *message in messages) {
        
        [messageItems addObject:[[QMMessageItem alloc] initWithMessage:message]];
    }
    
    return [messageItems mutableCopy];
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Chat";
}

#pragma mark - ASCollectionDelegate


#pragma mark - ASCollectionDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if (collectionView == _collectionNode.view) {
        
        return 1;
    }
    
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView == _collectionNode.view && section == 0) {
        
        return _items.count;
    }
    
    return 0;
}

- (ASCellNodeBlock)collectionView:(ASCollectionView *)__unused collectionView nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return ^{
        
        if (indexPath.section == 0) {
            
            QMMessageItem *item = indexPath.row < (NSInteger)self->_items.count ? self->_items[indexPath.row] : nil;
            
            if (item != nil) {
                
                return item.messageNode;
            }
        }
        
        QMMessageNode *cellNode = [[QMMessageNode alloc] init];
        cellNode.backgroundColor = [UIColor redColor];
        return cellNode;
    };
}

#pragma mark - QMChatCollectionViewLayoutDelegate

- (NSArray *)items {
    
    return [_items copy];
}

@end
