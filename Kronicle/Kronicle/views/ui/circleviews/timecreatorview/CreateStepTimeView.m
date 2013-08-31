//
//  CreateStepTimeView.m
//  Kronicle
//
//  Created by Scott on 8/11/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "CreateStepTimeView.h"
#import "TouchCircleCreatorView.h"
#import "KRFontHelper.h"
#import "KRColorHelper.h"

CGFloat const unitWidth = 30.f;
CGFloat const unitHeight = 20.f;


@interface CreateStepTimeView () <TouchCircleCreatorViewDelegate> {
    @private
    TouchCircleCreatorView *_durationCreator;
    UILabel *_topUnitLabel;
    UILabel *_bottomUnitLabel;
    UILabel *_leftUnitLabel;
    UILabel *_rightUnitLabel;
    UILabel *_largerCenterLabel;
    UILabel *_sublabel;
    
    UIButton *_cancelXBUtton;
    UIButton *_okButton;
    int _startVal;
}

@end

@implementation CreateStepTimeView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        int size = 260;
        _durationCreator = [[TouchCircleCreatorView alloc] initWithFrame:CGRectMake((self.frame.size.width - size) * .5,
                                                                                 (frame.size.height - size) * .5,
                                                                                 size,
                                                                                 size)];
        _durationCreator.lineJoin                       = kCGLineJoinRound;
        _durationCreator.lineCap                        = kCGLineCapButt;
        _durationCreator.strokeColorBackground          = [UIColor whiteColor];
        _durationCreator.strokeColor                    = [KRColorHelper orange];
        _durationCreator.delegate                       = self;
        
        _topUnitLabel = [self getUniteLabel];
        _topUnitLabel.frame = CGRectMake((self.frame.size.width - unitWidth) * .5,
                                         _durationCreator.frame.origin.y - (unitHeight + 4),
                                         unitWidth,
                                         unitHeight);
        [self addSubview:_topUnitLabel];

        _rightUnitLabel = [self getUniteLabel];
        _rightUnitLabel.frame = CGRectMake(self.frame.size.width - unitWidth,
                                           (_durationCreator.frame.origin.y + (_durationCreator.frame.size.height * .5)) - (unitHeight*.5),
                                           unitWidth,
                                           unitHeight);
        [self addSubview:_rightUnitLabel];

        _bottomUnitLabel = [self getUniteLabel];
        _bottomUnitLabel.frame = CGRectMake((self.frame.size.width - unitWidth) * .5,
                                            _durationCreator.frame.origin.y + _durationCreator.frame.size.height + 6,
                                            unitWidth,
                                            unitHeight);
        [self addSubview:_bottomUnitLabel];
        
        _leftUnitLabel = [self getUniteLabel];
        _leftUnitLabel.frame = CGRectMake(0,
                                          (_durationCreator.frame.origin.y + (_durationCreator.frame.size.height * .5)) - (unitHeight*.5),
                                          unitWidth,
                                          unitHeight);
        [self addSubview:_leftUnitLabel];
        
        _largerCenterLabel = [self getUniteLabel];
        _largerCenterLabel.frame = CGRectMake(_durationCreator.frame.origin.x,
                                              _durationCreator.frame.origin.y - 15,
                                              _durationCreator.frame.size.width,
                                              _durationCreator.frame.size.height);
        _largerCenterLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:122];
        _largerCenterLabel.text = @"0";
        [self addSubview:_largerCenterLabel];
        
        _sublabel = [self getUniteLabel];
        _sublabel.frame = CGRectMake(0,
                                     _durationCreator.frame.origin.y + (_durationCreator.frame.size.height * .5) + 35,
                                     320,
                                     30);
        _sublabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:25];
        _sublabel.text = @"Seconds";
        [self addSubview:_sublabel];
        
        [self addSubview:_durationCreator];
        
        _cancelXBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelXBUtton.frame = CGRectMake(0, 0, 35, 35);
        _cancelXBUtton.backgroundColor = [UIColor clearColor];
        [_cancelXBUtton setImage:[UIImage imageNamed:@"cancel_x"] forState:UIControlStateNormal];
        [_cancelXBUtton addTarget:self action:@selector(exitPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelXBUtton];

        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _okButton.frame = CGRectMake(self.frame.size.width - 60, 0, 60, 42);
        _okButton.backgroundColor = [KRColorHelper orange];
        _okButton.titleLabel.font = [KRFontHelper getFont:KRBrandonBold withSize:20];
        _okButton.titleLabel.textColor = [UIColor whiteColor];
        [_okButton setTitle:@"Ok" forState:UIControlStateNormal];
        [_okButton addTarget:self action:@selector(okPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_okButton];

    }
    return self;
}

- (void)setUnit:(CreateStepTimeUnitType)unit withValue:(NSInteger)value {
    _startVal = value;
    _value = value;
    _unit = unit;
    _largerCenterLabel.text = [NSString stringWithFormat:@"%d", value];
    switch (_unit) {
        case CreateStepTimeUnitHours:
            _sublabel.text = @"Hours";
            _topUnitLabel.text = @"0";
            _rightUnitLabel.text = @"6";
            _bottomUnitLabel.text = @"12";
            _leftUnitLabel.text = @"18";
            [_durationCreator updateGraphWithPercent:(CGFloat)value / 24];
            break;
        case CreateStepTimeUnitMinutes:
            _sublabel.text = @"Minutes";
            _topUnitLabel.text = @"0";
            _rightUnitLabel.text = @"15";
            _bottomUnitLabel.text = @"30";
            _leftUnitLabel.text = @"45";
            [_durationCreator updateGraphWithPercent:(CGFloat)value / 60];
            break;
        case CreateStepTimeUnitSeconds:
            _sublabel.text = @"Seconds";
            _topUnitLabel.text = @"0";
            _rightUnitLabel.text = @"15";
            _bottomUnitLabel.text = @"30";
            _leftUnitLabel.text = @"45";
            [_durationCreator updateGraphWithPercent:(CGFloat)value / 60];
            break;
    }
}

- (UILabel *)getUniteLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = [KRFontHelper getFont:KRBrandonBold withSize:20];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (IBAction)okPressed:(id)sender {

    [self.delegate createStepTimeView:self finishedWithValue:_value];
    
}

- (IBAction)exitPressed:(id)sender {
    [self.delegate createStepTimeView:self finishedWithValue:_startVal];
}

- (void)touchCircleCreatorView:(TouchCircleCreatorView *)touchCircleCreatorView updateWithPercent:(CGFloat)percent {

    switch (_unit) {
        case CreateStepTimeUnitHours:
            _value = (NSInteger)ceil(percent * 23);
            _largerCenterLabel.text = [NSString stringWithFormat:@"%d", _value];
            break;
        case CreateStepTimeUnitMinutes:
            _value = (NSInteger)ceil(percent * 59);
            _largerCenterLabel.text = [NSString stringWithFormat:@"%d", _value];
            break;
        case CreateStepTimeUnitSeconds:
            _value = (NSInteger)ceil(percent * 59);
            _largerCenterLabel.text = [NSString stringWithFormat:@"%d", _value];
            break;
    }
}


@end
