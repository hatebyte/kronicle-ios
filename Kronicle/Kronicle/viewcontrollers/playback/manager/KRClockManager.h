//
//  KRClockManager.h
//  Kronicle
//
//  Created by Scott on 8/5/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Kronicle+Helper.h"
#import "Step+Helper.h"

@class KRClockManager;
@protocol KRClockManagerDelegate <NSObject>

- (void)manager:(KRClockManager *)manager updateTimeWithString:(NSString *)timeString
   andStepRatio:(CGFloat)stepRatio
 andGlobalRatio:(CGFloat)globalRatio;
- (void)manager:(KRClockManager *)manager stepComplete:(NSInteger)stepIndex;
- (void)manager:(KRClockManager *)manager pauseForInfiniteWait:(NSInteger)stepIndex
  withStepRatio:(CGFloat)stepRatio
 andGlobalRatio:(CGFloat)globalRatio;

@optional
- (void)pausedByUser;
- (void)pausedByPreview;
- (void)unPaused;

@end

@interface KRClockManager : NSObject


@property (nonatomic, weak) id <KRClockManagerDelegate> delegate;
@property (nonatomic, assign) BOOL isPausedByPreview;
@property (nonatomic, assign) BOOL isPausedByUser;
@property (nonatomic, assign) BOOL isPausedByInfiniteWait;

+ (NSString *)stringTimeForInt:(NSInteger)time;
+ (NSDictionary *)getTimeUnits:(NSInteger)secondsTotal;

- (id)initWithKronicle:(Kronicle *)kronicle;
- (void)setTimeForCurrentStep:(int)step;
//- (void)togglePlayPause;
- (void)stop;
- (void)unpause;
- (void)pauseForPreview;
- (void)pauseForUser;
- (void)resetForLastStep;

@end