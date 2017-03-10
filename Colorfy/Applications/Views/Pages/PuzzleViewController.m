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
#import <QuartzCore/QuartzCore.h>


@interface PuzzleViewController ()<UITabBarControllerDelegate>{
    
    IBOutlet UISegmentedControl *segmentPuzzle;
    IBOutlet UICollectionView *puzzleCollectionView;
    NSArray *puzzleArtworksArray;
    IBOutlet UIView *emptyView;
    double tileWidth;
    double tileHeight;
    UIPanGestureRecognizer *panView;
    UITapGestureRecognizer *tapView;
    CGFloat ss;
    int num;
    int counter;
    NSMutableArray *ranNumArray;    
}

@end

@implementation PuzzleViewController

@synthesize puzzleArray;
@synthesize imgViewArray;
@synthesize imgShare;
@synthesize easyMaskImgArray;
@synthesize tmpPuzzleArray;
@synthesize collectionimgViewArray;


-(IBAction)puzzlePress:(id)sender {
    if (ranNumArray.count!=0) {
        int u=[[ranNumArray firstObject] intValue];
        [[imgViewArray objectAtIndex:u] setHidden:NO];
        [ranNumArray removeObjectAtIndex:0];
        if (ranNumArray.count==0) {
            [imgButton setBackgroundImage:nil forState:UIControlStateNormal];
            [uiView bringSubviewToFront:[imgViewArray objectAtIndex:u]];
        }
        else
        {
            [imgButton setBackgroundImage:[puzzleArray objectAtIndex:[[ranNumArray firstObject] intValue]] forState:UIControlStateNormal];
            [uiView bringSubviewToFront:[imgViewArray objectAtIndex:u]];
        }
    }
    else{
        [imgButton setBackgroundImage:nil forState:UIControlStateNormal];
    }
}

-(IBAction)levelSelect:(id)sender{
    
    counter=0;
    
    switch ([sender selectedSegmentIndex]) {
        case 0:
            num=3;
            
            [self viewWillAppear:YES];
            break;
        case 1:
            num=4;
            [self viewWillAppear:YES];
            break;
        case 2:
            num=5;
            [self viewWillAppear:YES];
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)move:(UIPanGestureRecognizer *)recognizer{
    
    CGPoint transpoint = [recognizer translationInView:uiView];
    [uiView.subviews lastObject].center = CGPointMake([uiView.subviews lastObject].center.x+transpoint.x, [uiView.subviews lastObject].center.y+transpoint.y) ;
    [recognizer setTranslation:CGPointMake(0, 0) inView:uiView];
}

-(void)tap:(UITapGestureRecognizer *)recognizer {
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    emptyView.hidden = YES;
    
    puzzleArray=[[NSMutableArray alloc] initWithCapacity:100];
    imgViewArray=[[NSMutableArray alloc] initWithCapacity:100];
    collectionimgViewArray=[[NSMutableArray alloc] initWithCapacity:100];
    tmpPuzzleArray=[[NSMutableArray alloc] initWithCapacity:100];
    
    NSArray *viewArray=[[NSArray alloc] init];
    viewArray=[uiView subviews];
    for (UIImageView *img in viewArray) {
        [img removeFromSuperview];
    }
    counter=0;
    if (num==0) {
        num=3;
    }
    
    UIImage *sourceImg=imgShare;
    if (sourceImg==nil) {
        sourceImg=[UIImage imageNamed:@"1.jpg"];
        emptyView.hidden = NO;
    } else {
        UIImageView *bgImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, uiView.frame.size.width, uiView.frame.size.height)];
        [bgImageView setImage:sourceImg];
        [bgImageView setAlpha:0.3];
        [uiView addSubview:bgImageView];
        
        
        UIGraphicsBeginImageContext(uiView.frame.size);
        [sourceImg drawInRect:CGRectMake(0,0, uiView.frame.size.width, uiView.frame.size.height)];
        sourceImg=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        ss=uiView.frame.size.width/sourceImg.size.width;
        
        originalCatImage_ = sourceImg;
        
        peaceHCount_ = num;
        
        peaceVCount_ = num;
        
        cubeHeightValue_ = ss*originalCatImage_.size.height/peaceVCount_;
        
        cubeWidthValue_ = ss*originalCatImage_.size.width/peaceHCount_;
        
        deepnessH_ = -(cubeHeightValue_ / 4);
        
        deepnessV_ = -(cubeWidthValue_ / 4);
        
        [self setUpPeaceCoordinatesTypesAndRotationValuesArrays];
        
        [self setUpPeaceBezierPaths];
        
        [self setUpPuzzlePeaceImages];
        
        //////////////
        
        switch (num) {
            case 3:
                ranNumArray=[[NSMutableArray alloc] initWithObjects:@"4",@"7",@"2",@"8",@"6",@"0",@"3",@"1",@"5", nil];
                break;
            case 4:
                ranNumArray=[[NSMutableArray alloc] initWithObjects:@"12",@"7",@"6",@"8",@"5",@"10",@"13",@"1",@"15",@"2",@"9",@"4",@"0",@"3",@"14",@"11", nil];
                break;
            case 5:
                ranNumArray=[[NSMutableArray alloc] initWithObjects:@"14",@"17",@"12",@"18",@"16",@"0",@"13",@"1",@"15",@"11",@"7",@"6",@"8",@"5",@"20",@"3",@"2", @"24",@"20",@"19",@"9",@"4",@"10",@"23",@"21",nil];
                break;
                
            default:
                break;
        }
        
        [imgButton setBackgroundImage:[puzzleArray objectAtIndex:[[ranNumArray firstObject] intValue]] forState:UIControlStateNormal];
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

- (IBAction)makeNewBtnClick:(id)sender {
//    MyWorksViewController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyWorksView"];
////    [self.navigationController pushViewController:panelController animated:YES];
//    [self.tabBarController.navigationController pushViewController:panelController animated:YES];
    UITabBarController *viewController1 = self.tabBarController;
    [viewController1 setSelectedIndex:1];
}

#pragma mark - UICollectionView Delegate


- (void) moveImageView:(UIPanGestureRecognizer *) panGesture {
    CGPoint point = [panGesture translationInView:uiView];
    UIView *movingView = panGesture.view;
    [uiView bringSubviewToFront:movingView];
    movingView.center = CGPointMake(movingView.center.x+point.x, movingView.center.y+point.y) ;
    [panGesture setTranslation:CGPointMake(0, 0) inView:uiView];
}

- (void)setUpPeaceCoordinatesTypesAndRotationValuesArrays
{
    //// DLog();
    
    //--- rotations  (currently commented out so that at the beginning would be generated picture, where each peace is in its correct place)
//    NSArray *mRotationTypeArray = [NSArray arrayWithObjects:
//                                   [NSNumber numberWithFloat:M_PI/2],
//                                   [NSNumber numberWithFloat:M_PI],
//                                   [NSNumber numberWithFloat:M_PI + M_PI/2],
//                                   [NSNumber numberWithFloat:M_PI*2],
//                                   nil];
    //===
    
    
    //---
    pieceTypeValueArray_ = [NSMutableArray new]; //0: empty side /  1: outside  / -1: inside
    
    pieceCoordinateRectArray_ = [NSMutableArray new];
    
    pieceRotationValuesArray_ = [NSMutableArray new];
    
    int mSide1 = 0;
    
    int mSide2 = 0;
    
    int mSide3 = 0;
    
    int mSide4 = 0;
    
    int mCounter = 0;
    
    int mCubeWidth = 0;
    
    int mCubeHeight = 0;
    
    int mXPoint = 0;
    
    int mYPoint = 0;
    
    for(int i = 0; i < peaceVCount_; i++)
    {
        for(int j = 0; j < peaceHCount_; j++)
        {
            if(j != 0)
            {
                mSide1 = ([[[pieceTypeValueArray_ objectAtIndex:mCounter-1] objectAtIndex:2] intValue] == 1)?-1:1;
            }
            
            if(i != 0)
            {
                mSide4 = ([[[pieceTypeValueArray_ objectAtIndex:mCounter-peaceHCount_] objectAtIndex:1] intValue] == 1)?-1:1;
            }
            
            
            mSide2 = ((arc4random() % 2) == 1)?1:-1;
            
            mSide3 = ((arc4random() % 2) == 1)?1:-1;
            
            
            if(i == 0)
            {
                mSide4 = 0;
            }
            
            if(j == 0)
            {
                mSide1 = 0;
            }
            
            
            if(i == peaceVCount_-1)
            {
                mSide2 = 0;
            }
            
            if(j == peaceHCount_-1)
            {
                mSide3 = 0;
            }
            
            
            //--- calculate cube width and height
            mCubeWidth = (int)cubeWidthValue_;
            
            mCubeHeight = (int)cubeHeightValue_;
            
            if(mSide1 == 1)
            {
                mCubeWidth -= deepnessV_;
            }
            
            if(mSide3 == 1)
            {
                mCubeWidth -= deepnessV_;
            }
            
            if(mSide2 == 1)
            {
                mCubeHeight -= deepnessH_;
            }
            
            if(mSide4 == 1)
            {
                mCubeHeight -= deepnessH_;
            }
            //===
            
            
            //--- piece side types
            [pieceTypeValueArray_ addObject:[NSArray arrayWithObjects:
                                             [NSString stringWithFormat:@"%i", mSide1],
                                             [NSString stringWithFormat:@"%i", mSide2],
                                             [NSString stringWithFormat:@"%i", mSide3],
                                             [NSString stringWithFormat:@"%i", mSide4],
                                             nil]];
            //===
            
            
            //--- frames for cropping and imageviews
            mXPoint = MAX(mCubeWidth, MIN(arc4random() % MAX(1,(int)(uiView.frame.size.width - mCubeWidth*2)) + mCubeWidth, uiView.frame.size.width - mCubeWidth*2));
            
            mYPoint = MAX(mCubeHeight, MIN(arc4random() % MAX(1,(int)(uiView.frame.size.height - mCubeHeight*2)) + mCubeHeight, uiView.frame.size.height - mCubeHeight*2));
            
            [pieceCoordinateRectArray_ addObject:[NSArray arrayWithObjects:
                                                  [NSValue valueWithCGRect:CGRectMake(j*cubeWidthValue_,i*cubeHeightValue_,mCubeWidth,mCubeHeight)],
                                                  [NSValue valueWithCGRect:CGRectMake(j*cubeWidthValue_-(mSide1==1?-deepnessV_:0),i*cubeHeightValue_-(mSide4==1?-deepnessH_:0), mCubeWidth, mCubeHeight)], nil]];
            //[NSValue valueWithCGRect:CGRectMake(mXPoint, mYPoint, mCubeWidth, mCubeHeight)], nil]];
            //===
            
            // Rotation
            [pieceRotationValuesArray_ addObject:[NSNumber numberWithFloat:0]];//[mRotationTypeArray objectAtIndex:(arc4random() % 4)]];
            
            mCounter++;
        }
    }
}


- (void)setUpPeaceBezierPaths
{
    ////  DLog();
    
    //---
    pieceBezierPathsMutArray_ = [NSMutableArray new];
    
    pieceBezierPathsWithoutHolesMutArray_ = [NSMutableArray new];
    //===
    
    
    float mYSideStartPos = 0;
    
    float mXSideStartPos = 0;
    
    float mCustomDeepness = 0;
    
    float mCurveHalfVLength = cubeWidthValue_ / 10;
    
    float mCurveHalfHLength = cubeHeightValue_ / 10;
    
    float mCurveStartXPos = cubeWidthValue_ / 2 - mCurveHalfVLength;
    
    float mCurveStartYPos = cubeHeightValue_ / 2 - mCurveHalfHLength;
    
    float mTotalHeight = 0;
    
    float mTotalWidth = 0;
    
    
    for(int i = 0; i < [pieceTypeValueArray_ count]; i++) {
        mXSideStartPos = ([[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:0] intValue] == 1)?-deepnessV_:0;
        
        mYSideStartPos = ([[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:3] intValue] == 1)?-deepnessH_:0;
        
        mTotalHeight = mYSideStartPos + mCurveStartYPos*2 + mCurveHalfHLength * 2;
        
        mTotalWidth = mXSideStartPos + mCurveStartXPos*2 + mCurveHalfVLength * 2;
        
        
        //--- bezierPath begins
        UIBezierPath* mPieceBezier = [UIBezierPath bezierPath];
        
        [mPieceBezier moveToPoint: CGPointMake(mXSideStartPos, mYSideStartPos)];
        //===
        
        
        //--- bezier for touches begins
        UIBezierPath* mTouchPieceBezier = [UIBezierPath bezierPath];
        
        [mTouchPieceBezier moveToPoint: CGPointMake(mXSideStartPos, mYSideStartPos)];
        //===
        
        //--- kreisā puse
        [mPieceBezier addLineToPoint: CGPointMake(mXSideStartPos, mYSideStartPos + mCurveStartYPos)];
        
        if(![[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:0] isEqualToString:@"0"])
        {
            mCustomDeepness = deepnessV_ * [[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:0] intValue];
            
            [mPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCustomDeepness, mYSideStartPos + mCurveStartYPos+mCurveHalfHLength) controlPoint1: CGPointMake(mXSideStartPos, mYSideStartPos + mCurveStartYPos) controlPoint2: CGPointMake(mXSideStartPos + mCustomDeepness, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength - mCurveStartYPos)];//25
            
            [mPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength*2) controlPoint1: CGPointMake(mXSideStartPos + mCustomDeepness, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength + mCurveStartYPos) controlPoint2: CGPointMake(mXSideStartPos, mYSideStartPos+mCurveStartYPos + mCurveHalfHLength*2)]; //156
        }
        
        [mPieceBezier addLineToPoint: CGPointMake(mXSideStartPos, mTotalHeight)];
        
        [mTouchPieceBezier addLineToPoint: CGPointMake(mXSideStartPos, mYSideStartPos + mCurveStartYPos)];
        
        if([[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:0] isEqualToString:@"1"])
        {
            mCustomDeepness = deepnessV_;
            
            [mTouchPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCustomDeepness, mYSideStartPos + mCurveStartYPos+mCurveHalfHLength) controlPoint1: CGPointMake(mXSideStartPos, mYSideStartPos + mCurveStartYPos) controlPoint2: CGPointMake(mXSideStartPos + mCustomDeepness, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength - mCurveStartYPos)];//25
            
            [mTouchPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength*2) controlPoint1: CGPointMake(mXSideStartPos + mCustomDeepness, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength + mCurveStartYPos) controlPoint2: CGPointMake(mXSideStartPos, mYSideStartPos+mCurveStartYPos + mCurveHalfHLength*2)]; //156
        }
        
        [mTouchPieceBezier addLineToPoint: CGPointMake(mXSideStartPos, mTotalHeight)];
        //===
        
        //--- apakša
        [mPieceBezier addLineToPoint: CGPointMake(mXSideStartPos+ mCurveStartXPos, mTotalHeight)];
        
        if(![[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:1] isEqualToString:@"0"])
        {
            mCustomDeepness = deepnessH_ * [[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:1] intValue];
            
            [mPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCurveStartXPos + mCurveHalfVLength, mTotalHeight - mCustomDeepness) controlPoint1: CGPointMake(mXSideStartPos + mCurveStartXPos, mTotalHeight) controlPoint2: CGPointMake(mXSideStartPos + mCurveHalfVLength, mTotalHeight - mCustomDeepness)];
            
            [mPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCurveStartXPos + mCurveHalfVLength+mCurveHalfVLength, mTotalHeight) controlPoint1: CGPointMake(mTotalWidth - mCurveHalfVLength, mTotalHeight - mCustomDeepness) controlPoint2: CGPointMake(mXSideStartPos + mCurveStartXPos + mCurveHalfVLength + mCurveHalfVLength, mTotalHeight)];
        }
        
        [mPieceBezier addLineToPoint: CGPointMake(mTotalWidth, mTotalHeight)];
        
        
        [mTouchPieceBezier addLineToPoint: CGPointMake(mXSideStartPos+ mCurveStartXPos, mTotalHeight)];
        
        if([[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:1] isEqualToString:@"1"])
        {
            mCustomDeepness = deepnessH_;
            
            [mTouchPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCurveStartXPos + mCurveHalfVLength, mTotalHeight - mCustomDeepness) controlPoint1: CGPointMake(mXSideStartPos + mCurveStartXPos, mTotalHeight) controlPoint2: CGPointMake(mXSideStartPos + mCurveHalfVLength, mTotalHeight - mCustomDeepness)];
            
            [mTouchPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCurveStartXPos + mCurveHalfVLength+mCurveHalfVLength, mTotalHeight) controlPoint1: CGPointMake(mTotalWidth - mCurveHalfVLength, mTotalHeight - mCustomDeepness) controlPoint2: CGPointMake(mXSideStartPos + mCurveStartXPos + mCurveHalfVLength + mCurveHalfVLength, mTotalHeight)];
        }
        
        [mTouchPieceBezier addLineToPoint: CGPointMake(mTotalWidth, mTotalHeight)];
        //===
        
        
        //--- labā puse
        [mPieceBezier addLineToPoint: CGPointMake(mTotalWidth, mTotalHeight - mCurveStartYPos)];
        
        if(![[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:2] isEqualToString:@"0"])
        {
            mCustomDeepness = deepnessV_ * [[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:2] intValue];
            
            [mPieceBezier addCurveToPoint: CGPointMake(mTotalWidth - mCustomDeepness, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength) controlPoint1: CGPointMake(mTotalWidth, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength * 2) controlPoint2: CGPointMake(mTotalWidth - mCustomDeepness, mTotalHeight - mCurveHalfHLength)];
            
            [mPieceBezier addCurveToPoint: CGPointMake(mTotalWidth, mYSideStartPos + mCurveStartYPos) controlPoint1: CGPointMake(mTotalWidth - mCustomDeepness, mYSideStartPos + mCurveHalfHLength) controlPoint2: CGPointMake(mTotalWidth, mCurveStartYPos + mYSideStartPos)];
        }
        
        [mPieceBezier addLineToPoint: CGPointMake(mTotalWidth, mYSideStartPos)];
        
        [mTouchPieceBezier addLineToPoint: CGPointMake(mTotalWidth, mTotalHeight - mCurveStartYPos)];
        
        if([[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:2] isEqualToString:@"1"])
        {
            mCustomDeepness = deepnessV_;
            
            [mTouchPieceBezier addCurveToPoint: CGPointMake(mTotalWidth - mCustomDeepness, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength) controlPoint1: CGPointMake(mTotalWidth, mYSideStartPos + mCurveStartYPos + mCurveHalfHLength * 2) controlPoint2: CGPointMake(mTotalWidth - mCustomDeepness, mTotalHeight - mCurveHalfHLength)];
            
            [mTouchPieceBezier addCurveToPoint: CGPointMake(mTotalWidth, mYSideStartPos + mCurveStartYPos) controlPoint1: CGPointMake(mTotalWidth - mCustomDeepness, mYSideStartPos + mCurveHalfHLength) controlPoint2: CGPointMake(mTotalWidth, mCurveStartYPos + mYSideStartPos)];
        }
        
        [mTouchPieceBezier addLineToPoint: CGPointMake(mTotalWidth, mYSideStartPos)];
        //===
        
        
        //--- augša
        [mPieceBezier addLineToPoint: CGPointMake(mTotalWidth - mCurveStartXPos, mYSideStartPos)];
        
        if(![[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:3] isEqualToString:@"0"])
        {
            mCustomDeepness = deepnessH_ * [[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:3] intValue];
            
            [mPieceBezier addCurveToPoint: CGPointMake(mTotalWidth - mCurveStartXPos - mCurveHalfVLength, mYSideStartPos + mCustomDeepness) controlPoint1: CGPointMake(mTotalWidth - mCurveStartXPos, mYSideStartPos) controlPoint2: CGPointMake(mTotalWidth - mCurveHalfVLength, mYSideStartPos + mCustomDeepness)];
            
            [mPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCurveStartXPos, mYSideStartPos) controlPoint1: CGPointMake(mXSideStartPos + mCurveHalfVLength, mYSideStartPos + mCustomDeepness) controlPoint2: CGPointMake(mXSideStartPos + mCurveStartXPos, mYSideStartPos)];
        }
        
        [mPieceBezier addLineToPoint: CGPointMake(mXSideStartPos, mYSideStartPos)];
        
        
        [mTouchPieceBezier addLineToPoint: CGPointMake(mTotalWidth - mCurveStartXPos, mYSideStartPos)];
        
        if([[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:3] isEqualToString:@"1"])
        {
            mCustomDeepness = deepnessH_;
            
            [mTouchPieceBezier addCurveToPoint: CGPointMake(mTotalWidth - mCurveStartXPos - mCurveHalfVLength, mYSideStartPos + mCustomDeepness) controlPoint1: CGPointMake(mTotalWidth - mCurveStartXPos, mYSideStartPos) controlPoint2: CGPointMake(mTotalWidth - mCurveHalfVLength, mYSideStartPos + mCustomDeepness)];
            
            [mTouchPieceBezier addCurveToPoint: CGPointMake(mXSideStartPos + mCurveStartXPos, mYSideStartPos) controlPoint1: CGPointMake(mXSideStartPos + mCurveHalfVLength, mYSideStartPos + mCustomDeepness) controlPoint2: CGPointMake(mXSideStartPos + mCurveStartXPos, mYSideStartPos)];
        }
        
        [mTouchPieceBezier addLineToPoint: CGPointMake(mXSideStartPos, mYSideStartPos)];
        //===
        
        //---
        [pieceBezierPathsMutArray_ addObject:mPieceBezier];
        
        [pieceBezierPathsWithoutHolesMutArray_ addObject:mTouchPieceBezier];
        //===
    }
}


- (void)setUpPuzzlePeaceImages {
    ////  DLog();
    
    float mXAddableVal = 0;
    
    float mYAddableVal = 0;
    
    for(int i = 0; i < [pieceBezierPathsMutArray_ count]; i++)
    {
        CGRect mCropFrame = [[[pieceCoordinateRectArray_ objectAtIndex:i] objectAtIndex:0] CGRectValue];
        
        CGRect mImageFrame = [[[pieceCoordinateRectArray_ objectAtIndex:i] objectAtIndex:1] CGRectValue];
        
        //--- puzzle peace image.
        UIImageView *mPeace = [UIImageView new];
        
        [mPeace setFrame:mImageFrame];
        
        [mPeace setTag:i+100];
        
        [mPeace setUserInteractionEnabled:YES];
        
        [mPeace setContentMode:UIViewContentModeTopLeft];
        //===
        
        //--- addable value
        mXAddableVal = ([[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:0] intValue] == 1)?deepnessV_:0;
        
        mYAddableVal = ([[[pieceTypeValueArray_ objectAtIndex:i] objectAtIndex:3] intValue] == 1)?deepnessH_:0;
        
        mCropFrame.origin.x += mXAddableVal;
        
        mCropFrame.origin.y += mYAddableVal;
        
        //--- crop and clip and add to self view
        [mPeace setImage:[self cropImage:originalCatImage_
                                withRect:mCropFrame]];
        
        [self setClippingPath:[pieceBezierPathsMutArray_ objectAtIndex:i]:mPeace];
        
        [mPeace setContentMode:UIViewContentModeScaleAspectFit];
        [uiView addSubview:mPeace];
        
//        int toX=(mPeace.frame.size.width*(num-1)+1);
//        int toY=(mPeace.frame.size.height*(num-1)+1);
        int toX= uiView.frame.size.width-mPeace.frame.size.width;
        int toY= uiView.frame.size.height-mPeace.frame.size.height;
        
        int xPos=arc4random() % toX;
        int yPos=arc4random() % toY;
        
        
        
        [mPeace setFrame:CGRectMake(xPos, yPos, mPeace.frame.size.width, mPeace.frame.size.height)];
        
        [mPeace setTransform:CGAffineTransformMakeRotation([[pieceRotationValuesArray_ objectAtIndex:i] floatValue])];
        //===
        
        
        //--- border line
        CAShapeLayer *mBorderPathLayer = [CAShapeLayer layer];
        
        [mBorderPathLayer setPath:[[pieceBezierPathsMutArray_ objectAtIndex:i] CGPath]];
        
        [mBorderPathLayer setFillColor:[UIColor clearColor].CGColor];
        
        [mBorderPathLayer setStrokeColor:[UIColor blackColor].CGColor];
        
        [mBorderPathLayer setLineWidth:3];
        
        [mBorderPathLayer setFrame:CGRectZero];
        
        [[mPeace layer] addSublayer:mBorderPathLayer];
        //===
        
        //--- secret border line for touch recognition
        CAShapeLayer *mSecretBorder = [CAShapeLayer layer];
        
        [mSecretBorder setPath:[[pieceBezierPathsWithoutHolesMutArray_ objectAtIndex:i] CGPath]];
        
        [mSecretBorder setFillColor:[UIColor clearColor].CGColor];
        
        [mSecretBorder setStrokeColor:[UIColor blackColor].CGColor];
        
        [mSecretBorder setLineWidth:0];
        
        [mSecretBorder setFrame:CGRectZero];
        
        [[mPeace layer] addSublayer:mSecretBorder];
        //===
        
        //--- gestures
        UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc]
                                                           initWithTarget:self action:@selector(rotate:)];
        
        [rotationRecognizer setDelegate:self];
        
        [mPeace addGestureRecognizer:rotationRecognizer];
        
        // [rotationRecognizer release];
        
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(move1:)];
        
        [panRecognizer setMinimumNumberOfTouches:1];
        
        [panRecognizer setMaximumNumberOfTouches:2];
        
        [panRecognizer setDelegate:self];
        
        [mPeace addGestureRecognizer:panRecognizer];
        
        [imgViewArray addObject:mPeace];
 
        UIGraphicsBeginImageContext([mPeace frame].size);
        [[mPeace layer] renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *ttt=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [tmpPuzzleArray addObject:ttt];
        [puzzleArray addObject:ttt];
        
        [imgButton setBackgroundImage:ttt forState:UIControlStateNormal];
    
         mPeace.hidden=YES;
     }
}

#pragma mark -
#pragma mark help functions

- (void) setClippingPath:(UIBezierPath *)clippingPath : (UIImageView *)imgView; {
    if (![[imgView layer] mask]) {
        [[imgView layer] setMask:[CAShapeLayer layer]];
    }
    [(CAShapeLayer*) [[imgView layer] mask] setPath:[clippingPath CGPath]];
}


- (UIImage *) cropImage:(UIImage*)originalImage withRect:(CGRect)rect {
    
    return [UIImage imageWithCGImage:CGImageCreateWithImageInRect([originalImage CGImage], rect)];
}

#pragma mark -
#pragma mark gesture functions

- (void)rotate:(id)sender
{
    //DLog();
    
    [uiView bringSubviewToFront:[(UIRotationGestureRecognizer*)sender view]];
    
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded)
    {
        CGFloat realRotation = 0;
        
        realRotation = lastRotation_-((M_PI*2)*(int)(lastRotation_/(M_PI*2)));
        
        realRotation += [[pieceRotationValuesArray_ objectAtIndex:[(UIRotationGestureRecognizer*)sender view].tag-100] floatValue];
        
        
        if(realRotation > M_PI*2)
        {
            realRotation -= M_PI*2;
        }
        
        realRotation -= M_PI/4;
        
        if(realRotation < -M_PI/4)
        {
            realRotation += M_PI*2;
        }
        
        if(realRotation < 0)
        {
            realRotation = 0;
        }
        else if(realRotation < M_PI/2)
        {
            realRotation = M_PI/2;
        }
        else if(realRotation < M_PI)
        {
            realRotation = M_PI;
        }
        else if(realRotation < M_PI + M_PI/2)
        {
            realRotation = M_PI + M_PI/2;
        }
        else if(realRotation <= M_PI * 2)
        {
            realRotation = M_PI * 2;
        }
        
        [pieceRotationValuesArray_ replaceObjectAtIndex:[(UIRotationGestureRecognizer*)sender view].tag-100
                                             withObject:[NSNumber numberWithFloat:realRotation]];
        
        
        [UIView beginAnimations:nil context:nil];
        
        [UIView setAnimationDuration:0.25];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [[(UIRotationGestureRecognizer*)sender view] setTransform:CGAffineTransformMakeRotation(realRotation)];
        
        [UIView commitAnimations];
        
        lastRotation_ = 0.0;
        
        return;
    }
    
    CGFloat rotation = 0.0 - (lastRotation_ - [(UIRotationGestureRecognizer*)sender rotation]);
    
    CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
    
    
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [[(UIRotationGestureRecognizer*)sender view] setTransform:newTransform];
    
    lastRotation_ = [(UIRotationGestureRecognizer*)sender rotation];
}


- (void)move1:(id)sender
{
    // DLog();
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:uiView];
    
    if(touchedImgViewTag_ == 0 || touchedImgViewTag_ == 99)
    {
        
        return;
    }
    
    
    
    UIImageView *mImgView = (UIImageView *)[uiView viewWithTag:touchedImgViewTag_];
    
    translatedPoint = CGPointMake(firstX_+translatedPoint.x, firstY_+translatedPoint.y);
    
    [mImgView setCenter:translatedPoint];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;//![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // DLog();
    
    if(touchedImgViewTag_ == 0)
    {
        return;
    }
    
    UIImageView *mImgView = (UIImageView *)[uiView viewWithTag:touchedImgViewTag_];
    
    if(!mImgView || ![mImgView isKindOfClass:[UIImageView class]])
    {
        return;
    }
    
    
    CGFloat mRotation = [[pieceRotationValuesArray_ objectAtIndex:mImgView.tag-100] floatValue];
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.25];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    if(mRotation >= 0  && mRotation < M_PI/2)
    {
        [mImgView setTransform:CGAffineTransformMakeRotation(M_PI/2)];
        
        mRotation = M_PI/2;
    }
    else if(mRotation >= M_PI/2 && mRotation < M_PI)
    {
        [mImgView setTransform:CGAffineTransformMakeRotation(M_PI)];
        
        mRotation = M_PI;
    }
    else if(mRotation >= M_PI && mRotation < M_PI + M_PI/2)
    {
        [mImgView setTransform:CGAffineTransformMakeRotation(M_PI + M_PI/2)];
        
        mRotation = M_PI + M_PI/2;
    }
    else
    {
        [mImgView setTransform:CGAffineTransformMakeRotation(M_PI*2)];
        
        mRotation = 0;
    }
    
    
    [UIView commitAnimations];
    
    
    [pieceRotationValuesArray_ replaceObjectAtIndex:mImgView.tag-100 withObject:[NSNumber numberWithFloat:mRotation]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // DLog();
    
    touchedImgViewTag_ = 0;
    
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint location = [touch locationInView:uiView];
        
    //--- get imageview
    UIImageView *mImgView = nil;
    
    touchedImgViewTag_ = 0;
    
    for(int i = [[uiView subviews] count]-1; i > -1 ; i--) {
        mImgView = (UIImageView *)[[uiView subviews] objectAtIndex:i];
        
        location = [touch locationInView:mImgView];
        
        if(CGPathContainsPoint([(CAShapeLayer*) [[[mImgView layer] sublayers] objectAtIndex:1] path], nil, location, NO))
        {
            touchedImgViewTag_ = mImgView.tag;
            
            [uiView bringSubviewToFront:mImgView];
            
            firstX_ = mImgView.center.x;
            
            firstY_ = mImgView.center.y;
            
            break;
        }
    }
}
//

////////////////
@end
