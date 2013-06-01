;//
//  KRSwipeUpScrollView.m
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRSwipeUpScrollView.h"

@implementation KRSwipeUpScrollView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UISwipeGestureRecognizer *swipeLR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
        swipeLR.delegate = self;
        swipeLR.direction = UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp;
        
        [self addGestureRecognizer:swipeLR];
    }
    return self;
}

-(void)swipeDetected:(UISwipeGestureRecognizer *)swipeRecognizer {
    
    if (swipeRecognizer.direction & UISwipeGestureRecognizerDirectionDown) {
        //left detected
    }
    if (swipeRecognizer.direction & UISwipeGestureRecognizerDirectionUp) {
        //right detected
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
