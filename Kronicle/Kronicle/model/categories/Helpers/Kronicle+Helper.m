//
//  Kronicle+Helper.m
//  Kronicle
//
//  Created by Scott on 8/22/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "Kronicle+Helper.h"
#import "Kronicle+Life.h"
#import "Kronicle+JSON.h"
#import "KronicleEngine.h"
#import "Step+Helper.h"
#import "ManagedContextController.h"
#import "KRGlobals.h"

@implementation Kronicle (Helper)

+ (NSString *)makeUUID {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

+ (NSString *)createCoverImageName {
    return [NSString stringWithFormat:@"coverimage_%@.png", [Kronicle makeUUID]];
}

+ (void)getLocaleKronicles:(void (^)(NSArray *kronicles))successBlock
                 onFailure:(void (^)(NSDictionary *dict))failBlock {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Kronicle"];
    request.predicate = [NSPredicate predicateWithFormat:@"isFinishedNumber = YES"];
    NSArray *matches = [[ManagedContextController current].managedObjectContext executeFetchRequest:request error:nil];
    
    if ([matches count] < 1) {
        failBlock(@{@"error":NO_LOCAL_KRONICLES});
        return;
    } else {
        successBlock(matches);
        return;
    }
}

+ (void)getRemoteKronicles:(void (^)(NSArray *kronicles))successBlock
                 onFailure:(void (^)(NSError *error))failBlock {
    
    [[KronicleEngine current] allKroniclesWithCompletion:^(NSArray *kronicles) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in kronicles) {
                    Kronicle *k = [Kronicle kronicleShortFromJSONDictionary:dict];
                    [[ManagedContextController current] saveContext];
                    [arr addObject:k];
                }
                successBlock(arr);
            }
                                               onFailure:^(NSError *error) {
                                                   
                                                   NSLog(@"error : %@", error);
                                                   failBlock(error);
                                                   
                                               }];
    


}

+ (void)getLocaleKronicleWithUuid:(NSString *)uuid
                      withSuccess:(void (^)(Kronicle *kronicle))successBlock
                        onFailure:(void (^)(NSDictionary *error))failBlock {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Kronicle"];
    request.predicate = [NSPredicate predicateWithFormat:@"uuid = %@", uuid];
    NSArray *matches = [[ManagedContextController current].managedObjectContext executeFetchRequest:request error:nil];
    
    if ([matches count] < 1) {
        failBlock(@{@"error":NO_LOCAL_KRONICLE});
        return;
    }
    
    successBlock([matches lastObject]);
}

+ (void)getRemoteKronicleWithUuid:(NSString *)uuid
                      withSuccess:(void (^)(Kronicle *kronicle))successBlock
                        onFailure:(void (^)(NSError *error))failBlock {
    
    [[KronicleEngine current] fetchKronicle:uuid
                             withCompletion:^(NSDictionary *dict) {

                                 Kronicle *k = [Kronicle getKronicleWithUuid:[dict objectForKey:@"_id"]];
                                 if (!k || k.steps.count < 1) {
                                     k = [Kronicle readFromJSONDictionary:dict];
                                     [[ManagedContextController current] saveContext];
                                     successBlock(k);
                                     
                                 } else {
                                     successBlock(k);
                                 }
                             
                             }
                                  onFailure:^(NSError *error) {
                                      
                                      failBlock(error);
                                      
                                  }];
    
}

+ (void)populateLocalKronicleWithRemoteSteps:(Kronicle *)kronicle
                                 withSuccess:(void (^)(Kronicle *kronicle))successBlock
                                   onFailure:(void (^)(NSDictionary *dict))failBlock {    
    
    [[KronicleEngine current] fetchStepsForKronicleUUID:kronicle.uuid
                                         withCompletion:^(NSDictionary *dict) {
                                            [kronicle addStepsFromArray:(NSArray *)dict];
                                            [[ManagedContextController current] saveContext];
                                             
                                             if (kronicle.steps.count > 0) {
                                                 successBlock(kronicle);
                                             } else {
                                                 failBlock(@{@"error":@"bad stuff"});
                                             }

                                         }
                                              onFailure:^(NSError *error) {
                                                  failBlock(@{@"error":@"bad stuff"});
                                                  
                                              }];
}

+ (NSArray *)moduloKronicleList:(NSArray *)kronicles {
    NSMutableArray *kroniclesModuloed = [[NSMutableArray alloc] init];
    int stepsMinusFinish = [kronicles count];
    
    if(stepsMinusFinish % 2 == 0) {
        for (int i = 0; i < stepsMinusFinish; i++) {
            int next = i + 1;
            NSArray *inArray = [NSArray arrayWithObjects:[kronicles objectAtIndex:i], [kronicles objectAtIndex:next], nil];
            [kroniclesModuloed addObject:inArray];
            i = next;
        }
        
    } else {
        for (int i = 0; i < stepsMinusFinish; i++) {
            NSArray *inArray;
            int next = i + 1;
            if (next < stepsMinusFinish) {
                inArray = [NSArray arrayWithObjects:[kronicles objectAtIndex:i], [kronicles objectAtIndex:next], nil];
            } else {
                inArray = [NSArray arrayWithObjects:[kronicles objectAtIndex:i], nil];
            }
            i= next;
            [kroniclesModuloed addObject:inArray];
        }
    }
    
    return kroniclesModuloed;
}

+ (NSDictionary *)reviewSettingsByRating:(CGFloat)rating {
    NSDictionary *dict;
    if (rating > .75) {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
         NSLocalizedString(@"GREAT", @"CreateReviewView bold label text"), @"text",
             [KRColorHelper turquoise], @"color", nil];
    } else if (rating > .5) {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
         NSLocalizedString(@"GOOD", @"CreateReviewView GOOD bold label text"), @"text",
         [KRColorHelper green], @"color", nil];
    } else if (rating > .25) {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
         NSLocalizedString(@"OK", @"CreateReviewView OK bold label text"), @"text",
         [KRColorHelper orangeDark], @"color", nil];
    } else {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
         NSLocalizedString(@"MEH", @"CreateReviewView MEH bold label text"), @"text",
         [KRColorHelper red], @"color", nil];
    }
    return dict;
}


- (NSString *)fullCoverURL {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", self.coverUrl]];
}

- (NSArray *)items {
    return [self.itemsSet allObjects];
}

- (void)setItems:(NSArray *)items {
    [self setValue:[NSSet setWithArray:items] forKey:@"itemsSet"];
}

- (NSArray *)steps {
    NSArray *stepsArray = [self.stepsSet allObjects];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"indexInKronicleNumber" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return [stepsArray sortedArrayUsingDescriptors:sortDescriptors];;
}

- (void)setSteps:(NSArray *)steps {
    [self setValue:[NSSet setWithArray:steps] forKey:@"stepsSet"];
}

- (NSInteger)stepCount {
    return (self.steps) ? [self.steps count] : 0;
}

- (void)setStepCount:(NSInteger)stepCount {
    self.stepCountNumber = [NSNumber numberWithInteger:stepCount];
}

- (NSInteger)totalTime {
    NSInteger tTime = 0;
    for (Step *s in self.steps) {
        tTime += s.time;
    }
    return tTime;
}

- (CGFloat)rating {
    return [self.ratingNumber floatValue];
}

- (void)setRating:(CGFloat)rating {
    self.ratingNumber = [NSNumber numberWithFloat:rating];
}

- (BOOL)isFinished {
    return [self.ratingNumber boolValue];
}

- (void)setIsFinished:(BOOL)isFinished {
    self.isFinishedNumber = [NSNumber numberWithBool:isFinished];
}



@end
