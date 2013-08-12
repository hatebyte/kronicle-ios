//
//  KRTextButton.m
//  Kronicle
//
//  Created by Jabari Bell on 8/11/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRTextButton.h"
#import "KRFontHelper.h"

@implementation KRTextButton

#pragma mark - building stuff

- (void)buildHomeTextButton
{
    self.titleLabel.font = [KRFontHelper getFont:KRBrandonLight withSize:KRFontSizeLarge];
    self.titleLabel.textColor = [UIColor whiteColor];
}

- (void)buildWithImage:(UIImage*)image
{
//    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:image];
//    [self.viewForBaselineLayout addSubview:iconImageView];
//    iconImageView.frame = CGRectMake(0, (self.) - (image.size.height / 2), image.size.width, image.size.height);
    [self setImage:image forState:UIControlStateNormal];
}


#pragma mark - init stuff

- (id)initWithFrame:(CGRect)frame andType:(KRTextButtonType)type andIcon:(UIImage*)image
{
    if (self = [super initWithFrame:frame]) {
        switch (type) {
            case KRTextButtonTypeHomeScreen:
                [self buildHomeTextButton];
                [self buildWithImage:image];
                break;
                
            default:
                break;
        }
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
