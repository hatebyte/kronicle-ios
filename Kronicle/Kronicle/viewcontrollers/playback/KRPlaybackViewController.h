//
//  KRPlaybackViewController.h
//  Kroncile
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRHomeViewController.h"
#import "Kronicle+Helper.h"
#import "MediaView.h"
#import "KRKronicleBaseViewController.h"
#import "KRStep.h"
#import "DescriptionView.h"
#import "KRColorHelper.h"
#import "KRFontHelper.h"
#import "KRGlobals.h"
#import "KRClockManager.h"
#import "KRKronicleManager.h"
#import "KRStepNavigation.h"
#import "KRScrollView.h"
#import "KRGraphView.h"
#import "KRStepListContainerView.h"
#import "MediaView.h"
#import "KRCircularKronicleGraph.h"
#import "ManagedContextController.h"
#import "KRNavigationViewController.h"
#import "KRHomeViewController.h"
#import "KRItemsViewController.h"
#import "KRReviewViewController.h"
#import "KRTextButton.h"
#import "KRPublishKronicleOverlay.h"
#import <QuartzCore/QuartzCore.h>

#define kScrollViewNormal 320.f
#define kScrollViewUp 180.f

@interface KRPlaybackViewController : KRKronicleBaseViewController <KRClockManagerDelegate, KRKronicleManagerDelegate,
KRStepNavigationDelegate, KRScrollViewDelegate,  MediaViewDelegate, KRStepListContainerViewDelegate>{
    @protected
    UILabel *_globalClockLabel;
    UILabel *_subGlobalClockLabel;
    UIScrollView *_sview;
    UIButton *_backButton;
    UIButton *_publishButton;
    KRTextButton *_itemsButton;
    KRKronicleManager *_kronicleManager;
    KRClockManager *_clockManager;
    KRStepNavigation *_stepNavigation;
    KRScrollView *_scrollView;
    KRGraphView *_graphView;
    KRStepListContainerView *_stepListContainerView;
    MediaView *_mediaView;
    KRCircularKronicleGraph *_circularGraphView;
}


@property (nonatomic, strong) Kronicle *kronicle;

- (id)initWithKronicle:(Kronicle *)kronicle ;

@end
