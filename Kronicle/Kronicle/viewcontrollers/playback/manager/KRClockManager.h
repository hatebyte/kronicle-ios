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
- (void)manager:(KRClockManager *)manager stepComplete:(int)stepIndex;

@end

@interface KRClockManager : NSObject


@property (nonatomic, weak) id <KRClockManagerDelegate> delegate;
@property (nonatomic, assign) BOOL isPaused;

+ (NSString *)stringTimeForInt:(int)time;
+ (NSDictionary *)getTimeUnits:(NSInteger)secondsTotal;

- (id)initWithKronicle:(Kronicle *)kronicle;
- (void)setTimeForStep:(int)step;
- (void)togglePlayPause;
- (void)stop;

@end
