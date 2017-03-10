//
//  CategoryViewController.m
//  Colorfy
//
//  Created by Mac729 on 6/17/16.
//  Copyright © 2016 Mac729. All rights reserved.
//

#import "CategoryViewController.h"
#import "CFLibrariesCollectionViewCell.h"
#import "DetailCategoryViewController.h"
#import "EditViewController.h"
#import "PremiumPageViewController.h"

@interface CategoryViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate> {
    
    IBOutlet UISegmentedControl *segmentCategory;
    NSArray *categoryImages, *categoryNameArray, *artworkNumArray;
    NSMutableArray *allImages;
    NSMutableArray *artworkImageArray;
    IBOutlet UICollectionView *categoryCollectionView;
}

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    allImages = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    categoryImages = [NSArray arrayWithObjects:@"001.jpg",@"002.jpg",@"003.jpg",@"004.jpg",@"005.jpg",@"006.jpg",@"007.jpg", nil];
    categoryNameArray = [NSArray arrayWithObjects:@"Mandalas", @"Florals", @"Oriental",@"Patterns",@"Messages",@"Animals",@"Scenery",nil];
    artworkImageArray = [[NSMutableArray alloc] init];
    artworkNumArray = [NSArray arrayWithObjects:@"12",@"9",@"6",@"7",@"5",@"7",@"4" ,nil];
    for (int i = 1; i < 51 ; i++) {
        [artworkImageArray addObject:[NSString stringWithFormat:@"%d.jpg", i]];
    }
    allImages = (NSMutableArray *)categoryImages;
}

-(void) viewWillAppear:(BOOL)animated {
    segmentCategory.selectedSegmentIndex = 0;
    allImages = (NSMutableArray *)categoryImages;
    [categoryCollectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIInterfaceOrientationMask) navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation) navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController {
    return UIInterfaceOrientationPortrait;
}

- (IBAction)decodeBtn:(id)sender {
    if (segmentCategory.selectedSegmentIndex == 0) {
        allImages = (NSMutableArray *)categoryImages;
        appController.selectedSegmentItem = 0;
        [categoryCollectionView reloadData];
    }else if(segmentCategory.selectedSegmentIndex == 1){
        allImages = artworkImageArray;
        appController.allImages = allImages;
        appController.selectedSegmentItem = 1;
        [categoryCollectionView reloadData];
    }
}

- (IBAction)premiumBtnClick:(id)sender {
//    PremiumPageViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"premiumPage"];
//    [self.navigationController pushViewController:panelController animated:YES];
    UINavigationController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"navPremium"];
    [self.navigationController presentViewController:panelController animated:YES completion:nil];
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [allImages count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Cell";
    CFLibrariesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [cell.categoryImageView setFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    cell.categoryImageView.image = [UIImage imageNamed:[allImages objectAtIndex:indexPath.item]];
    
    [commonUtils setRoundedRectBorderImage:cell.categoryImageView withBorderWidth:1 withBorderColor:RGBA(30, 114, 200, 1) withBorderRadius:0];
    
    if (segmentCategory.selectedSegmentIndex == 0) {
        cell.artworkNum.hidden = NO;
        cell.categoryName.hidden = NO;
        cell.cellNumberView.hidden = NO;        
        cell.categoryName.text = [categoryNameArray objectAtIndex:indexPath.row];
        cell.artworkNum.text = [NSString stringWithFormat:@"%@ Arts", [artworkNumArray objectAtIndex:indexPath.row]];
    }else{
        if (indexPath.row < 12) {
            cell.artworkNum.text = [categoryNameArray objectAtIndex:0];
        }else if (indexPath.row < 21){
            cell.artworkNum.text = [categoryNameArray objectAtIndex:1];
        }else if (indexPath.row < 27){
            cell.artworkNum.text = [categoryNameArray objectAtIndex:2];
        }else if (indexPath.row < 34){
            cell.artworkNum.text = [categoryNameArray objectAtIndex:3];
        }else if (indexPath.row < 39){
            cell.artworkNum.text = [categoryNameArray objectAtIndex:4];
        }else if (indexPath.row < 46){
            cell.artworkNum.text = [categoryNameArray objectAtIndex:5];
        }else{
            cell.artworkNum.text = [categoryNameArray objectAtIndex:6];
        }
        cell.categoryName.text = @"";
        
        cell.categoryName.hidden = YES;
        cell.artworkNum.hidden = YES;
        cell.cellNumberView.hidden = YES;
    }
    
    return cell;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self->categoryCollectionView.collectionViewLayout;
    
    CGFloat availableWidthForCells = CGRectGetWidth(self->categoryCollectionView.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow - 1);
    CGFloat cellWidth = availableWidthForCells / kCellsPerRow;
    flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
    
    return flowLayout.itemSize; //CGSizeMake(192.f, 192.f);
}


-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *categoryArtworksArray = [[NSMutableArray alloc] init];
    
    if (segmentCategory.selectedSegmentIndex == 0) {
        if (indexPath.row == 0) {
            for (int i = 0; i < 12; i++) {
                [categoryArtworksArray addObject:[NSString stringWithFormat:@"%d.jpg", i+1]];
            }
        }else if (indexPath.row == 1) {
            for (int i = 12; i < 21; i++) {
                [categoryArtworksArray addObject:[NSString stringWithFormat:@"%d.jpg", i+1]];
            }
        }else if (indexPath.row == 2) {
            for (int i = 21; i < 27; i++) {
                [categoryArtworksArray addObject:[NSString stringWithFormat:@"%d.jpg", i+1]];
            }
        }else if (indexPath.row == 3) {
            for (int i = 27; i < 34; i++) {
                [categoryArtworksArray addObject:[NSString stringWithFormat:@"%d.jpg", i+1]];
            }
        }else if (indexPath.row == 4) {
            for (int i = 34; i < 39; i++) {
                [categoryArtworksArray addObject:[NSString stringWithFormat:@"%d.jpg", i+1]];
            }
        }else if (indexPath.row == 5) {
            for (int i = 39; i < 46; i++) {
                [categoryArtworksArray addObject:[NSString stringWithFormat:@"%d.jpg", i+1]];
            }
        }else if (indexPath.row == 6) {
            for (int i = 46; i < 50; i++) {
                [categoryArtworksArray addObject:[NSString stringWithFormat:@"%d.jpg", i+1]];
            }
        }

        int imageNumberSum = 0;
        if (indexPath.row > 0) {
            for (int i = 0; i < indexPath.row; i++) {
                imageNumberSum = imageNumberSum + (int)[[artworkNumArray objectAtIndex:i] integerValue];
            }
        }
        
        DetailCategoryViewController *panelController1 = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailCategoryViewController"];
        panelController1.selectedCategoryIndex = (int)indexPath.row;
        panelController1.previousImageNumSum = imageNumberSum;
        panelController1.selectedCategoryImages = categoryArtworksArray;
        panelController1.selectedCategoryName = [categoryNameArray objectAtIndex:indexPath.row];

        UINavigationController *panelController = [[UINavigationController alloc] initWithRootViewController:panelController1];
        panelController.navigationBar.hidden = YES;
        [self.navigationController presentViewController:panelController animated:YES completion:nil];
    }else {
        EditViewController *panelController1 = [self.storyboard instantiateViewControllerWithIdentifier:@"EditViewController"];
        panelController1.selectedImageNumber = (int)indexPath.row + 1;
        
        UINavigationController *panelController = [[UINavigationController alloc] initWithRootViewController:panelController1];
        panelController.navigationBar.hidden = YES;
        [self.navigationController presentViewController:panelController animated:YES completion:nil];
    }
}

@end
