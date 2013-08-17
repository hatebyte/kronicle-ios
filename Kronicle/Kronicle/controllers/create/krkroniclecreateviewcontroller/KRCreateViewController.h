//
//  KRCreateViewController.h
//  Kronicle
//
//  Created by Scott on 6/11/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRKronicle.h"

typedef enum {
    KRCreateCellTitle,
    KRCreateCellDescription,
    KRCreateCellStep,
} KRCreateCellType;

@interface KRCreateViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) KRKronicle *kronicle;

- (IBAction)popViewController:(id)sender;

@end