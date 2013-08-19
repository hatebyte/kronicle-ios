//
//  AddDescriptionTableViewCell.h
//  Kronicle
//
//  Created by Scott on 8/15/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRFormFieldCell.h"

@class AddDescriptionTableViewCell;
@protocol AddDescriptionTableViewCellDelegate <KRFormFieldCellDelegate>

- (void)formFieldCellDidBecomeFirstResponderWithExpansion:(AddDescriptionTableViewCell *)addDescriptionTableViewCell;

@end


@interface AddDescriptionTableViewCell : KRFormFieldCell

@property (nonatomic, weak) id <AddDescriptionTableViewCellDelegate> delegate;

+ (CGFloat)cellHeightKronicle;
+ (CGFloat)cellHeightExpanded;
+ (CGFloat)cellHeightStep;

- (void)prepareForUseWithDescription:(NSString *)description andType:(AddTitleLocation)type;

@end
