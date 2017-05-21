//
//  JsonLoader.m
//  Selfie
//
//  Created by Egzon Arifi on 5/21/17.
//  Copyright © 2017 Egzon Arifi. All rights reserved.
//

#import "JsonLoader.h"

@implementation JsonLoader

+ (NSDictionary *_Nonnull)loadJsonFromFile:( NSString * _Nonnull )fileName {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", fileName]
                                                         ofType:@"json"];
    NSData *JSONData = [NSData dataWithContentsOfFile:filePath
                                              options:NSDataReadingMappedIfSafe
                                                error:nil];
    NSDictionary *jsonObject =
    [NSJSONSerialization JSONObjectWithData:JSONData
                                    options:NSJSONReadingMutableContainers
                                      error:nil];
    return jsonObject;
}

@end
