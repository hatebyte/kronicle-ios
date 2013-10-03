//
//  KROperationQueue.h
//  Kronicle
//
//  Created by hatebyte on 9/21/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Kronicle+Helper.h"
#import "Step+Helper.h"
#import "KRUploadEngine.h"

extern NSString *KronicleUploadQueueError;
extern NSString *KronicleUploadQueueProgress;
extern NSString *KronicleUploadQueueSuccess;
extern NSString *KronicleUploadQueueStart;

@interface KRKronicleUploadQueue : NSObject {
    @private
    void (^_errorHandler)(NSError *, id);
    void (^_stepSuccessHandler)(Step *);
    void (^_kronicleSuccessHandler)(Kronicle *);
    
}

@property(nonatomic, weak) Kronicle *kronicle;
@property(nonatomic, weak) KRUploadEngine *engine;
@property(nonatomic, strong) NSMutableArray *steps;

- (id)initWithEngine:(KRUploadEngine *)engine;
- (void)setUpWithKronicle:(Kronicle *)kronicle;
- (void)startUpload;

@end
