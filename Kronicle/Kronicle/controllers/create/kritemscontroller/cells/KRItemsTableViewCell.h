//
//  KRItemsTableViewCell.h
//  Kronicle
//
//  Created by Scott on 8/28/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item+Helper.h"
#import "KRFormFieldCell.h"

typedef enum {
    KRItemsListCreate,
    KRItemsListUse,
} KRItemsListType;


@interface KRItemsTableViewCell : KRFormFieldCell

@property(nonatomic, weak) Item *item;
@property(nonatomic, assign) KRItemsListType itemType;
@property(nonatomic, assign) BOOL acquired;

+ (CGFloat)cellHeight;

- (void)prepareForUseWith:(Item *)item;
- (id)initWithType:(KRItemsListType)type reuseIdentifier:(NSString *)reuseIdentifier;

@end
