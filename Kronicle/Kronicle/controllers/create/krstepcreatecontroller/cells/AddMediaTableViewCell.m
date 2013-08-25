//
//  AddMediaTableViewCell.m
//  Kronicle
//
//  Created by Scott on 8/17/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "AddMediaTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "ContentWithLabelView.h"

@interface AddMediaTableViewCell () {
    @private
    UIImageView *_imageView;
    UIView *_mediaBar;
    ContentWithLabelView *_add;
    ContentWithLabelView *_camRoll;
    ContentWithLabelView *_camera;
    ContentWithLabelView *_video;
    
}

@end

@implementation AddMediaTableViewCell

+ (CGFloat)cellHeight {
    //return (IS_IPHONE_5) ? 285.f : 240.f;
    return 285.f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle                         = UITableViewCellSelectionStyleNone;
        
        _imageView                                          = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                                            ([AddMediaTableViewCell cellHeight] - 320) * .5,
                                                                                                            320,
                                                                                                            320)];
        _imageView.backgroundColor                          = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:.1f];
        [self.contentView addSubview:_imageView];
        
        _mediaBar                                          = [[UIView alloc] initWithFrame:CGRectMake(10,
                                                                                                           ([AddMediaTableViewCell cellHeight] - 95) * .5,
                                                                                                           300,
                                                                                                           95)];
        CALayer *layer = [CALayer layer];
        [layer setBackgroundColor:[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f] CGColor]];
        layer.frame = CGRectMake(0, 0,_mediaBar.frame.size.width, _mediaBar.frame.size.height);
        layer.cornerRadius = 48;
        [_mediaBar.layer addSublayer:layer];
        _mediaBar.backgroundColor                           = [UIColor clearColor];
        [self.contentView addSubview:_mediaBar];
        
        NSInteger width = 60;
        NSInteger sidePadding = 15;
        NSInteger padding = (_mediaBar.frame.size.width - ((sidePadding * 2) + (width * 4))) / 3;
        _add = [[ContentWithLabelView alloc] initWithFrame:CGRectMake(sidePadding * .75, 6, width, 70)
                                                       andTitle:@"add"
                                                       andImage:[UIImage imageNamed:@"plusbutton"]];
        [_mediaBar addSubview:_add];
        
        _camRoll = [[ContentWithLabelView alloc] initWithFrame:CGRectMake(_add.frame.origin.x + _add.frame.size.width + padding-8, _add.frame.origin.y, _add.frame.size.width, _add.frame.size.height)
                                                      andTitle:@"cam roll"
                                                      andImage:[UIImage imageNamed:@"camroll"]];
        [_camRoll addTarget:self withSelector:@selector(camRollTapped)];
        [_mediaBar addSubview:_camRoll];
        
        _camera = [[ContentWithLabelView alloc] initWithFrame:CGRectMake(_camRoll.frame.origin.x + _camRoll.frame.size.width + padding+4, _add.frame.origin.y, _add.frame.size.width, _add.frame.size.height)
                                                     andTitle:@"camera"
                                                     andImage:[UIImage imageNamed:@"camera"]];
        [_camera addTarget:self withSelector:@selector(cameraTapped)];
        [_mediaBar addSubview:_camera];

        _video = [[ContentWithLabelView alloc] initWithFrame:CGRectMake(_camera.frame.origin.x + _camera.frame.size.width + padding, _add.frame.origin.y, _add.frame.size.width, _add.frame.size.height)
                                                    andTitle:@"video"
                                                    andImage:[UIImage imageNamed:@"video"]];
        [_video addTarget:self withSelector:@selector(videoTapped)];
        [_mediaBar addSubview:_video];
        
        self.contentView.backgroundColor                    = [UIColor blackColor];
        self.clipsToBounds                                  = YES;
        
    }
    return self;
}

- (void)prepareForUseWithImage:(NSString *)imagePath {
    NSLog(@"imagePath : %@",imagePath);
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imageUrl = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", imagePath]];
    _imageView.image = [UIImage imageWithContentsOfFile:imageUrl];
}

- (void)camRollTapped {
    [self.delegate addMediaRequested:self forType:KRMediaCameraRoll];
}

- (void)cameraTapped {
    [self.delegate addMediaRequested:self forType:KRMediaCamera];
}

- (void)videoTapped {
    [self.delegate addMediaRequested:self forType:KRMediaVideo];
}

- (NSString *)value {
    return @"imagepath";
}


@end
