//
//  AddItemsCell.h
//  Kronicle
//
//  Created by Scott on 8/17/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRFormFieldCell.h"

@class AddItemsCell;
@protocol AddItemsCellDelegate <KRFormFieldCellDelegate>

- (void)addListItemsRequested:(AddItemsCell *)addItemsCell;

@end

@interface AddItemsCell : KRFormFieldCell

@property (nonatomic, weak) id <AddItemsCellDelegate> delegate;

@end

