//
//  KRCategoriesViewController.h
//  Kronicle
//
//  Created by Jabari Bell on 8/15/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRSearchTextFieldView.h"
#import "KRBaseEditTableViewController.h"

@interface KRCategoriesViewController : KRBaseEditTableViewController <KRSearchTextFieldViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@end