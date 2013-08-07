//
//  KRStepListView.h
//  Kronicle
//
//  Created by Scott on 8/7/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRStep.h"

@interface KRStepListView : UIView


- (id)initWithFrame:(CGRect)frame andStep:(KRStep *)step;
- (void)setStepCompleted:(BOOL)isCompleted;
- (void)setCurrentStepWithRatio:(CGFloat)stepRatio;

@end
