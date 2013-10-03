//
//  KRNetworkConnection.h
//  Kroncile
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KRSerializable.h"

@interface KRNetworkConnection : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    @private
    NSURLConnection *_internalConnection;
    NSMutableData *_container;
}

- (id)initWithRequest:(NSURLRequest*)request;
- (void)start;

@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, copy) void (^completionBlock)(id obj, NSError *err);
@property (nonatomic, strong) id <KRSerializable> kRootObject;

@end
