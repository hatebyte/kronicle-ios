//
//  KRNavigationViewController.m
//  Kronicle
//
//  Created by Scott on 8/12/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRNavigationViewController.h"
#import "KRSwipeViewNavigation.h"
#import "KRGlobals.h"

@interface KRNavigationViewController () {
    @private
    KRSwipeViewNavigation *_swipeNav;
}

@end

@implementation KRNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect bounds = [UIScreen mainScreen].bounds;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        UIView *firstView = [[self.view subviews] objectAtIndex:0];
        firstView.frame  = CGRectMake(firstView.frame.origin.x, firstView.frame.origin.y-20, firstView.frame.size.width, firstView.frame.size.height+20);
    }

    _swipeNav = [[KRSwipeViewNavigation alloc] initWithFrame:CGRectMake(0,
                                                                        bounds.size.height - [KRSwipeViewNavigation cellHeight],
                                                                        320,
                                                                        [KRSwipeViewNavigation cellHeight])];
    [self.view addSubview:_swipeNav];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
