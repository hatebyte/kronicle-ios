//
//  KRClockManager.h
//  Kronicle
//
//  Created by Scott on 8/5/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KRKronicle.h"
#import "KRStep.h"

@class KRClockManager;
@protocol KRClockManagerDelegate <NSObject>

- (void)manager:(KRClockManager *)manager updateTimeWithString:(NSString *)timeString
   andStepRatio:(CGFloat)stepRatio
 andGlobalRatio:(CGFloat)globalRatio;
- (void)manager:(KRClockManager *)manager stepComplete:(int)stepIndex;

@end

@interface KRClockManager : NSObject


@property (nonatomic, weak) id <KRClockManagerDelegate> delegate;

+ (NSString *)stringTimeForInt:(int)time;

- (id)initWithKronicle:(KRKronicle *)kronicle;
- (void)setTimeForStep:(int)step;

@end
