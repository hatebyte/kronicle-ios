//
//  StepBlockView.h
//  Kronicle
//
//  Created by Scott on 8/15/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRStep.h"

typedef enum {
    StepBlockTypeDefault,
    StepBlockTypeAdd
} StepBlockType;

@class StepBlockView;
@protocol StepBlockViewDelegate <NSObject>
- (void)stepBlockView:(StepBlockView *)stepBlockView deleteStepIndex:(int)stepIndex;
- (void)stepBlockView:(StepBlockView *)stepBlockView requestStepIndex:(int)stepIndex;
@end

@interface StepBlockView : UIImageView

@property (nonatomic, weak) id <StepBlockViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andStep:(KRStep *)step;
- (id)initAsAddStepWithFrame:(CGRect)frame;

@end
