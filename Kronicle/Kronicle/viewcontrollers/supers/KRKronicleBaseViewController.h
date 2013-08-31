//
//  KRKronicleBaseViewController.h
//  Kronicle
//
//  Created by Scott on 8/12/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kronicle+Helper.h"
#import "UIHelper.h"
#import "KRGlobals.h"
#import "KRNavigationViewController.h"

@interface KRKronicleBaseViewController : UIViewController {
    @protected
    CGRect _bounds;

}

- (void)viewListItems:(Kronicle *)kronicle;

@end
