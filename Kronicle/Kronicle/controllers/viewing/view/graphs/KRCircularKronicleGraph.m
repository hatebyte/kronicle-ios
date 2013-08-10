//
//  KRCircularKronicleGraph.m
//  Kronicle
//
//  Created by Scott on 8/8/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRCircularKronicleGraph.h"
#import "KRGlobals.h"
#import "KRStep.h"
#import "KRColorHelper.h"

@interface KRCircularKronicleGraph () {
    @private
    CGPoint _centerPoint;
    CGFloat _startAngle;
    CGFloat _endAngle;
    CGFloat _radius;
    CGFloat _stroke;
    __weak KRKronicle *_kronicle;
    int _step;
    CGFloat _ratio;
}

@end

@implementation KRCircularKronicleGraph

- (id)initWithFrame:(CGRect)frame andKronicle:(KRKronicle *)kronicle {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor    = [UIColor whiteColor];
        
        _kronicle               = kronicle;
        _startAngle             = 0.f;
        _endAngle               = 0.f;
        _centerPoint            = CGPointMake(self.frame.size.width * .5, self.frame.size.height *.5);
        _stroke                 = 45;
        _radius                 = (self.frame.size.width * .5) - (_stroke * .6);
        
    }
    return self;
}

- (void)updateForCurrentStep:(int)step andRatio:(CGFloat)ratio {
    _step = step;
    _ratio = ratio;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat comingStartAngle = 0;
    KRStep *kstep;
    for (int i = 0; i < _step+1; i++) {
        kstep = [_kronicle.steps objectAtIndex:i];
        comingStartAngle += kstep.time;
    }
    comingStartAngle = (comingStartAngle / _kronicle.totalTime) * 360;
    CGFloat globalStartAngle = _ratio * 360;
    
    CGContextBeginPath(context);
    CGContextSetRGBStrokeColor(context, 241/255.0f, 163/255.0f, 37/255.0f, 1.0f);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetLineWidth(context, 26.f);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetMiterLimit(context, 2.0);
    CGContextAddArc(context, _centerPoint.x, _centerPoint.y, _radius+9.5, degreesToRadiansMinus90(0), degreesToRadiansMinus90(comingStartAngle), 0);
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextSetRGBStrokeColor(context, 0.f, 0.f, 0.f, .1f);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetLineWidth(context, _stroke);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetMiterLimit(context, 2.0);
    CGContextAddArc(context, _centerPoint.x, _centerPoint.y, _radius, degreesToRadiansMinus90(comingStartAngle), degreesToRadiansMinus90(360), 0);
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextSetRGBStrokeColor(context, 64/255.0f, 188/255.0f, 178/255.0f, 1.0f);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetLineWidth(context, _stroke);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetMiterLimit(context, 2.0);
    CGContextAddArc(context, _centerPoint.x, _centerPoint.y, _radius, degreesToRadiansMinus90(0), degreesToRadiansMinus90(globalStartAngle), 0);
    CGContextStrokePath(context);
    
    CGFloat tangle = 0;
    for (int i = 0; i < _kronicle.steps.count; i++) {
        kstep = [_kronicle.steps objectAtIndex:i];
        tangle += kstep.time;
        CGFloat angle =  (tangle / _kronicle.totalTime) * 360;
        [self drawLineAtAngle:angle withWidth:2 andColor:[UIColor whiteColor].CGColor];
    }
    [self drawLineAtAngle:comingStartAngle withWidth:4 andColor:[UIColor grayColor].CGColor];
    [self drawLineAtAngle:globalStartAngle withWidth:4 andColor:[UIColor grayColor].CGColor];

    //[self drawLineWithLength:10 atAngle:45 distFromCenter:30 andColored:[UIColor grayColor].CGColor];
}

- (void)drawLineAtAngle:(CGFloat)angle withWidth:(CGFloat)width andColor:(CGColorRef)colorRef {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath (context);
    CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y);
    CGFloat x = _centerPoint.x + (self.frame.size.width*.5) * cosf(degreesToRadiansMinus90(angle));
    CGFloat y = _centerPoint.y + (self.frame.size.width*.5) * sinf(degreesToRadiansMinus90(angle));
    CGContextAddLineToPoint(context, x, y);
    CGContextSetStrokeColorWithColor(context, colorRef);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetLineWidth(context, width);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetMiterLimit(context, 2.0);
    CGContextStrokePath(context);
}



@end




