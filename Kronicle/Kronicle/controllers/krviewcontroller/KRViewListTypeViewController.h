//
//  KRViewListTypeViewController.h
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRKronicle.h"
#import "KRStep.h"

@interface KRViewListTypeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate> {
    void (^_completion)(int step);
    KRKronicle *_kronicle;
}

@property(nonatomic,weak) IBOutlet UITableView *tableView;
@property(nonatomic,assign) int currentStep;

- (id)initWithNibName:(NSString *)nibNameOrNil andKronicle:(KRKronicle *)kronicle completion:(void (^)(int step))completion;

@end
