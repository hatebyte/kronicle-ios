//
//  AddTimeCell.h
//  Kronicle
//
//  Created by Scott on 8/17/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRFormFieldCell.h"

#define kTimeUnitCompleted         @"TimeUnitCompleted"
#define kRequestTimeUnitEdit       @"RequestTimeUnitEdit"

@interface AddTimeCell : KRFormFieldCell

- (void)prepareForUserWithTime:(NSInteger)time;
- (NSInteger)value;

@end
