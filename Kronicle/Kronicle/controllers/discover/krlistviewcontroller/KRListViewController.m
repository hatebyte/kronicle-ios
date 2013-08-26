//
//  KRListViewController.m
//  Kroncile
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRListViewController.h"
#import "KRPlaybackViewController.h"
#import "KRAPIStore.h"
#import "KRKronicle.h"
#import "StepsTableCellViewCell.h"
#import "KRColorHelper.h"
#import "KRKronicleStartViewController.h"
#import "KronicleEngine.h"
#import "KRGlobals.h"
#import "KRNavigationViewController.h"
#import "KRClockManager.h"
#import "Step+Helper.h"
#import "Kronicle+Helper.h"

@interface KRListViewController ()

// if step has no steps get steps;

@end

@implementation KRListViewController

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
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
        
    [Kronicle getLocaleKronicles:^(NSArray *kronicles) {
                                self.tableData = kronicles;
                                [self.tableView reloadData];
        
                            }
                              onFailure:^(NSDictionary *error) {
                                  if ([[error objectForKey:@"error"] isEqualToString:NO_LOCAL_KRONICLES]) {
                                      [Kronicle getRemoteKronicles:^(NSArray *kronicles) {
                                          self.tableData = kronicles;
                                          [self.tableView reloadData];
                                          
                                                              }
                                                                onFailure:^(NSError *error) {
                                                                    NSLog(@"Cant get remote kronicle : %@", error);
                                                                }];
                                  }
                              }];


}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [(KRNavigationViewController *)self.navigationController navbarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backHit:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma tableview

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StepsTableCellViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StepsTableCellViewCell"];
    if (cell == nil) {
        cell = [[StepsTableCellViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StepsTableCellViewCell"];
    }
    Kronicle *k = (Kronicle*)[self.tableData objectAtIndex:indexPath.row];
    NSLog(@"k.uuid : %@", k.uuid);
    cell.titleLabel.text = k.title;
//    cell.subLabel.text = [k stringTime];
    NSString *time = [KRClockManager stringTimeForInt:k.totalTime];
    if ([[time substringToIndex:1] isEqualToString:@"0"]) {
        time = [time substringFromIndex:1];
    }
    cell.subLabel.text = time;

    cell.kImage.image = [UIImage imageNamed:k.coverUrl];
    
    cell.titleLabel.textColor = [KRColorHelper grayDark];
    cell.frameimage.image = [UIImage imageNamed:@"hole"];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StepsTableCellViewCell *c = (StepsTableCellViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [c hit];
    Kronicle *k = [self.tableData objectAtIndex:indexPath.row];
    
    if (k.steps.count > 0) {
        [self navigateToKronicle:k];
    } else {
        [Kronicle populateLocalKronicleWithRemoteSteps:k
                                           withSuccess:^(Kronicle *kronicle) {
                                               [self navigateToKronicle:kronicle];
                                           }
                                             onFailure:^(NSDictionary *error) {
                                             }];
    }

}
//
//- (void)fetchRemoteKronicle:(NSString *)uuid {
//    [Kronicle getRemoteKronicleWithUuid:uuid
//                            withSuccess:^(Kronicle *kronicle) {
//                                NSLog(@"kronicle made it REMOTE : %@", kronicle.steps);
//                                [self navigateToKronicle:kronicle];
//                                
//                            }
//                              onFailure:^(NSError *error) {
//                                  NSLog(@"CAnt get remote kronicle : %@", error);
//                              }];
//}

- (void)navigateToKronicle:(Kronicle*)kronicle {
    KRKronicleStartViewController *kronicleStartViewController = [[KRKronicleStartViewController alloc] initWithNibName:@"KRKronicleStartViewController" andKronicle:kronicle];
    [self.navigationController pushViewController:kronicleStartViewController animated:YES];
}


@end
