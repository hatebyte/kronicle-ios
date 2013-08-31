//
//  KRPlaybackViewController.h
//  Kroncile
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRHomeViewController.h"
#import "Kronicle+Helper.h"
#import "MediaView.h"
#import "KRKronicleBaseViewController.h"

typedef enum {
    KRKronicleViewingStateView,
    KRKronicleViewingStatePreview
} KRKronicleViewingState;

@interface KRPlaybackViewController : KRKronicleBaseViewController {

}

@property (nonatomic, strong) Kronicle *kronicle;

- (id)initWithKronicle:(Kronicle *)kronicle andViewingState:(KRKronicleViewingState)viewingState;
- (id)initWithKronicle:(Kronicle *)kronicle ;

@end
