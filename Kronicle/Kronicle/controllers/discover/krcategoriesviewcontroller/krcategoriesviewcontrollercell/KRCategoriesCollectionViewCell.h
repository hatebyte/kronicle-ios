//
//  KRCategoriesCollectionViewCell.h
//  Kronicle
//
//  Created by Jabari Bell on 8/17/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

enum {
  KRCategoriesViewControllerCellDimension = 100
};

#import <UIKit/UIKit.h>
#import "NMCustomLabel.h"

@interface KRCategoriesCollectionViewCell : UICollectionViewCell

@property(strong, nonatomic) NMCustomLabel *cellTitleLabel;

@end
