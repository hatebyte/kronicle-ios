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

#import "KRViewController.h"
#import "KRCreateViewController.h"
#import "KRAPIStore.h"

#import "KRTextButton.h"
#import "NMCustomLabel.h"
#import "NMCustomLabelStyle.h"

@interface KRHomeViewController ()

@property(strong, nonatomic) KRTextButton *createButton;
@property(strong, nonatomic) UIButton *findButton;

@end

@implementation KRHomeViewController

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
    
    NMCustomLabel *welcomeLabel = [[NMCustomLabel alloc] initWithFrame:CGRectMake(buttonX, 60, 200, 100)];
    welcomeLabel.text = welcomeString;
    welcomeLabel.numberOfLines = 2;
    welcomeLabel.lineHeight = 40;
    [welcomeLabel setDefaultStyle:[NMCustomLabelStyle styleWithFont:[KRFontHelper getFont:KRBrandonLight withSize:KRFontSizeHuge] color:[UIColor whiteColor]]];
    welcomeLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:welcomeLabel];
   
    NSString *createString = NSLocalizedString(@"Create", @"");
    _createButton = [[KRTextButton alloc] initWithFrame:CGRectMake(buttonX, welcomeLabel.frame.origin.y + welcomeLabel.frame.size.height - 10, 100.0f, 50.0f) andType:KRTextButtonTypeHomeScreen andIcon:[UIImage imageNamed:@"plus-sign-white"]];
    [_createButton setTitle:createString forState:UIControlStateNormal];
    [_createButton addTarget:self action:@selector(create) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_createButton];
    
    NSString *findString = NSLocalizedString(@"Find", @"");
    _findButton = [[KRTextButton alloc] initWithFrame:CGRectMake(buttonX - 12, _createButton.frame.origin.y + _createButton.frame.size.height, 100.0f, 50.0f) andType:KRTextButtonTypeHomeScreen andIcon:[UIImage imageNamed:@"magnifying-glass-white"]];
    [_findButton setTitle:findString forState:UIControlStateNormal];
    [_findButton addTarget:self action:@selector(find) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_findButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)find
{
    KRCategoriesViewController *categoryViewController = [[KRCategoriesViewController alloc] initWithNibName:@"KRCategoriesViewController" bundle:nil];
    [self.navigationController pushViewController:categoryViewController animated:YES];
}

- (void)create
{
    KRCreateViewController *createViewController = [[KRCreateViewController alloc] initWithNibName:@"KRCreateViewController" bundle:nil];
    [self.navigationController pushViewController:createViewController animated:YES];
}

@end
