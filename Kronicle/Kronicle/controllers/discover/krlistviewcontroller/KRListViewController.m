//
//  KRListViewController.m
//  Kronicle
//
//  Created by Scott on 8/17/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRListViewController.h"
#import "KRColorHelper.h"
#import "Kronicle+Life.h"
#import "Kronicle+Helper.h"
#import "KronicleBlockTableViewCell.h"
#import "KRKronicleStartViewController.h"
#import "MyKroniclesSectionHeader.h"
#import "Kronicle+Helper.h"
#import "KRNavigationViewController.h"

@interface KRListViewController () <KronicleBlockTableViewCellDelegate> {
@private
    NSMutableArray *_kroniclesModuloed;
    NSArray *_savedKronicles;
}
@end

@implementation KRListViewController

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
        
    [self loadLocalKronicles];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [(KRNavigationViewController *)self.navigationController navbarHidden:NO];
    [_tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadLocalKronicles {
    [Kronicle getLocaleKronicles:^(NSArray *kronicles) {
        _savedKronicles = kronicles;
        [self parseKroniclesToTable];
    }
                       onFailure:^(NSDictionary *error) {
                           if ([[error objectForKey:@"error"] isEqualToString:NO_LOCAL_KRONICLES]) {
                               [Kronicle getRemoteKronicles:^(NSArray *kronicles) {
                                   _savedKronicles = kronicles;
                                   [self parseKroniclesToTable];
                               }
                                                  onFailure:^(NSError *error) {
                                                      NSLog(@"Cant get remote kronicle : %@", error);
                                                  }];
                           }
                       }];
}

- (void)parseKroniclesToTable {
    _kroniclesModuloed = [[NSMutableArray alloc] init];
    int stepsMinusFinish = [_savedKronicles count];
    if (stepsMinusFinish < 1) {
        [_tableView reloadData];
        return;
    }
    
    if(stepsMinusFinish % 2 == 0) {
        for (int i = 0; i < stepsMinusFinish; i++) {
            int next = i + 1;
            NSArray *inArray = [NSArray arrayWithObjects:[_savedKronicles objectAtIndex:i], [_savedKronicles objectAtIndex:next], nil];
            [_kroniclesModuloed addObject:inArray];
            i = next;
        }
        
    } else {
        for (int i = 0; i < stepsMinusFinish; i++) {
            NSArray *inArray;
            int next = i + 1;
            if (next < stepsMinusFinish) {
                inArray = [NSArray arrayWithObjects:[_savedKronicles objectAtIndex:i], [_savedKronicles objectAtIndex:next], nil];
            } else {
                inArray = [NSArray arrayWithObjects:[_savedKronicles objectAtIndex:i], nil];
            }
            i= next;
            [_kroniclesModuloed addObject:inArray];
        }
    }
    [_tableView reloadData];
}


#pragma tableview
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[MyKroniclesSectionHeader alloc] initWithFrame:CGRectMake(0, 0, 320, [MyKroniclesSectionHeader headerHeight])];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [MyKroniclesSectionHeader headerHeight];
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
    cell.deleteIsHidden = YES;
    [cell prepareForReuseWithArray: [_kroniclesModuloed objectAtIndex:indexPath.row] ];
    cell.delegate = self;
    return cell;
}


#pragma kronicleblocktableviewcell

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





















