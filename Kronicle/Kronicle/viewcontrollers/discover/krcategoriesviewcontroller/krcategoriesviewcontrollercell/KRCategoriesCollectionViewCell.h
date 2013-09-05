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

@class KRCategoriesCollectionViewCell;
@protocol KRCategoriesCollectionViewCellDelegate <NSObject>
- (void)categorieCellHit:(KRCategoriesCollectionViewCell *)categoriesCollectionViewCell;

@end

@interface KRCategoriesCollectionViewCell : UICollectionViewCell

@property(strong, nonatomic) NMCustomLabel *cellTitleLabel;
@property(strong, nonatomic) UIImageView *imageView;
@property(weak, nonatomic) id <KRCategoriesCollectionViewCellDelegate> delegate;

@end
