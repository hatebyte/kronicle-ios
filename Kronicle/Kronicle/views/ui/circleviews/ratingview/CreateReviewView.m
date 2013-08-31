//
//  CreateReviewView.m
//  Kronicle
//
//  Created by Scott on 8/30/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "CreateReviewView.h"
#import "TouchCircleCreatorView.h"
#import "KRGlobals.h"
#import "UIHelper.h"
#import "Kronicle+Helper.h"

@interface CreateReviewView () <TouchCircleCreatorViewDelegate> {
    @private
    TouchCircleCreatorView *_reviewCircle;
    UILabel *_lightLabel;
    UILabel *_boldLabel;
    NSArray *_valueDictionarys;
}
@end


@implementation CreateReviewView

+ (CGFloat)size {
    return 290.f;
}

- (id)initWithFrame:(CGRect)frame andType:(CreateReviewViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        _enabled                                    = YES;
        
//        _valueDictionarys = [NSArray arrayWithObjects:
//                             [NSDictionary dictionaryWithObjectsAndKeys:
//                              NSLocalizedString(@"GREAT", @"CreateReviewView bold label text"), @"text",
//                              [KRColorHelper turquoise], @"color", nil],
//                             [NSDictionary dictionaryWithObjectsAndKeys:
//                              NSLocalizedString(@"GOOD", @"CreateReviewView GOOD bold label text"), @"text",
//                              [KRColorHelper green], @"color", nil],
//                             [NSDictionary dictionaryWithObjectsAndKeys:
//                              NSLocalizedString(@"OK", @"CreateReviewView OK bold label text"), @"text",
//                              [KRColorHelper orangeDark], @"color", nil],
//                             [NSDictionary dictionaryWithObjectsAndKeys:
//                              NSLocalizedString(@"MEH", @"CreateReviewView MEH bold label text"), @"text",
//                              [KRColorHelper red], @"color", nil],
//                             nil];
        
        _reviewCircle                               = [[TouchCircleCreatorView alloc] initWithFrame:CGRectMake((self.frame.size.width - [CreateReviewView size]) * .5,
                                                                                                               (frame.size.height - [CreateReviewView size]) * .5,
                                                                                                               [CreateReviewView size],
                                                                                                               [CreateReviewView size])];
        _reviewCircle.lineJoin                      = kCGLineJoinRound;
        _reviewCircle.lineCap                       = kCGLineCapRound;
        _reviewCircle.delegate                      = self;
        _reviewCircle.strokeWidth                   = 35.f;
        _reviewCircle.backgroundColor               = [UIColor clearColor];
        
        NSInteger labelHeight                       = 38;
        NSInteger lightY                            = (self.frame.size.height - (labelHeight * 2)) * .5;
        
        _lightLabel                                 = [UIHelper blackLabel];
        _lightLabel.frame                           = CGRectMake(0, lightY - 8, self.frame.size.width, labelHeight);
        _lightLabel.font                            = [KRFontHelper getFont:KRBrandonRegular withSize:36];
        _lightLabel.text                            = NSLocalizedString(@"This is", @"CreateReviewView light label text");
        _lightLabel.textAlignment                   = UITextAlignmentCenter;
        _lightLabel.textColor                       = [KRColorHelper grayMedium];
        [self addSubview:_lightLabel];

        _boldLabel                                  = [UIHelper blackLabel];
        _boldLabel.frame                            = CGRectMake(0,
                                                                _lightLabel.frame.origin.y + _lightLabel.frame.size.height - 2,
                                                                self.frame.size.width,
                                                                labelHeight);
        _boldLabel.font                             = [KRFontHelper getFont:KRBrandonBold withSize:38];
        _boldLabel.textAlignment                    = UITextAlignmentCenter;
        [self addSubview:_boldLabel];
       
        [self addSubview:_reviewCircle];
        _reviewCircle.exclusiveTouch                = YES;
        self.exclusiveTouch                         = YES;
        
        switch (type) {
            case CreateReviewViewCreate:
                _reviewCircle.strokeColorBackground         = [KRColorHelper grayLight];
                _reviewCircle.strokeColor                   = [KRColorHelper turquoise];
                _lightLabel.textColor                       = [KRColorHelper grayMedium];
                _boldLabel.textColor                        = [UIColor whiteColor];
                break;
            case CreateReviewViewShow:
                _reviewCircle.strokeColorBackground         = [KRColorHelper grayLight];
                _reviewCircle.strokeColor                   = [KRColorHelper turquoise];
                _lightLabel.textColor                       = [KRColorHelper grayMedium];
                _boldLabel.textColor                        = [UIColor blackColor];
                break;
        }
        
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    _reviewCircle.enabled = _enabled;
}

- (void)setReviewWithValue:(CGFloat)value {
    [_reviewCircle updateGraphWithPercent:value];
    [self adjustColorToPercent:value];
}

- (void)adjustColorToPercent:(CGFloat)percent {
    self.percent = percent;
    NSDictionary *dict = [Kronicle reviewSettingsByRating:_percent];
    _reviewCircle.strokeColor                   = [dict objectForKey:@"color"];
    _boldLabel.text                             = [dict objectForKey:@"text"];
}

#pragma mark TouchCircleCreatorViewDelegate
- (void)touchCircleCreatorView:(TouchCircleCreatorView *)touchCircleCreatorView updateWithPercent:(CGFloat)percent {
    [self adjustColorToPercent:percent];
}

@end

































