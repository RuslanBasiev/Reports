//
//  ReportsController.m
//  Reports
//
//  Created by Mac on 19.03.14.
//  Copyright (c) 2014 RuslanBasiev. All rights reserved.
//

#import "ReportsController.h"

@interface ReportsController ()
{
    NSDictionary *offices;
    NSArray *officesTitles;
    
    NSDate *date;
    UITextField *titleTextField;
}

@end

@implementation ReportsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    offices = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"offices" withExtension:@"plist"]];
    
    officesTitles = [offices allKeys];
    officesTitles = [officesTitles sortedArrayUsingSelector:@selector(localizedCompare:)];
    
    titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 180, 21)];
    titleTextField.textAlignment = NSTextAlignmentCenter;
    titleTextField.delegate = self;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    titleTextField.text = [dateFormatter stringFromDate:[NSDate date]];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
    datePicker.maximumDate = [NSDate date];
    datePicker.minimumDate = [dateFormatter dateFromString:@"01 января 2014 г."];
    titleTextField.inputView = datePicker;
    

    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleBordered target:self action:@selector(dateChanged:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Отмена" style:UIBarButtonItemStyleBordered target:self action:@selector(dateCancel:)];
    
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    [toolbar setItems:@[cancelButton, flexibleSpace, doneButton]];
    titleTextField.inputAccessoryView = toolbar;
    
    
    [self.navigationItem setTitleView:titleTextField];
}

-(void)dateCancel:(id)sender
{
    [titleTextField endEditing:YES];
}

-(void)pickerChanged:(UIDatePicker*)sender
{
    date = sender.date;
}

-(void)dateChanged:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    titleTextField.text = [dateFormatter stringFromDate:date];
    [titleTextField endEditing:YES];
}

#pragma mark - Text field delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIDatePicker *datePicker = (UIDatePicker*)textField.inputView;
    datePicker.date = [NSDate date];
    date = datePicker.date;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [officesTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[offices objectForKey:[officesTitles objectAtIndex:section]] count];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    view.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 240, 30)];
    title.text = [NSString stringWithFormat:@"Филиал %@",[officesTitles objectAtIndex:section]];
    title.textColor = [UIColor whiteColor];
    
    [view addSubview:title];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSArray *employees = [offices objectForKey:[officesTitles objectAtIndex:indexPath.section]];
    cell.textLabel.text = [employees objectAtIndex:indexPath.row];
    
    cell.detailTextLabel.text = @"в ожидании";
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [titleTextField endEditing:YES];
}


@end
