//
//  KRKronicleManager.h
//  Kronicle
//
//  Created by Scott on 8/5/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KRKronicle.h"
#import "KRStep.h"

@class KRKronicleManager;
@protocol KRKronicleManagerDelegate <NSObject>

- (void)manager:(KRKronicleManager *)manager updateUIForStep:(KRStep*)step;
- (void)manager:(KRKronicleManager *)manager previewUIForStep:(KRStep*)step;
- (void)kronicleComplete:(KRKronicleManager *)manager;

@end


@interface KRKronicleManager : NSObject

@property (nonatomic, weak) id <KRKronicleManagerDelegate> delegate;
@property (nonatomic, assign) int currentStepIndex;
@property (nonatomic, assign) int previewStepIndex;

- (id)initWithKronicle:(KRKronicle *)kronicle;
- (void)setStep:(int)step;
- (void)setPreviewStep:(int)step;

@end
