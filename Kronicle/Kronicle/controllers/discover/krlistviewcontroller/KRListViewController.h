//
//  KRListViewController.h
//  Kroncile
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "ViewController.h"

@interface KRListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>

@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSArray *tableData;

- (IBAction)backHit:(id)sender;

@end
