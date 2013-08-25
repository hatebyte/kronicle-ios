//
//  KRCreateStepViewController.h
//  Kronicle
//
//  Created by Scott on 6/12/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRBaseEditTableViewController.h"
#import "DurationCreatorView.h"
#import "Step+Helper.h"

@interface KRCreateStepViewController : KRBaseEditTableViewController {
    @private

}


- (id)initWithStep:(Step *)step andSaveBlock:(void (^)(Step *newStep))completion;

@end
