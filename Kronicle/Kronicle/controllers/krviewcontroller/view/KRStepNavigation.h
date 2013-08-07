//
//  KRStepNavigation.h
//  Kronicle
//
//  Created by Scott on 8/6/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    KRStepNavigationRequestForward,
    KRStepNavigationRequestBackward,
    KRStepNavigationRequestResume,
    KRStepNavigationRequestSkip,
    KRStepNavigationRequestStartOver,
} KRStepNavigationRequest;

@class KRStepNavigation;
@protocol KRStepNavigationDelegate <NSObject>

- (void)controls:(KRStepNavigation *)controls navigationRequested:(KRStepNavigationRequest)type;

@end

@interface KRStepNavigation : UIView

@property (nonatomic, weak) id <KRStepNavigationDelegate> delegate;
@property (nonatomic, assign) BOOL isShowing;

- (void)animateNavbarIn;
- (void)animateNavbarOut;

@end
