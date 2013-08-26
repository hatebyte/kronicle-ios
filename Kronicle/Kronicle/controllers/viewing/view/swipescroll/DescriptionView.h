//
//  DescriptionView.h
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Step.h"

@interface DescriptionView : UIView

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *subClockLabel;
@property(nonatomic, strong) UITextView *description;
@property(nonatomic, weak) Step *step;


- (id)initWithFrame:(CGRect)frame andStep:(Step*)step;
- (id)initAsFinishedWithFrame:(CGRect)frame;
- (void)updateClock:(NSString *)timeString;
- (void)resetClock;
- (void)updateForFinished;

@end
