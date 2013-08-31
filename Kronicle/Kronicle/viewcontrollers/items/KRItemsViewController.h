//
//  KRItemsViewController.h
//  Kronicle
//
//  Created by Scott on 8/16/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRBaseEditTableViewController.h"
#import "KRItemsTableViewCell.h"

@interface KRItemsViewController : KRBaseEditTableViewController

@property(nonatomic, assign) KRItemsListType type;
@property(nonatomic, strong) NSArray *items;

- (id)initWithItems:(NSArray *)items andState:(KRItemsListType)type;

@end
