//
//  KRHomeViewController.m
//  Kronicle
//
//  Created by Jabari Bell on 8/11/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRHomeViewController.h"
#import "KRCategoriesViewController.h"
#import "KRColorHelper.h"
#import "KRFontHelper.h"
#import "KRNavigationViewController.h"

#import "KRCreateViewController.h"
#import "KRAPIStore.h"

#import "KRTextButton.h"
#import "BBRichTextView.h"
#import "NMCustomLabel.h"
#import "NMCustomLabelStyle.h"

#import "KRPlaybackViewController.h"
#import "KRCreateViewController.h"
#import "KRGlobals.h"

const char *class_getName(Class cls);


@interface KRHomeViewController () {
    @private
    KRTextButton *_createButton;
    KRTextButton *_findButton;
    UILabel *_topLine;
    UILabel *_bottomLine;
    UITextView *_description;
}

@end

@implementation KRHomeViewController

+ (KRHomeViewController *)current {
    static KRHomeViewController *current = nil;
    if (current == nil) {
        current = [[super allocWithZone:nil] initWithNibName:@"KRHomeViewController" bundle:nil];
    }
    return current;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self current];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    /*
     void(^completionBlock)(KRKronicle *kronicle, NSError *err) = ^(KRKronicle *kronicle, NSError *err) {
     KRViewController *kronicleViewController = [[KRViewController alloc] initWithNibName:@"KRViewController" andKronicle:kronicle];
     [self.navigationController pushViewController:kronicleViewController animated:YES];
     };
     
     [[KRAPIStore sharedStore] fetchKronicle:@"51aab816631eb50000000008" withCompletion:completionBlock];
     */
    
    self.view.backgroundColor                   = [KRColorHelper turquoise];
    float buttonX                               = 10.0f;

    _topLine                                    = [[UILabel alloc] initWithFrame:CGRectMake(buttonX, 50, 300, 40)];
    _topLine.font                               = [KRFontHelper getFont:KRBrandonLight withSize:46];
    _topLine.textColor                          = [UIColor whiteColor];
    _topLine.backgroundColor                    = [UIColor clearColor];
    _topLine.text                               = NSLocalizedString(@"Welcome to", @"");
    [self.view addSubview:_topLine];
    
    _bottomLine                                 = [[UILabel alloc] initWithFrame:CGRectMake(buttonX,
                                                                                            _topLine.frame.origin.y + _topLine.frame.size.height + 4,
                                                                                            _topLine.frame.size.width,
                                                                                            _topLine.frame.size.height)];
    _bottomLine.font                            = [KRFontHelper getFont:KRBrandonLight withSize:46];
    _bottomLine.textColor                       = [UIColor whiteColor];
    _bottomLine.backgroundColor                 = [UIColor clearColor];
    _bottomLine.text                            = NSLocalizedString(@"Kronicle.", @"");
    [self.view addSubview:_bottomLine];
    
    _description                                = [[UITextView alloc] initWithFrame:CGRectMake(buttonX-6,
                                                                                              _bottomLine.frame.origin.y + _bottomLine.frame.size.height,
                                                                                              _topLine.frame.size.width,
                                                                                              70)];
    _description.font                           = [KRFontHelper getFont:KRMinionProRegular withSize:18];
    _description.scrollEnabled                  = YES;
    _description.textColor                      = [UIColor whiteColor];
    _description.backgroundColor                = [UIColor clearColor];
    _description.editable                       = NO;
    _description.text                           = NSLocalizedString(@"Timeline based guides and \nskill sharing.", @"");
    [self.view addSubview:_description];
    
    _createButton = [[KRTextButton alloc] initWithFrame:CGRectMake(buttonX, _description.frame.origin.y + _description.frame.size.height, 150, 36)
                                                andType:KRTextButtonTypeHomeScreen
                                                andIcon:[UIImage imageNamed:@"plus-sign-white"]];
    [_createButton setTitle:NSLocalizedString(@"Create", @"") forState:UIControlStateNormal];
    [_createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_createButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_createButton addTarget:self action:@selector(create) forControlEvents:UIControlEventTouchUpInside];
    _createButton.titleEdgeInsets               = UIEdgeInsetsMake(0, 6, 0, 0);
    [self.view addSubview:_createButton];
    
    _findButton = [[KRTextButton alloc] initWithFrame:CGRectMake(buttonX, _createButton.frame.origin.y + _createButton.frame.size.height, 150, 36)
                                              andType:KRTextButtonTypeHomeScreen
                                              andIcon:[UIImage imageNamed:@"magnifying-glass-white"]];
    [_findButton setTitle:NSLocalizedString(@"Discover", @"") forState:UIControlStateNormal];
    [_findButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_findButton addTarget:self action:@selector(discover) forControlEvents:UIControlEventTouchUpInside];
    _findButton.titleEdgeInsets                 = UIEdgeInsetsMake(0, 6, 0, 0);
    [self.view addSubview:_findButton];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [(KRNavigationViewController *)self.navigationController navbarHidden:NO];

#if kDEBUG
    [self gotoToViewController:@"KRCategoriesViewController"];
#endif
}

- (void)closeNavigation{
    [(KRNavigationViewController *)self.navigationController close];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)gotoToViewController:(NSString *)viewControllerName {
    [self closeNavigation];
    NSString *currentSelectedCViewController = NSStringFromClass([self.navigationController.visibleViewController class]);
    if ([currentSelectedCViewController isEqualToString:viewControllerName]) {
        return;
    }

    [self.navigationController popToRootViewControllerAnimated:NO];
    if ([viewControllerName isEqualToString:@"KRHomeViewController"]) {
        return;
    }
    
    UIViewController *requestController = (UIViewController *)[[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
    [self.navigationController pushViewController:requestController animated:NO];

}

- (void)home {
    [self gotoToViewController:@"KRHomeViewController"];
}

- (void)mykronicles {
    [self gotoToViewController:@"KRMyKroniclesViewController"];
}

- (void)create {
    [self gotoToViewController:@"KRCreateViewController"];
}

- (void)discover {
    [self gotoToViewController:@"KRCategoriesViewController"];
}

- (void)me {
    [self gotoToViewController:@"KRMeViewController"];
}


@end
