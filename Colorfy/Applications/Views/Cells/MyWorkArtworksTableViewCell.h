//
//  MyWorkArtworksTableViewCell.h
//  Colorfy
//
//  Created by Mac729 on 7/7/16.
//  Copyright © 2016 Mac729. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWorkArtworksTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *artworkUserName;
@property (strong, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (strong, nonatomic) IBOutlet UILabel *notationUserName1;
@property (strong, nonatomic) IBOutlet UILabel *notationUserName2;
@property (strong, nonatomic) IBOutlet UILabel *notationLbl1;
@property (strong, nonatomic) IBOutlet UILabel *notationLbl2;
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UILabel *favorite_count_lbl;
@property (weak, nonatomic) IBOutlet UILabel *comment_count_lbl;
@property (weak, nonatomic) IBOutlet UIView *commentGroupView;

@end
