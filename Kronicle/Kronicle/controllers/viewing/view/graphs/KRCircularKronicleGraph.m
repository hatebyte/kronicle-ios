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
#import "KRFontHelper.h"
#import "KRColorHelper.h"
#import "KRClockManager.h"

CGFloat const _largeStroke = 45.f;
CGFloat const _smallStroke = 26.f;
CGFloat const _sidesBuffer = .42;


@interface KRCircularKronicleGraph () {
    @private
    CGPoint _centerPoint;
    CGFloat _startAngle;
    CGFloat _endAngle;
    CGFloat _radius;
    CGFloat _ratio;
    __weak KRKronicle *_kronicle;
    int _step;
    UILabel *_clockLabel;
    UILabel *_subClockLabel;
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
        _radius                 = (self.frame.size.width * _sidesBuffer) - (_largeStroke * .5);

        _clockLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        _clockLabel.frame = CGRectMake((self.frame.size.width - _clockLabel.frame.size.width) * .5,
                                       ((self.frame.size.height - _clockLabel.frame.size.height) * .5) - 7,
                                       _clockLabel.frame.size.width,
                                       _clockLabel.frame.size.height);
        _clockLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:38];
        _clockLabel.textColor = [UIColor blackColor];
        _clockLabel.backgroundColor = [UIColor clearColor];
        _clockLabel.textAlignment = NSTextAlignmentCenter;
        _clockLabel.text = @"00:00";
        [self addSubview:_clockLabel];
        
        _subClockLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _clockLabel.frame.size.height + _clockLabel.frame.origin.y + 1, 320, 17)];
        _subClockLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:17];
        _subClockLabel.textColor = [UIColor blackColor];
        _subClockLabel.backgroundColor = [UIColor clearColor];
        _subClockLabel.textAlignment = NSTextAlignmentCenter;
        _subClockLabel.text = @"until finished!";
        [self addSubview:_subClockLabel];
}
    return self;
}

- (void)updateForCurrentStep:(int)step andRatio:(CGFloat)ratio andTimeCompleted:(int)totalCompleted {
    _step = step;
    _ratio = ratio;
    
    _clockLabel.text = [KRClockManager stringTimeForInt:(_kronicle.totalTime - totalCompleted)];
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
    CGContextSetLineWidth(context, _smallStroke);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetMiterLimit(context, 2.0);
    CGContextAddArc(context, _centerPoint.x, _centerPoint.y, _radius+((_largeStroke - _smallStroke) * .5), degreesToRadiansMinus90(0), degreesToRadiansMinus90(comingStartAngle), 0);
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextSetRGBStrokeColor(context, 0.f, 0.f, 0.f, .1f);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetLineWidth(context, _largeStroke);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetMiterLimit(context, 2.0);
    CGContextAddArc(context, _centerPoint.x, _centerPoint.y, _radius, degreesToRadiansMinus90(comingStartAngle), degreesToRadiansMinus90(360), 0);
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextSetRGBStrokeColor(context, 64/255.0f, 188/255.0f, 178/255.0f, 1.0f);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetLineWidth(context, _largeStroke);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetMiterLimit(context, 2.0);
    CGContextAddArc(context, _centerPoint.x, _centerPoint.y, _radius, degreesToRadiansMinus90(0), degreesToRadiansMinus90(globalStartAngle), 0);
    CGContextStrokePath(context);
    
    CGFloat tangle = 0;
    CGFloat length = _largeStroke;
    CGFloat distFromCenter = (self.frame.size.width * _sidesBuffer)-(length);
    for (int i = 0; i < _kronicle.steps.count; i++) {
        kstep = [_kronicle.steps objectAtIndex:i];
        tangle += kstep.time;
        CGFloat angle =  (tangle / _kronicle.totalTime) * 360;
        [self drawLineWithLength:length atAngle:angle distFromCenter:distFromCenter colored:[UIColor whiteColor].CGColor withStroke:2.f];
    }
    
    // draw zero bar
    length = _largeStroke + 15;
    distFromCenter = (self.frame.size.width * _sidesBuffer)-(length);
    [self drawLineWithLength:length atAngle:0 distFromCenter:distFromCenter colored:[UIColor colorWithRed:.6f green:.6f blue:.6f alpha:1.f].CGColor withStroke:6.f];

    // draw long light moving hand
    distFromCenter = -(self.frame.size.width * 0.0625);
    length = self.frame.size.width * .25;
    [self drawLineWithLength:length atAngle:globalStartAngle distFromCenter:distFromCenter colored:[UIColor colorWithRed:.9f green:.9f blue:.9f alpha:1.f].CGColor withStroke:5.f];

    // draw long dark moving hand w/ shadow
    distFromCenter = length + distFromCenter;
    length = self.frame.size.width * .28;
    [self drawLineWithLength:length-1 atAngle:globalStartAngle+.5 distFromCenter:distFromCenter colored:[UIColor colorWithRed:.0f green:.0f blue:.0f alpha:.3f].CGColor withStroke:5.5f];
    [self drawLineWithLength:length atAngle:globalStartAngle distFromCenter:distFromCenter colored:[UIColor colorWithRed:.6f green:.6f blue:.6f alpha:1.f].CGColor withStroke:5.f];

    CGRect circleRect = CGRectMake(_centerPoint.x-5, _centerPoint.y-5, 10, 10);
    CGContextSetRGBFillColor(context, .9f, .9f, .9f, 1.f);
    CGContextFillEllipseInRect(context, circleRect);
    CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
    CGContextSetLineWidth(context, 1.f);
    CGContextStrokeEllipseInRect(context, circleRect);

}

- (void)drawLineWithLength:(CGFloat)length
                   atAngle:(CGFloat)angle
            distFromCenter:(CGFloat)distancefromCenter
                   colored:(CGColorRef)colorRef
                withStroke:(CGFloat)stroke{
    
    CGPoint startPoint = [self distanceFromCenter:distancefromCenter atAngle:angle];
    CGPoint endPoint = [self distanceFromCenter:(distancefromCenter + length) atAngle:angle];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath (context);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextSetStrokeColorWithColor(context, colorRef);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetLineWidth(context, stroke);
    CGContextSetShouldAntialias(context, YES);
    CGContextSetMiterLimit(context, 2.0);
    CGContextStrokePath(context);    
}

- (CGPoint)distanceFromCenter:(CGFloat)length atAngle:(CGFloat)angle {
    CGFloat x = _centerPoint.x + length * cosf(degreesToRadiansMinus90(angle));
    CGFloat y = _centerPoint.y + length * sinf(degreesToRadiansMinus90(angle));
    return CGPointMake(x, y);
}


@end




