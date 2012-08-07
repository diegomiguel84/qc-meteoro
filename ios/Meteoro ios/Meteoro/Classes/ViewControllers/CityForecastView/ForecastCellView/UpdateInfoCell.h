//
//  UpdateInfoCell.h
//  Meteoro
//
//  Created by domiguel on 11/07/12.
//
//

#import <UIKit/UIKit.h>

@interface UpdateInfoCell : UITableViewCell
{
    IBOutlet UIView *view;
    IBOutlet UILabel *lblUpdate;
}

@property (nonatomic, retain) IBOutlet UIView *view;

-(void)setDescription;

@end
