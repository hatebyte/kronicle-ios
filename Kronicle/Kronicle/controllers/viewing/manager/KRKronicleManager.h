//
//  KRKronicleManager.h
//  Kronicle
//
//  Created by Scott on 8/5/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Kronicle+Helper.h"
#import "Step+Helper.h"

typedef enum {
    KronicleManagerLeft,
    KronicleManagerRight
} KronicleManagerDirection;

@class KRKronicleManager;
@protocol KRKronicleManagerDelegate <NSObject>

- (void)manager:(KRKronicleManager *)manager updateUIForStep:(Step*)step;
- (void)manager:(KRKronicleManager *)manager previewUIForStep:(Step*)step;
- (void)kronicleComplete:(KRKronicleManager *)manager;

@end


@interface KRKronicleManager : NSObject

@property (nonatomic, weak) id <KRKronicleManagerDelegate> delegate;
@property (nonatomic, assign) int currentStepIndex;
@property (nonatomic, assign) int previewStepIndex;
@property (nonatomic, assign) KronicleManagerDirection requestedDirection;

- (id)initWithKronicle:(Kronicle *)kronicle;
- (void)setStep:(int)step;
- (void)setPreviewStep:(int)step;

@end
