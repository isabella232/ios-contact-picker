//
//  CContact.h
//  SinchAppToPhoneTutorial
//
//  Created by Ali Minty on 5/17/15.
//  Copyright (c) 2015 Ali Minty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CContact : NSObject
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *mobileNumber;
@property (nonatomic, copy) NSString *homeNumber;

+ (id)createContactWithFirst:(NSString *)firstName Last:(NSString *)lastName
                MobileNumber:(NSString *)mobileNumber HomeNumber:(NSString *)homeNumber;
@end
