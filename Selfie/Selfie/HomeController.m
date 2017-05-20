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
#import "CSStickyHeaderFlowLayout.h"

@interface HomeController ()
@property (strong, nonatomic) NSArray *candidates;
@property (nonatomic, strong) UINib *headerNib;
@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
    [self reloadLayout];
    // Also insets the scroll indicator so it appears below the search bar
   // self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, 0);
    
    [self.collectionView registerNib:self.headerNib
          forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
                 withReuseIdentifier:@"header"];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.candidates = @[@"isa_mustafa",@"avdulla.hoti",@"isa_mustafa",@"avdulla.hoti",@"isa_mustafa",@"avdulla.hoti",@"isa_mustafa",@"avdulla.hoti",@"isa_mustafa",@"avdulla.hoti"];
        self.headerNib = [UINib nibWithNibName:@"CSGrowHeader" bundle:nil];
    }
    return self;
}
- (IBAction)goToStickerCamera:(id)sender {
    [self.navigationController presentViewController:[[YCameraViewController alloc] init]
                                            animated:YES
                                          completion:nil];
}

#pragma mark - CollectionView Delegate and Datasource
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self reloadLayout];
}

- (void)reloadLayout {
    CSStickyHeaderFlowLayout *layout = (id)self.collectionViewLayout;
    
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, 200);
        layout.itemSize = CGSizeMake(self.view.frame.size.width, layout.itemSize.height);
        // If we want to disable the sticky header effect
        layout.disableStickyHeaders = NO;
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.candidates.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CandidateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CandidateCell"
                                                                  forIndexPath:indexPath];
    [cell.candidateImage setImage:[UIImage imageNamed:self.candidates[indexPath.row]]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
 
    if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:@"header"
                                                                                   forIndexPath:indexPath];
        
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.collectionView.frame.size.width/2.2, self.collectionView.frame.size.width/2.2);
}
@end
