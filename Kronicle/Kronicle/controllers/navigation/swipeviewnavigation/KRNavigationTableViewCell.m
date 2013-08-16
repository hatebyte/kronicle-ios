//
//  KRNavigationTableViewCell.m
//  Kronicle
//
//  Created by Scott on 8/13/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRNavigationTableViewCell.h"
#import "KRColorHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "KRFontHelper.h"

@interface KRNavigationTableViewCell () {
    @private
    UILabel *_titleLabel;
    CALayer *_bottomStroke;
    UIImageView *_thumbImage;
}

@end

@implementation KRNavigationTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:.85];

        
//        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        self.textLabel.font         = [KRFontHelper getFont:KRBrandonLight withSize:28];
        self.textLabel.textColor    = [KRColorHelper turquoise];
        
        _bottomStroke = [CALayer layer];
        _bottomStroke.frame = CGRectMake(0, self.contentView.frame.size.height+1, 320, .5);
        _bottomStroke.backgroundColor = [KRColorHelper turquoise].CGColor;
        
        _thumbImage = [[UIImageView alloc] initWithFrame:CGRectMake(320 - 45, 0, 45, 45)];
        [self.contentView addSubview:_thumbImage];
        
    }
    return self;
}

- (void)prepareForUseWithData:(NSDictionary *)data {
    
    [_bottomStroke removeFromSuperlayer];
    self.textLabel.text = [data objectForKey:@"title"];
    _thumbImage.image = [UIImage imageNamed:[data objectForKey:@"thumbImage"]];

}

- (void)addStroke {
    [self.contentView.layer addSublayer:_bottomStroke];
}

@end
