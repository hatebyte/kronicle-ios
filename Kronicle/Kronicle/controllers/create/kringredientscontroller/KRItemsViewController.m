//
//  KRItemsViewController.m
//  Kronicle
//
//  Created by Scott on 8/16/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRItemsViewController.h"
#import "KRColorHelper.h"
#import "KRFontHelper.h"

@interface KRItemsViewController () {
    @private
    UIButton *_cancelXButton;
}

@end

@implementation KRItemsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _cancelXButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelXButton.backgroundColor = [KRColorHelper turquoise];
    [_cancelXButton setBackgroundImage:[UIImage imageNamed:@"close-x_40px"] forState:UIControlStateNormal];
    _cancelXButton.frame = CGRectMake(0, 0, 40, 40);
    [_cancelXButton addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelXButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popViewController:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
