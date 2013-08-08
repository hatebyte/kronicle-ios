//
//  KRStepListContainerView.h
//  Kronicle
//
//  Created by Scott on 8/7/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>


@class KRStepListContainerView;
@protocol KRStepListContainerViewDelegate <NSObject>

- (void)stepListContainerView:(KRStepListContainerView*)stepListContainerView selectedByIndex:(int)stepIndex;

@end

@interface KRStepListContainerView : UIView

@property(nonatomic, weak) id <KRStepListContainerViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andSteps:(NSArray *)steps;
- (void)adjustStepListForCurrentStep:(int)steIndex;
- (void)updateCurrentStepWithRatio:(CGFloat)stepRatio;

@end
