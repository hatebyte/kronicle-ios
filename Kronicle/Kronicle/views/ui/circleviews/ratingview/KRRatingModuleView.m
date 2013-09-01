//
//  KRRatingModuleView.m
//  Kronicle
//
//  Created by Scott on 8/29/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRRatingModuleView.h"
#import "KRGlobals.h"
#import "KRRatingCircleView.h"
#import <QuartzCore/QuartzCore.h>
#import "Kronicle+Helper.h"

@interface KRRatingModuleView () {
    @private
    UILabel *_titleLabel;
    KRRatingCircleView *_circleView;
}

@end

@implementation KRRatingModuleView

- (id)initWithPoint:(CGPoint)point andStyle:(KRRatingModuleStyle)style andRating:(CGFloat)rating {
    CGRect frame;
    UIFont *font;
    NSInteger circleSize;
    NSInteger circleY;
    NSInteger labelX;
    switch (style) {
        case KRRatingModuleStart:
            frame = CGRectMake(point.x, point.y, 200, 40);
            font = [KRFontHelper getFont:KRBrandonLight withSize:32];
            circleSize = 24;
            circleY = 4;
            labelX = 4;
            break;
        case KRRatingModuleBlock:
        default:
            frame = CGRectMake(point.x, point.y+1, 60, 22);
            font = [KRFontHelper getFont:KRBrandonRegular withSize:16];
            circleSize = 12;
            circleY = 2;
            labelX = 6;
            break;
    }
    
    self = [super initWithFrame:frame];
    if (self) {
                
        _circleView = [[KRRatingCircleView alloc] initWithFrame:CGRectMake(0, 5+ circleY, circleSize, circleSize)];
        _circleView.rating = rating;
        [self addSubview:_circleView];
    
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_circleView.frame.size.width + labelX,
                                                                0,
                                                                frame.size.width - _circleView.frame.size.width,
                                                                frame.size.height)];
        _titleLabel.font = font;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = @"great";
        _titleLabel.layer.shadowColor        = [[UIColor blackColor] CGColor];
        _titleLabel.layer.shadowOffset       = CGSizeMake(.7f, .7f);
        _titleLabel.layer.shadowOpacity      = .7f;
        _titleLabel.layer.shadowRadius       = .7f;
        [self addSubview:_titleLabel];
        
        
    }
    return self;
}

- (void)setRating:(CGFloat)rating {
    NSDictionary *dict                      = [Kronicle reviewSettingsByRating:rating];
    _circleView.strokeColor                 = [dict objectForKey:@"color"];
    [_circleView setRating:rating];
}


@end












