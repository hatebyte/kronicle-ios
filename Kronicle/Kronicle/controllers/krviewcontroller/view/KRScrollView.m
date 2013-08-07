//
//  KRScrollView.m
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRScrollView.h"
#import "KRKronicle.h"
#import "KRStep.h"
#import "DescriptionView.h"

@interface KRScrollView () <UIScrollViewDelegate> {
    @private
    CGFloat _velocity;
}
@end

@implementation KRScrollView

- (id)initWithFrame:(CGRect)frame andKronicle:(KRKronicle *)kronicle {
    if (self = [super initWithFrame:frame]) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];

        for (int i = 0; i < [kronicle.steps count]; i++) {
            KRStep *s = [kronicle.steps objectAtIndex:i];
            DescriptionView *d = [[DescriptionView alloc] initWithFrame:CGRectMake(frame.size.width * i,
                                                                                   0,
                                                                                   frame.size.width,
                                                                                   frame.size.height) andStep:s];
            [self addSubview:d];
        }
    }
    return self;
}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    _velocity = velocity.x;
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = self.contentOffset.x / self.frame.size.width;
    [_scrollDelegate scrollView:self pageToIndex:index];
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
