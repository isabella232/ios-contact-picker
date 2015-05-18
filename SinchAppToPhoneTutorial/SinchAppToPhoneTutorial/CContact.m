//
//  CContact.m
//  SinchAppToPhoneTutorial
//
//  Created by Ali Minty on 5/17/15.
//  Copyright (c) 2015 Ali Minty. All rights reserved.
//

#import "CContact.h"

@implementation CContact
+ (id)createContactWithFirst:(NSString *)firstName Last:(NSString *)lastName
                MobileNumber:(NSString *)mobileNumber HomeNumber:(NSString *)homeNumber
/*HomeEmail:(NSString *)homeEmail WorkEmail:(NSString *)workEmail
 Address:(NSString *)address Zipcode:(NSString *)zipcode City:(NSString *)city*/
{
    CContact *newContact = [[self alloc] init];
    [newContact setFirstName:firstName];
    [newContact setLastName:lastName];
    [newContact setMobileNumber:mobileNumber];
    [newContact setHomeNumber:homeNumber];
    /*[newContact setHomeEmail:homeEmail];
     [newContact setWorkEmail:workEmail];
     [newContact setAddress:address];
     [newContact setZipcode:zipcode];
     [newContact setCity:city];*/
    return newContact;
}

@end
