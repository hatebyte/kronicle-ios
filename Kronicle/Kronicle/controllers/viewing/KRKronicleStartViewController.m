//
//  KRKronicleStartViewController.m
//  Kronicle
//
//  Created by Scott on 6/2/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRKronicleStartViewController.h"
#import "KRPlaybackViewController.h"
#import "KRFontHelper.h"
#import "KRColorHelper.h"
#import "KRGlobals.h"
#import "KRNavigationViewController.h"

@interface KRKronicleStartViewController ()

@end

@implementation KRKronicleStartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil andKronicle:(Kronicle *)kronicle;
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
    self.kImage.image = [UIImage imageNamed:self.kronicle.coverUrl];
    //self.kImage.image = [UIImage imageNamed:@"ydstep1.png"];

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 162, 300, 50)];
    self.titleLabel.font = [KRFontHelper getFont:KRBrandonLight withSize:32];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = self.kronicle.title;
    [self.view addSubview:self.titleLabel];
    
    int titleHeight = self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y;
    self.description = [[UITextView alloc] initWithFrame:CGRectMake(9,
                                                                    titleHeight+28,
                                                                    306,
                                                                    self.view.frame.size.height - titleHeight)];
    self.description.font = [KRFontHelper getFont:KRMinionProRegular withSize:16];
    self.description.text = self.kronicle.desc;
    self.description.scrollEnabled = NO;
    self.description.textColor = [UIColor blackColor];
    //self.description.contentInset = UIEdgeInsetsMake(3,-8,3,0);
    self.description.editable = NO;
    self.description.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.description];
    
    
#if kDEBUG
    KRPlaybackViewController *playbackViewController = [[KRPlaybackViewController alloc] initWithKronicle:self.kronicle];
    [self.navigationController pushViewController:playbackViewController animated:YES];
#endif
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [(KRNavigationViewController *)self.navigationController navbarHidden:NO];
    
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)gotoToKronicle:(id)sender {
    KRPlaybackViewController *playbackViewController = [[KRPlaybackViewController alloc] initWithKronicle:self.kronicle];
    [self.navigationController pushViewController:playbackViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
