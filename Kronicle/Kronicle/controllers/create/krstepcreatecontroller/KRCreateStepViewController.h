//
//  KRCreateStepViewController.h
//  Kronicle
//
//  Created by Scott on 6/12/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DurationCreatorView.h"
#import "KRStep.h"


@interface KRCreateStepViewController : UIViewController <UINavigationControllerDelegate>

@property(nonatomic, weak) IBOutlet UIButton *backbutton;
@property(nonatomic, weak) IBOutlet UIButton *seconds;
@property(nonatomic, weak) IBOutlet UIButton *minutes;
@property(nonatomic, weak) IBOutlet UIButton *hours;

- (IBAction)back:(id)sender;
- (IBAction)hoursTapped:(id)sender;
- (IBAction)minutesTapped:(id)sender;
- (IBAction)secondsTapped:(id)sender;
- (id)initWithStep:(KRStep *)step;

@end
