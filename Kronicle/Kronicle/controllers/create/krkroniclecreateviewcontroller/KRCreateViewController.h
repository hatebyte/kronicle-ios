//
//  KRCreateViewController.h
//  Kronicle
//
//  Created by Scott on 6/11/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRBaseEditTableViewController.h"
#import "KRKronicle.h"


@interface KRCreateViewController : KRBaseEditTableViewController

@property (nonatomic, strong) KRKronicle *kronicle;

@end