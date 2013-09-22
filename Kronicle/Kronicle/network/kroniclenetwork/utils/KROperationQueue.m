//
//  KROperationQueue.m
//  Kronicle
//
//  Created by hatebyte on 9/21/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KROperationQueue.h"
#import "KronicleEngine.h"


@implementation KROperationQueue


- (id)initWithKronicle:(Kronicle *)kronicle {
    if (self = [super init]) {
        NSLog(@"[kronicle.steps count] : %d", [kronicle.steps count]);
        if ([kronicle.steps count] <= 1) {
            [[NSException exceptionWithName:@"The OperationsQueue cannot be made, there are not enought steps in this kronicle." reason:NSInvalidArgumentException userInfo:nil] raise];
        }
        _kronicle = kronicle;
        
        [self createOperations];
    }
    return self;
}

- (void)createOperations {
    NSMutableArray *mutableOps = [[NSMutableArray alloc] init];
    MKNetworkOperation *kronicleOp = [[KronicleEngine current] uploadKronicle:_kronicle withCompletion:^(Kronicle *k){} onFailure:^(NSError *error){}];
    [mutableOps addObject:kronicleOp];
    for (int i = 0; i < [_kronicle.steps count]; i++) {
        Step *step = [_kronicle.steps objectAtIndex:i];
        MKNetworkOperation *stepOp = [[KronicleEngine current] uploadStep:step withCompletion:^(Step *s){} onFailure:^(NSError *error){}];
        [mutableOps addObject:stepOp];
    }
    _operations = [NSArray arrayWithArray:mutableOps];
}



@end
