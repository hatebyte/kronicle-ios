//
//  AddDescriptionTableViewCell.h
//  Kronicle
//
//  Created by Scott on 8/15/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDescriptionTableViewCell : UITableViewCell

+ (CGFloat)cellHeight;

- (void)prepareForUseWithDescription:(NSString *)description;

@end
