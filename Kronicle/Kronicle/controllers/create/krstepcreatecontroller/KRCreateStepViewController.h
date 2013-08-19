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


@interface KRCreateStepViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>

- (id)initWithStep:(KRStep *)step;

@end
