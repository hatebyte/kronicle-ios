//
//  AddTimeCell.h
//  Kronicle
//
//  Created by Scott on 8/17/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRFormFieldCell.h"

static NSString *kTimeUnitCompleted               = @"TimeUnitCompleted";
static NSString *kRequestTimeUnitEdit             = @"RequestTimeUnitEdit";

@interface AddTimeCell : KRFormFieldCell

- (void)prepareForUserWithTime:(NSInteger)time;
- (NSInteger)value;

@end
