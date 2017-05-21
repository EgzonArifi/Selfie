//
//  JsonLoader.h
//  Selfie
//
//  Created by Egzon Arifi on 5/21/17.
//  Copyright © 2017 Egzon Arifi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonLoader : NSObject

+ (NSDictionary *_Nonnull)loadJsonFromFile:( NSString * _Nonnull )fileName;

@end
