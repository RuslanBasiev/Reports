//
//  NewEmployeeController.m
//  Reports
//
//  Created by Mac on 20.03.14.
//  Copyright (c) 2014 RuslanBasiev. All rights reserved.
//

#import "NewEmployeeController.h"
#import <Parse/Parse.h>

@interface NewEmployeeController ()
{
    NSString *fio;
    NSString *username;
    NSString *password;
    NSString *phone;
    NSString *office;
}
@end


@implementation NewEmployeeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    office = [_offices objectAtIndex:0];
}

-(BOOL)checkData
{
    return (fio.length > 0 &&
            username.length > 0 &&
            password.length > 0 &&
            phone.length > 0 &&
            office.length > 0);
}

//pickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.offices count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.offices objectAtIndex:row][@"name"];
}

//textField
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
            fio = textField.text;
            break;
        case 2:
            username = textField.text;
            break;
        case 3:
            password = textField.text;
            break;
        case 4:
            phone = textField.text;
            break;
            
        default:
            break;
    }
}


- (IBAction)doneBtnHandler:(id)sender
{
    [self.tableView endEditing:YES];
    
    if ([self checkData]) {
        PFUser *user = [PFUser user];
        user.username = username;
        user.password = password;
        user.email = username;
        user[@"phone"] = phone;
        user[@"office"] = office;
        user[@"fio"] = fio;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Hooray! Let them use the app now.
                NSLog(@"success");
            } else {
                NSString *errorString = [error userInfo][@"error"];
                NSLog(@"%@",errorString);
            }
        }];
    }
    else NSLog(@"error");
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    office = [_offices objectAtIndex:row][@"name"];
}

@end
