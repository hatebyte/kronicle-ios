//
//  Kronicle+Life.h
//  Kronicle
//
//  Created by Scott on 8/24/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "Kronicle.h"

@interface Kronicle (Life)

+ (Kronicle *)getKronicleWithUuid:(NSString *)uuid;
+ (Kronicle *)newKronicle;
+ (Kronicle *)newUnfinishedKronicle;
+ (void)deleteKronicleWithUUID:(NSString *)uuid;
+ (void)deleteKronicle:(Kronicle *)kronicle;
+ (Kronicle *)getUnfinishedKronicle;
+ (void)saveContext;


- (void)update;


@end
