//
//  User.h
//  Kronicle
//
//  Created by hatebyte on 10/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Kronicle;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSData * profilePic;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSSet *favoritesSet;
@property (nonatomic, retain) NSSet *kroniclesSet;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addFavoritesSetObject:(Kronicle *)value;
- (void)removeFavoritesSetObject:(Kronicle *)value;
- (void)addFavoritesSet:(NSSet *)values;
- (void)removeFavoritesSet:(NSSet *)values;

- (void)addKroniclesSetObject:(Kronicle *)value;
- (void)removeKroniclesSetObject:(Kronicle *)value;
- (void)addKroniclesSet:(NSSet *)values;
- (void)removeKroniclesSet:(NSSet *)values;

@end
