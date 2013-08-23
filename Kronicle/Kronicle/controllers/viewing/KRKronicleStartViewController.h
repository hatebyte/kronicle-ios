//
//  KRKronicleStartViewController.h
//  Kronicle
//
//  Created by Scott on 6/2/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kronicle+Helper.h"

@interface KRKronicleStartViewController : UIViewController

@property(nonatomic,strong) Kronicle *kronicle;
@property(nonatomic, weak) IBOutlet UIImageView *kImage;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UITextView *description;

- (IBAction)back:(id)sender;
- (IBAction)gotoToKronicle:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil andKronicle:(Kronicle *)kronicle;

@end
