//
//  AddTitleTableViewCell.h
//  Kronicle
//
//  Created by Scott on 8/14/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRFormFieldCell.h"


@interface AddTitleTableViewCell : KRFormFieldCell

+ (CGFloat)cellHeight;
+ (CGFloat)cellHeightForStep;
+ (CGFloat)cellHeightForKronicle;

- (void)prepareForUseWithTitle:(NSString *)title andType:(AddTitleLocation)type;
- (NSString *)value;

@end
