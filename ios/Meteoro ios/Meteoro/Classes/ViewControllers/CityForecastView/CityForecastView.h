//
//  PageControlExampleViewControl.h
//  PageControlExample
//
//  Created by Chakra on 26/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"


@interface CityForecastView : UIViewController <UITableViewDataSource, UITableViewDelegate>{

	IBOutlet UILabel *pageNumberLabel;
    int pageNumber;
    IBOutlet UILabel *cityNameLabel;
    
    IBOutlet UILabel *tempActualLabel;
    IBOutlet UILabel *sensacionTermicaActualLabel;
    IBOutlet UILabel *humedadActualLabel;
    IBOutlet UILabel *estadoLabel;
    IBOutlet UIView *view;
    
    IBOutlet UITableView *forecastTable;
    IBOutlet UIImageView *statusImage;
    City *thisCity;
    
    UINib *cellLoader;
}

@property (nonatomic, retain) UILabel *pageNumberLabel;
@property (nonatomic, retain) City *thisCity;
@property (nonatomic, retain) IBOutlet UIView *view;



- (id)initWithCity:(City*) city;


	


@end
