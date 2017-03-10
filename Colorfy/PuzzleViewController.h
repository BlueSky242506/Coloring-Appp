//
//  PuzzleViewController.h
//  Colorfy
//
//  Created by Mac729 on 7/10/16.
//  Copyright © 2016 Mac729. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PuzzleViewController : UIViewController
{
    IBOutlet UIImageView *imageView;
    IBOutlet UIView *uiView;
    IBOutlet UISegmentedControl * segmentedControl;
    IBOutlet UIButton *imgButton;
    ////////////////
    
    NSInteger cubeHeightValue_;
    
    NSInteger cubeWidthValue_;
    
    NSInteger peaceHCount_;
    
    NSInteger peaceVCount_;
    
    NSInteger deepnessH_;
    
    NSInteger deepnessV_;
    
    CGFloat lastScale_;
    
    CGFloat lastRotation_;
    
    CGFloat firstX_;
    
    CGFloat firstY_;
    
    NSInteger touchedImgViewTag_;
    
    NSMutableArray *pieceTypeValueArray_;
    
    NSMutableArray *pieceRotationValuesArray_;
    
    NSMutableArray *pieceCoordinateRectArray_;
    
    NSMutableArray *pieceBezierPathsMutArray_;
    
    NSMutableArray *pieceBezierPathsWithoutHolesMutArray_;
    
    UIImage *originalCatImage_;
    
    /////////////////////
   
    
}
@property(nonatomic,retain) NSMutableArray *puzzleArray;
@property(nonatomic,retain) NSMutableArray *tmpPuzzleArray;
@property(nonatomic,retain) NSMutableArray *imgViewArray;
@property(nonatomic,retain) NSMutableArray *collectionimgViewArray;
@property (nonatomic, strong) UIImage *imgShare;
@property (nonatomic, retain) NSArray *easyMaskImgArray;

//-(IBAction)move:(UIPanGestureRecognizer *)recognizer;
//-(IBAction)tap:(UITapGestureRecognizer *)recognizer;

-(IBAction)puzzlePress:(id)sender;


@end
