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
#import "CandidateModel.h"
#import "SearchController.h"

@interface HomeController ()

@property (strong, nonatomic) NSArray *candidates;

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.search setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.search.bounds.size.height)];
    
    [CandidateModel loadCandidates:^(NSArray *candidatesArray) {
        self.candidates = candidatesArray;
    }];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SliderCell" bundle:nil] forCellWithReuseIdentifier:@"SliderCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CandidateCell" bundle:nil] forCellWithReuseIdentifier:@"CandidateCell"];
}
- (IBAction)goToStickerCamera:(id)sender {
    [self.navigationController presentViewController:[[YCameraViewController alloc] init]
                                            animated:YES
                                          completion:nil];
}
- (IBAction)goToSearch:(id)sender {
    UINavigationController *navigationController =
    (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"searchNavigation"];
    
    [self presentViewController:navigationController
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
        [cell layoutCell];
        return cell;
    } else {
        CandidateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CandidateCell"
                                                                        forIndexPath:indexPath];
        [cell configureCell:self.candidates[indexPath.row]];
        return cell;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(5, 2.5, 5, 2.5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YCameraViewController *camera = [[YCameraViewController alloc] init];
    camera.candidateModel = self.candidates[indexPath.row];
    [self.navigationController presentViewController:camera
                                            animated:YES
                                          completion:nil];
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
