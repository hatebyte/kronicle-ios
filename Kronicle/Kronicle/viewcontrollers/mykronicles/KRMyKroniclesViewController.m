//
//  KRMyKroniclesViewController.m
//  Kronicle
//
//  Created by Scott on 8/17/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRMyKroniclesViewController.h"
#import "KRColorHelper.h"
#import "Kronicle+Life.h"
#import "Kronicle+Helper.h"
#import "KronicleBlockTableViewCell.h"
#import "KRKronicleStartViewController.h"
#import "MyKroniclesSectionHeader.h"
#import "Kronicle+Helper.h"
#import "KRNavigationViewController.h"
#import "KRKroniclesPageNavigationView.h"
#import "KRSwipeViewNavigation.h"

@interface KRMyKroniclesViewController () <KronicleBlockTableViewCellDelegate, KRKroniclesPageNavigationViewDelegate> {
    @private
    NSArray *_kroniclesModuloed;
    NSArray *_savedKronicles;
    KRKroniclesPageNavigationView *_subHeaderView;
}
@end

@implementation KRMyKroniclesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [KRColorHelper grayLight];
    _tableView.backgroundColor = [KRColorHelper grayLight];
    
    _cancelButton.hidden                    = YES;
    
    
    _subHeaderView                                      = [[KRKroniclesPageNavigationView alloc] initWithFrame:CGRectMake(0,
                                                                                                                          0,
                                                                                                                          320,
                                                                                                                          55)
                                                                                                 andTitleArray:[NSArray arrayWithObjects:@"Created by me",
                                                                                                                @"Added",
                                                                                                                @"History", nil]];
    _subHeaderView.delegate                             = self;
    [self.view addSubview:_subHeaderView];
    
    NSInteger top                                       = _subHeaderView.frame.origin.y + _subHeaderView.frame.size.height;
    _tableView.frame = CGRectMake(0, top, 320, _bounds.size.height - (top + [KRSwipeViewNavigation cellHeight]));
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadLocalKronicles];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [(KRNavigationViewController *)self.navigationController navbarHidden:NO];
    [(KRNavigationViewController *)self.navigationController setNavigationTitle:@"My Kronicles"];
    [_tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadLocalKronicles {
    [Kronicle getLocaleKronicles:^(NSArray *kronicles) {
        _kroniclesModuloed = [Kronicle moduloKronicleList:kronicles];
        [_tableView reloadData];
    }
                       onFailure:^(NSDictionary *error) {
                           if ([[error objectForKey:@"error"] isEqualToString:NO_LOCAL_KRONICLES]) {
                               [Kronicle getRemoteKronicles:^(NSArray *kronicles) {
                                   _kroniclesModuloed = [Kronicle moduloKronicleList:kronicles];
                                   [_tableView reloadData];
                               }
                                                  onFailure:^(NSError *error) {
                                                      NSLog(@"Cant get remote kronicle : %@", error);
                                                  }];
                           }
                       }];
}


#pragma KRKroniclesPageNavigationView
- (void)kroniclesPageNavigationView:KRKroniclesPageNavigationView didSelect:(KroniclesPageNavigationItem)item {
    CGRect originalTableFrame = _tableView.frame;
    [UIView animateWithDuration:.4
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = _tableView.frame;
                         frame.origin.y = _bounds.size.height + 10;
                         _tableView.frame = frame;
                     }
                     completion:^(BOOL fin){
                         [UIView animateWithDuration:.4
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              _tableView.frame = originalTableFrame;
                                          }
                                          completion:^(BOOL fin){
                                              _subHeaderView.preventHit = NO;
                                          }];
                     }];
}

#pragma tableview
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *viewer = [[UIView alloc] init];
    viewer.backgroundColor = [UIColor clearColor];
    viewer.userInteractionEnabled = NO;
    return viewer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KronicleBlockTableViewCell cellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_kroniclesModuloed count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KronicleBlockTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"KronicleCell"];
    if (!cell) {
        cell = [[KronicleBlockTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KronicleCell"];
    }
    [cell prepareForReuseWithArray: [_kroniclesModuloed objectAtIndex:indexPath.row] ];
    cell.delegate = self;
    return cell;
}


#pragma kronicleblocktableviewcell
- (void)kronicleDeletionRequested:(KronicleBlockTableViewCell *)kronicleBlockTableViewCell forKronicle:(Kronicle *)kronicle {
    [Kronicle deleteKronicle:kronicle];
    
    [Kronicle getLocaleKronicles:^(NSArray *kronicles) {
        _kroniclesModuloed = [Kronicle moduloKronicleList:kronicles];
        [_tableView reloadData];
    }
                       onFailure:^(NSDictionary *error) {
                           NSLog(@"Cant get local kronicles : %@", error);
                           if ([[error objectForKey:@"error"] isEqualToString:NO_LOCAL_KRONICLES]) {
                               NSLog(@"Cant get remote kronicles : %@", error);
                           }
                           _kroniclesModuloed = [[NSArray alloc] init];
                           [_tableView reloadData];

                       }];
}

- (void)kroniclePlaybackRequested:(KronicleBlockTableViewCell *)kronicleBlockTableViewCell forKronicle:(Kronicle *)kronicle {
    if (kronicle.steps.count > 0) {
        [self navigateToKronicle:kronicle];
    } else {
        [Kronicle populateLocalKronicleWithRemoteSteps:kronicle
                                           withSuccess:^(Kronicle *k) {
                                               [self navigateToKronicle:k];
                                           }
                                             onFailure:^(NSDictionary *error) {
                                             }];
    }
}

- (void)navigateToKronicle:(Kronicle*)kronicle {
    KRKronicleStartViewController *kronicleStartViewController = [[KRKronicleStartViewController alloc] initWithNibName:@"KRKronicleStartViewController" andKronicle:kronicle];
    [self.navigationController pushViewController:kronicleStartViewController animated:YES];
}

@end





















