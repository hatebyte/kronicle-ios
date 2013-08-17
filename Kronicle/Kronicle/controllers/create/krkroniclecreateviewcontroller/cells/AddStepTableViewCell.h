//
//  AddStepTableViewCell.h
//  Kronicle
//
//  Created by Scott on 8/15/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRStep.h"

@class AddStepTableViewCell;
@protocol AddStepTableViewCellDelegate <NSObject>

- (void)stepDeletionRequested:(AddStepTableViewCell *)addStepTableViewCell forStep:(KRStep *)step;
- (void)stepEditingRequested:(AddStepTableViewCell *)addStepTableViewCell forStep:(KRStep *)step;

@end

@interface AddStepTableViewCell : UITableViewCell

@property (nonatomic, weak) id <AddStepTableViewCellDelegate> delegate;

+ (CGFloat)cellHeight;

- (void)prepareForReuseWithArray:(NSArray *)stepArray;

@end
