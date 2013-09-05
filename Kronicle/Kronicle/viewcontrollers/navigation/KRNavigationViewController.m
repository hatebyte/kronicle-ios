//
//  KRNavigationViewController.m
//  Kronicle
//
//  Created by Scott on 8/12/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRNavigationViewController.h"
#import "KRSwipeViewNavigation.h"

@interface KRNavigationViewController () {
    @private
    KRSwipeViewNavigation *_swipeNav;
}

@end

@implementation KRNavigationViewController

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
	
    // Do any additional setup after loading the view.
    
    _swipeNav = [[KRSwipeViewNavigation alloc] initWithFrame:CGRectMake(0,
                                                                        self.view.frame.size.height - [KRSwipeViewNavigation cellHeight],
                                                                        320,
                                                                        [KRSwipeViewNavigation cellHeight])];
    [self.view addSubview:_swipeNav];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
}

- (void)close {
    [_swipeNav close];
}

- (void)navbarHidden:(BOOL)isHidden {
    if (isHidden) {
        [_swipeNav hide];
    } else {
        [_swipeNav reposition];
    }
}

- (void)setNavigationTitle:(NSString *)title {
    _swipeNav.titleLabel.text = title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
