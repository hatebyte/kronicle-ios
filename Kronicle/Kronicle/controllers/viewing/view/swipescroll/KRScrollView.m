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

@interface KRScrollView () <UIScrollViewDelegate> {
    @private
    __weak DescriptionView *_currentStep;
}
@end

@implementation KRScrollView

- (id)initWithFrame:(CGRect)frame andKronicle:(Kronicle *)kronicle {
    if (self = [super initWithFrame:frame]) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];

        int count = [kronicle.steps count];
        DescriptionView *d;
        for (int i = 0; i < count; i++) {
            Step *s = [kronicle.steps objectAtIndex:i];
            NSLog(@"s.k : %d", s.indexInKronicle);
            d = [[DescriptionView alloc] initWithFrame:CGRectMake(frame.size.width * i,
                                                                                   0,
                                                                                   frame.size.width,
                                                                                   frame.size.height) andStep:s];
            d.subClockLabel.text = [NSString stringWithFormat:@"Step %d of %d", (i +1), count];
            [self addSubview:d];
        }
    }
    return self;
}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    _velocity = velocity.x;
//}
- (void)setCurrentStep:(int)stepIndex {
    _currentStep = [[self subviews] objectAtIndex:stepIndex];
}

- (void)updateForLastStep {
//    NSArray *subViews = [self subviews];
//    DescriptionView *d;
//    for (int i = 0; i < subViews.count; i++) {
//        d  = [[self subviews] objectAtIndex:i];
//        [d resetClock];
//    }
    [_currentStep resetClock];
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
    //[d updateForLastStep];
}


#pragma public properties
- (void)scrollToPage:(int)page {
    CGPoint offset = CGPointMake(page * self.frame.size.width, 0);
    [self setContentOffset:offset animated:YES];
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
