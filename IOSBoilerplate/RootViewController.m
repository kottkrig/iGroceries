//
//  RootViewController.m
//  IOSBoilerplate
//
//  Copyright (c) 2011 Alberto Gimeno Brieba
//  
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//  

#import "RootViewController.h"
#import "HTTPHUDExample.h"
#import "AsyncImageExample.h"
#import "AsyncCellImagesExample.h"
#import "VariableHeightExample.h"
#import "DirectionsExample.h"
#import "AutocompleteLocationExample.h"
#import "PullDownExample.h"
#import "SwipeableTableViewExample.h"
#import "BrowserSampleViewController.h"

#import "SVProgressHUD.h"
#import "JSONKit.h"
#import "DictionaryHelper.h"
#import "AFJSONRequestOperation.h"
#import "Constants.h"


@implementation RootViewController

@synthesize table;
@synthesize addField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Groceries";
    
    [self updateList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];        
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (items != nil) {
        return [items count];
    }
    
    return 0;
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (items != nil) {
        cell.textLabel.text = [items objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
    NSString *item = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
    [self removeItemFromList:item];
}

- (void)removeItemFromList:(NSString *)item
{
    [SVProgressHUD showInView:self.view];
    
    NSString *requestString = [NSString stringWithFormat:@"%@/list/%i/", serverUrl, listId, item];
    NSURL *remoteUrl = [NSURL URLWithString:requestString];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:remoteUrl];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"DELETE" path:item parameters:nil];
        
    AFHTTPRequestOperation *operation = [AFHTTPRequestOperation HTTPRequestOperationWithRequest:request success:^(id status) {
        
        [SVProgressHUD dismissWithSuccess:@"Removed!"];
        [self updateList];
        
    } failure:^(NSHTTPURLResponse *response, NSError *error) {
        [SVProgressHUD dismissWithError:[error localizedDescription]];
        NSLog([error localizedDescription]);
    }];
    [operation start];
}

- (void)updateList
{
    [SVProgressHUD showInView:self.view];
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@/list/%i", serverUrl, listId];
    
    NSLog(requestUrl);
        
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        items = [[JSON arrayForKey:@"items"] retain];
        NSLog(@"items.count: %i",items.count);
        
        [self.table reloadData];
        [SVProgressHUD dismissWithSuccess:@"Ok!"];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [SVProgressHUD dismissWithError:[error localizedDescription]];
    }];
    [operation start];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //[textField resignFirstResponder];
    
    NSLog(@"Trying to add something!");
    
    [self addItemToList:textField.text];
    
    
    return YES;
}

- (void)addItemToList:(NSString *)item
{
    [SVProgressHUD showInView:self.view];
    
    NSLog(item);
    
    NSURL *remoteUrl = [NSURL URLWithString:serverUrl];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:item forKey:@"item"];
    
    NSString *path = [NSString stringWithFormat:@"list/%i", listId];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:remoteUrl];
    NSURLRequest *request = [httpClient requestWithMethod:@"POST" path:path parameters:parameters];
    
    
    
    //NSLog([NSString stringWithFormat:@"Request: %@", [[request HTTPBody]]);
    
    AFHTTPRequestOperation *operation = [AFHTTPRequestOperation HTTPRequestOperationWithRequest:request success:^(id status) {
        
        [SVProgressHUD dismissWithSuccess:@"Added!"];
        [self updateList];
        
    } failure:^(NSHTTPURLResponse *response, NSError *error) {
        [SVProgressHUD dismissWithError:[error localizedDescription]];
        NSLog([error localizedDescription]);
    }];
    [operation start];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [table release];
    
    [super dealloc];
}

@end
