//
//  CSTopVC.m
//  ComboSmith
//
//  Created by Erran Carey on 3/10/12.
//  Copyright (c) 2012 app2o. All rights reserved.
//
#import "CSTopVC.h"
#import "permutation.h"

@implementation CSTopVC
//Picker:
@synthesize picker;
//Labels:
@synthesize label;
//Columns:
@synthesize column1;
@synthesize column2;
@synthesize column3;
@synthesize column4;
@synthesize column5;
@synthesize column6;
@synthesize numberOfColumns;
@synthesize userInput;
@synthesize permutations;
@synthesize permutationsCount;
@synthesize permutationsIndex;
@synthesize currentPermutation;
//Buttons:
@synthesize forwardButton;
@synthesize backButton;
@synthesize inputInvoker;
@synthesize initialInvoker;
@synthesize saveButton;
//Misc.:
@synthesize customSlider;
@synthesize testData;
@synthesize topCombos;
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
    alert.tag = 1;
    self.name = [[alert textFieldAtIndex:0]text];
    [alert show];
    [alert release];
    //NSLog(@"name = %@",name);
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

- (IBAction) sliderMoved{
    //NSLog(@"customSlider has moved to: %i", (int)roundf(customSlider.value));
    self.permutationsCount = (int)roundf(customSlider.value);
    self.permutationsIndex = ((int)roundf(customSlider.value))-1;
    [self getCurrentPermutation];
    [self Recover];
    [self.picker reloadAllComponents];    
}

- (IBAction)triggerInputAlert{
    //NSArray *startArray = [NSArray arrayWithObjects:@"प्रारंभ!",@"Commencer!",@"Go!",@"¡Ir!",@"去！", nil];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Top Used PINs" message:@"The following PINs are insecure. Using them to protect anything valuable is a bad idea." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    alert.tag = 0;
    [alert show];
    [alert release];
}

- (void) decrementPermutation{
    // decrement and keep track of count and index values
    if (self.permutationsIndex > 0)
        self.permutationsIndex--;
    if (self.permutationsCount > 1)
        self.permutationsCount--;
}

- (void) incrementPermutation{
    // increment and keep track of count and index values
    if (self.permutationsIndex < [self.permutations count]-1)
        self.permutationsIndex++;
    if (self.permutationsCount < [self.permutations count] )
        self.permutationsCount++;
}

- (IBAction) backButtonPressed{
    [self decrementPermutation];
    [self getCurrentPermutation];
    [self Recover];
    
}

- (IBAction) doubleTapBack{
    if (self.permutationsIndex > 0)
        self.permutationsIndex = 0;
    if (self.permutationsCount > 1)
        self.permutationsCount = 1;
    self.currentPermutation = [self.permutations objectAtIndex:self.permutationsIndex];
    [self Recover];
    
}

- (IBAction) forwardButtonPressed{
    [self incrementPermutation];
    [self getCurrentPermutation];
    [self Recover];
}


// Split the individual array items

- (void) splitArrayItems{
    NSMutableArray *splitTopCombos = [NSMutableArray array];
    for (id topcombo in self.topCombos) {
        //NSLog(@">>>>>>>>>>>>>>>>>>%@", self.topCombos);
        NSMutableArray *digits = [[NSMutableArray alloc] initWithCapacity:[topcombo length]];
        for (int i=0; i < [topcombo length]; i++){
            NSString *digit = [NSString stringWithFormat:@"%c", [topcombo characterAtIndex:i]];
            [digits addObject:digit];
        }
        [splitTopCombos addObject:digits];
        [digits release];
    }
    
    self.permutations = splitTopCombos;
    //NSLog(@"Self Permutations %@", self.permutations);
    //NSLog(@"Split Top Combos %@", splitTopCombos);

    
}

- (void) getCurrentPermutation{
    // give the current permutation value
    self.currentPermutation = [self.permutations objectAtIndex:self.permutationsIndex];
}


//[self getAllPermutations];



// Generates recover permutations
- (IBAction)Recover{
    NSString *pickerValue = @"";
    int i = 0;
    for (id digit in self.currentPermutation) {
        
        // ---------- Assign the permutation numbers to the picker view -----------
        
        [picker selectRow:([digit intValue]+3) inComponent:i animated:YES];
        [picker reloadComponent:i];
        // Save the Recoverd combination for future use
        pickerValue = [NSString stringWithFormat:@"%@%d", pickerValue, [digit intValue]];
        i++;

    }
    self.combo = pickerValue;
    //NSLog(@"pickerVal = %@",pickerValue);
    //Updates the label's text: 
    customSlider.maximumValue = [self.permutations count];
    customSlider.value = self.permutationsCount;
    ;
    label.text = [NSString stringWithFormat:@"%d of %d", self.permutationsCount, [self.permutations count]];
}
/*
// This happens upon the view loading
-(void)viewWillAppear:(BOOL)animated{
    NSString *pickerValue = @"";
    
    for (int i = 0; i < userInput.length; i++) {
        // ---------- Assign the permutation numbers to the picker view -----------
        
        //[picker selectRow:[digit intValue] inComponent:i animated:YES];
        [picker selectRow:(3) inComponent:i animated:YES];
        [picker reloadComponent:i];
        // Save the Recoverd combination for future use
        pickerValue = [NSString stringWithFormat:@"%@%d", pickerValue, i];
        backButton.hidden = YES;
        forwardButton.hidden = YES;
        saveButton.hidden = YES;
        inputInvoker.hidden = YES;
        label.hidden = YES;
        initialInvoker.hidden = NO;
        customSlider.hidden = YES;        
    }
    //NSLog(@"pickerVal = %@",pickerValue);
    //Updates the label's text: 
    customSlider.maximumValue = [self.permutations count];
    customSlider.value = self.permutationsCount;
    ;
    label.text = [NSString stringWithFormat:@"%d of %d", self.permutationsCount, [self.permutations count]];
    [picker reloadAllComponents];
}
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    label.hidden = YES;
    //Making the picker small...
    self.topCombos = [NSArray arrayWithObjects:@"1234",@"0000",@"2580",@"1111",@"5555", //Top 10
                      @"5683",@"0852",@"2222",@"1212",@"1998", //Top 10
                      @"1990",@"1991",@"1992",@"1993",@"1994",@"1995",@"1996",@"1997",@"1999",@"2000", //90's to 21st century
                      @"1980",@"1982",@"2007",@"1983",@"2006",@"1984",@"2005",@"1985",@"1986",@"1987",@"1988",@"1989", //80's
                      @"8888",@"3333",@"7777",@"4444",@"9999",@"6666", //Repeats
                      @"2001",@"2002",@"1981",@"2003",@"2004",@"2008",@"2009",@"2010",@"2011",//Recent years
                      @"3825",@"3425",@"1337", //Words
                      @"0123",@"4567",@"7890",@"1470",@"0741",@"0963", //sequences
                      nil];
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 320.0, 120.0)]; 
    [self.view addSubview:picker];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    picker.userInteractionEnabled = NO;
    [self showPerms];
   
    //Additional setup after loading the view from its nib.
    self.numberOfColumns = 4;
    self.permutationsCount = 1;
    self.permutationsIndex = 0;
    [self splitArrayItems];
    label.text = @"";
    self.testData = [NSArray arrayWithObjects:@"0",@"0",@"0",@"0", nil];
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
        //[self incrementPermutation];
        //[self getCurrentPermutation];
        //[self Recover];
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
    self.forwardButton = nil;
    self.backButton = nil;
    self.saveButton = nil;
    self.initialInvoker = nil;
    self.inputInvoker = nil;
    self.topCombos = nil;
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
-(void) submitData{
    //NSLog(@"submitData:userInput = %@",self.userInput);
    self.numberOfColumns = 4;
    self.permutationsCount = 1;
    self.permutationsIndex = 0;
    [self splitArrayItems];
    [self getCurrentPermutation];
    [picker reloadAllComponents];
    [self Recover];
    backButton.hidden = NO;
    forwardButton.hidden = NO;
    label.hidden = NO;
    saveButton.hidden = NO;
    inputInvoker.hidden = NO;
    initialInvoker.hidden = YES;
    customSlider.hidden = NO;
}
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    self.name = [[alertView textFieldAtIndex:0] text];
    if([self.name length] > 0)
    {
        //NSLog(@"Print this: %@",self.name);
        return YES;
    }    
    else
    {
        //NSLog(@"Don't print this: %@",self.name);
        return NO;
    }
}
//Alert View clickbutton action
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 0){
        
        if (buttonIndex == 0){
            [self submitData];
        }
    }
    else if (alertView.tag == 2){
        
        if (buttonIndex == 0){
            [self initiateSave];
        }
    }
    else if(alertView.tag == 1){
        
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
                        alert.tag = 2;
                        [alert show];
                        [alert release];                        
                    }
                    else {
                        /////////////////////////////////////////////////////////////////////////////
                        //Write the new combo to the database
                        //...... insert code
                        ///////////////////////////////////////////////////////////////////////////// 
                        
                        [self saveCombo];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congrats!" message:@"Your new combination rocks!" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                    }
                    sqlite3_finalize(statement);
                }
                sqlite3_close(comboDB);
            }
        }
    }
}
@end