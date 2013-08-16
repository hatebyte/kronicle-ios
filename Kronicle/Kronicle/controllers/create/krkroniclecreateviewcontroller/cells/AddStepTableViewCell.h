//
//  AddStepTableViewCell.h
//  Kronicle
//
//  Created by Scott on 8/15/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddStepTableViewCell : UITableViewCell

+ (CGFloat)cellHeight;

- (void)prepareForReuseWithArray:(NSArray *)stepArray;

@end
