//
//  KRFormFieldCell.m
//  Kronicle
//
//  Created by Scott on 8/16/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRFormFieldCell.h"

@implementation KRFormFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
