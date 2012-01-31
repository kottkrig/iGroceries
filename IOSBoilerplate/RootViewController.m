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

@implementation RootViewController

@synthesize table;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Groceries";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [SVProgressHUD showInView:self.view];
    
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://groceries-server.herokuapp.com/getList?listId=1"]];
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
    
    UIViewController* vc = nil;
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                vc = [[HTTPHUDExample alloc] init];
                break;
                
            case 1:
                vc = [[AsyncImageExample alloc] init];
                break;
                
            case 2:
                vc = [[AsyncCellImagesExample alloc] init];
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                vc = [[VariableHeightExample alloc] init];
                break;
                
            case 1:
                vc = [[PullDownExample alloc] init];
                break;
                
            case 2:
                vc = [[SwipeableTableViewExample alloc] init];
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                vc = [[DirectionsExample alloc] init];
                break;
                
            case 1:
                vc = [[AutocompleteLocationExample alloc] init];
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 3) {
        switch (indexPath.row) {
            case 0:
                vc = [[BrowserSampleViewController alloc] init];
                break;
                
            default:
                break;
        }
    }
    
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }

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
