//
//  AddCityViewController.m
//  Meteoro
//
//  Created by Julio Andrés Carrettoni on 30/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddCityViewController.h"
#import "JSONASIHTTPRequest.h"
#import "City.h"
#import "Config.h"
#import "AdminCities.h"

@interface AddCityViewController ()

@end

@implementation AddCityViewController
@synthesize city;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (city)
        selectedCity.text = city.name;
    
    if (selectedCity.text.length > 0)
    {
        [self setOptionsEnabled:YES];
        theSearchBar.hidden = YES;
        settingsViewPanel.frame = CGRectMake(settingsViewPanel.frame.origin.x, 44, settingsViewPanel.frame.size.width, settingsViewPanel.frame.size.height);
    }
    else
    {
        [self setOptionsEnabled:NO];
        theSearchBar.hidden = NO;
    }
    
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear : (BOOL) animated
{
    [super viewWillAppear:animated];
    // Make keyboard pop and enable the "Cancel" button.
    [theSearchBar becomeFirstResponder];
}

- (void)viewDidUnload
{
    [fakeNavBar release];
    fakeNavBar = nil;
    [theSearchBar release];
    theSearchBar = nil;
    [theTableView release];
    theTableView = nil;
    [temperaturaLabel release];
    temperaturaLabel = nil;
    [humedadLabel release];
    humedadLabel = nil;
    [presionLabel release];
    presionLabel = nil;
    [sensacionTermicaLabel release];
    sensacionTermicaLabel = nil;
    [rayosUVLabel release];
    rayosUVLabel = nil;
    [temperaturaSwitch release];
    temperaturaSwitch = nil;
    [humedadSwitch release];
    humedadSwitch = nil;
    [presionSwitch release];
    presionSwitch = nil;
    [sensacionTermicaSwitch release];
    sensacionTermicaSwitch = nil;
    [rayosSwitch release];
    rayosSwitch = nil;
    [selectedCity release];
    selectedCity = nil;
    [blackDIMButton release];
    blackDIMButton = nil;
    [addCityButton release];
    addCityButton = nil;
    [settingsViewPanel release];
    settingsViewPanel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onDoneButtonTUI:(id)sender {
    
    [[Config getInstance] addCity:city];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)onAddCityButtonTUI:(id)sender {
    if (temperaturaSwitch.isOn ||
        humedadSwitch.isOn ||
        presionSwitch.isOn ||
        sensacionTermicaSwitch.isOn ||
        rayosSwitch.isOn)
    {
        city.temperatura = temperaturaSwitch.isOn;
        city.humedad = humedadSwitch.isOn;
        city.presion = presionSwitch.isOn;
        city.sensacionTermica = sensacionTermicaSwitch.isOn;
        city.rayos = rayosSwitch.isOn;
        
        [[Config getInstance] addCity:city];
        [self onDoneButtonTUI:nil];
    }
    else {
        [Config showAlertWithTitle:@"Error" andMessage:@"Please Select at least one item."];
    }
}

- (IBAction)onBackgroundTUI:(id)sender {
    [self.view endEditing:YES];
}

- (void)dealloc {
    [self cancelSearchRequest];
    [fakeNavBar release];
    [theSearchBar release];
    [theTableView release];
    [temperaturaLabel release];
    [humedadLabel release];
    [presionLabel release];
    [sensacionTermicaLabel release];
    [rayosUVLabel release];
    [temperaturaSwitch release];
    [humedadSwitch release];
    [presionSwitch release];
    [sensacionTermicaSwitch release];
    [rayosSwitch release];
    [selectedCity release];
    [addCityButton release];
    [blackDIMButton release];
    [settingsViewPanel release];
    [super dealloc];
}

#pragma mark - table view delagate/datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchResultArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"simple_cell"];
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"simple_cell"] autorelease];
    }    
    cell.textLabel.text = ((City*)[searchResultArray objectAtIndex:indexPath.row]).name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [city release];
    city = nil;
    City* newCity = [searchResultArray objectAtIndex:indexPath.row];
    
    if (![[Config getInstance] ContainsCity:newCity])
    {
        city = [newCity retain];
        theSearchBar.text = city.name;
        if (city)
        {
            [[Config getInstance] addCity:city];
            [self dismissModalViewControllerAnimated:YES];
            /*
             selectedCity.text = city.name;
             [self onBackgroundTUI:nil];
             [self setOptionsEnabled:YES]; */       
        }
    }
    else
    {
        [Config showAlertWithTitle:@"Error" andMessage: NSLocalizedString(@"ErrorCiudadDuplicada", @"")];
    }
    
    [searchResultArray release];
    searchResultArray = nil;
    
    [theTableView reloadData];
    

}

- (void) cancelSearchRequest
{
    [delayTimer invalidate];
    delayTimer = nil;
    searchRequest.delegate = nil;
    [searchRequest cancel];
    [searchRequest release];
    searchRequest = nil;
}

- (NSURL*) getURLSearchQuery
{
    return [[Config getInstance] URLWithString:[NSString stringWithFormat:@"get_cities?contains=%@", [theSearchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (void) performSearch
{
    delayTimer = nil;
    NSURL* searchURL = [self getURLSearchQuery];
    searchRequest = [[JSONASIHTTPRequest requestUsingGetURL:searchURL andCallFinishSelector:@selector(searchRequestFinished:) orFailureSelector:@selector(searchRequestFailed:) inObject:self] retain];
}

#pragma mark - search request landing methods
- (void) searchRequestFinished:(JSONASIHTTPRequest*) request
{
    [searchResultArray release];
    NSArray* array = [(NSArray*)request.theJSONResponse retain];
    NSMutableArray* mutArray = [NSMutableArray array];
    for (NSDictionary* dic in array)
    {
        City* aCity = [[City alloc] initWithDictionary:dic];
        [mutArray addObject:aCity];
        [aCity release];
    }
    searchResultArray = [[NSArray arrayWithArray:mutArray] retain];
    
    [theTableView reloadData];
}

- (void) searchRequestFailed:(JSONASIHTTPRequest*) request
{
    [Config showAlertWithTitle:NSLocalizedString(@"Error", @"") andMessage:NSLocalizedString(@"ErrorServidorNoDisponible", @"")];
}

#pragma mark - search delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //blackDIMButton.hidden = NO;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    //blackDIMButton.hidden = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self cancelSearchRequest];
    if (searchBar.text.length > 0)
    {
        theTableView.hidden = NO;
        delayTimer = [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(performSearch) userInfo:nil repeats:NO];
    }        
    else
    {
        theTableView.hidden = YES;
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)sBar {
    sBar.text = nil;
    [sBar resignFirstResponder];
    
    AdminCities* controller = [AdminCities new];
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:controller animated:YES];
    [controller release];
}

- (void) setOptionsEnabled:(BOOL) enabled
{
    settingsViewPanel.hidden = !enabled;
    temperaturaSwitch.enabled = enabled;
    humedadSwitch.enabled = enabled;
    presionSwitch.enabled = enabled;
    sensacionTermicaSwitch.enabled = enabled;
    rayosSwitch.enabled = enabled;
    addCityButton.enabled = enabled;
}

@end
