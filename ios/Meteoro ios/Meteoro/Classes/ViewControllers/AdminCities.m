//
//  AdminCities.m
//  Meteoro
//
//  Created by domiguel on 11/07/12.
//
//

#import "AdminCities.h"
#import "AddCityViewController.h"
#import "Config.h"
#import "City.h"
#import "ViewController.h"
#import "AppDelegate.h"





@interface AdminCities ()

@end

@implementation AdminCities

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    citiesTable.backgroundColor = [UIColor clearColor];
    citiesTable.opaque = NO;
    citiesTable.backgroundView = nil;
    
    if([Config getInstance].cities.count == 0)
        citiesTable.hidden = YES;
    else citiesTable.hidden = NO;

    
    UINavigationItem * titleItem = [fakeNavBar.items objectAtIndex:0];
    titleItem.title = NSLocalizedString(@"TituloAgregarCiudad", @"");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL) animated
{
    [super viewWillAppear:animated];
    [citiesTable reloadData];
    [self EnableRightButton];
    
    if([Config getInstance].cities.count == 0)
        citiesTable.hidden = YES;
    else citiesTable.hidden = NO;

    
    //[theCarousel reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onAddCityButtonTUI:(id)sender {
    AddCityViewController* controller = [AddCityViewController new];
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:controller animated:YES];
    [controller release];
}

- (IBAction)onOkButtonTUI:(id)sender {
    
    
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    
    ViewController* controller = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    delegate.window.rootViewController = controller;

    /*
    ViewController* controller = [ViewController new];
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
    [controller release];*/
}

-(void) EnableRightButton
{
    UINavigationItem * rightItem = [fakeNavBar.items objectAtIndex:0];
    if([Config getInstance].cities.count > 0)
    {
        rightItem.rightBarButtonItem.enabled = YES;
    }
    else
    { 
        rightItem.rightBarButtonItem.enabled = NO;
    }
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section
{
	return [Config getInstance].cities.count;
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    static NSString *CellIdentifier = @"Cell";
    
    cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; 
    }
    
    City * city = [[Config getInstance].cities objectAtIndex:indexPath.row];
    
    cell.textLabel.text = city.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
    
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Perform delete here
        [[Config getInstance] RemoveCity:indexPath.row];

        [citiesTable reloadData];
        [self EnableRightButton];
        
        if([Config getInstance].cities.count == 0)
            citiesTable.hidden = YES;
        else citiesTable.hidden = NO;
        
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleDelete;
}

@end
