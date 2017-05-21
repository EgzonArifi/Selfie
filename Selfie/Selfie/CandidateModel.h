//
//  CandidateModel.h
//  Selfie
//
//  Created by Egzon Arifi on 5/21/17.
//  Copyright © 2017 Egzon Arifi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CandidateModel : NSObject

@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSString *name;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+ (void)loadCandidates:(void (^)(NSArray *candidatesArray))completion;
+ (void)searchCandidate:(NSString *)text results:(void (^)(NSArray *candidatesArray))completion;
@end