//
//  MyWorksViewController.m
//  Colorfy
//
//  Created by Mac729 on 7/4/16.
//  Copyright © 2016 Mac729. All rights reserved.
//

#import "MyWorksViewController.h"
#import "CFLibrariesCollectionViewCell.h"
#import "MyWorkArtworksTableViewCell.h"
#import "MyWorksTransViewController.h"
#import "EditViewController.h"
#import "MBProgressHUD.h"

@interface MyWorksViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate>{
    
    IBOutlet UISegmentedControl *segmentMyWorks;
    IBOutlet UICollectionView *myOwnWorkCollectionView;
    IBOutlet UITableView *myPublicWorkTableView;
    NSMutableArray *myOwnWorkArtworks;
    NSMutableArray *myPublicWorkArtworks;
    
    NSDictionary *tempFB;
    IBOutlet UILabel *noArtworksLbl;
}

@end

@implementation MyWorksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    myOwnWorkCollectionView.hidden = NO;
    myPublicWorkTableView.hidden = YES;
    noArtworksLbl.hidden = YES;
}

-(void) viewWillAppear:(BOOL)animated {
    segmentMyWorks.selectedSegmentIndex = 0;
    
    if ([[commonUtils getUserDefaultDicByKey:@"RegisteredUser"] objectForKey:@"user_id"]) {
        [self getMyImages];
    } else {
        noArtworksLbl.hidden = NO;
        myOwnWorkCollectionView.hidden = YES;
        myPublicWorkTableView.hidden = YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)premiumBtnClick:(id)sender {
    UINavigationController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"navPremium"];
    [self.navigationController presentViewController:panelController animated:YES completion:nil];
}

- (IBAction)decodeBtn:(id)sender {
    if (segmentMyWorks.selectedSegmentIndex == 0) {
        myOwnWorkCollectionView.hidden = NO;
        myPublicWorkTableView.hidden = YES;
    }else if(segmentMyWorks.selectedSegmentIndex == 1){
        myOwnWorkCollectionView.hidden = YES;
        myPublicWorkTableView.hidden = NO;
        if (![[commonUtils getUserDefaultDicByKey:@"RegisteredUser"] objectForKey:@"user_id"])
            myPublicWorkTableView.hidden = YES;
    }
    if ([[commonUtils getUserDefaultDicByKey:@"RegisteredUser"] objectForKey:@"user_id"]) {
        [self getMyImages];
    }    
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [myOwnWorkArtworks count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"MyWorksCell";
    CFLibrariesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [cell.categoryImageView setFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    cell.cellNumberView.hidden = YES;
    NSDictionary *imageDic = [myOwnWorkArtworks objectAtIndex:indexPath.row];
    NSString *image_url = [imageDic objectForKey:@"image_url"];
    NSString *imageUrl = [SERVER_IMAGE_URL stringByAppendingString:image_url];
    [commonUtils setImageViewAFNetworking:cell.categoryImageView withImageUrl:imageUrl withPlaceholderImage:nil];
    
//    cell.categoryImageView.image = [UIImage imageNamed:[myOwnWorkArtworks objectAtIndex:indexPath.item]];
    
    [commonUtils setRoundedRectBorderImage:cell.categoryImageView withBorderWidth:1 withBorderColor:RGBA(30, 114, 200, 1) withBorderRadius:0];
    
    return cell;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self->myOwnWorkCollectionView.collectionViewLayout;
    
    CGFloat availableWidthForCells = CGRectGetWidth(self->myOwnWorkCollectionView.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow - 1);
    CGFloat cellWidth = availableWidthForCells / kCellsPerRow;
    flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
    
    return flowLayout.itemSize; //CGSizeMake(192.f, 192.f);
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *imageDic = [myOwnWorkArtworks objectAtIndex:indexPath.row];
    NSString *image_url = [imageDic objectForKey:@"image_url"];
    NSString *imageUrl = [SERVER_IMAGE_URL stringByAppendingString:image_url];
    NSURL *url = [NSURL URLWithString:imageUrl];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imageData];
    EditViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditViewController"];
    panelController.imgFinalImage = image;
    panelController.fromMyWorkFlag = 1;
    
    UINavigationController *panelController1 = [[UINavigationController alloc] initWithRootViewController:panelController];
    panelController1.navigationBar.hidden = YES;
    [self.navigationController presentViewController:panelController1 animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource, Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableview numberOfRowsInSection:(NSInteger)section{
    return [myPublicWorkArtworks count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 360;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyWorkArtworksTableViewCell *cell = (MyWorkArtworksTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MyWorksArtworkCell"];
    [commonUtils setRoundedRectBorderImage:cell.artworkImageView withBorderWidth:1 withBorderColor:RGBA(30, 114, 200, 1) withBorderRadius:0];
    NSDictionary *imageDic = [myPublicWorkArtworks objectAtIndex:indexPath.row];
    NSString *image_url = [imageDic objectForKey:@"image_url"];
    NSString *imageUrl = [SERVER_IMAGE_URL stringByAppendingString:image_url];
    [commonUtils setImageViewAFNetworking:cell.artworkImageView withImageUrl:imageUrl withPlaceholderImage:nil];
    NSString *favoriteCount = [imageDic objectForKey:@"image_favorite_count"];
    NSString *commentCount = [imageDic objectForKey:@"image_comment_count"];
    NSString *favoriteStatus = [imageDic objectForKey:@"image_favorite_status"];
    
    if ([favoriteStatus isEqualToString:@"0"]) {
        UIImage *backgroundImage = [UIImage imageNamed:@"hardImage_trans.png"];
        [cell.favoriteBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    } else {
        UIImage *backgroundImage = [UIImage imageNamed:@"hardImage_red.png"];
        [cell.favoriteBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    }
    
    if (![favoriteCount isEqualToString:@"0"]) {
        cell.favorite_count_lbl.text = favoriteCount;
    }
    
    if (![commentCount isEqualToString:@"0"]) {
        cell.comment_count_lbl.text = commentCount;
    }
    
    NSMutableArray *arrCommentInfo = [[NSMutableArray alloc] init];
    arrCommentInfo = [imageDic objectForKey:@"comment_info"];
    if (arrCommentInfo.count == 0) {
        cell.commentGroupView.hidden = YES;
    } else {
        if (arrCommentInfo.count == 1) {
            NSDictionary *commentDic = [arrCommentInfo objectAtIndex:0];
            NSString *user_name = [commentDic objectForKey:@"comment_user_name"];
            NSString *description = [commentDic objectForKey:@"comment_description"];
            cell.notationUserName1.text = user_name;
            cell.notationLbl1.text = description;
            cell.notationUserName2.hidden = YES;
            cell.notationLbl2.hidden = YES;
        } else {
            for (int i = 0; i < arrCommentInfo.count ; i++) {
                NSDictionary *commentDic = [arrCommentInfo objectAtIndex:i];
                NSString *user_name = [commentDic objectForKey:@"comment_user_name"];
                NSString *description = [commentDic objectForKey:@"comment_description"];
            
                if (i == 0) {
                    cell.notationUserName1.text = user_name;
                    cell.notationLbl1.text = description;
                } else {
                    cell.notationUserName2.text = user_name;
                    cell.notationLbl2.text = description;
                }
            }
        }
    }
    cell.favoriteBtn.tag = indexPath.row;
    [cell.favoriteBtn addTarget:self action:@selector(favoriteBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.commentBtn.tag = indexPath.row;
    [cell.commentBtn addTarget:self action:@selector(commentBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void) getMyImages {
    NSString *current_user_id = [[commonUtils getUserDefaultDicByKey:@"RegisteredUser"] objectForKey:@"user_id"];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:current_user_id forKey:@"user_id"];
    if (segmentMyWorks.selectedSegmentIndex == 0){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[DatabaseController sharedManager] imageOwn:userInfo onSuccess:^(id json) {
            NSLog(@"Database Data : %@", json);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *temp = json;
            if ([[temp objectForKey:@"status"] intValue] == 1) {
                myOwnWorkArtworks = [temp objectForKey:@"own_images"];
                [myOwnWorkCollectionView reloadData];
            } else {
                
            }
        } onFailure:^(id json) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [commonUtils showVAlertSimple:@"Connection error" body:@"Please try again later" duration:1.2];
        }];
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[DatabaseController sharedManager] imagePublic:userInfo onSuccess:^(id json) {
            NSLog(@"Database Data : %@", json);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *temp = json;
            if ([[temp objectForKey:@"status"] intValue] == 1) {
                myPublicWorkArtworks = [temp objectForKey:@"public_images"];
                [myPublicWorkTableView reloadData];
            } else {
                
            }
        } onFailure:^(id json) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [commonUtils showVAlertSimple:@"Connection error" body:@"Please try again later" duration:1.2];
        }];
    }
}

-(void) favoriteBtnTap : (UIButton *) sender {
    MyWorkArtworksTableViewCell *cell = (MyWorkArtworksTableViewCell *)sender.superview.superview;
    NSDictionary *imageDic = [myPublicWorkArtworks objectAtIndex:sender.tag];
    NSString *favoriteCount = [imageDic objectForKey:@"image_favorite_count"];
    NSString *favoriteStatus = [imageDic objectForKey:@"image_favorite_status"];
    
    if ([favoriteStatus intValue] == 0) {
        UIImage *image = [UIImage imageNamed:@"hardImage_red.png"];
        [sender setBackgroundImage:image forState:UIControlStateNormal];
        int favorite_count = [favoriteCount intValue] + 1;
        cell.favorite_count_lbl.text = [NSString stringWithFormat:@"%d", favorite_count];
    } else {
        UIImage *image = [UIImage imageNamed:@"hardImage_trans.png"];
        [sender setBackgroundImage:image forState:UIControlStateNormal];
        int favorite_count = [favoriteCount intValue] - 1;
        if (favorite_count == 0) {
            cell.favorite_count_lbl.text = @"";
        } else {
            cell.favorite_count_lbl.text = [NSString stringWithFormat:@"%d", favorite_count];
        }
    }
    
    NSString *current_user_id = [[commonUtils getUserDefaultDicByKey:@"RegisteredUser"] objectForKey:@"user_id"];
    NSString *image_id = [imageDic objectForKey:@"image_id"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:current_user_id forKey:@"user_id"];
    [parameters setObject:image_id forKey:@"image_id"];
    [commonUtils showActivityIndicator:self.view];
    [[DatabaseController sharedManager] imageFavorite:parameters onSuccess:^(id json) {
        NSLog(@"Database Data : %@", json);
        [commonUtils hideActivityIndicator];
        NSDictionary *temp = json;
        NSString *status = [temp objectForKey:@"status"];
        if ([status intValue] == 1) {
            myPublicWorkArtworks = [temp objectForKey:@"public_images"];
            [myPublicWorkTableView reloadData];
        }
    } onFailure:^(id json) {
        NSLog(@"Database Data1 : %@", json);
    }];
}

-(void) commentBtnTap : (UIButton *) sender {
    [commonUtils showVAlertSimple:@"" body:@"You can't give commit to your artworks" duration:1.2];
}

//- (void) showTransView:(UIButton *) sender {
//    
//    if ([[commonUtils getUserDefaultDicByKey:@"RegisteredUser"] objectForKey:@"email"]) {
//        MyWorksTransViewController *TransView = [self.storyboard instantiateViewControllerWithIdentifier:@"TransView"];
//        //    [commonUtils fnShowModalTransparent:self :TransView];
//        
//        TransView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        TransView.modalPresentationStyle = UIModalPresentationOverFullScreen;
//        //TransView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//        
//        [self presentViewController:TransView animated:YES completion:nil];
//    } else {
//        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//        
//        [login logInWithReadPermissions: @[@"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//            if (error) {
//                NSLog(@"Process error");
//            } else if (result.isCancelled) {
//                NSLog(@"Cancelled");
//            } else {
//                NSLog(@"Logged in with token : @%@", result.token);
//                if ([result.grantedPermissions containsObject:@"email"]) {
//                    [self fetchUserFacebookInfo];
//                }
//            }
//        }];
//    }
//}

@end
