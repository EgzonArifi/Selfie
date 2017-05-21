//
//  CandidateModel.h
//  Selfie
//
//  Created by Egzon Arifi on 5/21/17.
//  Copyright © 2017 Egzon Arifi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CandidateModel : NSObject

@property (nonatomic, assign) NSString *number;
@property (nonatomic, strong) NSArray * images;
@property (nonatomic, strong) NSString * name;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+ (void)loadCandidates:(void (^)(NSArray *candidatesArray))completion;

@end