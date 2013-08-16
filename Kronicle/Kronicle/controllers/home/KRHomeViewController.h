//
//  KRHomeViewController.h
//  Kronicle
//
//  Created by Jabari Bell on 8/11/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KRHomeViewController : UIViewController


+ (KRHomeViewController *)current;

//- (void)closeNavigation;

- (void)home;
- (void)mykronicles;
- (void)create;
- (void)discover;
- (void)me;

@end
