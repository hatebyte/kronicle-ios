//
//  KRClock.m
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRClock.h"

@implementation KRClock

+ (KRClock *)sharedClock {
    static KRClock *krClock = nil;
    if (!krClock) {
        krClock = [[KRClock alloc] init];
    }
    return krClock;
}

- (void)resetWithTime:(CGFloat)total {
//    if (_index == _maxIndex-1) {
//        [self pause];
//        if ([self.delegate respondsToSelector:@selector(kronicleTimeOver:)]) {
//            [self.delegate kronicleTimeOver:self];
//        }
//    } else {
        _total = total;
//    }
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
    //int hours = floor(_total / 3600);
    int minutes = floor(_total / 60);
    int seconds = floor(_total - (minutes*60));
    
//    if (hours < 10) {
//        _hours = [NSString stringWithFormat:@"0%d", hours];
//    } else {
//        _hours = [NSString stringWithFormat:@"%d", hours];
//    }
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
            return;
        } else {
            if ([self.delegate respondsToSelector:@selector(clockTimeOver:)]) {
                [self.delegate clockTimeOver:self];
            }
        }

        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(clock:updateWithTimeString:)]) {
        [self.delegate clock:self updateWithTimeString:[self stringForTime]];
    }
}

- (NSString*)stringForTime {
    return [NSString stringWithFormat:@"%@:%@", _minutes, _seconds];
}

- (void) dealloc {
    [_timer invalidate];
    _timer = nil;
}
@end
