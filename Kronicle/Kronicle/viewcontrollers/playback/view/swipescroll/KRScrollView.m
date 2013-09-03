//
//  KRScrollView.m
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRScrollView.h"
#import "Step+Helper.h"
#import "DescriptionView.h"
#import <QuartzCore/QuartzCore.h>

@interface KRScrollView () <UIScrollViewDelegate> {
    @private
    __weak DescriptionView *_currentStep;
}
@end

@implementation KRScrollView

+ (CGFloat)playbackHeight {
    return [DescriptionView playbackHeight];
}

+ (CGFloat)finishedHeight {
    return [DescriptionView finishedHeight];
}

- (id)initWithFrame:(CGRect)frame andKronicle:(Kronicle *)kronicle {
    if (self = [super initWithFrame:frame]) {
        self.showsHorizontalScrollIndicator             = NO;
        self.showsVerticalScrollIndicator               = NO;
        self.delegate                                   = self;
        self.pagingEnabled                              = YES;
        self.bounces                                    = NO;

        int count = [kronicle.steps count];
        DescriptionView *d;
        NSInteger i = 0;
        for (i = 0; i < count; i++) {
            Step *s = [kronicle.steps objectAtIndex:i];
            NSLog(@"%@", s);
            d = [[DescriptionView alloc] initWithFrame:CGRectMake(frame.size.width * i,
                                                                                   0,
                                                                                   frame.size.width,
                                                                                   frame.size.height) andStep:s];
            d.subClockLabel.text = [NSString stringWithFormat:@"Step %d of %d", (i +1), count];
            [self addSubview:d];
        }
        
        d = [[DescriptionView alloc] initAsFinishedWithFrame:CGRectMake(d.frame.size.width + d.frame.origin.x,
                                                                        0,
                                                                        frame.size.width,
                                                                        frame.size.height)];
        [self addSubview:d];
     
    }
    return self;
}

- (void)setCurrentStep:(NSInteger)stepIndex {
    NSArray *subViews = [self subviews];
    _currentStep = [subViews objectAtIndex:stepIndex];
    _currentStep.frame = CGRectMake(_currentStep.frame.origin.x,
                                    _currentStep.frame.origin.y,
                                    _currentStep.frame.size.width,
                                    [DescriptionView playbackHeight]);
    [self scrollToPage:stepIndex];
    DescriptionView *d;
    for (int i = 0; i < subViews.count; i++) {
        d  = [[self subviews] objectAtIndex:i];
        if (i < stepIndex) {
            [d updateGraphWithRatio:1];
        } else {
            [d updateGraphWithRatio:0];
        }
    }
}

- (void)updateForFinished {
//    [_currentStep resetClock];
    DescriptionView *finishedStep = [[self subviews] lastObject];
    [self scrollToPage:[[self subviews] count]-1];
    finishedStep.frame = CGRectMake(finishedStep.frame.origin.x,
                                    finishedStep.frame.origin.y,
                                    finishedStep.frame.size.width,
                                    [DescriptionView finishedHeight]);
    [finishedStep updateForFinished];
}

#pragma delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = self.contentOffset.x / self.frame.size.width;
    [_scrollDelegate scrollView:self pageToIndex:index];
}

- (void)updateCurrentStepClock:(NSString *)timeString {
    NSArray *subViews = [self subviews];
    DescriptionView *d;
    for (int i = 0; i < subViews.count; i++) {
        d  = [[self subviews] objectAtIndex:i];
        [d resetClock];
    }
    [_currentStep updateClock:timeString];
    [_currentStep updateGraphWithRatio:1];
}

- (void)updateCurrentStepClock:(NSString *)timeString withRatio:(CGFloat)ratio {
    NSArray *subViews = [self subviews];
    DescriptionView *d;
    for (int i = 0; i < subViews.count; i++) {
        d  = [[self subviews] objectAtIndex:i];
        [d resetClock];
    }
    [_currentStep updateClock:timeString];
    [_currentStep updateGraphWithRatio:ratio];

}


#pragma public properties
- (void)scrollToPage:(NSInteger)page {
    CGPoint offset = CGPointMake(page * self.frame.size.width, 0);
//    [self setContentOffset:offset animated:YES];
    [UIView animateWithDuration:1.f
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [self setContentOffset:offset];
                     }
                     completion:^(BOOL fin){
//                         [self scrollViewDidEndDecelerating:self];
                     }];

}

@end
