

//
//  KROperationQueue.m
//  Kronicle
//
//  Created by hatebyte on 9/21/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRKronicleUploadQueue.h"
#import "ManagedContextController.h"


@implementation KRKronicleUploadQueue

- (id)initWithEngine:(KRUploadEngine *)engine {
    if (self = [super init]) {
        self.engine = engine;
    }
    return self;
}

- (void)setUpWithKronicle:(Kronicle *)kronicle {
    if (kronicle.steps && [kronicle.steps count] < 2) {
        [[NSException exceptionWithName:NSInvalidArgumentException
                                 reason:@"The OperationsQueue cannot be made, there are not enough steps in this kronicle."
                               userInfo:nil] raise];
        return;
    }

    _kronicle = kronicle;
    NSString *predicateString = @"isFinished == NO";
    NSPredicate *predicate =[NSPredicate predicateWithFormat:predicateString];
    _steps = [[_kronicle.steps filteredArrayUsingPredicate:predicate] mutableCopy];
}

- (void)startUpload {
    NSAssert(self.kronicle, @"There needs to be a kronicle before you start an upload.");
    
    __block KRKronicleUploadQueue *selfBlockRef = self;
    _errorHandler = ^(NSError *error, id erroredObject) {
        // Notify ui of error
        //NSLog(@"error : %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:KronicleUploadQueueError object:erroredObject userInfo:nil];
    };
    
    _stepSuccessHandler = ^(Step *step) {
        //step.isFinished = YES;
        //[[ManagedContextController current] saveContext];

        //NSLog(@"kronicle : %@", kronicle);
        [selfBlockRef nextOperation];
    };
    
    
    _kronicleSuccessHandler = ^(Kronicle *kronicle){
        //kronicle.isFinished = YES;
        //[[ManagedContextController current] saveContext];
        
        //NSLog(@"kronicle : %@", kronicle);
        [[NSNotificationCenter defaultCenter] postNotificationName:KronicleUploadQueueSuccess object:kronicle userInfo:nil];
    };
    
    [self nextOperation];
    
}

- (void)nextOperation {
    if (!_steps) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KronicleUploadQueueStart object:_kronicle userInfo:nil];
        [_engine uploadKronicle:_kronicle withCompletion:_kronicleSuccessHandler onFailure:_errorHandler withProgressKey:KronicleUploadQueueProgress];
    } else {

        Step *step = [_steps objectAtIndex:0];
        if ([_steps count] <= 1) {
            _steps = nil;
        } else {
            [_steps removeObject:step];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KronicleUploadQueueStart object:step userInfo:nil];
        [_engine uploadStep:step withCompletion:_stepSuccessHandler onFailure:_errorHandler withProgressKey:KronicleUploadQueueProgress];
    }
}

@end

NSString *KronicleUploadQueueError      = @"KronicleUploadQueueError";
NSString *KronicleUploadQueueSuccess    = @"KronicleUploadQueueSuccess";
NSString *KronicleUploadQueueStart      = @"KronicleUploadQueueStart";
NSString *KronicleUploadQueueProgress   = @"KronicleUploadQueueProgress";









