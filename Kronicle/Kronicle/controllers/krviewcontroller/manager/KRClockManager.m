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
    _globalRatio = 0;
    _step = [_kronicle.steps objectAtIndex:stepIndex];
    _stepTotal = _step.time;
    _currentTime = _stepTotal;

    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(update) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];

}

- (void)update {
    _currentTime -= 1;
    
    // create time string
    NSString *timeString = [KRClockManager stringTimeForInt:_currentTime];
    NSArray *splitTimeArr = [timeString  componentsSeparatedByString:@":"];
    
    _minutes = [splitTimeArr objectAtIndex:0];
    _seconds = [splitTimeArr objectAtIndex:1];
    
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
    
    [self.delegate manager:self updateTimeWithString:timeString andStepRatio:_stepRatio andGlobalRatio:_globalRatio];
}

+ (NSString *)stringTimeForInt:(int)time {
    int minutes = floor(time / 60);
    int seconds = floor(time - (minutes*60));
    NSString *sMinutes;
    NSString *sSeconds;
    
    if (minutes < 10) {
        sMinutes = [NSString stringWithFormat:@"0%d", minutes];
    } else {
        sMinutes = [NSString stringWithFormat:@"%d", minutes];
    }
    if (seconds < 10) {
        sSeconds = [NSString stringWithFormat:@"0%d", seconds];
    } else {
        sSeconds = [NSString stringWithFormat:@"%d", seconds];
    }
    return [NSString stringWithFormat:@"%@:%@", sMinutes, sSeconds];
}

@end
