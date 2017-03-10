//
//  InspirationViewController.m
//  Colorfy
//
//  Created by Mac729 on 7/9/16.
//  Copyright © 2016 Mac729. All rights reserved.
//

#import "InspirationViewController.h"
#import "InspirationDetailViewController.h"
#import "CFLibrariesCollectionViewCell.h"
#import "MyWorkArtworksTableViewCell.h"
#import "MBProgressHUD.h"

@interface InspirationViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITabBarControllerDelegate>{
    
    IBOutlet UISegmentedControl *segmentInspiration;
    IBOutlet UICollectionView *inspirationCollectionView;
    NSMutableArray *inspirationTrendingArtworks;
    NSMutableArray *inspirationFreshArtworks;
    NSMutableArray *inspirationShowArtworksArray;
    
    IBOutlet UILabel *noArtworkLbl;
}

@end

@implementation InspirationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    noArtworkLbl.hidden = YES;
    inspirationShowArtworksArray = [[NSMutableArray alloc] init];
    inspirationTrendingArtworks = [[NSMutableArray alloc] init];
    inspirationFreshArtworks = [[NSMutableArray alloc] init];

}

- (void) viewWillAppear:(BOOL)animated {
    segmentInspiration.selectedSegmentIndex = 0;
    [self getAllPublicImages];
}

- (IBAction)premiumBtnClick:(id)sender {
    UINavigationController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"navPremium"];
    [self.navigationController presentViewController:panelController animated:YES completion:nil];
}

- (IBAction)decodeBtn:(id)sender {
    if (segmentInspiration.selectedSegmentIndex == 0) {
        inspirationShowArtworksArray = inspirationTrendingArtworks;
        [inspirationCollectionView reloadData];
    }else if(segmentInspiration.selectedSegmentIndex == 1){
        inspirationShowArtworksArray = inspirationFreshArtworks;
        [inspirationCollectionView reloadData];
    }
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [inspirationShowArtworksArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"InspirationCell";
    CFLibrariesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [cell.categoryImageView setFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    cell.cellNumberView.hidden = YES;
//    cell.categoryImageView.image = [UIImage imageNamed:[inspirationShowArtworksArray objectAtIndex:indexPath.item]];
    
    NSDictionary *imageDic = [inspirationShowArtworksArray objectAtIndex:indexPath.row];
    NSString *image_url = [imageDic objectForKey:@"image_url"];
    NSString *imageUrl = [SERVER_IMAGE_URL stringByAppendingString:image_url];
    [commonUtils setImageViewAFNetworking:cell.categoryImageView withImageUrl:imageUrl withPlaceholderImage:nil];
    
    [commonUtils setRoundedRectBorderImage:cell.categoryImageView withBorderWidth:1 withBorderColor:RGBA(30, 114, 200, 1) withBorderRadius:0];
    
    return cell;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self->inspirationCollectionView.collectionViewLayout;
    
    CGFloat availableWidthForCells = CGRectGetWidth(self->inspirationCollectionView.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow - 1);
    CGFloat cellWidth = availableWidthForCells / kCellsPerRow;
    flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
    
    return flowLayout.itemSize;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    appController.selectedImageNum = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    
    InspirationDetailViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"InspirationDetail"];
    panelController.segmentIndex = (int)segmentInspiration.selectedSegmentIndex;
    panelController.allPublicImages = inspirationShowArtworksArray;
    [self.tabBarController.navigationController pushViewController:panelController animated:YES];
}

#pragma mark - custom functions

-(void) getAllPublicImages {
    NSString *userId = [NSString stringWithFormat:@"%d", DEFAULT_USER_ID];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:userId forKey:@"user_id"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[DatabaseController sharedManager] imageAllPublic:userInfo onSuccess:^(id json) {
        NSLog(@"Database Data : %@", json);
        NSDictionary *temp = json;
        if ([[temp objectForKey:@"status"] intValue] == 1) {
            inspirationFreshArtworks = [temp objectForKey:@"public_fresh_images"];
            inspirationTrendingArtworks = [temp objectForKey:@"public_trend_images"];
            inspirationShowArtworksArray = inspirationTrendingArtworks;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (inspirationShowArtworksArray.count == 0) {
                noArtworkLbl.hidden = NO;
            } else {
                [inspirationCollectionView reloadData];
            }
        }
    } onFailure:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [commonUtils showVAlertSimple:@"Connection error" body:@"Please try again later" duration:1.2];
    }];
}

@end
