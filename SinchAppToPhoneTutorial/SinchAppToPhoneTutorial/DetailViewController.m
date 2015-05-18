//
//  DetailViewController.m
//  SinchAppToPhoneTutorial
//
//  Created by Ali Minty on 5/17/15.
//  Copyright (c) 2015 Ali Minty. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController (){
    id<SINClient> _client;
    id<SINCall> _call;
}
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.contactTitle.title = [NSString stringWithFormat:@"%@ %@", [self.detailItem firstName], [self.detailItem lastName]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    [_numberTable setDelegate:self];
    [_numberTable setDataSource:self];
    
    [self initSinchClient];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Phone Numbers";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    NSString *cellText = @"";
    NSString *detailText = @"";
    
    
    switch (indexPath.row) {
        case 0:
            cellText = [self.detailItem mobileNumber];
            detailText = @"Mobile Number";
            break;
        case 1:
            cellText = [self.detailItem homeNumber];
            detailText = @"Home Number";
            break;
    }
    
    cell.textLabel.text = cellText;
    cell.detailTextLabel.text = detailText;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *alertTitle = [NSString stringWithFormat:@"Calling %@...", [self.detailItem firstName]];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *alertMessage = cell.textLabel.text;
    
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:@"Hang up" otherButtonTitles:nil];
    
    [messageAlert show];
    
    // parse out unwanted characters in number
    NSString *parsedPhoneNumber;
    for (int i = 0; i < alertMessage.length; i++) {
        char currentChar = [alertMessage characterAtIndex:i];
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
    
    NSString *number;
    if (parsedPhoneNumber.length == 10) {
        number = [NSString stringWithFormat:@"+1%@", parsedPhoneNumber];
    }
    else {
        number = [NSString stringWithFormat:@"+%@", parsedPhoneNumber];
    }
    
    if (_call == nil)
    {
        _call = [[_client callClient] callPhoneNumber:number];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)initSinchClient
{
    _client = [Sinch clientWithApplicationKey:@"a69b6373-a67b-4de5-906f-0b6e43580187"
                            applicationSecret:@"aU9oIYRpi06Ku850EWjd3A=="
                              environmentHost:@"sandbox.sinch.com"
                                       userId:@"phoneCaller"];
    _client.callClient.delegate = self;
    [_client setSupportCalling:YES];
    [_client start];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
        [_call hangup];
}


@end
