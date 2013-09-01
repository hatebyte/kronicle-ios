//
//  KRPublishKronicleModule.h
//  Kronicle
//
//  Created by Scott on 8/31/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kronicle+Helper.h"

@interface KRPublishKronicleModule : UIView

@property(nonatomic, strong) UIButton *cameraButton;
@property(nonatomic, strong) UIButton *cancelButton;
@property(nonatomic, strong) UIButton *publishButton;
@property(nonatomic, strong) UIImageView *coverImage;


+ (CGFloat)width;
+ (CGFloat)height;

- (id)initWithFrame:(CGRect)frame andKronicle:(Kronicle *)kronicle;

@end
