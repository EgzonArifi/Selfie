//
//  SliderCell.m
//  Selfie
//
//  Created by Egzon Arifi on 5/21/17.
//  Copyright © 2017 Egzon Arifi. All rights reserved.
//

#import "SliderCell.h"
#import "SDCycleScrollView.h"

@interface SliderCell()<SDCycleScrollViewDelegate>

@end

@implementation SliderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
    
    NSArray *imageNames = @[@"Slide1",
                            @"Slide1",
                            @"Slide1",
                            @"Slide1."
                            ];
    CGFloat w = self.contentView.bounds.size.width;
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, w, w/1.5)
                                                                  shouldInfiniteLoop:YES imageNamesGroup:imageNames];
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    cycleScrollView.autoScrollTimeInterval = 4.0;
    [self.contentView addSubview:cycleScrollView];
}

@end
