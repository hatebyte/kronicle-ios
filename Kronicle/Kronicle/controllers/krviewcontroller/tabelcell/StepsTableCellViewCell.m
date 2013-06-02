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
        // Initialization code
        
        self.frameimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        self.frameimage.image = [UIImage imageNamed:@""];
        
        self.kImage = [[UIImageView alloc] initWithFrame:self.frameimage.frame];
        self.kImage.image = [UIImage imageNamed:@""];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frameimage.frame.size.width - 20,
                                                                    0,
                                                                    200,
                                                                    30)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:KRFontSizeLarge];
        self.titleLabel.textColor = [UIColor grayColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleLabel];

        self.subLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x,
                                                                  self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height,
                                                                  200,
                                                                  30)];
        self.subLabel.textAlignment = NSTextAlignmentCenter;
        self.subLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:KRFontSizeRegular];
        self.subLabel.textColor = [UIColor grayColor];
        self.subLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.subLabel];
        
        self.number = [[UILabel alloc] initWithFrame:self.frameimage.frame];
        self.number.textAlignment = NSTextAlignmentCenter;
        self.number.font = [KRFontHelper getFont:KRBrandonMedium withSize:32];
        self.number.textColor = [UIColor whiteColor];
        self.number.backgroundColor = [UIColor clearColor];

        CALayer *bottomOfUnderMediaBorder = [CALayer layer];
        bottomOfUnderMediaBorder.frame = CGRectMake(0, self.contentView.frame.size.height-4, 320, 2);
        bottomOfUnderMediaBorder.backgroundColor = [KRColorHelper darkGrey].CGColor;
        [self.contentView.layer addSublayer:bottomOfUnderMediaBorder];
        
        CALayer *barf = [CALayer layer];
        barf.frame = CGRectMake(0, self.contentView.frame.size.height-2, 320, 2);
        barf.backgroundColor = [KRColorHelper lightGrey].CGColor;
        [self.contentView.layer addSublayer:barf];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
