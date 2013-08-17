//
//  AddDescriptionTableViewCell.h
//  Kronicle
//
//  Created by Scott on 8/15/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRFormFieldCell.h"

@interface AddDescriptionTableViewCell : KRFormFieldCell <KRFormFieldCellDelegate>

+ (CGFloat)cellHeight;

- (void)prepareForUseWithDescription:(NSString *)description;

@end
