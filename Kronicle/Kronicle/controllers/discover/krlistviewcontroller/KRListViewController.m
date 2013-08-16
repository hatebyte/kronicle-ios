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

@interface KRListViewController ()

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
    
//    void(^completionBlock)(KRList *k, NSError *err) = ^(KRList *k, NSError *err) {
//        self.tableData = [k.kronicles copy];
//        [self.tableView reloadData];
//    };
//    
//    [[KRAPIStore sharedStore] fetchAllKroniclesWithCompletion:completionBlock];

    
    [[KronicleEngine current] allKroniclesWithCompletion:^(KRList *k) {
        
                                                    self.tableData = [k.kronicles copy];
                                                    [self.tableView reloadData];
        
        
#if kDEBUG

        NSIndexPath *myIP = [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:self.tableView didSelectRowAtIndexPath:myIP];
#endif

        
                                                }
                                                onFailure:^(NSError *error) {
                                                   
                                                   NSLog(@"error : %@", error);
                                                   
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
    KRKronicle *k = (KRKronicle*)[self.tableData objectAtIndex:indexPath.row];
    NSLog(@"k.uuid : %@", k.uuid);
    cell.titleLabel.text = k.title;
    cell.subLabel.text = [k stringTime];
    cell.kImage.image = [UIImage imageNamed:k.imageUrl];
    
    cell.titleLabel.textColor = [KRColorHelper grayDark];
    cell.frameimage.image = [UIImage imageNamed:@"hole"];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StepsTableCellViewCell *c = (StepsTableCellViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [c hit];
    KRKronicle *k = (KRKronicle*)[self.tableData objectAtIndex:indexPath.row];
    
//    void(^completionBlock)(KRKronicle *kronicle, NSError *err) = ^(KRKronicle *kronicle, NSError *err) {
//        KRKronicleStartViewController *kronicleStartViewController = [[KRKronicleStartViewController alloc] initWithNibName:@"KRKronicleStartViewController" andKronicle:kronicle];
//        [self.navigationController pushViewController:kronicleStartViewController animated:YES];
//    };
//    [[KRAPIStore sharedStore] fetchKronicle:k.uuid withCompletion:completionBlock];
    
    [[KronicleEngine current] fetchKronicle:k.uuid withCompletion:^(KRKronicle *kronicle) {
        
        KRKronicleStartViewController *kronicleStartViewController = [[KRKronicleStartViewController alloc] initWithNibName:@"KRKronicleStartViewController" andKronicle:kronicle];
        [self.navigationController pushViewController:kronicleStartViewController animated:YES];
        
    }
                                               onFailure:^(NSError *error) {
                                                   
                                                   NSLog(@"error : %@", error);
                                                   
                                               }];
    
    
}



@end
