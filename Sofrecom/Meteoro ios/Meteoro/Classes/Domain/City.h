//
//  City.h
//  Meteoro
//
//  Created by Julio Andrés Carrettoni on 30/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Model.h"
#import "ViewController.h"

@class JSONASIHTTPRequest;
@interface City : Model
{
    JSONASIHTTPRequest* forecastResquest;
    int orden;
}

@property (nonatomic, retain) NSString* code;
@property (nonatomic, retain) NSString* name;
@property (nonatomic) BOOL temperatura;
@property (nonatomic) BOOL humedad;
@property (nonatomic) BOOL presion;
@property (nonatomic) BOOL sensacionTermica;
@property (nonatomic) BOOL rayos;
@property (nonatomic) int orden;
@property (nonatomic, retain) ViewController* controllerCallback;
@property (nonatomic, retain) NSDate* lastDateUpdate;

@property (nonatomic, retain) NSArray* forecasts;

- (void) refreshForecast;

@end
