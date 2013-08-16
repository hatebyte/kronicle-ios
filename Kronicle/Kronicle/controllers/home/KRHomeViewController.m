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

const char *class_getName(Class cls);


@interface KRHomeViewController () {
    @private
    KRTextButton *_createButton;
    KRTextButton *_findButton;
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
    
    self.view.backgroundColor = [KRColorHelper turquoise];
    
    float buttonX = 22.0f;
    
    NSString *welcomeString = NSLocalizedString(@"Welcome to Kronicle.", @"");
    
    NMCustomLabel *welcomeLabel = [[NMCustomLabel alloc] initWithFrame:CGRectMake(buttonX, 55, 290, 200)];
    welcomeLabel.text = welcomeString;
    welcomeLabel.numberOfLines = 2;
//    welcomeLabel.lineHeight = -40;
    [welcomeLabel setDefaultStyle:[NMCustomLabelStyle styleWithFont:[KRFontHelper getFont:KRBrandonLight withSize:48] color:[UIColor whiteColor]]];
//    welcomeLabel.font = [KRFontHelper getFont:KRBrandonLight withSize:50];
//    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:welcomeLabel];
   
//    BBRichTextView *welcomeLabel        = [[BBRichTextView alloc] initWithFrame:CGRectMake(22, 55, 298, 200)];
//    welcomeLabel.text                   = welcomeString;
//    welcomeLabel.literalMode            = NO;
//    welcomeLabel.font                   = [KRFontHelper getFont:KRBrandonLight withSize:50];
//    welcomeLabel.color                  = [UIColor whiteColor];
//    welcomeLabel.lineheight             = -40;
//    welcomeLabel.padding                = 0;
//    welcomeLabel.backgroundColor        = [UIColor clearColor];
//    [self.view addSubview:welcomeLabel];

    
    NSString *createString = NSLocalizedString(@"Create", @"");
    _createButton = [[KRTextButton alloc] initWithFrame:CGRectMake(buttonX, welcomeLabel.frame.origin.y + welcomeLabel.frame.size.height - 10, 100.0f, 50.0f)
                                                andType:KRTextButtonTypeHomeScreen andIcon:[UIImage imageNamed:@"plus-sign-white"]];
    [_createButton setTitle:createString forState:UIControlStateNormal];
    [_createButton addTarget:self action:@selector(create) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_createButton];
    
    NSString *findString = NSLocalizedString(@"Find", @"");
    _findButton = [[KRTextButton alloc] initWithFrame:CGRectMake(buttonX - 12, _createButton.frame.origin.y + _createButton.frame.size.height, 100.0f, 50.0f)
                                              andType:KRTextButtonTypeHomeScreen andIcon:[UIImage imageNamed:@"magnifying-glass-white"]];
    [_findButton setTitle:findString forState:UIControlStateNormal];
    [_findButton addTarget:self action:@selector(discover) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_findButton];
    
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [(KRNavigationViewController *)self.navigationController navbarHidden:NO];
}

- (void)closeNavigation{
    [(KRNavigationViewController *)self.navigationController close];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}

- (void)create {
//    [self.navigationController popToRootViewControllerAnimated:NO];
//    KRCreateViewController *createViewController = [[KRCreateViewController alloc] initWithNibName:@"KRCreateViewController" bundle:nil];
//    [self.navigationController pushViewController:createViewController animated:YES];

    [self gotoToViewController:@"KRCreateViewController"];
}

- (void)discover {
//    [self.navigationController popToRootViewControllerAnimated:NO];
//    KRCategoriesViewController *categoryViewController = [[KRCategoriesViewController alloc] initWithNibName:@"KRCategoriesViewController" bundle:nil];
//    [self.navigationController pushViewController:categoryViewController animated:YES];
    [self gotoToViewController:@"KRCategoriesViewController"];

}

- (void)me {

}


@end
