//
//  KRClockManager.m
//  Kronicle
//
//  Created by Scott on 8/5/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRClockManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

CGFloat const _increment = 1.0f;

@interface KRClockManager () {
@private
    __weak Kronicle *_kronicle;
    __weak Step *_step;
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
    dispatch_queue_t _backgroundQueue;
}
@end

@implementation KRClockManager

- (id)initWithKronicle:(Kronicle *)kronicle {
    if (self = [super init]) {
        _kronicle = kronicle;
        _kronicleTotal = 0;
        for (Step *s in _kronicle.steps) {
            _kronicleTotal += s.time;
        }
        _backgroundQueue = dispatch_queue_create("KRClockManager.queue", NULL);
        
    }
    return self;
}

- (void)setTimeForCurrentStep:(NSInteger)stepIndex {
    
    _stepRatio = 0;
    _globalRatio = 0;
    _step = [_kronicle.steps objectAtIndex:stepIndex];
        
    _stepTotal = _step.time;
    _currentTime = _stepTotal;
    
    [_timer invalidate];
    _timer = nil;
    if (_step.time == 0) {

        // reset clock to end of step before or 0
        
        int totalSecondsPassed = 0;
        for (int i = 0; i < stepIndex; i++) {
            Step *s = [_kronicle.steps objectAtIndex:i];
            totalSecondsPassed += s.time;
        }
        _globalRatio = ([[NSNumber numberWithInt:totalSecondsPassed] floatValue] / [[NSNumber numberWithInt: _kronicleTotal] floatValue] );
        
        [self pauseForInfiniteWait];
        [self.delegate manager:self pauseForInfiniteWait:stepIndex withStepRatio:1 andGlobalRatio:_globalRatio];
        
        return;
    } else {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_increment target:self selector:@selector(update) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    }    
}

- (void)unpause {
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_increment target:self selector:@selector(update) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    _isPausedByUser = NO;
    _isPausedByPreview = NO;
    _isPausedByInfiniteWait = NO;
    
    if ([self.delegate respondsToSelector:@selector(unPaused)]) {
        [self.delegate unPaused];
    }
}
- (void)pauseForUser {
    _isPausedByUser = YES;
    [self pause];
    if ([self.delegate respondsToSelector:@selector(pausedByUser)]) {
        [self.delegate pausedByUser];
    }
}

- (void)pauseForPreview {
    _isPausedByPreview = YES;
    [self pause];
    if ([self.delegate respondsToSelector:@selector(pausedByPreview)]) {
        [self.delegate pausedByPreview];
    }
}

- (void)pauseForInfiniteWait {
    self.isPausedByInfiniteWait = YES;
    [self pause];
}

- (void)pause {
    [_timer invalidate];
    _timer = nil;
}

- (void)resetForLastStep {
    [self pause];
    
    if (_currentTime <= 0) {
        Step *s = [_kronicle.steps lastObject];
        _currentTime = s.time;
    }
}

- (void)dealloc {
//    dispatch_release(_backgroundQueue);
    [_timer invalidate];
    _timer = nil;
}

- (void)stop {
    [_timer invalidate];
    _timer = nil;
}

- (void)update {
    _currentTime -= 1;
    
    // create time string
    NSString *timeString = [KRClockManager clockTimeString:_currentTime];
    NSArray *splitTimeArr = [timeString  componentsSeparatedByString:@":"];
    
    _minutes = [splitTimeArr objectAtIndex:0];
    _seconds = [splitTimeArr objectAtIndex:1];
    
    // fires when over
    if ([_seconds isEqualToString:@"0-1"] && [_minutes isEqualToString:@"00"]) {
        [self playSound];
        [_timer invalidate];
        [self.delegate manager:self stepComplete:_step.indexInKronicle];
        return;
    }
    
    // ratio of completed step, minus one because its a countdown clock
    _stepRatio = 1 - ([[NSNumber numberWithInt: _currentTime] floatValue] / [[NSNumber numberWithInt: _stepTotal] floatValue] );
    
    // ratio of completed all time
    int totalSecondsPassed = _stepTotal - _currentTime;
    for (int i = 0; i < _step.indexInKronicle; i++) {
        Step *s = [_kronicle.steps objectAtIndex:i];
        totalSecondsPassed += s.time;
    }
    _globalRatio = ([[NSNumber numberWithInt:totalSecondsPassed] floatValue] / [[NSNumber numberWithInt: _kronicleTotal] floatValue] );
    
    [self.delegate manager:self updateTimeWithString:timeString andStepRatio:_stepRatio andGlobalRatio:_globalRatio];
}

+ (NSString *)displayTimeString:(NSInteger)time {
    NSDictionary *timeDict = [self getTimeUnits:time];
    NSInteger hours        = [[timeDict objectForKey:@"hours"] integerValue];
    NSInteger minutes      = [[timeDict objectForKey:@"minutes"] integerValue];
    NSInteger seconds      = [[timeDict objectForKey:@"seconds"] integerValue];
    
    NSString *unit;
    NSString *returnString = @"";
    
    if (time < 60) {
        if (time > 0) {
            unit            = [NSString stringWithFormat:@"%ds", seconds];
            returnString    = [returnString stringByAppendingString: [NSString stringWithFormat:@"%@", unit]];
        } else {
            returnString    = @"No time";
        }
        return returnString;
    }
    
    if (hours > 0) {
        unit                = [NSString stringWithFormat:@"%dh", hours];
        returnString        = [returnString stringByAppendingString: [NSString stringWithFormat:@"%@ ", unit]];
    }
    
    if (minutes > 0) {
        unit                = [NSString stringWithFormat:@"%dm", minutes];
        returnString        = [returnString stringByAppendingString: [NSString stringWithFormat:@"%@ ", unit]];
    }
    return returnString;
}

+ (NSString *)clockTimeString:(NSInteger)time {
    NSDictionary *timeDict = [self getTimeUnits:time];
    NSInteger hours        = [[timeDict objectForKey:@"hours"] integerValue];
    NSInteger minutes      = [[timeDict objectForKey:@"minutes"] integerValue];
    NSInteger seconds      = [[timeDict objectForKey:@"seconds"] integerValue];
    NSString *unit;    
    NSString *returnString = @"";
    if (hours > 0) {
        if (hours < 10) {
            unit = [NSString stringWithFormat:@"0%d", hours];
        } else {
            unit = [NSString stringWithFormat:@"%d", hours];
        }
        returnString = [returnString stringByAppendingString: [NSString stringWithFormat:@"%@:", unit]];
    }
    
    if (minutes < 10) {
        unit = [NSString stringWithFormat:@"0%d", minutes];
    } else {
        unit = [NSString stringWithFormat:@"%d", minutes];
    }
    returnString = [returnString stringByAppendingString: [NSString stringWithFormat:@"%@:", unit]];
    
    if (seconds < 10) {
        unit = [NSString stringWithFormat:@"0%d", seconds];
    } else {
        unit = [NSString stringWithFormat:@"%d", seconds];
    }
    returnString = [returnString stringByAppendingString: [NSString stringWithFormat:@"%@", unit]];
    
    return returnString;
}

+ (NSDictionary *)getTimeUnits:(NSInteger)secondsTotal {
    NSInteger seconds;
    NSInteger minutes;
    NSInteger hours;
    hours                           = floor(secondsTotal / (60 * 60));
    secondsTotal                    = secondsTotal - (hours * (60 * 60));
    minutes                         = floor(secondsTotal / 60);
    seconds                         = secondsTotal - (minutes * 60);
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:seconds],   @"seconds",
            [NSNumber numberWithInteger:minutes],   @"minutes",
            [NSNumber numberWithInteger:hours],     @"hours",
            [NSNumber numberWithInteger:secondsTotal],     @"totalTime",
            nil];
}

- (void)playSound {
    dispatch_async(_backgroundQueue, ^(void) {
        SystemSoundID soundID;
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/OrganicAlertNotifications_04.mp3", [[NSBundle mainBundle] resourcePath]]];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
        AudioServicesPlaySystemSound (soundID);
    });
}


@end
























