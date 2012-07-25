//
//  AdminCities.h
//  Meteoro
//
//  Created by domiguel on 11/07/12.
//
//

#import <UIKit/UIKit.h>

@interface AdminCities : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UINavigationBar *fakeNavBar;
    IBOutlet UITableView *citiesTable;
    
}

- (IBAction)onAddCityButtonTUI:(id)sender;
- (IBAction)onOkButtonTUI:(id)sender;

@end
