//
//  MasterViewController.m
//  SinchAppToPhoneTutorial
//
//  Created by Ali Minty on 5/17/15.
//  Copyright (c) 2015 Ali Minty. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#import "CContact.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){
        //1
        UIAlertView *cantAddContactAlert = [[UIAlertView alloc] initWithTitle: @"Cannot Add Contact" message: @"You must give the app permission to add the contact first." delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [cantAddContactAlert show];
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        //2
        [self fillContacts];
    } else{ //ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined
        //3
        ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!granted){
                    //4
                    UIAlertView *cantAddContactAlert = [[UIAlertView alloc] initWithTitle: @"Cannot Add Contact" message: @"You must give the app permission to add the contact first." delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
                    [cantAddContactAlert show];
                    return;
                }
                //5
                [self fillContacts];
            });
        });
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CContact *object = self.objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    CContact *object = self.objects[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [object firstName], [object lastName]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void) fillContacts {

    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, nil);
    
    NSArray *allContacts = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    for (id record in allContacts){
        ABRecordRef thisContact = (__bridge ABRecordRef)record;
        
        NSString *fName;
        NSString *lName;
        NSString *mNumber;
        NSString *hNumber;
        
        int numberCount = 0;
        
        ABMultiValueRef phonesRef = ABRecordCopyValue(thisContact, kABPersonPhoneProperty);
        
        if (ABMultiValueGetCount(phonesRef) > 0) {
            fName = (__bridge NSString *)ABRecordCopyValue(thisContact, kABPersonFirstNameProperty);
            lName = (__bridge NSString *)ABRecordCopyValue(thisContact, kABPersonLastNameProperty);
            for (int i=0; i < ABMultiValueGetCount(phonesRef); i++) {
                CFStringRef phoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
                CFStringRef phoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
                
                NSString *phoneNumber = (__bridge NSString *)phoneValue;
                
                // parse out unwanted characters in number
                NSString *parsedPhoneNumber;
                for (int i = 0; i < phoneNumber.length; i++) {
                    char currentChar = [phoneNumber characterAtIndex:i];
                    if (currentChar >= '0' && currentChar <= '9') {
                        NSString *digitString = [NSString stringWithFormat:@"%c",currentChar];
                        if (parsedPhoneNumber.length == 0) {
                            parsedPhoneNumber = [NSString stringWithString:digitString];
                        }
                        else{
                            NSString * newString = [parsedPhoneNumber stringByAppendingString:digitString];
                            parsedPhoneNumber = [NSString stringWithString:newString];
                        }
                    }
                }
                
                // check if number is foreign
                if ((parsedPhoneNumber.length < 11)
                    || (parsedPhoneNumber.length == 11 && [parsedPhoneNumber hasPrefix:@"1"])) {
                    
                    numberCount++;
                    
                    if (CFStringCompare(phoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
                        mNumber = phoneNumber;
                    }
                    
                    if (CFStringCompare(phoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
                        hNumber = phoneNumber;
                    }
                }
                
                CFRelease(phoneLabel);
                CFRelease(phoneValue);
            }
            
            if (numberCount > 0) {
                CContact *newContact = [CContact createContactWithFirst:fName Last:lName MobileNumber:mNumber HomeNumber:hNumber];
                
                if (!self.objects) {
                    self.objects = [[NSMutableArray alloc] init];
                }
                [self.objects addObject:newContact];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_objects.count-1 inSection:0];
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView reloadData];
            }

        }
        
        CFRelease(phonesRef);

        
    }

}

@end
