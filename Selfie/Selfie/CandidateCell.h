//
//  CandidateCell.h
//  Selfie
//
//  Created by Egzon Arifi on 5/20/17.
//  Copyright © 2017 Egzon Arifi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CandidateModel.h"

@interface CandidateCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *candidateImage;
@property (weak, nonatomic) IBOutlet UILabel *candidateNumber;
@property (weak, nonatomic) IBOutlet UILabel *candidateName;
- (void)configureCell:(CandidateModel *)candidate;
@end
