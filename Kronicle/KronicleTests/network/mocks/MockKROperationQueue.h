//
//  MockKROperationQueue.h
//  Kronicle
//
//  Created by hatebyte on 9/30/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRKronicleUploadQueue.h"
#import "FakeKronicleEngine.h"

@interface MockKROperationQueue : KRKronicleUploadQueue

@property(nonatomic, weak) FakeKronicleEngine *engine;

@end
