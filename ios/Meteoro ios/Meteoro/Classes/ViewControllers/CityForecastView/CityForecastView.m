//
//  PageControlExampleViewControl.m
//  PageControlExample
//
//  Created by Chakra on 26/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CityForecastView.h"
#import "Forecast.h"
#import "Forecast.h"
#import "UpdateInfoCell.h"
#import "AdminCities.h"
#import "AppDelegate.h"



@implementation CityForecastView

@synthesize pageNumberLabel,thisCity;



// Creates the color list the first time this method is invoked. Returns one color object from the list.


- (id)initWithCity:(City*) city
{
    if (self = [super initWithNibName:@"CityForecastView" bundle:nil]) {
        thisCity = city;
    }
    return self;
    
}

- (void)dealloc {
    [pageNumberLabel release];
    [super dealloc];
}

// Set the label and background color when the view has finished loading.
- (void)viewDidLoad {
    //pageNumberLabel.text = [NSString stringWithFormat:@"Page %d", pageNumber + 1];
    //self.view.backgroundColor = [PageControlExampleViewControl pageControlColorWithIndex:pageNumber];
    cityNameLabel.text = thisCity.name;

    
    if(thisCity.forecasts.count > 0)
    {
        Forecast * forecast = [thisCity.forecasts objectAtIndex:0];
        estadoLabel.text = NSLocalizedString(forecast.status, @"");
        tempActualLabel.text = [[NSString stringWithFormat:@"%d", forecast.temperature] stringByAppendingString:@"º"];
        humedadActualLabel.text = [[NSString stringWithFormat:@"%d", forecast.humidity] stringByAppendingString:@"%"];
        sensacionTermicaActualLabel.text = forecast.pressure;
        
        statusImage.image = [UIImage imageNamed: [[Config getInstance] ImageName:forecast.status]]; 
    }
    
    forecastTable.backgroundColor = [UIColor clearColor];
    forecastTable.opaque = NO;
    forecastTable.backgroundView = nil;
    self.view.backgroundColor = [UIColor clearColor];
    
}

-(void)adminCities
{
    /*
    AdminCities* controller = [AdminCities new];
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
    [controller release];
     */
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    
    AdminCities* controller = [[[AdminCities alloc] initWithNibName:@"AdminCities" bundle:nil] autorelease];
    delegate.window.rootViewController = controller;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section
{
	return [thisCity.forecasts count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 41;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(indexPath.row < thisCity.forecasts.count - 1)
    {
        static NSString *CellIdentifier = @"Cell";
        
        cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; 
        } 
        
        int indice = indexPath.row + 1;
        UILabel *scoreLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(0, 0.0, 100.0, 43.0) ];
        Forecast * forecast = [thisCity.forecasts objectAtIndex:indice];
        scoreLabel.backgroundColor = [UIColor clearColor];
        scoreLabel.textColor = [UIColor whiteColor];
        
        if(indice == 1)
        {
            scoreLabel.text = NSLocalizedString (@"Today", @"");
                    }
        else if( indice == 2)
        {
           scoreLabel.text = NSLocalizedString(@"Tomorrow", @""); 
        }
        else
        {
            NSString * fecha =  (NSString *) forecast.date;
            NSDate * date = [[Config getInstance] getTimeDateFromString:fecha];
            scoreLabel.text = [[Config getInstance] dayOfWeek:date];
        }
        [cell.contentView addSubview:scoreLabel];
        
        UIImageView * imagen = [[UIImageView alloc] initWithFrame:CGRectMake(110, 0, 28, 28)];
        imagen.image = [UIImage imageNamed: [[Config getInstance] ImageName:forecast.status]];
        
        [cell.contentView addSubview:imagen];
        
        UILabel *maxminLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(180, 0.0, 100.0, 43.0) ];
        NSString * strmaxmin = @" %dº    %dº";
        maxminLabel.text = [NSString stringWithFormat:strmaxmin, forecast.max, forecast.min];
        maxminLabel.backgroundColor = [UIColor clearColor];
        maxminLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:maxminLabel];
    }
    else
    {
        static NSString *CellIdentifier = @"Cell-1";
        
        
        cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; 
        }
        
        UILabel *refreshLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(0, 0.0, 230.0, 43.0) ];
        refreshLabel.textAlignment = NSTextAlignmentCenter;
        refreshLabel.backgroundColor = [UIColor clearColor];
        NSString * dateup = [[Config getInstance] dateToStringAR:thisCity.lastDateUpdate];
        refreshLabel.text = NSLocalizedString(@"LblActualizar", @"");
        refreshLabel.text = [refreshLabel.text stringByAppendingString:dateup];
        refreshLabel.font = [UIFont systemFontOfSize:12];
        refreshLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:refreshLabel];
        
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        infoButton.frame = CGRectMake(240, 8, 30, 30);
        [infoButton addTarget:self action:@selector(adminCities) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:infoButton];
        
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryNone;
}


@end
