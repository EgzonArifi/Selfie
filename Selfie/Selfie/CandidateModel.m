//
//  CandidateModel.m
//  Selfie
//
//  Created by Egzon Arifi on 5/21/17.
//  Copyright © 2017 Egzon Arifi. All rights reserved.
//

#import "CandidateModel.h"
#import "JsonLoader.h"

NSString *const kCandidateModelNumber = @"id";
NSString *const kCandidateModelImages = @"images";
NSString *const kCandidateModelName = @"name";

@interface CandidateModel ()

@end

@implementation CandidateModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (![dictionary[kCandidateModelNumber] isKindOfClass:[NSNull class]] ){
        self.number = dictionary[kCandidateModelNumber];
    }
    
    if (![dictionary[kCandidateModelImages] isKindOfClass:[NSNull class]]) {
        self.images = dictionary[kCandidateModelImages];
    }
    if (![dictionary[kCandidateModelName] isKindOfClass:[NSNull class]]) {
        self.name = dictionary[kCandidateModelName];
    }
    return self;
}

+ (void)loadCandidates:(void (^)(NSArray *candidatesArray))completion {
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *attributes in [JsonLoader loadJsonFromFile:@"candidates"]) {
        CandidateModel *candidate = [[CandidateModel alloc] initWithDictionary:attributes];
        [array addObject:candidate];
    }
    completion(array);
}
+ (void)searchCandidate:(NSString *)text results:(void (^)(NSArray *candidatesArray))completion {
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *attributes in [JsonLoader loadJsonFromFile:@"candidates"]) {
        CandidateModel *candidate = [[CandidateModel alloc] initWithDictionary:attributes];
        [array addObject:candidate];
    }
    
    NSPredicate *prediacte = [NSPredicate predicateWithFormat:
                              @"name CONTAINS[cd] %@",text];
    NSArray *candidates = [array filteredArrayUsingPredicate:prediacte];
    completion(candidates);
}

@end
