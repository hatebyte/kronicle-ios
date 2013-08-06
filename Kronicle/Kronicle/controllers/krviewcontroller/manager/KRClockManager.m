//
//  KRClockManager.m
//  Kronicle
//
//  Created by Scott on 8/5/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRClockManager.h"

@interface KRClockManager () {
    @private
    __weak KRKronicle *_kronicle;
    __weak KRStep *_step;
    NSTimer *_timer;
    int _stepTotal;
    int _kronicleTotal;
    NSString *_minutes;
    NSString *_hours;
    NSString *_seconds;
    CGFloat _stepRatio;
    CGFloat _globalRatio;
    
    int _currentTime;
    int _currentStepIndex;
}
@end

@implementation KRClockManager 

- (id)initWithKronicle:(KRKronicle *)kronicle {
    if (self = [super init]) {
        _kronicle = kronicle;
        _kronicleTotal = 0;
        for (KRStep *s in _kronicle.steps) {
            _kronicleTotal += s.time;
        }
    }
    return self;
}

- (void)setTimeForStep:(int)stepIndex {
    _stepRatio = 0;
    _step = [_kronicle.steps objectAtIndex:stepIndex];
    _stepTotal = _step.time;
    _currentTime = _stepTotal;

    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(update) userInfo:nil repeats:YES];
}

- (void)update {
    _currentTime -= 1;
    [self setValues];
    
    // fires when over
    if ([_seconds isEqualToString:@"0-1"] && [_minutes isEqualToString:@"00"]) {
        [_timer invalidate];
        [self.delegate manager:self stepComplete:(int)_step.indexInKronicle];
        
        // send sound notification
        return;
    }
    
    // ratio of completed step, minus one because its a countdown clock
    _stepRatio = 1 - ([[NSNumber numberWithInt: _currentTime] floatValue] /[[NSNumber numberWithInt: _stepTotal] floatValue] );
    
    // ratio of completed all time
    int totalSecondsPassed = _stepTotal - _currentTime;
    for (int i = 0; i < _step.indexInKronicle; i++) {
        totalSecondsPassed += _step.time;
    }
    _globalRatio = ([[NSNumber numberWithInt: totalSecondsPassed] floatValue] /[[NSNumber numberWithInt: _kronicleTotal] floatValue] );
    
    // craete time string
    NSString *timeString = [NSString stringWithFormat:@"%@:%@", _minutes, _seconds];
    [self.delegate manager:self updateTimeWithString:timeString andStepRatio:_stepRatio andGlobalRatio:_globalRatio];
}

- (void)setValues{
    int minutes = floor(_currentTime / 60);
    int seconds = floor(_currentTime - (minutes*60));
    
    if (minutes < 10) {
        _minutes = [NSString stringWithFormat:@"0%d", minutes];
    } else {
        _minutes = [NSString stringWithFormat:@"%d", minutes];
    }
    if (seconds < 10) {
        _seconds = [NSString stringWithFormat:@"0%d", seconds];
    } else {
        _seconds = [NSString stringWithFormat:@"%d", seconds];
    }
}

@end
