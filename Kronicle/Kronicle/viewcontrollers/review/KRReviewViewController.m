//
//  KRReviewViewController.m
//  Kronicle
//
//  Created by Scott on 8/30/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRReviewViewController.h"
#import "CreateReviewView.h"
#import "AntiScrollVIew.h"
#import "KRReviewOverlay.h"
#import "KRTextButton.h"
#import "ManagedContextController.h"

@interface KRReviewViewController () <KRReviewOverlayDelegate> {
    @private
    UITextField *_titleField;
    CreateReviewView *_reviewCreatorView;
    KRReviewOverlay *_reviewOverlay;
    UIScrollView *_scrollView;
    __weak Kronicle *_kronicle;
    UIButton *_cancelXButton;
    KRTextButton *_addReviewButton;
}

@end

@implementation KRReviewViewController

- (id)initWithKronicle:(Kronicle *)kronicle {
    self = [super initWithNibName:@"KRReviewViewController" bundle:nil];
    if (self) {
        // Custom initialization
        _kronicle = kronicle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _bounds.size.width, _bounds.size.height-20)];
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _cancelXButton                                                  = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelXButton.backgroundColor                                  = [UIColor clearColor];
    _cancelXButton.frame                                            = CGRectMake(320 - 45, 5, 40, 40);
    [_cancelXButton setBackgroundImage:[UIImage imageNamed:@"transx"] forState:UIControlStateNormal];
    [_cancelXButton addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_cancelXButton];

    _titleField                                 = [UIHelper titleTextField];
    _titleField.frame                           = CGRectMake(kPadding, 0, kPaddingWidth, 90);
    _titleField.enabled                         = NO;
    _titleField.placeholder                     = NSLocalizedString(@"Reviews", @"Title of review view controller");
    [_scrollView addSubview:_titleField];
        
    _reviewOverlay                              = [[KRReviewOverlay alloc] initWithFrame:_bounds];
    _reviewOverlay.delegate                     = self;
    [_reviewOverlay setReviewWithValue:_kronicle.rating];
    
    _reviewCreatorView                          = [[CreateReviewView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - [CreateReviewView size]) * .5,
                                                                                                     _titleField.frame.origin.y + _titleField.frame.size.height - 20,
                                                                                                     [CreateReviewView size],
                                                                                                     [CreateReviewView size]) andType:CreateReviewViewShow];
    _reviewCreatorView.enabled                  = NO;
    [_reviewCreatorView setReviewWithValue:_kronicle.rating];
    [_scrollView addSubview:_reviewCreatorView];
    

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottomblarg"]];
    imageView.frame = CGRectMake(0, _reviewCreatorView.frame.origin.y + _reviewCreatorView.frame.size.height, 320, 708);
    [_scrollView addSubview:imageView];
    
    _addReviewButton = [[KRTextButton alloc] initWithFrame:CGRectMake(kPadding, imageView.frame.origin.y + 140, 200, 42)
                                              andType:KRTextButtonTypeHomeScreen
                                              andIcon:[UIImage imageNamed:@"addreviewbuttoncircle"]];
    [_addReviewButton setTitle:NSLocalizedString(@"Review this kronicle", @"Review this kronicle button") forState:UIControlStateNormal];
    [_addReviewButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_addReviewButton addTarget:self action:@selector(animateInReviewer) forControlEvents:UIControlEventTouchUpInside];
    _addReviewButton.titleEdgeInsets                 = UIEdgeInsetsMake(0, 18, 0, 0);
    _addReviewButton.imageEdgeInsets                = UIEdgeInsetsMake(0, 10, 0, 0);
    _addReviewButton.backgroundColor                = [KRColorHelper turquoise];
    _addReviewButton.titleLabel.font                = [KRFontHelper getFont:KRBrandonLight withSize:18];
    [_scrollView addSubview:_addReviewButton];
    
    _scrollView.contentSize = CGSizeMake(320, imageView.frame.origin.y + imageView.frame.size.height);
    _scrollView.canCancelContentTouches = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [(KRNavigationViewController *)self.navigationController navbarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popViewController:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark create review
- (void)reviewOverlay:(KRReviewOverlay *)reviewOverlay finishedWithValue:(CGFloat)value {
    _kronicle.rating = value;
    [[ManagedContextController current] saveContext];
   
    [_reviewCreatorView setReviewWithValue:value];
    [self animateOutReviewer];
}

- (void)reviewOverlayCancelled {
    [self animateOutReviewer];
}


#pragma review methods
- (void)animateInReviewer {
    [(KRNavigationViewController *)self.navigationController navbarHidden:YES];
    _reviewOverlay.alpha = 0;
    [self.view addSubview:_reviewOverlay];
    
    [UIView animateWithDuration:.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _scrollView.contentOffset = CGPointZero;
                     }
                     completion:^(BOOL fin){
                         [UIView animateWithDuration:.4f
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              _reviewOverlay.alpha = 1;
                                          }
                                          completion:^(BOOL fin){
                                          }];
                     }];
}

- (void)animateOutReviewer {
    [UIView animateWithDuration:.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _reviewOverlay.alpha = 0;
                     }
                     completion:^(BOOL fin){
                         [_reviewOverlay removeFromSuperview];
                         [_reviewOverlay setReviewWithValue:_kronicle.rating];
                     }];
}



@end































