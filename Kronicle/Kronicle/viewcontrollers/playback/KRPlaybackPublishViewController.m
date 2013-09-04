//
//  KRPlaybackPublishViewController.m
//  Kronicle
//
//  Created by Scott on 9/3/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRPlaybackPublishViewController.h"
#import "KRPublishKronicleOverlay.h"

@interface KRPlaybackPublishViewController () <KRPublishKronicleOverlayDelegate> {
    KRPublishKronicleOverlay *_publishOverlay;
    int _publishButtonHeight;
}

@end

@implementation KRPlaybackPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_backButton removeFromSuperview];
    _backButton = nil;
    [_itemsButton removeFromSuperview];
    _itemsButton = nil;
    
    _backButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];

    [_backButton setTitle:@"Edit" forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _backButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:.3];
    _backButton.titleLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:14];
    _backButton.frame = CGRectMake(5, 5, 40, 26);
    
    _publishButtonHeight = 42;
    _publishButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    _publishButton.backgroundColor = [KRColorHelper turquoise];
    [_publishButton setTitle:@"Publish" forState:UIControlStateNormal];
    [_publishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _publishButton.titleLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:14];
    _publishButton.frame = CGRectMake(_bounds.size.width - 82, _bounds.size.height-(_publishButtonHeight+20), 82, _publishButtonHeight);
    [_publishButton addTarget:self action:@selector(showPublishKronicleOverlay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_publishButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)kronicleComplete:(KRKronicleManager *)manager {
    [self showPublishKronicleOverlay];
}

#pragma publish
- (void)showPublishKronicleOverlay {
    _publishOverlay = [[KRPublishKronicleOverlay alloc] initWithFrame:self.view.frame andKronicle:self.kronicle];
    _publishOverlay.alpha = 0;
    _publishOverlay.delegate = self;
    [self.view addSubview:_publishOverlay];
    
    [UIView animateWithDuration:.5
                          delay:.2f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _publishOverlay.alpha = 1.f;
                     }
                     completion:^(BOOL fin){
                     }];
}

- (void)removePublishKronicleOverlay {
    
    [UIView animateWithDuration:.5
                          delay:.2f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _publishOverlay.alpha = 0.f;
                     }
                     completion:^(BOOL fin){
                         [_publishOverlay removeFromSuperview];
                         _publishOverlay = nil;
                         
                     }];
}

- (void)publishKronicleOverlayCanceled {
    [self removePublishKronicleOverlay];
}

- (void)publishKronicleOverlayPublish {
    self.kronicle.isFinished = YES;
    [[ManagedContextController current] saveContext];
    [self removePublishKronicleOverlay];
    
    [[KRHomeViewController current] mykronicles];
}

- (void)publishKronicleOverlayPhotoChanged {
    
}

@end
