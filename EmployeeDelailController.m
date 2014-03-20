//
//  EmployeeDelailController.m
//  Reports
//
//  Created by Mac on 20.03.14.
//  Copyright (c) 2014 RuslanBasiev. All rights reserved.
//

#import "EmployeeDelailController.h"

@interface EmployeeDelailController ()
{
    NSArray *titles;
    NSArray *keys;
}

@end

@implementation EmployeeDelailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    titles = @[@"ФИО", @"E-mail", @"Телефон", @"Филиал"];
    keys = @[@"fio", @"username", @"phone", @"office"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [titles objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = _user[[keys objectAtIndex:indexPath.row]];
    
    return cell;
}

@end
