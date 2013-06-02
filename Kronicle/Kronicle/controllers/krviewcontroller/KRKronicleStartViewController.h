//
//  KRKronicleStartViewController.h
//  Kronicle
//
//  Created by Scott on 6/2/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRKronicle.h"

@interface KRKronicleStartViewController : UIViewController

@property(nonatomic,strong) KRKronicle *kronicle;
@property(nonatomic, weak) IBOutlet UIImageView *kImage;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UITextView *description;

- (IBAction)back:(id)sender;
- (IBAction)gotoToKronicle:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil andKronicle:(KRKronicle *)kronicle;

@end
