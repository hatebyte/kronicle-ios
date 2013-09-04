//
//  KRStepNavigation.m
//  Kronicle
//
//  Created by Scott on 8/6/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRStepNavigation.h"
#import "KRColorHelper.h"
#import "KRFontHelper.h"
#import <QuartzCore/QuartzCore.h>

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@interface KRStepNavigation () <UIGestureRecognizerDelegate> {
    @private
    UIButton *_resume;
    UIButton *_skipThisStep;
    UIButton *_startOver;
    UIButton *_forward;
    UIButton *_backward;
    UIView *_clippingView;
    UIImageView *_carrot;
    UISwipeGestureRecognizer *_cellLeftSwipper;
    UISwipeGestureRecognizer *_cellRightSwipper;
    SEL _backwardSelector;
}

@end

@implementation KRStepNavigation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _clippingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        _clippingView.backgroundColor = [UIColor clearColor];
        _clippingView.clipsToBounds = YES;
        [self addSubview:_clippingView];
        
        _resume   = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resume setTitle:@"Resume" forState:UIControlStateNormal];
        [_resume setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _resume.titleLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:KRFontSizeRegular];
        _resume.titleLabel.textAlignment = UITextAlignmentCenter;
        [_resume setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_resume setBackgroundColor:[KRColorHelper turquoise]];
        _resume.frame = CGRectMake(0, 40, 88, 40);
        [_resume addTarget:self action:@selector(resume:) forControlEvents:UIControlEventTouchUpInside];
        [_clippingView addSubview:_resume];

        _skipThisStep   = [UIButton buttonWithType:UIButtonTypeCustom];
        [_skipThisStep setTitle:@"Skip to this step" forState:UIControlStateNormal];
        [_skipThisStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _skipThisStep.titleLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:KRFontSizeRegular];
        _skipThisStep.titleLabel.textAlignment = UITextAlignmentCenter;
        [_skipThisStep setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_skipThisStep setBackgroundColor:[UIColor blackColor]];
        _skipThisStep.frame = CGRectMake(_resume.frame.origin.x + _resume.frame.size.width, 40, 134, 40);
        [_skipThisStep addTarget:self action:@selector(skipThis:) forControlEvents:UIControlEventTouchUpInside];
        [_clippingView addSubview:_skipThisStep];
        CALayer *whiteLine = [CALayer layer];
        whiteLine.frame = CGRectMake(0, 0, 1, _skipThisStep.frame.size.height);
        whiteLine.backgroundColor = [UIColor whiteColor].CGColor;
        [_skipThisStep.layer addSublayer:whiteLine];

        _startOver      = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startOver setTitle:@"Start over" forState:UIControlStateNormal];
        [_startOver setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _startOver.titleLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:KRFontSizeRegular];
        _startOver.titleLabel.textAlignment = UITextAlignmentCenter;
        [_startOver setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_startOver setBackgroundColor:[UIColor blackColor]];
        _startOver.frame = CGRectMake(_skipThisStep.frame.origin.x + _skipThisStep.frame.size.width, 40, 102, 40);
        [_startOver addTarget:self action:@selector(startOver:) forControlEvents:UIControlEventTouchUpInside];
        [_clippingView addSubview:_startOver];
        whiteLine = [CALayer layer];
        whiteLine.frame = CGRectMake(0, 0, 1, _startOver.frame.size.height);
        whiteLine.backgroundColor = [UIColor whiteColor].CGColor;
        [_startOver.layer addSublayer:whiteLine];
        
        _forward        = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forward setBackgroundImage:[UIImage imageNamed:@"forward"] forState:UIControlStateNormal];
        _forward.backgroundColor = [UIColor clearColor];
        _forward.frame = CGRectMake(320 - 35, 63, 35, 35);
        [_forward addTarget:self action:@selector(forward:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_forward];

        _backward       = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backward setBackgroundImage:[UIImage imageNamed:@"backward"] forState:UIControlStateNormal];
        _backward.backgroundColor = [UIColor clearColor];
        _backward.frame = CGRectMake(0, 63, 35, 35);
        [_backward addTarget:self action:@selector(backward:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backward];
        
        _carrot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"black_trans_carrot"]];
        _carrot.frame = CGRectMake(145, 30, 20, 10);
        _carrot.alpha = 0;
        _carrot.hidden = YES;
        [self addSubview:_carrot];
        
        _cellLeftSwipper = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
        [_cellLeftSwipper setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        
        _cellRightSwipper = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
        [_cellRightSwipper setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [self addGestureRecognizer:_cellRightSwipper];
        [self addGestureRecognizer:_cellLeftSwipper];
        
        _backwardSelector = @selector(backward:);
    }
    return self;
}

- (void)resume:(id)sender {
    [self.delegate controls:self navigationRequested:KRStepNavigationRequestResume];
}

- (void)skipThis:(id)sender {
    [self.delegate controls:self navigationRequested:KRStepNavigationRequestSkip];
}

- (void)startOver:(id)sender {
    [self.delegate controls:self navigationRequested:KRStepNavigationRequestStartOver];
}

- (void)backward:(id)sender {
    [self.delegate controls:self navigationRequested:KRStepNavigationRequestBackward];
}

- (void)forward:(id)sender {
    [self.delegate controls:self navigationRequested:KRStepNavigationRequestForward];
}

- (void)goback:(id)sender {
    [self.delegate controls:self navigationRequested:KRStepNavigationRequestGoBack];
}

- (void)reset {
    _forward.hidden = NO;
    [_backward removeTarget:self action:@selector(goback:)  forControlEvents:UIControlEventTouchUpInside];
    [_backward addTarget:self action:@selector(backward:) forControlEvents:UIControlEventTouchUpInside];
    _backwardSelector = @selector(backward:);
}

- (void)setAsLastStep {
    _forward.hidden = YES;
}

- (void)updateForFinished {
    self.isShowing = YES;
    [self animateNavbarOut];
    _forward.hidden = YES;

    [_backward removeTarget:self action:@selector(backward:) forControlEvents:UIControlEventTouchUpInside];
    [_backward addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
    _backwardSelector = @selector(goback:);
}

- (void)animateNavbarIn {
    if (!self.isShowing) {
        self.isShowing = YES;
        _carrot.hidden = NO;

        [UIView animateWithDuration:.5
                              delay:.1f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _carrot.frame          = CGRectMake(145, 40, 20, 10);
                             _carrot.alpha          = 1;
                             _resume.frame          = CGRectMake(_resume.frame.origin.x, 0, _resume.frame.size.width, 40);
                             _skipThisStep.frame    = CGRectMake(_skipThisStep.frame.origin.x, 0, _skipThisStep.frame.size.width, 40);
                             _startOver.frame       = CGRectMake(_startOver.frame.origin.x, 0, _startOver.frame.size.width, 40);
                         }
                         completion:^(BOOL fin){
                         }];
    }
}

- (void)animateNavbarOut {
    if (self.isShowing) {
        self.isShowing = NO;
        [UIView animateWithDuration:.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _carrot.frame          = CGRectMake(145, 30, 20, 10);
                             _carrot.alpha          = 0;
                             _resume.frame          = CGRectMake(_resume.frame.origin.x, 40, _resume.frame.size.width, 40);
                             _skipThisStep.frame    = CGRectMake(_skipThisStep.frame.origin.x, 40, _skipThisStep.frame.size.width, 40);
                             _startOver.frame       = CGRectMake(_startOver.frame.origin.x, 40, _startOver.frame.size.width, 40);
                         }
                         completion:^(BOOL fin){
                             _carrot.hidden = YES;
                         }];
    }
}

-(void)swipeDetected:(UISwipeGestureRecognizer *)swipeRecognizer {
    
    if (swipeRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self forward:nil];
    }
    if (swipeRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self performSelector:_backwardSelector withObject:nil];
    }
}


@end
