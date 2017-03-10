//
//  DetailCategoryViewController.m
//  Colorfy
//
//  Created by Mac729 on 6/23/16.
//  Copyright © 2016 Mac729. All rights reserved.
//

#import "DetailCategoryViewController.h"
#import "DetailCategoryCell.h"
#import "EditViewController.h"

@interface DetailCategoryViewController() <UITableViewDataSource, UITableViewDelegate>

@end

@implementation DetailCategoryViewController{
    
    IBOutlet UILabel *categoryNameLbl;
    IBOutlet UILabel *artworkNumLbl;    
    IBOutlet UITableView *tableViewOutput;
    NSMutableArray *categoryImageArray;
    IBOutlet UIView *tableLayoutView;
}

-(void) viewDidLoad{
    [super viewDidLoad];
    tableViewOutput.separatorStyle = UITableViewCellSeparatorStyleNone;
    categoryImageArray = [[NSMutableArray alloc] init];
    categoryImageArray = self.selectedCategoryImages;
    categoryNameLbl.text = self.selectedCategoryName;
    artworkNumLbl.text = [NSString stringWithFormat:@"%ld Artworks", (unsigned long)[self.selectedCategoryImages count]];
}

- (IBAction)backBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource, Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableview numberOfRowsInSection:(NSInteger)section{
    return [categoryImageArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        return 300;
    } else {
        return 500;
    }    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailCategoryCell *cell = (DetailCategoryCell *)[tableView dequeueReusableCellWithIdentifier:@"DetailCategoryCell" forIndexPath:indexPath];
    [commonUtils setRoundedRectBorderImage:cell.categoryImageView withBorderWidth:1 withBorderColor:RGBA(30, 114, 200, 1) withBorderRadius:0];
    NSString *categoryImage = [categoryImageArray objectAtIndex:indexPath.row];
    cell.categoryImageView.image = [UIImage imageNamed:categoryImage];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EditViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditViewController"];
    panelController.selectedImageNumber = self.previousImageNumSum + (int)indexPath.row + 1;
    [self.navigationController pushViewController:panelController animated:YES];
}

@end
