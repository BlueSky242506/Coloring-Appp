//
//  PuzzleViewController.h
//  Colorfy
//
//  Created by Mac729 on 7/10/16.
//  Copyright © 2016 Mac729. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PuzzleViewController : UIViewController<UIGestureRecognizerDelegate>

{
    IBOutlet UIImageView *imageView;
    IBOutlet UIView *uiView;
    
   
}
@property(nonatomic,retain) NSMutableArray *puzzleArray;
@property(nonatomic,retain) NSMutableArray *imgViewArray;
@property (nonatomic, strong) UIImage *imgShare;
//-(IBAction)move:(UIPanGestureRecognizer *)recognizer;
//-(IBAction)tap:(UITapGestureRecognizer *)recognizer;


@end
