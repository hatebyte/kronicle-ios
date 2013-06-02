//
//  KRListViewController.m
//  Kroncile
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRListViewController.h"
#import "KRViewController.h"
#import "KRAPIStore.h"
#import "KRKronicle.h"
#import "StepsTableCellViewCell.h"
#import "KRColorHelper.h"
#import "KRKronicleStartViewController.h"

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
    
    void(^completionBlock)(KRList *k, NSError *err) = ^(KRList *k, NSError *err) {
        self.tableData = [k.kronicles copy];
        [self.tableView reloadData];
    };
    
    [[KRAPIStore sharedStore] fetchAllKroniclesWithCompletion:completionBlock];
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
    cell.titleLabel.text = k.title;
    cell.subLabel.text = [k stringTime];
    //cell.kImage.image = [UIImage imageNamed:_kronicle.imageUrl];
    cell.kImage.image = [UIImage imageNamed:@"ydstep1.png"];
    cell.number.text = [NSString stringWithFormat:@"%d", indexPath.row];
    
    cell.titleLabel.textColor = [KRColorHelper darkGrey];
    cell.frameimage.image = [UIImage imageNamed:@"hole"];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StepsTableCellViewCell *c = (StepsTableCellViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [c hit];
    KRKronicle *k = (KRKronicle*)[self.tableData objectAtIndex:indexPath.row];
    
    void(^completionBlock)(KRKronicle *kronicle, NSError *err) = ^(KRKronicle *kronicle, NSError *err) {
//        KRViewController *kronicleViewController = [[KRViewController alloc] initWithNibName:@"KRViewController" andKronicle:kronicle];
//        [self.navigationController pushViewController:kronicleViewController animated:YES];
        
        KRKronicleStartViewController *kronicleStartViewController = [[KRKronicleStartViewController alloc] initWithNibName:@"KRKronicleStartViewController" andKronicle:kronicle];
        [self.navigationController pushViewController:kronicleStartViewController animated:YES];
        
    };
    
    [[KRAPIStore sharedStore] fetchKronicle:k.uuid withCompletion:completionBlock];
}



@end
