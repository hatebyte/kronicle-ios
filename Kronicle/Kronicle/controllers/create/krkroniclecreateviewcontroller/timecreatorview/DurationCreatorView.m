//
//  TouchView.m
//  Krono
//
//  Created by Scott on 6/4/13.
//  Copyright (c) 2013 Hai Koncept. All rights reserved.
//

#import "DurationCreatorView.h"
#import "KRGlobals.h"
#import <QuartzCore/QuartzCore.h>

#define kStroke     20.0f

@interface DurationCreatorView () {
    CADisplayLink *displayLink;
}
@end

@implementation DurationCreatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (frame.size.width != frame.size.height) {
            [NSException raise:@"Invalid Frame" format:@"Make sure Bezier frame is a square"];
        }
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _startAngle             = degreesToRadians(0);
        _endAngle               = degreesToRadians(1);
        
        _stroke                 = kStroke;
        _radius                 = frame.size.width * .5;
        _adjustedRadius         = _radius-(_stroke * .6);
        _remove                 = false;
        
        _leadPoint = CGPointMake(0, 0);

    }
    return self;
}

- (void)setPercent:(CGFloat)percent {
    _endAngle = (2 * M_PI) * percent;
    NSLog(@"_endAngle : %f", _endAngle);
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan");
//    UITouch *touch = [touches anyObject];
//    CGPoint currentTouchPoint = [touch locationInView:self];
//
//    CGFloat dx = currentTouchPoint.x - _leadPoint.x;
//    CGFloat dy = currentTouchPoint.y - _leadPoint.y;
//    CGFloat distanceLeadPoint = sqrtf( (dx * dx) + (dy + dy) );
////    NSLog(@"_leadPoint : %f : %f", self.center.x, self.center.y);
//    NSLog(@"distanceLeadPoint : %f", distanceLeadPoint);
//    if (distanceLeadPoint < 10) {
//        _listening = YES;
////        NSLog(@"%f : %f", dx, dy);
////        NSLog(@"goot to add");
//    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPoint = [touch locationInView:self];
    
    CGFloat angle = atan2f(currentTouchPoint.y - _adjustedRadius, currentTouchPoint.x - _adjustedRadius);
    if (angle < 0)
        angle = M_PI + (M_PI - ABS(angle));
    
    CGFloat diff = angle - _lastAngle;
    if (diff < -M_PI || diff > M_PI)
        return;

    CGFloat gonnaBeAngle = _endAngle + diff;
    if ([self.delegate respondsToSelector:@selector(touchView:updateWithPercent:)]) {
        [self.delegate touchView:self updateWithPercent:(roundf(100 * (gonnaBeAngle / (M_PI * 2))) / 100.0)];
    }

    if (gonnaBeAngle > (M_PI * 2) || gonnaBeAngle < 0)
        return;
    
    _endAngle += diff;
    _lastAngle = angle;
    [self setNeedsDisplay];    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPoint = [touch locationInView:self];
    
    CGFloat angle = atan2f(currentTouchPoint.y - _adjustedRadius, currentTouchPoint.x - _adjustedRadius);
    if (angle < 0)
        angle = M_PI + (M_PI - ABS(angle));
    
    CGFloat diff = angle - _lastAngle;
    if (diff < -M_PI || diff > M_PI)
        return;
    
    CGFloat gonnaBeAngle = _endAngle + diff;
    if ([self.delegate respondsToSelector:@selector(touchUpForExit:withPercent:)]) {
        [self.delegate touchUpForExit:self withPercent:(roundf(100 * (gonnaBeAngle / (M_PI * 2))) / 100.0)];
    }
}

- (void)listen {
    _leadPoint = CGPointMake(self.frame.size.width * .5, 0);
}

- (void)remove {
    [_timer invalidate];
    _timer = nil;
    _remove = true;
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)removeWithDelay:(long)delay {
    _timer = [NSTimer scheduledTimerWithTimeInterval: delay
                                              target: self
                                            selector:@selector(remove)
                                            userInfo: nil repeats:NO];
}

- (void)stopTimer {
    [_timer invalidate];
    _timer = nil;
    [displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    _stroke             = kStroke;
    _remove             = false;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetRGBStrokeColor(context, 0.f, 0.f, 0.f, 0.6);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetAllowsAntialiasing(context, YES);
    
    if (_remove) {
        _stroke *= .91;
        if (_stroke < .01) { [self stopTimer]; }
    }
    
    CGContextSetLineWidth(context, _stroke);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetMiterLimit(context, 2.0);
    CGContextAddArc(context, _radius, _radius, _adjustedRadius, _startAngle, _endAngle, 0);
    CGContextStrokePath(context);
    
}


@end
