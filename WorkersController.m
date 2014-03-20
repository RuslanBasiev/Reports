//
//  WorkersController.m
//  Reports
//
//  Created by Mac on 20.03.14.
//  Copyright (c) 2014 RuslanBasiev. All rights reserved.
//

#import "WorkersController.h"
#import <Parse/Parse.h>

#import "NewEmployeeController.h"
#import "EmployeeDelailController.h"

@interface WorkersController ()
{
    NSArray *offices;
    NSArray *users;
    
    BOOL officesGained;
    BOOL usersGained;
    
    PFUser *user;
}

@end

@implementation WorkersController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self requestOffices];
    [self requestUsers];
}

-(void)requestUsers
{
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", (int)[objects count]);
            // Do something with the found objects
            users = objects;
            usersGained = YES;
            if (usersGained && officesGained) {
                [self.tableView reloadData];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)requestOffices
{
    PFQuery *query = [PFQuery queryWithClassName:@"Office"];
    [query orderByAscending:@"name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", (int)[objects count]);
            // Do something with the found objects
            offices = objects;
            officesGained = YES;
            if (usersGained && officesGained) {
                [self.tableView reloadData];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    user = [users objectAtIndex:indexPath.row];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [offices count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [users filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"office == %@",[offices objectAtIndex:section][@"name"]]];
    
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSArray *array = [users filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"office == %@",[offices objectAtIndex:indexPath.section][@"name"]]];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[array objectAtIndex:indexPath.row][@"fio"], [users objectAtIndex:indexPath.row][@"office"]];
    
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    view.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 240, 30)];
    title.text = [NSString stringWithFormat:@"Филиал %@",[offices objectAtIndex:section][@"name"]];
    title.textColor = [UIColor whiteColor];
    
    [view addSubview:title];
    
    return view;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"newEmployeeSegue"]) {
        NewEmployeeController *newController = [segue destinationViewController];
        newController.offices = offices;
    } else
    {
        EmployeeDelailController *detail = [segue destinationViewController];
        detail.user = user;
    }
    

}


@end
