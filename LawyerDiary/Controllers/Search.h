//
//  Search.h
//  LawyerDiary
//
//  Created by Verma Mukesh on 31/08/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import <UIKit/UIKit.h>

extern BOOL isForSubordinate;

@interface Search : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    NSMutableArray *arrCases;
    NSArray *filteredCasesArray;
    
    IBOutlet UIDatePicker *datePicker;
}

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
