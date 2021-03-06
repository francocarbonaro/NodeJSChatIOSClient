//
//  ViewController.h
//  NodeJSChat
//
//  Created by Franco Carbonaro on 3/10/14.
//  Copyright (c) 2014 Franco Carbonaro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UITextField *messageTextField;
@property (nonatomic, weak) IBOutlet UIButton *sendButton;

- (IBAction)sendButtonTouched:(id)sender;

@end
