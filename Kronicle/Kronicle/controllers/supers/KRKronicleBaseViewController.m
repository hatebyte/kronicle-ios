//
//  KRKronicleBaseViewController.m
//  Kronicle
//
//  Created by Scott on 8/12/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRKronicleBaseViewController.h"
#import "KRItemsViewController.h"

@interface KRKronicleBaseViewController ()

@end

@implementation KRKronicleBaseViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark listemsViewcontroller 
- (void)viewListItems:(Kronicle *)kronicle {
    KRItemsViewController *itemsViewController = [[KRItemsViewController alloc] initWithNibName:@"KRItemsViewController" bundle:nil];
    [itemsViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self.navigationController presentModalViewController:itemsViewController animated:YES];
}

@end
