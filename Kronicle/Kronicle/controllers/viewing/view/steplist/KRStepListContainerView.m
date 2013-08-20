//
//  KRStepListContainerView.m
//  Kronicle
//
//  Created by Scott on 8/7/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRStepListContainerView.h"
#import "KRStep.h"
#import "KRColorHelper.h"
#import "KRStepListView.h"
#import <QuartzCore/QuartzCore.h>

@interface KRStepListContainerView () <KRStepListViewDelegate> {
    @private
    NSMutableArray *_steps;
    int _currentIndex;
    CALayer *_orangeBox;
    CALayer *_blueBox;
    KRStepListView *_currentStepListView;
}

@end

@implementation KRStepListContainerView

- (id)initWithFrame:(CGRect)frame andSteps:(NSArray *)steps {

    self = [super initWithFrame:CGRectMake(frame.origin.x,frame.origin.y, frame.size.width, [KRStepListView cellHeight] * steps.count)];
    if (self) {
        // Initialization code
        _steps = [[NSMutableArray alloc] init];
        _currentIndex = 0;

        _orangeBox = [CALayer layer];
        _orangeBox.frame = CGRectMake(0, 0, 320, 0);
        _orangeBox.backgroundColor = [KRColorHelper orangeTransparent].CGColor;
        [self.layer addSublayer:_orangeBox];
        
        _blueBox = [CALayer layer];
        _blueBox.frame = CGRectMake(0, 0, 320, 0);
        _blueBox.backgroundColor = [KRColorHelper turquoiseTransparent].CGColor;
        [self.layer addSublayer:_blueBox];

        KRStepListView *stepListView;
        for (int i = 0; i < steps.count; i++) {
            KRStep *step = [steps objectAtIndex:i];
            stepListView = [[KRStepListView alloc] initWithFrame:CGRectMake(0, ([KRStepListView cellHeight] * i), 320, [KRStepListView cellHeight]) andStep:step];
            stepListView.delegate = self;
            if (i == _currentIndex) {
                [stepListView setCurrentStep];
                _currentStepListView = stepListView;
            } else {
                [stepListView setStepCompleted:(stepListView.step.indexInKronicle < _currentIndex)];
            }
            [_steps addObject:stepListView];
            [self addSubview:stepListView];
        }
        //[stepListView setTimeForLastStep];
        
    }
    return self;
}

#pragma public methods
- (void)adjustStepListForCurrentStep:(int)steIndex {
    _currentIndex = steIndex;
    for (int i = 0; i < _steps.count; i++) {
        KRStepListView *stepListView = [_steps objectAtIndex:i];
        if (i == _currentIndex) {
            [stepListView setCurrentStep];
            _currentStepListView = stepListView;
        } else {
            [stepListView setStepCompleted:(stepListView.step.indexInKronicle < _currentIndex)];
        }
    }
    [self slideBackgrounds];
}

- (void)updateCurrentStepWithRatio:(CGFloat)stepRatio {
    [_currentStepListView updateCurrentStepWithRatio:stepRatio];
}


- (void)updateForLastStep {
    KRStepListView *stepListView = [_steps lastObject];
    [stepListView setStepCompleted:YES];
}

#pragma private methods
- (void)slideBackgrounds {
    CGFloat topY = _currentIndex * [KRStepListView cellHeight];
    CGFloat bottomY = (_currentIndex+1) * [KRStepListView cellHeight];
    
    _blueBox.frame = CGRectMake(0, 0, 320, topY);
    _orangeBox.frame = CGRectMake(0, bottomY, 320, self.frame.size.height - bottomY);
}

#pragma KRStepView
- (void)stepListView:(KRStepListView*)setListView selectedByIndex:(int)stepIndex {
    [self.delegate stepListContainerView:self selectedByIndex:stepIndex];
}


@end
