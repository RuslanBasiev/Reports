//
//  NewEmployeeController.h
//  Reports
//
//  Created by Mac on 20.03.14.
//  Copyright (c) 2014 RuslanBasiev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewEmployeeController : UITableViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property(weak, nonatomic)NSArray *offices;

@end
