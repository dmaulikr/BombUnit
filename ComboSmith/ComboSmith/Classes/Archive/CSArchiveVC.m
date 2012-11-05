//
//  CSArchiveVC.m
//  ComboSmith
//
//  Created by Erran Carey on 3/12/12.
//  Copyright (c) 2012 app2o. All rights reserved.
//

#import "CSArchiveVC.h"
#import <sqlite3.h>
#define DATABASE_NAME @"combos.sqlite"
#define DATABASE_TITLE @"combos"

static int comboss(void *context, int count, char **values, char **columns)
{
    NSMutableArray *butts = (NSMutableArray *)context;
    for (int i=0; i < count; i++) {
        const char *comboCString = values[i];
        [butts addObject:[NSString stringWithUTF8String:comboCString]];
    }
    return SQLITE_OK;
}

#pragma mark Private Interface
@interface CSArchiveVC(Private)
-(void)createEditableCopyOfDatabaseIfNeeded;
-(void)saveData:(NSString *)data;
-(void)findCombos;
-(void)updateTextViewContents;
@end

@implementation CSArchiveVC

//Columns:
@synthesize column1;
@synthesize column2;
@synthesize column3;
@synthesize column4;
@synthesize column5;
@synthesize column6;
//Data:
@synthesize testData;
@synthesize listData;
//Vars:
@synthesize combo;
@synthesize toBeSavedCombo;
@synthesize name;
@synthesize valueOfRow;
@synthesize splitMeCombo;
@synthesize comboArray;
@synthesize numberOfColumns;
//Picker:
@synthesize picker;
//Buttons:
@synthesize editComboButton;
@synthesize savedComboButton;
@synthesize savedSessionsButton;

- (IBAction)initiateSave{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Combination" message:@"Do you want to add a new combination?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    alert.tag = 0;
    [alert show];
    [alert release];
}

- (void) saveCombo

{
    sqlite3_stmt    *statement;
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"combos.sqlite"]];
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &comboDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO combos (name, combo, cperm, session) VALUES (\"%@\", \"%@\",\"%i\",\"%i\")", self.name, self.toBeSavedCombo, 0, 0];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(comboDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            self.name = @"";
            self.toBeSavedCombo = @"";
        }
        sqlite3_finalize(statement);
        sqlite3_close(comboDB);
    }
    listData = nil;
    listData = [[NSMutableArray alloc] init];
    ////NSLog(@"This actually does something...");
    [self findCombos];
    ////NSLog(@"ListData: %@",listData);
    //[self updateTextViewContents];
    [table reloadData];
    [databasePath release];
}
// Split the individual array items

- (void) splitArrayItems{

        NSMutableArray *digits = [[NSMutableArray alloc] initWithCapacity:[self.combo length]];
        for (int i=0; i < [self.combo length]; i++){
            NSString *digit = [NSString stringWithFormat:@"%c", [self.combo characterAtIndex:i]];
            [digits addObject:digit];
        }
    self.numberOfColumns = [digits count];
    ////NSLog(@"Digits >> %@",digits);
    self.testData = digits;
    
    for(int i = 0; i < [self.testData count];i++){
        [picker selectRow:[[self.testData objectAtIndex:i] intValue]+3 inComponent:i animated:YES];
        [picker reloadAllComponents];
    }
    [digits release];
}

- (void) showPerms{
    for(int i = 0; i < [self.testData count];i++){
        [self.picker selectRow:[[self.testData objectAtIndex:i] intValue]+3 inComponent:i animated:YES];
        [self.picker reloadAllComponents];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    listData = nil;
    listData = [[NSMutableArray alloc] init];
    //NSLog(@"This actually does something...");
    [self findCombos];
    //NSLog(@"ListData: %@",listData);
    [table reloadData];
}
    
- (void)tableReload{
NSString *file = [self getWritableDBPath];
NSFileManager *fileManager = [NSFileManager defaultManager];
BOOL success = [fileManager fileExistsAtPath:file]; 

// If its not a local copy set it to the bundle copy
if(!success) {
    //file = [[NSBundle mainBundle] pathForResource:DATABASE_TITLE ofType:@"db"];
    [self createEditableCopyOfDatabaseIfNeeded];
}

sqlite3 *database = NULL;
if (sqlite3_open([file UTF8String], &database) == SQLITE_OK) {
    NSString *selstmt = [[NSString alloc] initWithFormat:@"SELECT COMBO FROM COMBOS WHERE NAME=\"%@\"", valueOfRow];
    const char *newselstmt = [selstmt UTF8String];
    sqlite3_exec(database, newselstmt, comboss, comboArray, NULL);
    [selstmt release];
}
combo = [comboArray objectAtIndex:0];
[self splitArrayItems];
[comboArray removeObjectAtIndex:0];
sqlite3_close(database);
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    // Setup the array
	//listData = [[NSMutableArray alloc] init];
	comboArray = [[NSMutableArray alloc] init];
    
	
    //[self findCombos];
    //[self updateTextViewContents];
    
    //Making the picker small...
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 320.0, 120.0)]; 
    [self.view addSubview:picker];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    picker.userInteractionEnabled = NO;
    [self showPerms];
    
    // Do any additional setup after loading the view.
    self.numberOfColumns = 6;
    self.testData = [NSArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0", nil];
    //Declares variables to point towards specified images. 
    UIImage *blank  = [UIImage imageNamed:@"*.png"];
    UIImage *zero   = [UIImage imageNamed:@"0.png"];
    UIImage *one    = [UIImage imageNamed:@"1.png"];
    UIImage *two    = [UIImage imageNamed:@"2.png"];
    UIImage *three  = [UIImage imageNamed:@"3.png"];
    UIImage *four   = [UIImage imageNamed:@"4.png"];
    UIImage *five   = [UIImage imageNamed:@"5.png"];
    UIImage *six    = [UIImage imageNamed:@"6.png"];
    UIImage *seven  = [UIImage imageNamed:@"7.png"];
    UIImage *eight  = [UIImage imageNamed:@"8.png"];
    UIImage *nine   = [UIImage imageNamed:@"9.png"];    
    
    //i is one of the numbers that determine the number of columns.
    //This also allocates the picker images.
    for (int i = 1; i <= self.numberOfColumns; i++) { 
        UIImageView *blank1View = [[UIImageView alloc] initWithImage:blank];
        UIImageView *blank2View = [[UIImageView alloc] initWithImage:blank];
        UIImageView *blank3View = [[UIImageView alloc] initWithImage:blank];
        UIImageView *zeroView   = [[UIImageView alloc] initWithImage:zero];
        UIImageView *oneView    = [[UIImageView alloc] initWithImage:one];
        UIImageView *twoView    = [[UIImageView alloc] initWithImage:two];
        UIImageView *threeView  = [[UIImageView alloc] initWithImage:three];
        UIImageView *fourView   = [[UIImageView alloc] initWithImage:four];
        UIImageView *fiveView   = [[UIImageView alloc] initWithImage:five];
        UIImageView *sixView    = [[UIImageView alloc] initWithImage:six];
        UIImageView *sevenView  = [[UIImageView alloc] initWithImage:seven];
        UIImageView *eightView  = [[UIImageView alloc] initWithImage:eight];
        UIImageView *nineView   = [[UIImageView alloc] initWithImage:nine];
        UIImageView *blank4View = [[UIImageView alloc] initWithImage:blank];
        UIImageView *blank5View = [[UIImageView alloc] initWithImage:blank];
        UIImageView *blank6View = [[UIImageView alloc] initWithImage:blank];
        NSArray *imageViewArray = [[NSArray alloc] initWithObjects:
                                   blank1View, blank2View, blank3View, zeroView, oneView, 
                                   twoView, threeView, fourView, fiveView, sixView, sevenView, 
                                eightView, nineView, blank4View, blank5View, blank6View, nil];
        
        NSString *fieldName = [[NSString alloc] initWithFormat:@"column%d", i];
        [self setValue:imageViewArray forKey:fieldName];
        [fieldName release];
        [blank1View release];
        [blank2View release];
        [blank3View release];
        [zeroView release];
        [oneView release];
        [twoView release];
        [threeView release];
        [fourView release];
        [fiveView release];
        [sixView release];
        [sevenView release];
        [eightView release];
        [nineView release];
        [blank4View release];
        [blank5View release];
        [blank6View release];
        [imageViewArray release];
    }
    for(int i = 0; i < [self.testData count];i++){
        [picker selectRow:[[self.testData objectAtIndex:i] intValue]+3 inComponent:i animated:YES];
        [picker reloadAllComponents];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.column1    = nil;
    self.column2    = nil;
    self.column3    = nil;
    self.column4    = nil;
    self.column5    = nil;
    self.column6    = nil;
    self.picker     = nil;
}

- (void)dealloc{
    [listData release];
    [comboArray release];
    [super dealloc];
}


#pragma mark Database Stuff

- (NSString *) getWritableDBPath {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:DATABASE_NAME];
}

- (void)findCombos
{
    NSString *file = [self getWritableDBPath];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL success = [fileManager fileExistsAtPath:file]; 
    
	// If its not a local copy set it to the bundle copy
	if(!success) {
		//file = [[NSBundle mainBundle] pathForResource:DATABASE_TITLE ofType:@"db"];
		[self createEditableCopyOfDatabaseIfNeeded];
	}
    
    sqlite3 *database = NULL;
    //listData = nil;
    if (sqlite3_open([file UTF8String], &database) == SQLITE_OK) {
        sqlite3_exec(database, "SELECT NAME FROM COMBOS ORDER BY NAME", comboss, listData, NULL);
    }
    sqlite3_close(database);
}

-(void)createEditableCopyOfDatabaseIfNeeded 
{
    // Testing for existence
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
														 NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DATABASE_NAME];
	
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success)
        return;
	
    // The writable database does not exist, so copy the default to
    // the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath]
							   stringByAppendingPathComponent:DATABASE_NAME];
    success = [fileManager copyItemAtPath:defaultDBPath
								   toPath:writableDBPath
									error:&error];
    if(!success)
    {
        NSAssert1(0,@"Failed to create writable database file with Message : '%@'.",
				  [error localizedDescription]);
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.numberOfColumns;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    return [self.column1 count];
}

// Picker Delegate Methods
- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSString *arrayName = [[NSString alloc] initWithFormat:@"column%d",
                           component+1];
    NSArray *array = [self valueForKey:arrayName];
    [arrayName release];
    return [array objectAtIndex:row];
}

/*Table Methods below.*/

//Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listData count];
    //[tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if(cell==nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier]autorelease];
        UIView *v = [[[UIView alloc] init] autorelease];
        v.backgroundColor = [UIColor cyanColor];
        cell.selectedBackgroundView = v;
        cell.textLabel.highlightedTextColor = [UIColor darkGrayColor];
}
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [listData objectAtIndex:row];
    cell.textLabel.textColor = [UIColor cyanColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
        
    NSUInteger row = [indexPath row];
    NSString *rowValue = [listData objectAtIndex:row];
    //Database junk:
    NSString *file = [self getWritableDBPath];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL success = [fileManager fileExistsAtPath:file]; 
    
	// If its not a local copy set it to the bundle copy
	if(!success) {
		//file = [[NSBundle mainBundle] pathForResource:DATABASE_TITLE ofType:@"db"];
		[self createEditableCopyOfDatabaseIfNeeded];
	}
    
    sqlite3 *database = NULL;
    if (sqlite3_open([file UTF8String], &database) == SQLITE_OK) {
        NSString *delstmt = [[NSString alloc] initWithFormat:@"DELETE FROM COMBOS WHERE NAME=\"%@\"", rowValue];
        const char *newdelstmt = [delstmt UTF8String];
        //NSLog(@"Delete statement: %@",delstmt);
        sqlite3_exec(database, newdelstmt, NULL, NULL, NULL);
        //sqlite3_exec(database, newdelstmt, comboss, rowValue, NULL);
        [delstmt release];
    }
    sqlite3_close(database);
    //Back to the Table View Deleting part
    [self.listData removeObjectAtIndex:row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView reloadData];
}

//Table View Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSUInteger row = [indexPath row];
    NSString *rowValue = [listData objectAtIndex:row];
    valueOfRow = rowValue;
    /*
    NSString *message = [[NSString alloc] initWithFormat:@"You selected %@", rowValue];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Row Selected!" message:message delegate:nil cancelButtonTitle:@"Yes I did" otherButtonTitles:nil];
    [alert show];
    */
    //[self findCombos];
    [self tableReload];
    //listData = nil;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//Alert View clickbutton action
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 0){
        
        if (buttonIndex == 1){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Combination" message:@"Enter a name:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue",nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField * alertTextField = [alert textFieldAtIndex:0];
            alertTextField.keyboardType = UIKeyboardTypeDefault;
            alertTextField.placeholder = @"New Combo";
            alert.tag = 1;
            [alert show];
            [alert release];       
        }
    }
    else if(alertView.tag == 1){
        
        if (buttonIndex == 1){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Combination" message:@"Enter a 3-6 digits:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save",nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField * alertTextField = [alert textFieldAtIndex:0];
            alertTextField.keyboardType = UIKeyboardTypeNumberPad;
            alertTextField.placeholder = @"123456";
            alert.tag = 2;
            [alert show];
            [alert release];        
        }
    }
    else if(alertView.tag == 2){
        
        if (buttonIndex == 1){
            // Database setup needed here. Re-use something that works
            // Insert code.....
            
            /////////////////////////////////////////////////////////////////////////////////////////
            //////// THE DB SETUP CODE BELOW NEEDS TO BE CHANGED TO SOMETHING THAT WORKS ////////////
            //////// SEE CODE THAT LOOKS FOR WRITABLE DATABASE ABOVE ////////////////////////////////
            /////////////////////////////////////////////////////////////////////////////////////////
            NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            
            NSString *docsDir = [dirPaths objectAtIndex:0];
            
            NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"combos.sqlite"]];
            
            const char *dbpath = [databasePath UTF8String];
            [databasePath release];
            sqlite3_stmt    *statement;
            
            if (sqlite3_open(dbpath, &comboDB) == SQLITE_OK)
        
            /////////////////////////////////////////////////////////////////////////////////////////    
            /////////////////////////////////////////////////////////////////////////////////////////   
                
            {
                NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM combos WHERE name=\"%@\"", name]; // Search to see if the name exists in database
                
                const char *query_stmt = [querySQL UTF8String];
                
                if (sqlite3_prepare_v2(comboDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) 
                    
                /////////////////////////////////////////////////////////////////////////////////////
                /////////////////////////////////////////////////////////////////////////////////////
                    
                {
                    if (sqlite3_step(statement) == SQLITE_ROW) // Checks to see if a row is returned
                        
                    /////////////////////////////////////////////////////////////////////////////////
                    /////////////////////////////////////////////////////////////////////////////////
                        
                    {
                    // Alert view should pop-up if the SQL row exists
                    //.. insert code
                        
                                NSString *message = [NSString stringWithFormat:@"%@ is already taken.",name];
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Oops, Sorry!" otherButtonTitles:nil];
                                alert.alertViewStyle = UIAlertViewStyleDefault;
                                alert.tag = 3;
                                [alert show];
                                [alert release];                        
                    }
                    else {
                        
                        /////////////////////////////////////////////////////////////////////////////
                        //Write the new combo to the database
                        //...... insert code
                        ///////////////////////////////////////////////////////////////////////////// 

                        [self saveCombo];
                        
                    }
                    sqlite3_finalize(statement);
                }
                sqlite3_close(comboDB);

            }
        }
        
    }
    else if(alertView.tag = 3){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Combination" message:@"Do you want to add a new combination?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
        alert.tag = 0;
        [alert show];
        [alert release];

    }
}

//Alert View Validation
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertView.tag == 2) {
        self.toBeSavedCombo = [[alertView textFieldAtIndex:0] text];
        if(( [self.toBeSavedCombo length] <= 6 && [self.toBeSavedCombo length] > 2))
        { 
            //NSLog(@"Print this: %@",self.toBeSavedCombo);
            return YES;
        }    
        else 
        {
            //NSLog(@"Don't print this: %@",self.toBeSavedCombo);
            return NO;
        }
    }
    
    else if (alertView.tag == 1){
        self.name = [[alertView textFieldAtIndex:0] text];
        if(([self.name length] > 0))
        { 
            //NSLog(@"Print this: %@",self.name);
            return YES;
        }    
        else //estoy aqui y estaba jugando con los "alertviews"
        {
            //NSLog(@"Don't print this: %@",self.name);
            return NO;
        }
    }
    
    else {
        return YES;
    }
        
}
@end