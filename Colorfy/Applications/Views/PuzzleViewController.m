//
//  PuzzleViewController.m
//  Colorfy
//
//  Created by Mac729 on 7/10/16.
//  Copyright © 2016 Mac729. All rights reserved.
//

#import "PuzzleViewController.h"
#import "CFLibrariesCollectionViewCell.h"
#import "MyWorksViewController.h"
#import "PuzzelcollectionViewCell.h"
#import "CustomImageView.h"

@interface PuzzleViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    
    IBOutlet UISegmentedControl *segmentPuzzle;
    IBOutlet UICollectionView *puzzleCollectionView;
    NSArray *puzzleArtworksArray;
    IBOutlet UIView *emptyView;
    double tileWidth;
    double tileHeight;
    UIPanGestureRecognizer *panView;
    UITapGestureRecognizer *tapView;
}

@end

@implementation PuzzleViewController

@synthesize puzzleArray;
@synthesize imgViewArray;
@synthesize imgShare;

-(void)initPuzzle:(int)num imagePath:(NSString *)imagePath
{
    UIImageView *tileImageView;
//    for ( tileImageView in imgViewArray) {
//        [tileImageView removeFromSuperview];
//    }
    NSArray *removeViews=[uiView subviews];
    for (tileImageView in removeViews) {
        [tileImageView removeFromSuperview];
    }
    if (imgShare == NULL) {
        imgShare=[UIImage imageNamed:@"1.jpg" ];
    }
     tileImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, uiView.frame.size.width, uiView.frame.size.height)];
    [tileImageView setImage:imgShare];
    [tileImageView setAlpha:0.5];
    [uiView addSubview:tileImageView];
    [self.puzzleArray removeAllObjects];
    [self.imgViewArray removeAllObjects];
    UIImage *orgImage=imgShare;
    int ratio=orgImage.size.width/uiView.frame.size.width;
    tileWidth=uiView.frame.size.width/num;
    tileHeight=uiView.frame.size.height/num;
    
    for (int x=0; x<num; x++) {
        for (int y=0; y<num; y++) {
            
            CGPoint orgPosition=CGPointMake(x,y);
            
            CGRect frame=CGRectMake(orgImage.size.width/num*x, orgImage.size.height/num*y, orgImage.size.width/num, orgImage.size.height/num);
            CGImageRef tileImageRef=CGImageCreateWithImageInRect(orgImage.CGImage, frame);
            UIImage *tileImage=[UIImage imageWithCGImage:tileImageRef];
            
            tileImageView=[[UIImageView alloc] initWithImage:tileImage];
            int toX=(tileWidth*(num-1)+1);
            int toY=(tileHeight*(num-1)+1);
            int xPos=arc4random() % toX;
            int yPos=arc4random() % toY;
            
            
       //     tileImageView.frame=CGRectMake(xPos, yPos, tileWidth, tileHeight);
            tileImageView.frame=CGRectMake(tileWidth*x, tileHeight*y, tileWidth, tileHeight);
            CGImageRelease(tileImageRef);
            [puzzleArray addObject:tileImage];
            [imgViewArray addObject:tileImageView];
            
            
        }
        
    }
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    puzzleArtworksArray = [NSArray arrayWithObjects:@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", nil];
  //  [imageView setImage:[UIImage imageNamed:@"1.jpg"]];
    puzzleArray=[[NSMutableArray alloc] initWithCapacity:100];
    imgViewArray=[[NSMutableArray alloc] initWithCapacity:100];
    
   
    panView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    panView.delegate=self;
    tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tapView.numberOfTapsRequired=1;
    tapView.delegate=self;
    
//    if (puzzleArray.count == 0) {
//        puzzleCollectionView.hidden = YES;
//        emptyView.hidden = NO;
//    }else{
//        puzzleCollectionView.hidden = NO;
//        emptyView.hidden = YES;
//    }
}
-(void)move:(UIPanGestureRecognizer *)recognizer{
    
    CGPoint transpoint=[recognizer translationInView:uiView];
    [uiView.subviews lastObject].center=CGPointMake([uiView.subviews lastObject].center.x+transpoint.x, [uiView.subviews lastObject].center.y+transpoint.y) ;
    [recognizer setTranslation:CGPointMake(0, 0) inView:uiView];
    NSLog(@"AAAA",nil);

}
-(void)tap:(UITapGestureRecognizer *)recognizer{
    
    NSLog(@"BBBBB",nil);
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self initPuzzle:3 imagePath:@"1.jpg"];
    [puzzleCollectionView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [[event allTouches] anyObject];
//    CGPoint touchLocation = [touch locationInView:touch.view];
//    
//    [touch.view addGestureRecognizer:panView];
////    if ([[touch.view class] isSubclassOfClass:[UIImageView class]]) {
////        
////        UIImageView *imgView=(UIImageView *) touch.view;
////        
////    }
//}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if((unsigned long)[[event allTouches] count] >= 1 )
//    {
//        //[self setScrollEnabled:YES];
//        [super touchesBegan: touches withEvent: event];
//    }
//    else
//    {
//        //self.panGestureRecognizer.enabled = NO;
//        //[self setScrollEnabled:NO];
//        [[self nextResponder] touchesBegan:touches withEvent:event];
//    }
//    
//}
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if((unsigned long)[[event allTouches] count] >= 1 )
//    {
//        [super touchesMoved: touches withEvent: event];
//    }
//    else
//    {
//        [[self nextResponder] touchesMoved:touches withEvent:event];
//    }
//}



- (IBAction)premiumBtnClick:(id)sender {
    UINavigationController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"navPremium"];
    [self.navigationController presentViewController:panelController animated:YES completion:nil];
}

- (IBAction)makeNewBtnClick:(id)sender {
    MyWorksViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyWorksView"];
//    [self.navigationController pushViewController:panelController animated:YES];
    [self.tabBarController.navigationController pushViewController:panelController animated:YES];
}

- (IBAction)decodeBtn:(id)sender {
    if (segmentPuzzle.selectedSegmentIndex == 0) {
        [puzzleCollectionView reloadData];
    }else if(segmentPuzzle.selectedSegmentIndex == 1){
        [puzzleCollectionView reloadData];
    }else{
        [puzzleCollectionView reloadData];
    }
}

#pragma mark - UICollectionView Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [puzzleArray count];
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self->puzzleCollectionView.collectionViewLayout;
    
    CGFloat availableHeightForCells = CGRectGetHeight(self->puzzleCollectionView.frame) - flowLayout.sectionInset.top - flowLayout.sectionInset.bottom - flowLayout.minimumInteritemSpacing * (rowNumber - 1);
    CGFloat cellHeight = availableHeightForCells ;
    flowLayout.itemSize = CGSizeMake(cellHeight, cellHeight);
   
    return flowLayout.itemSize;
}

//- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
////    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self->puzzleCollectionView.collectionViewLayout;
////    
////    CGFloat availableHeightForCells = CGRectGetHeight(self->puzzleCollectionView.frame) - flowLayout.sectionInset.top - flowLayout.sectionInset.bottom - flowLayout.minimumInteritemSpacing * (rowNumber - 1);
////    CGFloat cellHeight = availableHeightForCells ;
////    flowLayout.itemSize = CGSizeMake(cellHeight, cellHeight);
////    
////    return flowLayout.itemSize;
//    return CGSizeMake(70, 70);
//}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"PuzzleCell";
    
    PuzzelcollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    
    [cell.PuzzleImg setFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    cell.PuzzleImg.image =[puzzleArray objectAtIndex:indexPath.item];
    return cell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    int toX=(tileWidth*(3-1)+1);
    int toY=(tileHeight*(3-1)+1);
    int xPos=arc4random() % toX;
    int yPos=arc4random() % toY;
    
    [[imgViewArray objectAtIndex:indexPath.item] setFrame:CGRectMake(0, 0, tileWidth, tileHeight)];
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(xPos, yPos, tileWidth, tileHeight)];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveImageView:)];
//    tempView=[[UIView alloc] init];
//    [tempView addSubview:[imgViewArray objectAtIndex:indexPath.item]];
    [tempView addGestureRecognizer:panGesture];
    [tempView addSubview:[imgViewArray objectAtIndex:indexPath.item]];
    tempView.tag = 100 + indexPath.row;
    [uiView addSubview:tempView];
    
    
   // [uiView.subviews objectAtIndex:(uiView.subviews.count-1 )].userInteractionEnabled=YES;
    //[uiView.subviews objectAtIndex:(uiView.subviews.count-1 )].hidden=YES;
    //[uiView addGestureRecognizer:panView];
    
//   [[uiView.subviews objectAtIndex:0] addGestureRecognizer:panView];
   
    //[tempView addGestureRecognizer:panView];
    
    [puzzleArray removeObjectAtIndex:indexPath.item];
    [imgViewArray removeObjectAtIndex:indexPath.item];
    [collectionView reloadData];
    
}

- (void) moveImageView:(UIPanGestureRecognizer *) panGesture {
    CGPoint point = [panGesture translationInView:uiView];
    UIView *movingView = panGesture.view;
    [uiView bringSubviewToFront:movingView];
    movingView.center = CGPointMake(movingView.center.x+point.x, movingView.center.y+point.y) ;
    [panGesture setTranslation:CGPointMake(0, 0) inView:uiView];
    
   

}

@end
