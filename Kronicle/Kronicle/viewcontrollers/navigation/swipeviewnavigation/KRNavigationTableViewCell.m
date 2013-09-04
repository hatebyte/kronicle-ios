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

- (void)prepareForUseWithData:(NSDictionary *)data isTableOpen:(BOOL)isTableOpen {
    
    [_bottomStroke removeFromSuperlayer];
    self.textLabel.text = [data objectForKey:@"title"];
    _thumbImage.image = [UIImage imageNamed:[data objectForKey:@"thumbImage"]];
    UIColor *backgroundColor = [UIColor whiteColor];
    
    if (isTableOpen) {
        backgroundColor                = [UIColor colorWithRed:.9f green:.9f blue:.9f alpha:1.f];
    }
    
    [UIView animateWithDuration:.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.contentView.backgroundColor                = backgroundColor;
                         self.backgroundView.backgroundColor             = backgroundColor;
                         self.backgroundColor                            = backgroundColor;
                         
                     }
                     completion:^(BOOL fin){ }];

}

- (void)addStroke {
    [self.contentView.layer addSublayer:_bottomStroke];
}

@end
