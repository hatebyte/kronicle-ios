//
//  KRCreateStepViewController.m
//  Kronicle
//
//  Created by Scott on 6/12/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRCreateStepViewController.h"
#import "KRColorHelper.h"
#import "KRFontHelper.h"


@interface KRCreateStepViewController () {
    UIButton *_secondsButton;
    UIButton *_minutesButton;
    UIButton *_hoursButton;
    UIButton *_currentButton;
    DurationCreatorView *_durationCreator;
}

@end

@implementation KRCreateStepViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _secondsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _secondsButton.frame = CGRectMake(20, 350, 80, 35);
    [_secondsButton addTarget:self action:@selector(timeButtonHit:) forControlEvents:UIControlEventTouchDown];
    _secondsButton.titleLabel.text = @"0:00";
    _secondsButton.titleLabel.textColor = [KRColorHelper darkBlue];
    [self.view addSubview:_secondsButton];
    
    _minutesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _minutesButton.frame = CGRectMake(_secondsButton.frame.origin.x + _secondsButton.frame.size.width + 10, _secondsButton.frame.origin.y, 80, 35);
    [_minutesButton addTarget:self action:@selector(timeButtonHit:) forControlEvents:UIControlEventTouchDown];
    _minutesButton.titleLabel.text = @"0:00";
    _minutesButton.titleLabel.textColor = [KRColorHelper darkBlue];
    [self.view addSubview:_minutesButton];
    
    _hoursButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _hoursButton.frame = CGRectMake(_minutesButton.frame.origin.x + _minutesButton.frame.size.width+ 10, _minutesButton.frame.origin.y, 80, 35);
    [_hoursButton addTarget:self action:@selector(timeButtonHit:) forControlEvents:UIControlEventTouchDown];
    _hoursButton.titleLabel.text = @"0:00";
    _hoursButton.titleLabel.textColor = [KRColorHelper darkBlue];
    [self.view addSubview:_hoursButton];

}

- (void)timeButtonHit:(id)sender {
    
//    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:60] forKey:@"increments"];
//    [[NSNotificationCenter defaultCenter] postNotificationName: @"DurationCreation" object:self userInfo:userInfo];
    
    _currentButton = sender;
    CGFloat lastTime =(![_currentButton.titleLabel.text isEqualToString:@""]) ? [_currentButton.titleLabel.text intValue] : 1.f;
    
    _durationCreator = [[DurationCreatorView alloc] initWithFrame:CGRectMake(10, 50, 300, 300)];
    _durationCreator.transform = CGAffineTransformMakeRotation(M_PI_2);
    _durationCreator.delegate = self;
    [self.view addSubview:_durationCreator];

}
- (void)touchView:(DurationCreatorView *)touchview updateWithPercent:(CGFloat)percent {
    //    _label.text = [NSString stringWithFormat:@"%d", (int)(percent * 60 - 1)];
    NSLog(@"value : %d", (int)(percent * 59));
   
    [_currentButton setTitle:[NSString stringWithFormat:@"%d",  (int)(percent * 59)] forState:UIControlStateNormal];
    
}

- (void)touchUpForExit:(DurationCreatorView *)durationCreatorView withPercent:(CGFloat)percent{
    NSLog(@"value : %d", (int)(percent * 59));
    
    [_currentButton setTitle:[NSString stringWithFormat:@"%d",  (int)(percent * 59)] forState:UIControlStateNormal];
    [_durationCreator removeFromSuperview];
    
    //    [[NSNotificationCenter defaultCenter]
    //     postNotificationName:@"TestNotification"
    //     object:self];
    //    NSDictionary *userInfo = notification.userInfo;
    //    MyObject *myObject = [userInfo objectForKey:@"someKey"];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
