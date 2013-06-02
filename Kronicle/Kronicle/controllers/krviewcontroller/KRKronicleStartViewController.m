//
//  KRKronicleStartViewController.m
//  Kronicle
//
//  Created by Scott on 6/2/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRKronicleStartViewController.h"

@interface KRKronicleStartViewController ()

@end

@implementation KRKronicleStartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil andKronicle:(KRKronicle *)kronicle;
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        self.kronicle = kronicle;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}


- (IBAction)back:(id)sender {

}

- (IBAction)gotoToKronicle:(id)sender {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
