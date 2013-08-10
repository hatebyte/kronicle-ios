//
//  StepsTableCellViewCell.m
//  Kronicle
//
//  Created by Scott on 6/2/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "StepsTableCellViewCell.h"
#import "KRColorHelper.h"
#import "KRFontHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation StepsTableCellViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;

        self.frameimage = [[UIImageView alloc] initWithFrame:CGRectMake(-5, -2, KCellHeight, KCellHeight)];
        
        self.kImage = [[UIImageView alloc] initWithFrame:self.frameimage.frame];
        
        [self.contentView addSubview:self.kImage];
        [self.contentView addSubview:self.frameimage];
        
//        self.hightlight = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, KCellHeight)];
//        [self.contentView addSubview:self.hightlight];

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frameimage.frame.size.width-16,
                                                                    23,
                                                                    240,
                                                                    40)];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:26];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleLabel];

        self.subLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x,
                                                                  self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height-12,
                                                                  200,
                                                                  30)];
        self.subLabel.textAlignment = NSTextAlignmentLeft;
        self.subLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:KRFontSizeRegular];
        self.subLabel.textColor = [UIColor grayColor];
        self.subLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.subLabel];
        
        self.number = [[UILabel alloc] initWithFrame:self.frameimage.frame];
        self.number.textAlignment = NSTextAlignmentCenter;
        self.number.font = [KRFontHelper getFont:KRBrandonMedium withSize:34];
        self.number.textColor = [UIColor whiteColor];
        self.number.backgroundColor = [UIColor clearColor];
        self.number.shadowColor = [KRColorHelper darkGrey];
        self.number.shadowOffset = CGSizeMake(1,1);

        [self.contentView addSubview:self.number];
        
        CALayer *bottomOfUnderMediaBorder = [CALayer layer];
        bottomOfUnderMediaBorder.frame = CGRectMake(0, KCellHeight-2, 320, 1);
        bottomOfUnderMediaBorder.backgroundColor = [UIColor colorWithRed:.6 green:.6 blue:.6 alpha:1].CGColor;
        [self.contentView.layer addSublayer:bottomOfUnderMediaBorder];
        
        CALayer *barf = [CALayer layer];
        barf.frame = CGRectMake(0, KCellHeight-1, 320, 1);
        barf.backgroundColor = [KRColorHelper lightGrey].CGColor;
        [self.contentView.layer addSublayer:barf];
        
    }
    return self;
}

- (void)prepareForReuse {

}

- (void)hit {
//    self.subLabel.textColor = [UIColor blackColor];
//    self.titleLabel.textColor = [UIColor blackColor];
}


@end
