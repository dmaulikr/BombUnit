//
//  CSGenerateVC.m
//  ComboSmith
//
//  Created by Erran Carey on 3/10/12.
//  Copyright (c) 2012 app2o. All rights reserved.
//
#import "CSGenerateVC.h"

@implementation CSGenerateVC
//Picker:
@synthesize picker;
//Label which changes to match value:
@synthesize label;
//Columns:
@synthesize column1;
@synthesize column2;
@synthesize column3;
@synthesize column4;
@synthesize column5;
@synthesize column6;
//Buttons
@synthesize generateButton;
@synthesize initialGenerateButton;
@synthesize saveButton;
@synthesize noRepeatNumber;
@synthesize randomNumber;
@synthesize numberOfColumns;
@synthesize testData;
//Database stuff:
@synthesize session;
@synthesize name;
@synthesize combo;
@synthesize cperm;

- (IBAction)initiateSave{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save Combination" message:@"Enter a name:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    alertTextField.placeholder = @"New Combo";
    [alert show];
    alert.tag = 0;
    self.name = [[alert textFieldAtIndex:0]text];
    [alert release];
    NSLog(@"name = %@",name);
}

- (void) saveCombo

{
    sqlite3_stmt    *statement;
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docsDir = [dirPaths objectAtIndex:0];

    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"combos.sqlite"]];
    const char *dbpath = [databasePath UTF8String];
    [databasePath release];
    if (sqlite3_open(dbpath, &comboDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO combos (name, combo, cperm, session) VALUES (\"%@\", \"%@\",\"%i\",\"%i\")", self.name, self.combo, 0, 0];
        //sqlite3_bind_text( compiledStatement, 1, [data UTF8String], -1, SQLITE_TRANSIENT);			
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(comboDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            self.name = @"";
            self.combo = @"";
        }
        sqlite3_finalize(statement);
        sqlite3_close(comboDB);
    }
}

- (void) showPerms{
    for(int i = 0; i < [self.testData count];i++){
        [self.picker selectRow:[[self.testData objectAtIndex:i] intValue]+3 inComponent:i animated:YES];
        [self.picker reloadAllComponents];
    }
}

- (IBAction)toggleControls:(id)sender {
    // 0 == switches index
    if ([sender selectedSegmentIndex] == 0){
        self.numberOfColumns = 3;
        [picker reloadAllComponents];
        [self Generate];
    }
    else if ([sender selectedSegmentIndex] == 1){
        self.numberOfColumns = 4;
        [picker reloadAllComponents];
        [self Generate];
    }
    else if ([sender selectedSegmentIndex] == 2){
        self.numberOfColumns = 5;
        [picker reloadAllComponents];
        [self Generate];
    }
    else{
        self.numberOfColumns = 6;
        [picker reloadAllComponents];
        [self Generate];
    }
}

- (void) getRandomNumber{
    // Generates random number with no repeating value
    do{
        self.randomNumber = (arc4random()%10);
    }while(self.noRepeatNumber == self.randomNumber);
    
    // collect value to ensure no repeated numbers
    self.noRepeatNumber = self.randomNumber;
}

//Generates the random combinations on button action
- (IBAction) Generate{
    NSString *pickerValue = @"";
    initialGenerateButton.hidden = YES;
    generateButton.hidden = NO;
    saveButton.hidden = NO;
    for (int i = 0; i < self.numberOfColumns; i++) { 
        // Generate random number that doesn't repeat
        [self getRandomNumber];
        // Save the generated combination for future use
        pickerValue = [NSString stringWithFormat:@"%@%d", pickerValue, self.randomNumber];
        // Assign the generated number to the picker view
        [picker selectRow:self.randomNumber+3 inComponent:i animated:YES];
        [picker reloadComponent:i];
    }
    NSLog(@"pickerVal = %@",pickerValue);
    //Updates the label's text: 
    self.combo = pickerValue;
    NSLog(@"combo = %@",combo);
}

// This happens upon the view loading
/*
- (void)viewWillAppear:(BOOL)animated{
    NSString *pickerValue = @"";
    initialGenerateButton.hidden = NO;
    generateButton.hidden = YES;
    saveButton.hidden = YES;
    for (int i = 0; i < self.numberOfColumns; i++) { 
        // Generate random number that doesn't repeat
        self.testData = [NSArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
        // Save the generated combination for future use
        pickerValue = [NSString stringWithFormat:@"%@%d", pickerValue, [testData objectAtIndex:i]];
        // Assign the generated number to the picker view
        [picker selectRow:([[testData objectAtIndex:i] intValue]+3) inComponent:i animated:YES];
        [picker reloadComponent:i];
        }
        NSLog(@"pickerVal = %@",pickerValue);
        //Updates the label's text: 
        self.combo = pickerValue;
        NSLog(@"combo = %@",combo);
    [picker reloadAllComponents];
}
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Making the picker small...
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 320.0, 120.0)]; 
    [self.view addSubview:picker];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    picker.userInteractionEnabled = NO;
    [self showPerms];
    
    //Additional setup after loading the view from its nib.
    self.numberOfColumns = 6;
    self.noRepeatNumber = 999;
    self.testData = [NSArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
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
    for(int i = 0; i < self.numberOfColumns;i++){
        [picker selectRow:3 inComponent:i animated:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.picker     = nil;
    self.label      = nil;
    self.column1    = nil;
    self.column2    = nil;
    self.column3    = nil;
    self.column4    = nil;
    self.column5    = nil;
    self.column6    = nil;
    self.testData   = nil;
    self.generateButton = nil;
    self.initialGenerateButton = nil;
    self.saveButton = nil;
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
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    self.name = [[alertView textFieldAtIndex:0] text];
    if([self.name length] > 2)
    {
        NSLog(@"Print this: %@",self.name);
        return YES;
    }    
    else
    {
        NSLog(@"Don't print this: %@",self.name);
        return NO;
    }
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 0){
        
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
                        alert.tag = 1;
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
    else if (alertView.tag = 1){
        [self initiateSave];
    }
    else if (buttonIndex == 1){
        NSLog(@"Saving combo.");
        [self saveCombo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congrats!" message:@"Your new combination rocks!" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

@end