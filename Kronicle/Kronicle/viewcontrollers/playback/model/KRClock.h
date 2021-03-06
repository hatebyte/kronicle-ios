//
//  KRClock.h
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KRClock;
@protocol KRClockDelegate <NSObject>
    @optional
    - (void)clock:(KRClock*)clock updateWithTimeString:(NSString*)string andPercent:(CGFloat)percent;
    - (void)clockTimeOver:(KRClock*)clock;
    - (void)kronicleTimeOver:(KRClock*)clock;
@end

@interface KRClock : NSObject {
    @private
    int _startTotal;
    int _total;
    NSString *_minutes;
    NSString *_hours;
    NSString *_seconds;
    NSTimer *_timer;
}

@property(nonatomic, weak) id <KRClockDelegate> delegate;
@property(nonatomic, assign) BOOL isPaused;
@property(nonatomic, assign) int index;
@property(nonatomic, assign) int maxIndex;

+ (KRClock *)sharedClock;

- (void)resetWithTime:(CGFloat)time;
- (void)calibrateForKronicle:(int)numSteps;
- (void)pause;
- (void)play;
- (NSString*)stringForTime;

@end
