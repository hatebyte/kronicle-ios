//
//  KRStepListView.h
//  Kronicle
//
//  Created by Scott on 8/7/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRStep.h"

@class KRStepListView;
@protocol KRStepListViewDelegate <NSObject>

- (void)stepListView:(KRStepListView*)setListView selectedByIndex:(int)stepIndex;

@end

@interface KRStepListView : UIView

@property(nonatomic, weak) id <KRStepListViewDelegate> delegate;
@property(nonatomic, weak) KRStep *step;

- (id)initWithFrame:(CGRect)frame andStep:(KRStep *)step;
- (void)setStepCompleted:(BOOL)isCompleted;
- (void)setCurrentStep;
- (void)updateCurrentStepWithRatio:(CGFloat)stepRatio;

+ (CGFloat)cellHeight;

@end
