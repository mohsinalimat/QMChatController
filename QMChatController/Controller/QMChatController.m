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

// viewmodel
#import "QMMessageViewModel.h"

// view
#import "QMMessageNode.h"

@interface QMChatController ()
<
ASCollectionDelegate,
ASCollectionDataSource
>
{
    // collection
    ASCollectionNode *_collectionNode;
    
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
    
    _items = [[TMessagesFactory messagesOfAmount:50] mutableCopy]; // testing
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    _collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:flowLayout];
    
    self = [super initWithNode:_collectionNode];
    if (self != nil) {
        
        // collection setup
        _collectionNode.dataSource = self;
        _collectionNode.delegate = self;
        
        // items setup
        //        _items = [[NSMutableArray alloc] init];
    }
    
    return self;
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
            
            QBChatMessage *item = indexPath.row < (NSInteger)self->_items.count ? self->_items[indexPath.row] : nil;
            
            if (item != nil) {
                
                QMMessageViewModel *viewModel = [[QMMessageViewModel alloc] initWithMessage:item];
                
                QMMessageNode *cellNode = [[QMMessageNode alloc] initWithTitle:viewModel.attributedTitle
                                                                          text:viewModel.attributedText
                                                                          time:viewModel.attributedTime];
                
                return cellNode;
            }
        }
        
        QMMessageNode *cellNode = [[QMMessageNode alloc] init];
        cellNode.backgroundColor = [UIColor redColor];
        return cellNode;
    };
}

#pragma mark - UICollectionViewLayoutDelegate

- (NSArray *)items {
    
    return [_items copy];
}

@end
