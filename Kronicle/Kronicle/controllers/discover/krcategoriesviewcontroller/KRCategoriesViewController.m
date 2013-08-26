//
//  KRCategoriesViewController.m
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRCategoriesViewController.h"
#import "KRListViewController.h"
#import "KronicleEngine.h"
#import "KRGlobals.h"
#import "KRHomeViewController.h"
#import "KRNavigationViewController.h"

@interface KRCategoriesViewController ()

@end

@implementation KRCategoriesViewController

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
    // Do any additional setup after loading the view from its nib.
    
//    self.tableData = [NSArray arrayWithObjects:@"Cooking", @"Exercise",@"Music",@"Art",@"Productivity", nil];
//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
    
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [(KRNavigationViewController *)self.navigationController navbarHidden:NO];
}


//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    [[KRHomeViewController current] closeNavigation];
//
//}
//
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gotoCategory:(id)sender {
    
    // create kromcile categories
    KRListViewController *kronicleListViewController = [[KRListViewController alloc] initWithNibName:@"KRListViewController" bundle:nil];
    [self.navigationController pushViewController:kronicleListViewController animated:YES];
    
//    [[KRHomeViewController current] discover];
}

- (IBAction)backHit:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//
//#pragma tableview
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.tableData count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"defaultcell"];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultcell"];
//    }
//    cell.textLabel.text = [self.tableData objectAtIndex:indexPath.row];
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    KRListViewController *kronicleListViewController = [[KRListViewController alloc] initWithNibName:@"KRListViewController" bundle:nil];
//    [self.navigationController pushViewController:kronicleListViewController animated:YES];
//}

@end
