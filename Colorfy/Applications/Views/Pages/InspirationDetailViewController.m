 //
//  InspirationDetailViewController.m
//  Colorfy
//
//  Created by Mac729 on 7/9/16.
//  Copyright © 2016 Mac729. All rights reserved.
//

#import "InspirationDetailViewController.h"
#import "MyWorkArtworksTableViewCell.h"
#import "MyWorksTransViewController.h"
#import "CommentViewController.h"

@interface InspirationDetailViewController ()<UITableViewDataSource, UITableViewDelegate>{
    
    IBOutlet UITableView *inspirationDetailTableView;
    IBOutlet UILabel *inspirationTypeLbl;
    
    NSDictionary *tempFB;
    MBProgressHUD *progressHUD;
    NSMutableArray *inspirationTrendingArtworks;
    NSMutableArray *inspirationFreshArtworks;
    NSMutableArray *inspirationShowArtworksArray;
}

@end

@implementation InspirationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.segmentIndex == 0) {
        inspirationTypeLbl.text = @"TRENDING";
    } else {
        inspirationTypeLbl.text = @"FRESH";
    }
    
    progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    progressHUD.dimBackground = YES;
    [self.view addSubview:progressHUD];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    [self getAllPublicImages];
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource, Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableview numberOfRowsInSection:(NSInteger)section{
    return [self.allPublicImages count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        return 360;
    } else {
        return 500;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyWorkArtworksTableViewCell *cell = (MyWorkArtworksTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MyWorksArtworkCell"];
    [commonUtils setRoundedRectBorderImage:cell.artworkImageView withBorderWidth:1 withBorderColor:RGBA(30, 114, 200, 1) withBorderRadius:0];
    
    NSLog(@"total array : %@", self.allPublicImages);
    
    NSDictionary *imageDic = [self.allPublicImages objectAtIndex:indexPath.row];
    cell.artworkUserName.text = [imageDic objectForKey:@"user_name"];
    
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
    } else {
        cell.favorite_count_lbl.text = @"";
    }
    
    if (![commentCount isEqualToString:@"0"]) {
        cell.comment_count_lbl.text = commentCount;
    } else {
        cell.comment_count_lbl.text = @"";
    }
    
    NSMutableArray *arrCommentInfo = [[NSMutableArray alloc] init];
    arrCommentInfo = [imageDic objectForKey:@"comment_info"];
    if (arrCommentInfo.count == 0) {
//        cell.commentGroupView.hidden = YES;
        cell.notationUserName1.text = @"";
        cell.notationLbl1.text = @"";
        cell.notationUserName2.text = @"";
        cell.notationLbl2.text = @"";
    } else {
        if (arrCommentInfo.count == 1) {
            NSDictionary *commentDic = [arrCommentInfo objectAtIndex:0];
            NSString *user_name = [commentDic objectForKey:@"comment_user_name"];
            NSString *description = [commentDic objectForKey:@"comment_description"];
            cell.notationUserName1.text = user_name;
            cell.notationLbl1.text = description;
            cell.notationUserName2.text = @"";
            cell.notationLbl2.text = @"";
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

-(void) favoriteBtnTap : (UIButton *) sender {
    NSString *current_user_id = [[commonUtils getUserDefaultDicByKey:@"RegisteredUser"] objectForKey:@"user_id"];
    
    if (current_user_id == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"COMMENTS" message:@"Will you login to FACEBOOK to continue on this artwork" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction   * _Nonnull action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [progressHUD show:YES];
                [appController facebookLogin:self progressView:progressHUD];
                if (appController.currentUserId != nil) {
                    [progressHUD hide:YES];
                    MyWorkArtworksTableViewCell *cell = (MyWorkArtworksTableViewCell *)sender.superview.superview;
                    NSDictionary *imageDic = [self.allPublicImages objectAtIndex:sender.tag];
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
                        cell.favorite_count_lbl.text = [NSString stringWithFormat:@"%d", favorite_count];
                    }
                    
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
                            if ([inspirationTypeLbl.text isEqualToString:@"TRENDING"]) {
                                self.allPublicImages = [temp objectForKey:@"public_trend_images"];
                            } else if ([inspirationTypeLbl.text isEqualToString:@"FRESH"]){
                                self.allPublicImages = [temp objectForKey:@"public_fresh_images"];
                            }
                            [inspirationDetailTableView reloadData];
                        }
                    } onFailure:^(id json) {
                        NSLog(@"Database Data1 : %@", json);
                    }];
                }
            });
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction   * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        MyWorkArtworksTableViewCell *cell = (MyWorkArtworksTableViewCell *)sender.superview.superview;
        NSDictionary *imageDic = [self.allPublicImages objectAtIndex:sender.tag];
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
            cell.favorite_count_lbl.text = [NSString stringWithFormat:@"%d", favorite_count];
        }
        
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
                if ([inspirationTypeLbl.text isEqualToString:@"TRENDING"]) {
                    self.allPublicImages = [temp objectForKey:@"public_trend_images"];
                } else if ([inspirationTypeLbl.text isEqualToString:@"FRESH"]){
                    self.allPublicImages = [temp objectForKey:@"public_fresh_images"];
                }
                [inspirationDetailTableView reloadData];
            }
        } onFailure:^(id json) {
            NSLog(@"Database Data1 : %@", json);
        }];
    }
}

-(void) commentBtnTap : (UIButton *) sender {
    NSString *current_user_id = [[commonUtils getUserDefaultDicByKey:@"RegisteredUser"] objectForKey:@"user_id"];
    NSString *image_id = [[self.allPublicImages objectAtIndex: sender.tag] objectForKey:@"image_id"];
    if (current_user_id == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"COMMENTS" message:@"Will you login to FACEBOOK to continue on this artwork" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction   * _Nonnull action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [progressHUD show:YES];
                [appController facebookLogin:self progressView:progressHUD];
                if (appController.currentUserId != nil) {
                    [progressHUD hide:YES];
                    CommentViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"CommentView"];
                    panelController.imageId = image_id;
                    [self.navigationController presentViewController:panelController animated:YES completion:nil];
                }
                
            });
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction   * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        
        NSString *current_user_name = [[commonUtils getUserDefaultDicByKey:@"RegisteredUser"] objectForKey:@"user_name"];
        NSDictionary *imageDic = [self.allPublicImages objectAtIndex:sender.tag];
        NSString *image_user_name = [imageDic objectForKey:@"user_name"];
        if ([current_user_name isEqualToString: image_user_name]) {
            [commonUtils showVAlertSimple:@"" body:@"You can't give commit to your artwork" duration:1.2];
        } else {
            NSMutableArray *arrComment = [imageDic objectForKey:@"comment_info"];
            if (arrComment.count == 0) {
                CommentViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"CommentView"];
                panelController.imageId = image_id;
                [self.navigationController presentViewController:panelController animated:YES completion:nil];
            } else {
                int comment_user_flag = 0;
                for (int i = 0 ; i < arrComment.count; i++) {
                    NSString *comment_user_name = [[[imageDic objectForKey:@"comment_info"] objectAtIndex:i] objectForKey:@"comment_user_name"];
                    if ([current_user_name isEqualToString:comment_user_name]) {
                        [commonUtils showVAlertSimple:@"" body:@"You already commented to this artwork" duration:1.2];
                        comment_user_flag = 1;
                        break;
                    }
                }
                if (comment_user_flag == 0) {
                    CommentViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"CommentView"];
                    panelController.imageId = image_id;
                    [self.navigationController presentViewController:panelController animated:YES completion:nil];
                }
            }
        }
    }
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
            
            if ([inspirationTypeLbl.text isEqualToString:@"TRENDING"]) {
                self.allPublicImages = [temp objectForKey:@"public_trend_images"];
            } else if ([inspirationTypeLbl.text isEqualToString:@"FRESH"]){
                self.allPublicImages = [temp objectForKey:@"public_fresh_images"];
            }
            [inspirationDetailTableView reloadData];            
        }
    } onFailure:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [commonUtils showVAlertSimple:@"Connection error" body:@"Please try again later" duration:1.2];
    }];
}

@end
