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
#import "CreateStepTimeView.h"
#import "KRNavigationViewController.h"


@interface KRCreateStepViewController () <CreateStepTimeViewDelegate> {
    UIButton *_secondsButton;
    UIButton *_minutesButton;
    UIButton *_hoursButton;
    UIButton *_currentButton;
    CreateStepTimeView *_createStepTimeView;
    __weak KRStep *_step;
}

@end

@implementation KRCreateStepViewController

- (id)initWithStep:(KRStep *)step {
    self = [super initWithNibName:@"KRCreateStepViewController" bundle:nil];
    if (self) {
        _step = step;

        self.view.backgroundColor = [UIColor blackColor];
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [(KRNavigationViewController *)self.navigationController navbarHidden:NO];
}



- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)hoursTapped:(id)sender {
    [_createStepTimeView setUnit:CreateStepTimeUnitHours withValue:[self.hours.titleLabel.text integerValue]];
    [self animateInCreator];
}

- (IBAction)minutesTapped:(id)sender {
    [_createStepTimeView setUnit:CreateStepTimeUnitMinutes withValue:[self.minutes.titleLabel.text integerValue]];
    [self animateInCreator];
}

- (IBAction)secondsTapped:(id)sender {
    [_createStepTimeView setUnit:CreateStepTimeUnitSeconds withValue:[self.seconds.titleLabel.text integerValue]];
    [self animateInCreator];
}

- (void)animateInCreator {
    [(KRNavigationViewController *)self.navigationController navbarHidden:YES];

    _createStepTimeView.alpha = 0;
    [self.view addSubview:_createStepTimeView];

    [UIView animateWithDuration:.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _createStepTimeView.alpha = 1;
                     }
                     completion:^(BOOL fin){
                     }];
}

- (void)animateOutCreator {    
    [UIView animateWithDuration:.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _createStepTimeView.alpha = 0;
                     }
                     completion:^(BOOL fin){
                         [_createStepTimeView removeFromSuperview];
                     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _createStepTimeView = [[CreateStepTimeView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _createStepTimeView.delegate = self;

}

- (void)createStepTimeView:(CreateStepTimeView *)durationCreatorView finishedWithValue:(int)value {

    switch (durationCreatorView.unit) {
        case CreateStepTimeUnitHours:
            [self.hours setTitle:[NSString stringWithFormat:@"%d", value] forState:UIControlStateNormal];
            break;
        case CreateStepTimeUnitMinutes:
            [self.minutes setTitle:[NSString stringWithFormat:@"%d", value] forState:UIControlStateNormal];
            break;
        case CreateStepTimeUnitSeconds:
            [self.seconds setTitle:[NSString stringWithFormat:@"%d", value] forState:UIControlStateNormal];
            break;
    }
    [self animateOutCreator];
    [(KRNavigationViewController *)self.navigationController navbarHidden:NO];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
