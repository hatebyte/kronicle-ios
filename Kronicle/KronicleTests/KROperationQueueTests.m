//
//  KROperationQueueTests.m
//  Kronicle
//
//  Created by hatebyte on 9/21/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KROperationQueue.h"
#import "Kronicle+Life.h"

@interface KROperationQueueTests : XCTestCase {
    Kronicle *_kronicle;
}

@end

@implementation KROperationQueueTests

- (void)setUp
{
    [super setUp];
    _kronicle = [Kronicle getUnfinishedKronicle];
}

- (void)tearDown
{

    [super tearDown];
}

- (void)testOperationQueueHasValidKronicle {
    Kronicle *kronicle = [Kronicle newKronicle];
    XCTAssertThrows([[KROperationQueue alloc] initWithKronicle:kronicle], @"The OperationsQueue cannot be made, there are not enought steps in this kronicle.");
}

- (void)testOperationQueueAcceptsKronicle {
    KROperationQueue *queue = [[KROperationQueue alloc] initWithKronicle:_kronicle];
    XCTAssertEqualObjects(_kronicle, queue.kronicle, @"The operation queue accepts a kronicle");
}

- (void) testTheCorrectAmountOfOperationsHaveBeenMade {
    NSInteger expectedOpCount = [_kronicle.steps count] + 1;
    KROperationQueue *queue = [[KROperationQueue alloc] initWithKronicle:_kronicle];
    
    XCTAssertEqual(expectedOpCount, (NSInteger)[queue.operations count], @"The operations count should be eqaul to the step count, plus 1 for the kronicle.");
}


@end
