//
//  ViewController.m
//  Meteoro
//
//  Created by Julio Andrés Carrettoni on 30/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "AddCityViewController.h"
#import "CityForecastView.h"
#import "City.h"


@interface ViewController ()

@end

static NSUInteger kNumberOfPages = 0;

@implementation ViewController
@synthesize scrollView,thePageControl,viewControllers,timer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    kNumberOfPages = [Config getInstance].cities.count;
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:300.0f
                                     target:self
                                   selector:@selector(ScheduledMethod:)
                                   userInfo:nil
                                    repeats:YES];
    

    //[self InicializarPaginador];
}

- (void) viewWillAppear:(BOOL) animated
{
    [super viewWillAppear:animated];
    kNumberOfPages = [Config getInstance].cities.count;    
    
    [self InicializarPaginador];

}

- (void)viewDidUnload
{
    [fakeNavBar release];
    fakeNavBar = nil;
    //[theCarousel release];
    //theCarousel = nil;
    [thePageControl release];
    thePageControl = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [fakeNavBar release];
    //[theCarousel release];
    [thePageControl release];
    [super dealloc];
}



- (void)InicializarPaginador {
    
    
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++) {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    [controllers release];
    
	
    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
	
    thePageControl.numberOfPages = kNumberOfPages;
    thePageControl.currentPage = 0;
	
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    if(kNumberOfPages > 0)
    {
        int page = kNumberOfPages - 1;
        thePageControl.currentPage = page;
        
        CGFloat pageWidth = scrollView.frame.size.width;
        if(page > 0)
        {
            [scrollView setContentOffset: CGPointMake(pageWidth * page, 0)];
        }
        [self loadScrollViewWithPage:page]; 
        
    }
    

}


//Cada 5 minutos actualiza el clima de las ciudades
-(void)ScheduledMethod: (NSTimer *) theTimer
{
    
    for(int i=0; i< [Config getInstance].cities.count; i++)
    {
        City * aCity = [[Config getInstance].cities objectAtIndex:i];
        aCity.orden = i;
        aCity.controllerCallback = self;
        aCity.lastDateUpdate = [NSDate date];
        
        
        [aCity refreshForecast];
    }
}

- (void)loadScrollViewWithPage:(int) page {
    

    
    //page = [self PaginaActual];
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
    
    if([Config getInstance].cities.count > 0)
    {
        
        City * aCity = [[Config getInstance].cities objectAtIndex:page];
        aCity.orden = page;
        
        if(aCity.forecasts == nil)
        {
            aCity.controllerCallback = self;
            aCity.lastDateUpdate = [NSDate date];
            
            [aCity refreshForecast];
        }
        else [self CallBack:aCity];
        
        /*
        
        if(aCity.forecasts == nil || aCity.lastDateUpdate == nil)
        {
            aCity.controllerCallback = self;
            aCity.lastDateUpdate = [NSDate date];
            
            [aCity refreshForecast];
        }
        else
        {
            NSDate* now = [NSDate date];
            NSDate * lastdate = aCity.lastDateUpdate;
            
            
            NSTimeInterval secondsBetween = [now timeIntervalSinceDate:lastdate];
            float minutes = secondsBetween / 60;
            
            if(minutes > 5)
            {
                aCity.controllerCallback = self;
                aCity.lastDateUpdate = [NSDate date];
                [aCity refreshForecast];
            }
            else [self CallBack:aCity];
        }*/
    }
	
}

-(void)CallBack:(City*) sender
{

    
    
    NSLog([NSString stringWithFormat:@"Cantidad: %d", self.viewControllers.count]);
    
    if(sender.orden < self.viewControllers.count)
    {
        
        CityForecastView *controller = [self.viewControllers objectAtIndex:sender.orden];
        if ((NSNull *)controller == [NSNull null]) {
            controller = [[CityForecastView alloc] initWithCity:sender];
            [self.viewControllers replaceObjectAtIndex:sender.orden withObject:controller];
            [controller release];
            
            if (nil == controller.view.superview) {
                CGRect frame = scrollView.frame;
                frame.origin.x = frame.size.width * sender.orden;
                frame.origin.y = 0;
                controller.view.frame = frame;
                [scrollView addSubview:controller.view];
            }
        }
        else
        {
            [controller UpdateData:sender]; 
        }
    }
    

    
}

-(int)PaginaActual
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    return page;
    
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    // Switch the indicator when more than 50% of the previous/next page is visible
    int page = [self PaginaActual];
	thePageControl.currentPage = page;
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    //[self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender {
    int page = thePageControl.currentPage;
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    // update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}



@end
