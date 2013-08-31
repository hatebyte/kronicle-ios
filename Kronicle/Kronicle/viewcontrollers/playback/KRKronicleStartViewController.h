//
//  KRKronicleStartViewController.h
//  Kronicle
//
//  Created by Scott on 6/2/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRKronicleBaseViewController.h"

@interface KRKronicleStartViewController : KRKronicleBaseViewController

@property(nonatomic,strong) Kronicle *kronicle;


- (id)initWithNibName:(NSString *)nibNameOrNil andKronicle:(Kronicle *)kronicle;

@end
