//
//  DetailViewController.h
//  SinchAppToPhoneTutorial
//
//  Created by Ali Minty on 5/17/15.
//  Copyright (c) 2015 Ali Minty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Sinch/Sinch.h>
#import "CContact.h"

@interface DetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, SINCallClientDelegate>

@property (strong, nonatomic) CContact *detailItem;
@property (weak, nonatomic) IBOutlet UITableView *numberTable;
@property (weak, nonatomic) IBOutlet UINavigationItem *contactTitle;


@end

