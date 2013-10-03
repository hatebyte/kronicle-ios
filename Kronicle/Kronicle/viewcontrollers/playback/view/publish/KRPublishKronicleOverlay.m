//
//  KRPublishKronicleOverlay.m
//  Kronicle
//
//  Created by Scott on 8/31/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRPublishKronicleOverlay.h"
#import "KRPublishKronicleModule.h"
#import "Kronicle+Helper.h"
#import "KRHomeViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface KRPublishKronicleOverlay () <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    @private
    KRPublishKronicleModule *_overlayModule;
    __weak Kronicle *_kronicle;
    UIImageView *_fpoImagePublish;
}

@end

@implementation KRPublishKronicleOverlay

- (id)initWithFrame:(CGRect)frame andKronicle:(Kronicle *)kronicle {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor                    = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.8f];
        _kronicle                               = kronicle;
        
        _overlayModule                          = [[KRPublishKronicleModule alloc] initWithFrame:CGRectMake((self.frame.size.width - [KRPublishKronicleModule width]) * .5,
                                                                                                            (self.frame.size.width - [KRPublishKronicleModule width]) * .5,
                                                                                                            [KRPublishKronicleModule width],
                                                                                                            [KRPublishKronicleModule height]) andKronicle:_kronicle];
        [self addSubview:_overlayModule];
        
        [_overlayModule.cameraButton addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
        [_overlayModule.cancelButton addTarget:self action:@selector(cancelOverlay) forControlEvents:UIControlEventTouchUpInside];
        [_overlayModule.publishButton addTarget:self action:@selector(publishKronicle) forControlEvents:UIControlEventTouchUpInside];
        
        
        CALayer *whiteLayer                 = [CALayer layer];
        whiteLayer.backgroundColor          = [UIColor whiteColor].CGColor;
        whiteLayer.frame                    = CGRectMake(0,
                                                         frame.size.height - 80,
                                                         320,
                                                         80);
        [self.layer addSublayer:whiteLayer];
        
        
        _fpoImagePublish = [[UIImageView alloc] initWithFrame:whiteLayer.frame];
        _fpoImagePublish.image = [UIImage imageNamed:@"fpo_bottom"];
        _fpoImagePublish.backgroundColor   = [UIColor clearColor];
        [self addSubview:_fpoImagePublish];


    }
    return self;
}

- (void)cancelOverlay {
    [self.delegate publishKronicleOverlayCanceled];
}

- (void)publishKronicle {
    NSData *imageData = UIImagePNGRepresentation(_overlayModule.coverImage.image);
    if (imageData) {
        NSString *byteName = [Kronicle createCoverImageName];
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *imagePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", byteName]];
        [imageData writeToFile:imagePath atomically:YES];
        _kronicle.coverUrl = byteName;
    }
    
    [self.delegate publishKronicleOverlayPublish];
}


#pragma image picker
- (void)addImage {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;

    [[KRHomeViewController current].navigationController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [[KRHomeViewController current].navigationController dismissViewControllerAnimated:NO completion:^() {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        _overlayModule.coverImage.image = image;
        [self.delegate publishKronicleOverlayPhotoChanged];
        
    }];
}


@end
