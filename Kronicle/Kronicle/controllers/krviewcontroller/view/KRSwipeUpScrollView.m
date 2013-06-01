;//
//  KRSwipeUpScrollView.m
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRSwipeUpScrollView.h"

@implementation KRSwipeUpScrollView

+ (CGFloat)maxHeight {
    return 380.f;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
        [self addGestureRecognizer:recognizer];
        
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

-(void)swipeDetected:(UISwipeGestureRecognizer *)swipeRecognizer {
    
    if (swipeRecognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        if ([self.delegate respondsToSelector:@selector(scrollView:swipedDownWithDistance:)]) {
            [self.delegate scrollView:self swipedDownWithDistance:0];
        }
    }
    if (swipeRecognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        if ([self.delegate respondsToSelector:@selector(scrollView:swipedUpWithDistance:)]) {
            [self.delegate scrollView:self swipedUpWithDistance:0];
        }
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
