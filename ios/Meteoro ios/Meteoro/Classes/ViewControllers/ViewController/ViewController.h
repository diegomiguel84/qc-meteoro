//
//  ViewController.h
//  Meteoro
//
//  Created by Julio Andrés Carrettoni on 30/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface ViewController : UIViewController <UIApplicationDelegate , UIScrollViewDelegate> 
{
    IBOutlet UINavigationBar *fakeNavBar;
    //IBOutlet iCarousel *theCarousel;
    IBOutlet UIPageControl *thePageControl;
    
    IBOutlet UIScrollView *scrollView;
    NSMutableArray *viewControllers;
    BOOL pageControlUsed;
    NSTimer * timer;
}

- (IBAction)onAddCityButtonTUI:(id)sender;
- (IBAction)changePage:(id)sender;
-(void)CallBack:(City*) sender;

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *thePageControl;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) NSTimer * timer;



@end
