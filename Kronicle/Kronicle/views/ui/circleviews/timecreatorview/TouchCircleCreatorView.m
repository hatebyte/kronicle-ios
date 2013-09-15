//
//  TouchCircleCreatorView.m
//  Kronicle
//
//  Created by Scott on 6/4/13.
//  Copyright (c) 2013 Hai Koncept. All rights reserved.
//

#import "TouchCircleCreatorView.h"
#import "KRGlobals.h"
#import "KRColorHelper.h"
#import <QuartzCore/QuartzCore.h>

#define kStroke     30.0f

@interface TouchCircleCreatorView () {
}
@end

@implementation TouchCircleCreatorView

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
        _strokeWidth            = kStroke;
        _radius                 = frame.size.width * .5;
        _adjustedRadius         = _radius - (_strokeWidth);
    
        self.transform = CGAffineTransformMakeRotation(-M_PI_2);
        
        _enabled                = YES;
    }
    return self;
}

- (void)updateGraphWithPercent:(CGFloat)percent {
    _percent =(percent == 0) ? 0.001 : percent;
    _endAngle = (2 * M_PI) * _percent;
    _lastAngle = _endAngle;
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_enabled) {
        UITouch *touch = [touches anyObject];
        CGPoint currentTouchPoint = [touch locationInView:self];
        
        CGFloat angle = atan2f(currentTouchPoint.y - _adjustedRadius, currentTouchPoint.x - _adjustedRadius);
        if (angle < 0)
            angle = M_PI + (M_PI - ABS(angle));
        
        CGFloat diff = angle - _lastAngle;
        if (diff < -M_PI || diff > M_PI)
            return;

        CGFloat gonnaBeAngle = _endAngle + diff;
        [self.delegate touchCircleCreatorView:self updateWithPercent:(roundf(100 * (gonnaBeAngle / (M_PI * 2))) / 100.0)];

        if (gonnaBeAngle > (M_PI * 2) || gonnaBeAngle < 0)
            return;
        
        _endAngle += diff;
        _endAngle =(_endAngle == 0) ? 0.001 : _endAngle;
        _lastAngle = angle;
        [self setNeedsDisplay];    
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_enabled) {
        UITouch *touch = [touches anyObject];
        CGPoint currentTouchPoint = [touch locationInView:self];
        
        CGFloat angle = atan2f(currentTouchPoint.y - _adjustedRadius, currentTouchPoint.x - _adjustedRadius);
        if (angle < 0)
            angle = M_PI + (M_PI - ABS(angle));
        
        CGFloat diff = angle - _lastAngle;
        if (diff < -M_PI || diff > M_PI)
            return;
        
        CGFloat gonnaBeAngle = _endAngle + diff;
        [self.delegate touchCircleCreatorView:self updateWithPercent:(roundf(100 * (gonnaBeAngle / (M_PI * 2))) / 100.0)];
    }
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextBeginPath(context);
    CGContextSetLineWidth(context, _strokeWidth);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetStrokeColorWithColor(context, self.strokeColorBackground.CGColor);
    CGContextAddArc(context, _radius, _radius, _adjustedRadius, 0, M_PI * 2, 0);
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
    CGContextSetLineCap(context, self.lineCap);
    CGContextSetLineJoin(context, self.lineJoin);
    CGContextSetAllowsAntialiasing(context, YES);

    CGContextSetLineWidth(context, _strokeWidth);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetMiterLimit(context, 2);
    CGContextAddArc(context, _radius, _radius, _adjustedRadius, _startAngle, _endAngle, 0);
    CGContextStrokePath(context);
    
}


@end
