//
//  User.h
//  Kronicle
//
//  Created by Scott on 8/22/13.
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
@property (nonatomic, retain) NSSet *favorites;
@property (nonatomic, retain) NSSet *kronicles;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addFavoritesObject:(Kronicle *)value;
- (void)removeFavoritesObject:(Kronicle *)value;
- (void)addFavorites:(NSSet *)values;
- (void)removeFavorites:(NSSet *)values;

- (void)addKroniclesObject:(Kronicle *)value;
- (void)removeKroniclesObject:(Kronicle *)value;
- (void)addKronicles:(NSSet *)values;
- (void)removeKronicles:(NSSet *)values;

@end
