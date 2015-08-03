//
//  ChooseClient.h
//  LawyerDiary
//
//  Created by Verma Mukesh on 22/07/15.
//  Copyright © 2015 Singularsllp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Client.h"
#import "Court.h"

@protocol ChooseClientDelegate <NSObject>
@optional
- (void)clientSelected:(Client *)clientObj;

@end

@interface ChooseClient : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UILabel *lblErrorMsg;
}

@property (nonatomic, strong) id<ChooseClientDelegate> delegate;

@property (nonatomic, strong) Client *existingClientObj;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
