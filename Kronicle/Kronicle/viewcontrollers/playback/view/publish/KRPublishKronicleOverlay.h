//
//  KRPublishKronicleOverlay.h
//  Kronicle
//
//  Created by Scott on 8/31/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kronicle+Helper.h"

@class KRPublishKronicleOverlay;
@protocol KRPublishKronicleOverlayDelegate <NSObject>

- (void)publishKronicleOverlayCanceled;
- (void)publishKronicleOverlayPublish;
- (void)publishKronicleOverlayPhotoChanged;

@end

@interface KRPublishKronicleOverlay : UIView

@property(nonatomic, weak) id <KRPublishKronicleOverlayDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andKronicle:(Kronicle *)kronicle;

@end
