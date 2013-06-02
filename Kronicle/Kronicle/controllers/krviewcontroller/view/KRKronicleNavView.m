//
//  KRKronicleNavView.m
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRKronicleNavView.h"
#import "KRFontHelper.h"
#import "KRClock.h"

@implementation KRKronicleNavView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        _backgroundView = [[UIImageView alloc] initWithFrame:frame];
        _backgroundView.image = [UIImage imageNamed:@"black-bar"];
        [self addSubview:_backgroundView];
        _highlightView = [[UIImageView alloc] initWithFrame:frame];
        _highlightView.image = [UIImage imageNamed:@"green-bar"];
        _highlightView.alpha = 0;
        [self addSubview:_highlightView];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 320, 30)];
        _timeLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:32];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_timeLabel];
       
        _smallLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                _timeLabel.frame.origin.y + _timeLabel.frame.size.height - 4,
                                                                320,
                                                                17)];
        _smallLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:12];
        _smallLabel.textColor = [UIColor whiteColor];
        _smallLabel.backgroundColor = [UIColor clearColor];
        _smallLabel.textAlignment = NSTextAlignmentCenter;
        _smallLabel.text = @"until next step";
        [self addSubview:_smallLabel];
        
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(10,
                                        10,
                                        25,
                                        25);
        [_backButton setImage:[UIImage imageNamed:@"x-button.png"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonHit:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backButton];
        
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _pauseButton.frame = CGRectMake(320 - 35,
                                        10,
                                        25,
                                        25);
        [_pauseButton setImage:[UIImage imageNamed:@"pause-button"] forState:UIControlStateNormal];
        [_pauseButton addTarget:self action:@selector(pauseButtonHit:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_pauseButton];
        
    }
    return self;
}

- (void)backButtonHit:(id)sender {
    [self.delegate navViewBack:self];
}

- (void)pauseButtonHit:(id)sender {
    [self.delegate navViewPlayPause:self];
}

- (void)setTitleText:(NSString*)text {
    _timeLabel.text = text;
}

- (void)isCurrentStep:(BOOL)isCurrentStep {
    CGFloat alpha;
    if (isCurrentStep) {
        alpha = 0.f;
    } else {
        alpha = 1.f;
    }
    
    [UIView animateWithDuration:.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _highlightView.alpha = alpha;
                     }
                     completion:^(BOOL fin){

                     }];

}

- (void)play{

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
