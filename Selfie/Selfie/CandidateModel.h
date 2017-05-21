//
//  CandidateModel.h
//  Selfie
//
//  Created by Egzon Arifi on 5/21/17.
//  Copyright © 2017 Egzon Arifi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CandidateModel : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSArray * images;
@property (nonatomic, strong) NSString * name;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end