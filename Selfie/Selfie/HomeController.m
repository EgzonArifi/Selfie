//
//  HomeController.m
//  Selfie
//
//  Created by Egzon Arifi on 5/20/17.
//  Copyright © 2017 Egzon Arifi. All rights reserved.
//

#import "HomeController.h"
#import "YCameraViewController.h"
#import "CandidateCell.h"
#import "SliderCell.h"

@interface HomeController ()
@property (strong, nonatomic) NSArray *candidates;
@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.candidates = @[@"isa_mustafa",@"avdulla.hoti",@"isa_mustafa",@"avdulla.hoti",@"isa_mustafa",@"avdulla.hoti",@"isa_mustafa",@"avdulla.hoti",@"isa_mustafa",@"avdulla.hoti"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SliderCell" bundle:nil] forCellWithReuseIdentifier:@"SliderCell"];
    
}
- (IBAction)goToStickerCamera:(id)sender {
    [self.navigationController presentViewController:[[YCameraViewController alloc] init]
                                            animated:YES
                                          completion:nil];
}

#pragma mark - CollectionView Delegate and Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.candidates.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SliderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SliderCell"
                                                                     forIndexPath:indexPath];
//        [cell loadSlider];
        return cell;
    } else {
        CandidateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CandidateCell"
                                                                        forIndexPath:indexPath];
        [cell.candidateImage setImage:[UIImage imageNamed:self.candidates[indexPath.row]]];
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    /*if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
     SliderCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
     withReuseIdentifier:@"SliderCell"
     forIndexPath:indexPath];
     [cell loadSlider];
     return cell;
     }*/
    return nil;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(5, 2.5, 5, 2.5);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.width/1.5);
    }
    return CGSizeMake(self.collectionView.frame.size.width/2.1, self.collectionView.frame.size.width/2.1);
}
@end
