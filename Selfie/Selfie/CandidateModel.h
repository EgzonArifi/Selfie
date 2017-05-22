//
//  CandidateModel.h
//  Selfie
//
//  Created by Egzon Arifi on 5/21/17.
//  Copyright © 2017 Egzon Arifi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LdkBackColor [UIColor colorWithRed:28.0/255.0 green:42.6/255.0 blue:108.6/255.0 alpha:1.0]
#define AkrBackColor [UIColor colorWithRed:219.6/255.0 green:0.0/255.0 blue:40.0/255.0 alpha:1.0]
#define AlternativaBackColor [UIColor colorWithRed:208.0/255.0 green:161.0/255.0 blue:83.0/255.0 alpha:1.0]

#define LdkFrame @"ldk_frame"
#define AkrFrame @"akr_frame"
#define AlternativaFrame @"alternativa_frame"

@interface CandidateModel : NSObject

@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSUInteger type;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (NSString *)getFrame;
+ (void)loadCandidates:(void (^)(NSArray *candidatesArray))completion;
+ (void)searchCandidate:(NSString *)text results:(void (^)(NSArray *candidatesArray))completion;

typedef enum : NSUInteger {
    LDK = 1,
    AKR,
    Alternativa
} Subject;
@end
