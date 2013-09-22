//
//  APIRouter.h
//  Kronicle
//
//  Created by Scott on 7/8/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIRouter : NSObject

@property (nonatomic, copy) NSString *baseURL;
@property (nonatomic, copy) NSString *kronicles;

+ (APIRouter*)current;

-(NSString *)kronicleById:(NSString *)uuid;
-(NSString *)stepsForKronicleById:(NSString *)uuid;

@end
