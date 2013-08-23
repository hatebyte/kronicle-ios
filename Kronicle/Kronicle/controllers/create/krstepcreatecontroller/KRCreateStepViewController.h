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
#import "KRStep.h"

@interface KRCreateStepViewController : KRBaseEditTableViewController {
    @private

}


- (id)initWithStep:(KRStep *)step andSaveBlock:(void (^)(KRStep *newStep))completion;
;

@end
