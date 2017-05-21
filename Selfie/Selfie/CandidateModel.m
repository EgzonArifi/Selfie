//
//  CandidateModel.m
//  Selfie
//
//  Created by Egzon Arifi on 5/21/17.
//  Copyright © 2017 Egzon Arifi. All rights reserved.
//

#import "CandidateModel.h"

NSString *const kCandidateModelIdField = @"id";
NSString *const kCandidateModelImages = @"images";
NSString *const kCandidateModelName = @"name";

@interface CandidateModel ()
@end

@implementation CandidateModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (![dictionary[kCandidateModelIdField] isKindOfClass:[NSNull class]] ){
        self.idField = [dictionary[kCandidateModelIdField] integerValue];
    }
    
    if (![dictionary[kCandidateModelImages] isKindOfClass:[NSNull class]]) {
        self.images = dictionary[kCandidateModelImages];
    }
    if (![dictionary[kCandidateModelName] isKindOfClass:[NSNull class]]) {
        self.name = dictionary[kCandidateModelName];
    }
    return self;
}

@end