//
//  CandidateCell.m
//  Selfie
//
//  Created by Egzon Arifi on 5/20/17.
//  Copyright © 2017 Egzon Arifi. All rights reserved.
//

#import "CandidateCell.h"

@implementation CandidateCell

- (void)configureCell:(CandidateModel *)candidate {
    [self.candidateImage setImage:[UIImage imageNamed:candidate.images.firstObject]];
    self.candidateName.text = candidate.name;
    self.candidateNumber.text = candidate.number;
}

@end
