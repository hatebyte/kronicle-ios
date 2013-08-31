//
//  KRCategoriesViewControllerCellCircleView.m
//  Kronicle
//
//  Created by Jabari Bell on 8/17/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRCategoriesViewControllerCellCircleView.h"
#import "KRColorHelper.h"
#import "KRCategoriesCollectionViewCell.h"

@implementation KRCategoriesViewControllerCellCircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    float circleDimension = KRCategoriesViewControllerCellDimension - 30;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGRect rectangle = CGRectMake(0, 0, circleDimension, circleDimension);
    CGContextAddEllipseInRect(context, rectangle);
    CGContextSetFillColorWithColor(context, [KRColorHelper turquoiseDark].CGColor);
    CGContextFillPath(context);
}

@end
