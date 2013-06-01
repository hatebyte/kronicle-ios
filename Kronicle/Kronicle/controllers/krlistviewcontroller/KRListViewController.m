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

#pragma tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"defaultcell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultcell"];
    }
    KRKronicle *k = (KRKronicle*)[self.tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = k.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KRKronicle *k = (KRKronicle*)[self.tableData objectAtIndex:indexPath.row];
    
    void(^completionBlock)(KRKronicle *kronicle, NSError *err) = ^(KRKronicle *kronicle, NSError *err) {
        KRViewController *kronicleViewController = [[KRViewController alloc] initWithNibName:@"KRViewController" andKronicle:kronicle];
        [self.navigationController pushViewController:kronicleViewController animated:YES];
    };
    
    [[KRAPIStore sharedStore] fetchKronicle:k.uuid withCompletion:completionBlock];
}



@end
