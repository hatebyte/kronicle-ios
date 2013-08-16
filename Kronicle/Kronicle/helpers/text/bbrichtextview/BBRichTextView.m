//
//  BBRichTextView.m
//  BBUIPreview
//
//  Created by Scott on 7/12/13.
//  Copyright (c) 2013 Scott. All rights reserved.
//

#import "BBRichTextView.h"
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
#import "ACMagnifyingGlass.h"

@interface BBRichTextView () {
    @private
    CGSize _refreshSize;
    CFMutableAttributedStringRef _attrText;
    NSArray *_prefixMatches;
    NSMutableArray *_linkButtonArray;
    NSMutableArray *_stylesArray;
    UIColor *_literalColor;
    CGFloat _literalBorderWidth;
    CTTextAlignment ctAligment;
    void (^_buttonStyler)(UIButton *button);
    NSRange _highlightRange;
    NSInteger _highlightStart;
    BOOL _isTextUpdate;
    NSTimer *_touchTimer;
    ACMagnifyingGlass *_magnifyingGlass;
}

@end

@implementation BBRichTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
        CGAffineTransformTranslate(transform, 0, -self.bounds.size.height);
        self.transform = transform;
        
        _literalColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3f];
        self.backgroundColor = [UIColor whiteColor];
        self.lineheight = 0;
        self.font = [UIFont fontWithName:@"Arial" size:18.0];
        self.color = [UIColor blackColor];
        self.padding = 0;
        _stylesArray = [[NSMutableArray alloc] init];
        _highlightRange = NSMakeRange(0,0);
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setLiteralMode:(BOOL)literalMode {
    _literalMode = literalMode;
    if (_literalMode) {
        [[self layer] setBorderWidth:1.0f];
        [[self layer] setBorderColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.3f].CGColor];
        _buttonStyler = ^(UIButton *button) {
            button.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3f];
            [[button layer] setBorderWidth:1.0f];
            [[button layer] setBorderColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.3f].CGColor];
        };
    } else {
        [[self layer] setBorderWidth:0];
        [[self layer] setBorderColor:nil];
        _buttonStyler = ^(UIButton *button) {
            button.backgroundColor = [UIColor clearColor];
        };
    }
    [self render];
}

- (void)setText:(NSString *)text {
    if (text.length < 1) return;
    _text = text;
    [self render];
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self render];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    [self render];
}

- (void)setLineheight:(CGFloat)lineheight {
    _lineheight = lineheight;
    [self render];
}

- (void)setPadding:(int)padding {
    _padding = padding;
    [self render];
}

- (void)setAlignment:(BBRichTextAlignment)alignment {
    switch (alignment) {
        case BBRichTextAlignLeft:
            ctAligment = kCTLeftTextAlignment;
            break;
        case BBRichTextAlignRight:
            ctAligment = kCTRightTextAlignment;
            break;
        case BBRichTextAlignCenter:
            ctAligment = kCTCenterTextAlignment;
            break;
        case BBRichTextAlignJustified:
            ctAligment = kCTJustifiedTextAlignment;
            break;
        default:
            ctAligment = kCTNaturalTextAlignment;
            break;
    }
    [self render];
}

- (void)addPrefix:(BBRichTextPrefixStyle *)style {
    [_stylesArray addObject:style];
    [self render];
}

- (void)render {
    if (_text.length < 1)
        return;

    _isTextUpdate = YES;
    _prefixMatches = nil;
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_linkButtonArray removeAllObjects];
    _linkButtonArray = [[NSMutableArray alloc] init];
    _attrText = [self createAttributedStringWithText:_text andFont:self.font andColor:self.color.CGColor];
    
    // resize the view elements
    CGSize size = [self getHeightForText:_attrText andRange:CFRangeMake(0, _text.length) withConstraints: CGSizeMake(self.bounds.size.width - (_padding*2), 5000.f)];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height+(_padding*2));
    self.bounds = CGRectMake(0,0, self.bounds.size.width, size.height+(_padding*2));
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Initialize a graphics context and set the text matrix to a known value.
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    // write frame for text
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(_attrText);
    
    // Create the frame and draw it into the graphics context
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(_padding, -_padding, self.bounds.size.width - (_padding*2), self.bounds.size.height));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
    // add link buttons only when texst changes
    if (_isTextUpdate && _prefixMatches.count > 0) {
        _isTextUpdate = NO;
        __block CFRange dimensions;
        [self loopThroughCTRunsInFrame:frame withBlock:^(CTLineRef line, CTRunRef run, CGPoint origin) {
            CFRange runRange = CTRunGetStringRange(run);
            int runStart = runRange.location;
            int runEnd = runRange.location + runRange.length;
            // loop through prefixes and check if the ranges overlap
            for (NSDictionary *dict in _prefixMatches) {
                NSRange r = [[dict objectForKey:@"range"] rangeValue];
                int preStart = r.location;
                int preEnd = r.location + r.length;
                dimensions = CFRangeMake(0, r.length);

                // prefix starts before run start
                if (preStart <= runStart) {
                    // prefix ends after run ends
                    if (preEnd >= runEnd) {
                        dimensions.location = 0;
                        dimensions.length = 0;
                        [self addButtonWith:run andLine:line andOrigin:origin andDict:dict dimensionRange:dimensions];
                        break;
                    }
                    // prefix ends before run ends
                    else if (preEnd - runStart > 0) {
                        dimensions.location = 0;
                        dimensions.length = preEnd - runStart;
                        [self addButtonWith:run andLine:line andOrigin:origin andDict:dict dimensionRange:dimensions];
                        // dont break;
                    }
                }
                // whole prefix is in CTRun, not whole CTRun
                else if (runStart <= preStart && runEnd >= preEnd) {
                    dimensions.location = preStart - runStart;
                    [self addButtonWith:run andLine:line andOrigin:origin andDict:dict dimensionRange:dimensions];
                    // dont break;
                }
                // prefix was broken by CTRun but is not whole CTRun
                else if (preStart < runEnd && preEnd > runEnd) {
                    dimensions.location = runRange.length - (runEnd - preStart);
                    dimensions.length = runEnd - r.location;
                    [self addButtonWith:run andLine:line andOrigin:origin andDict:dict dimensionRange:dimensions];
                    break;
                }
            }
        }];
        
    // add highlighting
    } else if (_highlightRange.length > 0) {
        __block CFRange dimensions;
        [self loopThroughCTRunsInFrame:frame withBlock:^(CTLineRef line, CTRunRef run, CGPoint origin) {
            CFRange runRange = CTRunGetStringRange(run);
            int runStart = runRange.location;
            int runEnd = runRange.location + runRange.length;
            int preStart = _highlightRange.location;
            int preEnd = _highlightRange.location + _highlightRange.length;
            
            dimensions = CFRangeMake(0, _highlightRange.length);
 
            // highlight starts at run start
            if (preStart <= runStart) {
                // highlight ends after run ends
                if (preEnd >= runEnd) {
                    dimensions.location = 0;
                    dimensions.length = 0;
                    [self drawHightlightBox:run andLine:line andOrigin:origin dimensionRange:dimensions];
                }
                // highlight ends before run ends
                else if (preEnd - runStart > 0) {
                    dimensions.location = 0;
                    dimensions.length = preEnd - runStart;
                    [self drawHightlightBox:run andLine:line andOrigin:origin dimensionRange:dimensions];
                }
            }
            // highlight is in CTRun, not whole CTRun
            else if (runStart <= preStart && runEnd >= preEnd) {
                dimensions.location = preStart - runStart;
                [self drawHightlightBox:run andLine:line andOrigin:origin dimensionRange:dimensions];
            }
            // highlight was broken by CTRun but is not whole CTRun
            else if (preStart <= runEnd && preEnd >= runEnd) {
                dimensions.location = runRange.length - (runEnd - preStart);
                dimensions.length = runEnd - _highlightRange.location;
                [self drawHightlightBox:run andLine:line andOrigin:origin dimensionRange:dimensions];
            }

        }];
    }
    CTFrameDraw(frame, context);
    
    // release dat shit
    CFRelease(path);
    CFRelease(framesetter);
    CFRelease(frame);
}

- (void)loopThroughCTRunsInFrame:(CTFrameRef)frame withBlock:(void (^)(CTLineRef line, CTRunRef run, CGPoint origin))runBlockBehavior {
    // buttons for targets
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    
    // loop through all lines
    CGPoint origins[[lines count]];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    NSUInteger lineIndex = 0;
    
    for (id lineObj in lines) {
        CTLineRef line = (__bridge CTLineRef)lineObj;
        // loop through CFRunRefs (word frames)
        for (id runObj in (__bridge NSArray *)CTLineGetGlyphRuns(line)) {
            CTRunRef run = (__bridge CTRunRef)runObj;
            CGPoint origin = origins[lineIndex];
            runBlockBehavior(line, run, origin);
        }
        lineIndex++;
    }

}

- (void)addButtonWith:(CTRunRef)run andLine:(CTLineRef)line andOrigin:(CGPoint)origin andDict:(NSDictionary *)dict dimensionRange:(CFRange)dimensionsRange {
    CGRect runBounds = [self getRectForRun:run andLine:line andOrigin:origin dimensionRange:dimensionsRange];
    
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = runBounds;
    b.titleLabel.text = [dict objectForKey:@"content"];
    [b addTarget:[dict objectForKey:@"target"] action:[[dict objectForKey:@"action"] pointerValue] forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:b];
    _buttonStyler(b);
}

- (void)drawHightlightBox:(CTRunRef)run andLine:(CTLineRef)line andOrigin:(CGPoint)origin dimensionRange:(CFRange)dimensionsRange {
    CGRect runBounds = [self getRectForRun:run andLine:line andOrigin:origin dimensionRange:dimensionsRange];
	
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0);
    CGContextFillRect(context, runBounds);
}

- (CGRect)getRectForRun:(CTRunRef)run andLine:(CTLineRef)line andOrigin:(CGPoint)origin dimensionRange:(CFRange)dimensionsRange {
    CGRect runRect; CGFloat ascent; CGFloat descent;
    runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(dimensionsRange.location, dimensionsRange.length), &ascent, &descent, NULL);
    CGFloat runXOffset =(dimensionsRange.location > 0) ? CTRunGetTypographicBounds(run, CFRangeMake(0, dimensionsRange.location), &ascent, &descent, NULL) : 0;
    runRect.size.height = ascent + descent + 2; // plus 2 for a little larger hit area
    
    CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
    runRect.origin.x = origin.x + xOffset + runXOffset + self.padding;
    runRect.origin.y = (origin.y - 2) - descent;
    runRect.origin.y -= self.padding;
    return runRect;
}

- (CFMutableAttributedStringRef)createAttributedStringWithText:(NSString *)text andFont:(UIFont*)font andColor:(CGColorRef)colorRef {
    CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, text.length);
    CFAttributedStringReplaceString(attrString, CFRangeMake(0, 0), (CFStringRef) text);
    CFRange textRange = CFRangeMake(0, text.length);
    
    // Create a font and add it as an attribute to the string.
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    CFAttributedStringSetAttribute(attrString, textRange, kCTFontAttributeName, ctFont);
    CFRelease(ctFont);
    
    // Create a paragragh style and add it as an attribute to the string.
    CGFloat leading = self.lineheight;
    CTTextAlignment alignment = ctAligment;
    CTParagraphStyleSetting paragraphSettings[] = {
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof (CGFloat), &leading },
        { kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment }
    };

    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(paragraphSettings, sizeof(paragraphSettings) / sizeof(paragraphSettings[0]));
    CFAttributedStringSetAttribute(attrString, textRange, kCTParagraphStyleAttributeName, paragraphStyle);
    CFRelease(paragraphStyle);
    
    // Create the color with the attributed string.
    CFAttributedStringSetAttribute(attrString, textRange, kCTForegroundColorAttributeName, colorRef);
    
    // Get rexeg matches and load property array
    NSMutableArray *preMatches = [[NSMutableArray alloc] init];
    for (BBRichTextPrefixStyle *style in _stylesArray) {
        for (NSString *tag in style.prefixes) {
            NSArray *prefixeRanges = [self rangesForPrefix:tag];
            for (NSTextCheckingResult *result in prefixeRanges) {
                CFAttributedStringSetAttribute(attrString, CFRangeMake(result.range.location, result.range.length), kCTForegroundColorAttributeName, style.color.CGColor);
                CTFontRef preFont = CTFontCreateWithName((__bridge CFStringRef)style.font.fontName, style.font.pointSize, NULL);
                CFAttributedStringSetAttribute(attrString, CFRangeMake(result.range.location, result.range.length), kCTFontAttributeName, preFont);
                CFRelease(preFont);
                [preMatches addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSValue valueWithRange:result.range],    @"range"
                                       ,[_text substringWithRange:result.range], @"content"
                                       ,style.target,                            @"target"
                                       ,[NSValue valueWithPointer:style.action], @"action"
                                       , nil]];
            }
        }
    }
    _prefixMatches = [preMatches copy];
    
    return attrString;
}

- (CGSize)getHeightForText:(CFAttributedStringRef)attrString andRange:(CFRange)textRange withConstraints:(CGSize)constraints{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
    CFRange fitRange;
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, textRange, NULL, constraints, &fitRange);
    CFRelease(framesetter);
    return size;
}

- (NSArray *)rangesForPrefix:(NSString *)string {
    NSError* error = NULL;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:string options:NSRegularExpressionUseUnixLineSeparators error:&error];
    if (error) { NSLog(@"%@", [error description]); }
    NSArray *results = [regex matchesInString:_text options:0 range:NSMakeRange(0, [_text length])];
    return results;
}

- (void)dealloc {
    CFRelease(_attrText);
    _text = nil;
    _prefixMatches = nil;
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_linkButtonArray removeAllObjects];
    _linkButtonArray = nil;
    
}


#pragma touch 

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//	UITouch *touch = [touches anyObject];
//    _highlightStart = [self getDragStringIndex:touch];
//    _highlightRange = NSMakeRange(_highlightStart, 0);
//    
//    _touchTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f
//                                                   target:self
//                                                 selector:@selector(addMagnifyingGlass:)
//                                                 userInfo:[NSValue valueWithCGPoint:[touch locationInView:self]]
//                                                  repeats:NO];
//
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//	UITouch *touch = [touches anyObject];
//    NSInteger end = [self getDragStringIndex:touch];
//    if (end < _highlightStart) {
//        _highlightRange = NSMakeRange(end, _highlightStart - end);
//    } else {
//        _highlightRange = NSMakeRange(_highlightStart, end - _highlightStart);
//    }
//    [self setNeedsDisplay];
//    
//    _magnifyingGlass.touchPoint = [touch locationInView:self];
//	[_magnifyingGlass setNeedsDisplay];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
////    _highlightRange = NSMakeRange(0, 0);
////    [self setNeedsDisplay];
//
//    [_touchTimer invalidate];
//    _touchTimer = nil;
//    [_magnifyingGlass removeFromSuperview];
//}

- (NSInteger)getDragStringIndex:(UITouch*)touch {    
    // write frame for text
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(_attrText);
    
    // Create the frame and draw it into the graphics context
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(_padding, -_padding, self.bounds.size.width - (_padding*2), self.bounds.size.height));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);

    CGPoint point = [touch locationInView:self];
    CFArrayRef lines = CTFrameGetLines(frame);
    CGPoint *lineOrigins = malloc(sizeof(CGPoint)*CFArrayGetCount(lines));
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
    
    NSInteger index = 0;
    for (CFIndex i = 0; i < CFArrayGetCount(lines); i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGPoint origin = lineOrigins[i];
        if (point.y > origin.y) {
            index = CTLineGetStringIndexForPosition(line, point);
            break;
        }
    }
    
    free(lineOrigins);
    return index;
}

- (void)addMagnifyingGlass:(NSTimer*)timer {
	NSValue *v = timer.userInfo;
	CGPoint point = [v CGPointValue];
    
	if (!_magnifyingGlass) {
		_magnifyingGlass = [[ACMagnifyingGlass alloc] init];
	}
	
	if (!_magnifyingGlass.viewToMagnify) {
		_magnifyingGlass.viewToMagnify = self;
		
	}
	[self.superview addSubview:_magnifyingGlass];
	_magnifyingGlass.touchPoint = point;
	[_magnifyingGlass setNeedsDisplay];
}














































































@end
