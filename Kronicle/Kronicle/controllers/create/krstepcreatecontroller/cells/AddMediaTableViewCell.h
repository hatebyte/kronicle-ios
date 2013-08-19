//
//  AddMediaTableViewCell.h
//  Kronicle
//
//  Created by Scott on 8/17/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRFormFieldCell.h"

@class AddMediaTableViewCell;
@protocol AddMediaTableViewCellDelegate <KRFormFieldCellDelegate>

- (void)addMediaRequested:(AddMediaTableViewCell *)addItemsCell;

@end

@interface AddMediaTableViewCell : KRFormFieldCell

@property (nonatomic, weak) id <AddMediaTableViewCellDelegate> delegate;

- (void)prepareForUseWithImage:(NSString *)imagePath;

@end




