//
//  KRCategoriesCollectionViewCell.m
//  Kronicle
//
//  Created by Jabari Bell on 8/17/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRCategoriesCollectionViewCell.h"
#import "UIView+GCLibrary.h"
#import "KRCategoriesViewControllerCellCircleView.h"
#import "KRFontHelper.h"

@implementation KRCategoriesCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.width = KRCategoriesViewControllerCellDimension;
        self.height = KRCategoriesViewControllerCellDimension;
        float circleDimension = KRCategoriesViewControllerCellDimension - 30.0f;
        
        //for some reason dividing the circle dimension by two isn't good enough... leaving 2.75
        //coordinates in this whole file are fucked
        KRCategoriesViewControllerCellCircleView *circleView = [[KRCategoriesViewControllerCellCircleView alloc] initWithFrame:CGRectMake((self.width / 2) - (circleDimension / 2.75), 0, circleDimension, circleDimension)];
        [self.contentView addSubview:circleView];
        
        _cellTitleLabel = [[NMCustomLabel alloc] initWithFrame:CGRectMake(10, circleView.height + circleView.y, self.width, self.height)];
        [_cellTitleLabel setY:80];
        _cellTitleLabel.backgroundColor = [UIColor clearColor];
        _cellTitleLabel.numberOfLines = 0;
        _cellTitleLabel.textAlignment = UITextAlignmentCenter;
        _cellTitleLabel.lineHeight = 28;
//        _cellTitleLabel.font = [KRFontHelper getFont:KRBrandonLight withSize:KRFontSizeLarge];
//        _cellTitleLabel.textColor = [UIColor whiteColor];
        _cellTitleLabel.text = @"Category name";
        [_cellTitleLabel setDefaultStyle:[NMCustomLabelStyle styleWithFont:[KRFontHelper getFont:KRBrandonLight withSize:KRFontSizeLarge] color:[UIColor whiteColor]]];
        [self.contentView addSubview:_cellTitleLabel];
    }
    return self;
}

@end
