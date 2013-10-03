//
//  FakeKronicleEngine.h
//  Kronicle
//
//  Created by hatebyte on 10/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRUploadEngine.h"

@interface FakeKronicleEngine : KRUploadEngine

@property(nonatomic, assign) BOOL failAtStep;
@property(nonatomic, assign) BOOL failAtSecondStep;
@property(nonatomic, assign) BOOL failForKronicle;


@end
