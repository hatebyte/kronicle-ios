//
//  CreateStepTimeView.h
//  Kronicle
//
//  Created by Scott on 8/11/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CreateStepTimeUnitSeconds,
    CreateStepTimeUnitMinutes,
    CreateStepTimeUnitHours,
} CreateStepTimeUnitType;


@class CreateStepTimeView;
@protocol CreateStepTimeViewDelegate <NSObject>
- (void)createStepTimeView:(CreateStepTimeView *)durationCreatorView finishedWithValue:(int)value;
@end


@interface CreateStepTimeView : UIView

@property(nonatomic, weak) id <CreateStepTimeViewDelegate> delegate;
@property(nonatomic, assign) int value;
@property(nonatomic, assign) CreateStepTimeUnitType unit;

- (void)setUnit:(CreateStepTimeUnitType)unit withValue:(int)value;


@end
