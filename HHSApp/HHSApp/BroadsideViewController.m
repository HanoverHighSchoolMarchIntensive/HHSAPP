//
//  BroadsideViewController.m
//  HHSApp
//
//  Created by Sudikoff Lab iMac on 3/19/13.
//  Copyright (c) 2013 Lordtechy. All rights reserved.
//

#import "BroadsideViewController.h"

@interface BroadsideViewController ()

@end

@implementation BroadsideViewController
@synthesize broadsideTableView, rssParser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([stories count]==0){
        [self performSelectorInBackground:@selector(parseXMLFileAtURL:) withObject:@"http://feeds.feedburner.com/HHSBroadside"];
        /*[self parseXMLFileAtURL:@"http://feeds.feedburner.com/HHSBroadside"];*/
    }
    
	// Do any additional setup after loading the view.
    
    
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

//PARSING AREA//

- (void)parseXMLFileAtURL:(NSString *)URL {
    
    stories = [[NSMutableArray alloc] init];
    
	//you must then convert the path to a proper NSURL or it won't work
	NSURL *xmlURL = [NSURL URLWithString:URL];
    
	// here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error
	// this may be necessary only for the toolchain
	rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    
	// Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
	[rssParser setDelegate:self];
    
	// Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
	[rssParser setShouldProcessNamespaces:NO];
    
	[rssParser setShouldReportNamespacePrefixes:NO];
    
	[rssParser setShouldResolveExternalEntities:NO];
    
    
	[rssParser parse];
    
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	//NSLog(@"found file and started parsing");
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %i ). Please try again later.", [parseError code]];
	//NSLog(@"error parsing XML: %@", errorString);
    
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	currentElement = [elementName copy];
    NSLog(@"Current Element: %@", currentElement);
	if ([elementName isEqualToString:@"item"]) {  
		item = [[NSMutableDictionary alloc] init];
		currentTitle = [[NSMutableString alloc] init];
		currentAuthor = [[NSMutableString alloc] init];
		currentSummary = [[NSMutableString alloc] init];
		currentLink = [[NSMutableString alloc] init];
        currentURL = [[NSMutableString alloc]init];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
	//NSLog(@"ended element: %@", elementName);
    
	if ([elementName isEqualToString:@"item"]) { //change this back to id
		// save values to an item, then store that item into the array...
        //NSLog(@"item: %@", item);
        [item setObject:currentTitle forKey:@"title"];
		[item setObject:currentLink forKey:@"link"];
		[item setObject:currentAuthor forKey:@"author"];
        
        
		[stories addObject:[item copy]];
    }
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    NSLog(@"%@: %@", currentElement, string);
    if ([currentElement isEqualToString:@"description"]) {
        return;
    }else if ([currentElement isEqualToString:@"link"]){
        //NSLog(@"LINK: %@", string);
        [currentLink appendString:string];
    }else if ([currentElement isEqualToString:@"title"]) {
		[currentTitle appendString:string];
        //NSLog(@"TITLE: %@", string);
    }else if ([currentElement isEqualToString:@"author"]) {
		[currentAuthor appendString:@"HHS Council"];
        //NSLog(@"Author: %@", string);
    }else if ([currentElement isEqualToString:@"content:encoded"]){
        NSLog(@"Content Encoded: %@", string);
    }else if ([currentElement isEqualToString:@"description"]){
        NSLog(@"Description: %@", string);
    //NSLog(@"For element %@, found characters %@", currentElement, string);
    }
	// save the characters for the current item...
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
    
    //NSLog(@"Stories: %@", stories);
    
    [broadsideTableView reloadData];
    
    
}

//TABLEVIEW AREA//

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSLog(@"Updating table view, stories count: %i", [stories count]);
    
    return [stories count];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    //NSLog(@"Title: %@", [[stories objectAtIndex:[indexPath row]]objectForKey:@"title"]);
    NSMutableString *label = [[NSMutableString alloc]initWithString:[[stories objectAtIndex:[indexPath row]]objectForKey:@"title"]];
    
    //NSString *author = [[stories objectAtIndex:[indexPath row]]objectForKey:@"author"];
    //[label appendString:[NSString stringWithFormat:@" - %@", author]];
    //NSLog(@"Author: %@", author);
    
    [cell.textLabel setText:label];
    [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
    
    return cell;
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
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
}
@end


