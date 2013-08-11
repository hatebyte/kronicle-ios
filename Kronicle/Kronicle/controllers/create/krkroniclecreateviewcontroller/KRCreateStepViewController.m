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


@interface KRCreateStepViewController () <CreateStepTimeViewDelegate> {
    UIButton *_secondsButton;
    UIButton *_minutesButton;
    UIButton *_hoursButton;
    UIButton *_currentButton;
    CreateStepTimeView *_createStepTimeView;
}

@end

@implementation KRCreateStepViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor blackColor];
        
    }
    return self;
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
    // Do any additional setup after loading the view from its nib.
    
    _createStepTimeView = [[CreateStepTimeView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _createStepTimeView.delegate = self;

}

- (void)createStepTimeView:(CreateStepTimeView *)durationCreatorView finishedWithValue:(int)value {
    //    _label.text = [NSString stringWithFormat:@"%d", (int)(percent * 60 - 1)];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
