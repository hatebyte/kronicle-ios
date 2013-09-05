//
//  KRMeViewController.m
//  Kronicle
//
//  Created by Scott on 8/17/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRMeViewController.h"
#import "KRColorHelper.h"

@interface KRMeViewController () {
    UIScrollView *_sview;
    UIImageView *_imageView;
}

@end

@implementation KRMeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [KRColorHelper grayLight];
        
        _sview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _bounds.size.width, _bounds.size.height-64)];
        _sview.bounces = YES;
        _sview.showsVerticalScrollIndicator = YES;
        _sview.showsHorizontalScrollIndicator = NO;
        _sview.backgroundColor = [UIColor clearColor];
        _sview.contentSize = CGSizeMake(320, 750);
        [self.view addSubview:_sview];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile-view.png"]];
        imageView.frame = CGRectMake(0,0,_sview.contentSize.width, _sview.contentSize.height);
        [_sview addSubview:imageView];
        
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [KRColorHelper turquoise];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [(KRNavigationViewController *)self.navigationController navbarHidden:NO];
    [(KRNavigationViewController *)self.navigationController setNavigationTitle:@"Me"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
