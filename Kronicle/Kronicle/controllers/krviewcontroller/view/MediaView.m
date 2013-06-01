//
//  MediaView.m
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "MediaView.h"

@implementation MediaView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_imageView];
    }
    return self;
}

- (UIImage *)image {
    return _imageView.image;
}

- (void)setMediaPath:(NSString*)mediaPath andType:(MediaViewType)type {
    _mediaPath = mediaPath;
    _imageView.image = [UIImage imageNamed:mediaPath];
}

- (void)stop {

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
