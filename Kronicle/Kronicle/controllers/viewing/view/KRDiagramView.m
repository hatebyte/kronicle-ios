//
//  KRDiagramView.m
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRDiagramView.h"
#define radiansToDegrees(x) (x * 180 / M_PI)

@implementation KRDiagramView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setImagePath:(NSString *)imagePath {
    _imageView.image = [UIImage imageNamed:imagePath];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint center = CGPointMake(CGRectGetMidX([self bounds]), CGRectGetMidY([self bounds]));
    CGPoint currentTouchPoint = [touch locationInView:self];
    
    CGFloat degrees = radiansToDegrees(atan2f(currentTouchPoint.y - center.y, currentTouchPoint.x - center.x));
    if (degrees < 0) {
        degrees = 180 + (180 - ABS(degrees));
    }
    
    if ([self.delegate respondsToSelector:@selector(diagramView:withDegree:)]) {
        [self.delegate diagramView:self withDegree:degrees/360];
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
