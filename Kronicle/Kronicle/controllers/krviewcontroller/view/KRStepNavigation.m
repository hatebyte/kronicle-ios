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

@interface KRStepNavigation () {
    @private
    UIButton *_resume;
    UIButton *_skipThisStep;
    UIButton *_startOver;
    UIButton *_forward;
    UIButton *_backward;
    UIView *_clippingView;
    UIImageView *_carrot;
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
        [_resume setBackgroundColor:[KRColorHelper lightBlue]];
        _resume.frame = CGRectMake(0, 40, 90, 40);
        [_resume addTarget:self action:@selector(resume:) forControlEvents:UIControlEventTouchUpInside];
        [_clippingView addSubview:_resume];

        _skipThisStep   = [UIButton buttonWithType:UIButtonTypeCustom];
        [_skipThisStep setTitle:@"Skip to this step" forState:UIControlStateNormal];
        [_skipThisStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _skipThisStep.titleLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:KRFontSizeRegular];
        [_skipThisStep setBackgroundColor:[UIColor blackColor]];
        _skipThisStep.frame = CGRectMake(_resume.frame.origin.x + _resume.frame.size.width, 40, 140, 40);
        [_skipThisStep addTarget:self action:@selector(skipThis:) forControlEvents:UIControlEventTouchUpInside];
        [_clippingView addSubview:_skipThisStep];

        _startOver      = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startOver setTitle:@"Start over" forState:UIControlStateNormal];
        [_startOver setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _startOver.titleLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:KRFontSizeRegular];
        [_startOver setBackgroundColor:[UIColor blackColor]];
        _startOver.frame = CGRectMake(_skipThisStep.frame.origin.x + _skipThisStep.frame.size.width, 40, 90, 40);
        [_startOver addTarget:self action:@selector(startOver:) forControlEvents:UIControlEventTouchUpInside];
        [_clippingView addSubview:_startOver];

        _forward        = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forward setBackgroundImage:[UIImage imageNamed:@"forward"] forState:UIControlStateNormal];
        _forward.backgroundColor = [UIColor grayColor];
        _forward.frame = CGRectMake(320 - 60, 40, 60, 60);
        [_forward addTarget:self action:@selector(forward:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_forward];

        _backward       = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backward setBackgroundImage:[UIImage imageNamed:@"backward"] forState:UIControlStateNormal];
        _backward.backgroundColor = [UIColor grayColor];
        _backward.frame = CGRectMake(0, 40, 60, 60);
        [_backward addTarget:self action:@selector(backward:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backward];
        
        _carrot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        _carrot.frame = CGRectMake(145, 30, 30,30);
        _carrot.alpha = 0;
        [self addSubview:_carrot];

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

- (void)animateNavbarIn {
    if (!self.isShowing) {
        self.isShowing = YES;
        [UIView animateWithDuration:.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _carrot.frame          = CGRectMake(145, 0, 30,30);
                             _carrot.alpha          = 1;
                             _resume.frame          = CGRectMake(_resume.frame.origin.x, 0, 90, 40);
                             _skipThisStep.frame    = CGRectMake(_skipThisStep.frame.origin.x, 0, 140, 40);
                             _startOver.frame       = CGRectMake(_startOver.frame.origin.x, 0, 90, 40);
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
                             _carrot.frame          = CGRectMake(145, 30, 30,30);
                             _carrot.alpha          = 0;
                             _resume.frame          = CGRectMake(_resume.frame.origin.x, 40, 90, 40);
                             _skipThisStep.frame    = CGRectMake(_skipThisStep.frame.origin.x, 40, 140, 40);
                             _startOver.frame       = CGRectMake(_startOver.frame.origin.x, 40, 90, 40);
                         }
                         completion:^(BOOL fin){
                         }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
