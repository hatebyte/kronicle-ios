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

#pragma mark listemsViewcontroller delegate
- (void)viewListItems:(Kronicle *)kronicle {
    dispatch_async(dispatch_get_main_queue(), ^{
        KRItemsViewController *itemsViewController = [[KRItemsViewController alloc] initWithItems:kronicle.items andState:KRItemsListUse];
        [itemsViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self.navigationController presentModalViewController:itemsViewController animated:YES];
    });
}

- (void)createListItems:(Kronicle *)kronicle {
    dispatch_async(dispatch_get_main_queue(), ^{
        KRItemsViewController *itemsViewController = [[KRItemsViewController alloc] initWithItems:kronicle.items andState:KRItemsListCreate];
        [itemsViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self.navigationController presentModalViewController:itemsViewController animated:YES];
    });
}

@end
