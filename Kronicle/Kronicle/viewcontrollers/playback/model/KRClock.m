//
//  KRClock.m
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRClock.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@implementation KRClock

+ (KRClock *)sharedClock {
    static KRClock *krClock = nil;
    if (!krClock) {
        krClock = [[KRClock alloc] init];
    }
    return krClock;
}

- (void)resetWithTime:(CGFloat)total {
    _startTotal = total;
    _total = total;
}

- (void)calibrateForKronicle:(int)numSteps {
    _index = 0;
    _maxIndex = numSteps;
}

- (void)pause {
    _isPaused = YES;
    [_timer invalidate];
}

- (void)play {
    _isPaused = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(update) userInfo:nil repeats:YES];
}

- (void)setValues{
    int minutes = floor(_total / 60);
    int seconds = floor(_total - (minutes*60));
    
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

- (void)update {
    _total -= 1;
    [self setValues];
    if ([_seconds isEqualToString:@"0-1"] && [_minutes isEqualToString:@"00"]) {
        if (_index == _maxIndex-1) {
            [self pause];
            if ([self.delegate respondsToSelector:@selector(kronicleTimeOver:)]) {
                [self.delegate kronicleTimeOver:self];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(clockTimeOver:)]) {
                [self.delegate clockTimeOver:self];
            }
        }
        [self playSound];
        return;
    }
    CGFloat p = 1 - ([[NSNumber numberWithInt: _total] floatValue] /[[NSNumber numberWithInt: _startTotal] floatValue] );
    if ([self.delegate respondsToSelector:@selector(clock:updateWithTimeString:andPercent:)]) {
        [self.delegate clock:self updateWithTimeString:[self stringForTime] andPercent:p];
    }
}

- (void)playSound {
    SystemSoundID soundID;
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/OrganicAlertNotifications_04.mp3", [[NSBundle mainBundle] resourcePath]]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    AudioServicesPlaySystemSound (soundID);
}

- (NSString*)stringForTime {
    return [NSString stringWithFormat:@"%@:%@", _minutes, _seconds];
}

- (void) dealloc {
    [_timer invalidate];
    _timer = nil;
}
@end
