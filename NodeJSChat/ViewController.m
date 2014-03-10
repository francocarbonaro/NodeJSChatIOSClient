//
//  ViewController.m
//  NodeJSChat
//
//  Created by Franco Carbonaro on 3/10/14.
//  Copyright (c) 2014 Franco Carbonaro. All rights reserved.
//

#import "ViewController.h"
#import "SocketIO.h"
#import "SocketIOPacket.h"

@interface ViewController () <SocketIODelegate>
@property (nonatomic, strong) SocketIO *socketIO;
@property (nonatomic, strong) NSMutableArray *messages;

- (NSDictionary *)messageDictionaryFromPacketData:(SocketIOPacket *)packet;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.socketIO = [[SocketIO alloc] initWithDelegate:self];
    
    [self.socketIO connectToHost:@"localhost" onPort:3700];
    
    self.messages = [NSMutableArray new];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (NSDictionary *)messageDictionaryFromPacketData:(SocketIOPacket *)packet {
    if (![packet.data isEqualToString:@""]) {
        NSData *jsonData = [packet.data dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
        
        return [[json objectForKey:@"args"] firstObject];
    }
    
    return nil;
}

#pragma mark - Public Methods 

- (IBAction)sendButtonTouched:(id)sender {
    NSDictionary *message = @{@"message" : self.messageTextField.text, @"username" : @"ios"};
    
    [self.socketIO sendEvent:@"send" withData:message];
}

#pragma mark - SocketIODelegate

- (void)socketIO:(SocketIO *)socket didSendMessage:(SocketIOPacket *)packet {
    self.messageTextField.text = @"";
}

- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet {
    NSDictionary *message = [self messageDictionaryFromPacketData:packet];
    
    [self.messages addObject:message];
    
    [self.tableView reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self. messages count] - 1
                                         inSection:0];

    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}

- (void) socketIO:(SocketIO *)socket onError:(NSError *)error {
    NSLog(@"%@", error);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dictionary = [self.messages objectAtIndex:indexPath.row];
    
    NSString *username = (![dictionary objectForKey:@"username"]) ? @"Server" : [dictionary objectForKey:@"username"];
    
    NSString *message = [dictionary objectForKey:@"message"];

    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", username, message];
    
    return cell;
}

@end
