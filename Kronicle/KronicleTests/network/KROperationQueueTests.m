//
//  KROperationQueueTests.m
//  Kronicle
//
//  Created by hatebyte on 9/21/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KRKronicleUploadQueue.h"
#import "MockKROperationQueue.h"
#import "FakeKronicleEngine.h"
#import "KRUploadEngine.h"
#import "Kronicle+Life.h"
#import "Step+Helper.h"
#import "ManagedContextController.h"

@interface KROperationQueueTests : XCTestCase {
    Kronicle *_kronicle;
    Kronicle *_testKronicle;
    KRKronicleUploadQueue *_queue;
    KRUploadEngine *_engine;
    KRKronicleUploadQueue *_testQueue;
    FakeKronicleEngine *_fakeEngine;
    
    Step  *_erroredStep;
    Step  *_startedStep;
    Kronicle  *_erroredKronicle;
    Kronicle  *_successfulKronicle;
    Kronicle  *_startedKronicle;
    
    CGFloat _stepProgress;
    CGFloat _kronicleProgress;
}

@end

 /*
 The queue should accept a kronicle id and strip the onces that are done already
 The queue should cycle through the step data and end with the final kronicle data
 When an error happens it should send a notification, and break cycle
 When it is successfull it should sent a different notification and save the object to core data
 */

@implementation KROperationQueueTests

- (void)uploadBeganNotificationFromQueue:(NSNotification *)note {
    id noteObj                      = [note object];
    if ([noteObj isKindOfClass:[Step class]]) {
        _startedStep                = (Step *)noteObj;
    } else if ([noteObj isKindOfClass:[Kronicle class]]){
        _startedKronicle            = (Kronicle *)noteObj;
    }
}

- (void)heardErrorNotificationFromQueue:(NSNotification *)note {
    id noteObj                      = [note object];
    if ([noteObj isKindOfClass:[Step class]]) {
        _erroredStep                = (Step *)noteObj;
    } else if ([noteObj isKindOfClass:[Kronicle class]]){
        _erroredKronicle            = (Kronicle *)noteObj;
    }
}

- (void)heardSuccessNotificationFromQueue:(NSNotification *)note {
    _successfulKronicle             = [note object];
}

- (void)uploadProgressNotificationFromQueue:(NSNotification *)note {
    NSDictionary *dict              = [note userInfo];
    CGFloat tempStepProg            = [[dict objectForKey:@"stepProgress"] floatValue];
    CGFloat tempKronProg            = [[dict objectForKey:@"kronicleProgress"] floatValue];
    if (tempStepProg > 0) {
        _stepProgress               = tempStepProg;
    }
    if (tempKronProg > 0) {
        _kronicleProgress           = tempKronProg;
    }
}

- (void)setUp {
    [super setUp];
    _kronicle                       = [Kronicle getUnfinishedKronicle];
    _engine                         = [[KRUploadEngine alloc] init];
    _queue                          = [[KRKronicleUploadQueue alloc] initWithEngine:_engine];
    [_queue setUpWithKronicle:_kronicle];
    
    _testKronicle                   = [Kronicle getUnfinishedKronicle];
    _fakeEngine                     = [[FakeKronicleEngine alloc] init];
    _testQueue                      = [[KRKronicleUploadQueue alloc] initWithEngine:_fakeEngine];
    [_testQueue setUpWithKronicle:_testKronicle];
}

- (void)tearDown {
    _queue                          = nil;
    _kronicle                       = nil;
    _testKronicle                   = nil;
    _engine                         = nil;
    _fakeEngine                     = nil;
    _testQueue                      = nil;
    [super tearDown];
}

- (void)testOperationQueueHasValidKronicle {
    Kronicle *kronicle = [Kronicle newUnfinishedKronicle];
    kronicle.title = @"title";
    kronicle.desc = @"desc";
    [Kronicle saveContext];

    XCTAssertThrows([_queue setUpWithKronicle:kronicle], @"The OperationsQueue cannot be made, there are not enough steps in this kronicle.");

    [Kronicle deleteKronicle:kronicle];
    _queue                          = nil;
    
}

- (void)testOperationQueueAcceptsKronicle {
    XCTAssertEqualObjects(_kronicle, _queue.kronicle, @"The operation queue accepts a kronicle");
}

- (void)testQueueHandlesErrorAtFirstStepUpload {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(heardErrorNotificationFromQueue:) name:KronicleUploadQueueError object:nil];
    _fakeEngine.failAtStep = YES;
    [_testQueue startUpload];
    
    XCTAssertEqual(0, (NSInteger)_erroredStep.indexInKronicle, @"The failure of a step should send out a failure notification.");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KronicleUploadQueueError object:nil];
}

- (void)testQueueHandlesErrorAtSecondStepUpload {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(heardErrorNotificationFromQueue:) name:KronicleUploadQueueError object:nil];
    _fakeEngine.failAtSecondStep = YES;
    [_testQueue startUpload];
    
    XCTAssertEqual(1, (NSInteger)_erroredStep.indexInKronicle, @"The failure of a second step should send out a failure notification.");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KronicleUploadQueueError object:nil];
}

- (void)testQueueHandlesErrorAtKronicleUpload {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(heardErrorNotificationFromQueue:) name:KronicleUploadQueueError object:nil];
    _fakeEngine.failForKronicle = YES;
    [_testQueue startUpload];
    
    XCTAssertEqualObjects(_kronicle.uuid, _erroredKronicle.uuid, @"The failure of a kronicle should send out a failure notification.");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KronicleUploadQueueError object:nil];
}

- (void)testQueueHandlesInformsOfUploadStartWithNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadBeganNotificationFromQueue:) name:KronicleUploadQueueStart object:nil];
    [_testQueue startUpload];
    
    XCTAssertNotNil(_startedStep, @"The successful upload should send out an startUpload notification with step.");
    XCTAssertNotNil(_startedKronicle, @"The successful upload should send out an startUpload notification with kronicle.");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KronicleUploadQueueStart object:nil];
}

- (void)testQueueHandlesInformsOfUploadProgressWithNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadProgressNotificationFromQueue:) name:KronicleUploadQueueProgress object:nil];
    [_testQueue startUpload];
    
    XCTAssertTrue(_stepProgress > 0, @"The progress of the current step sends out a notification.");
    XCTAssertTrue(_kronicleProgress > 0, @"The progress of the kronicle sends out a notification.");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KronicleUploadQueueProgress object:nil];
}

- (void)testQueueHandlesSuccessfulUpload {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(heardSuccessNotificationFromQueue:) name:KronicleUploadQueueSuccess object:nil];
    [_testQueue startUpload];
    
    XCTAssertEqualObjects(_kronicle.uuid, _successfulKronicle.uuid, @"The successful upload should send out an success notification with kronicle.");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KronicleUploadQueueSuccess object:nil];
}

- (void) testQueueFiltersStepsThatAreComplete {
    Kronicle *tKronicle                   = [Kronicle getUnfinishedKronicle];

    Step *firstStep = [tKronicle.steps objectAtIndex:0];
    firstStep.isFinished = YES;
    [Kronicle saveContext];
    [_testQueue setUpWithKronicle:tKronicle];
    
    XCTAssertEqual((NSInteger)[_testQueue.steps count], (NSInteger)([tKronicle.steps count]-1), @"The queue should poplate steps with unfinished steps, not finished steps.");

    firstStep.isFinished = NO;
    [Kronicle saveContext];
    
}

@end
