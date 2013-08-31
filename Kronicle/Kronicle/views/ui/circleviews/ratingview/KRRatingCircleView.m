//
//  KRRatingCircleView.m
//  Kronicle
//
//  Created by Scott on 8/29/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRRatingCircleView.h"
#import "KRGlobals.h"
#import "KRColorHelper.h"
#import <QuartzCore/QuartzCore.h>

#define kStroke     30.0f

@interface KRRatingCircleView () {
    @private
    CGFloat _startAngle;
    CGFloat _endAngle;
    CGFloat _stroke;
    CGFloat _radius;
    CGFloat _adjustedRadius;
}

@end

@implementation KRRatingCircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (frame.size.width != frame.size.height) {
            [NSException raise:@"Invalid Frame" format:@"Make sure Bezier frame is a square"];
        }
        [self setBackgroundColor:[UIColor clearColor]];
        
        _startAngle             = degreesToRadians(0);
        _endAngle               = degreesToRadians(1);
        _stroke                 = frame.size.width / 7.5;
        _radius                 = frame.size.width * .5;
        _adjustedRadius         = _radius - (_stroke * .5);
        
        _strokeColor            = [KRColorHelper turquoiseDark];
        _strokeColorBackground  = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:.7f];
        
        self.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
    return self;
}

- (void)setRating:(CGFloat)rating {
    _endAngle = (2 * M_PI) * rating;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, _strokeColorBackground.CGColor);
    CGContextSetLineWidth(context, _stroke);
    CGContextSetShouldAntialias(context, YES);
    CGContextAddArc(context, _radius, _radius, _adjustedRadius, 0, M_PI * 2, 0);
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, _strokeColor.CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetAllowsAntialiasing(context, YES);
    
    
    CGContextSetLineWidth(context, _stroke);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetMiterLimit(context, 2);
    CGContextAddArc(context, _radius, _radius, _adjustedRadius, _startAngle, _endAngle, 0);
    CGContextStrokePath(context);
}

@end
CGFloat stroke;
CGFloat stroke;
