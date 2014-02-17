//
//  ViewController.m
//  FontViewer
//
//  Created by Jens Schwarzer on 14/02/14.
//  Copyright (c) 2014 marchv. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSMutableArray    *_fontNames;
    unsigned          _index;
    
    UINavigationItem  *_navigationItem;
    UITextView        *_textView;
    UISlider          *_sliderFontSize;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // available fonts listed in xcode output
    for (id familyName in [UIFont familyNames]) {
        NSLog(@"%@", familyName);
        for (id fontName in [UIFont fontNamesForFamilyName:familyName]) NSLog(@"  %@", fontName);
    }
    
    // generate list of available fonts
    _fontNames = [[NSMutableArray alloc] init];
    for (id familyName in [UIFont familyNames])
        [_fontNames addObjectsFromArray:[UIFont fontNamesForFamilyName:familyName]];
    
    // setup views
    id<UILayoutSupport> topLayoutGuide    = self.topLayoutGuide;
    id<UILayoutSupport> bottomLayoutGuide = self.bottomLayoutGuide; // mainly to remove AMBIGUOUS LAYOUT warning

    _navigationItem = [[UINavigationItem alloc] init]; // title set later
    _navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"previous" style:UIBarButtonItemStylePlain target:self action:@selector(prevButtonHandler)];
    _navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"next"     style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonHandler)];
    
    UINavigationBar *navigationbar = [[UINavigationBar alloc] initWithFrame:CGRectZero]; // has to be CGRectZero and not CGRectNull!
    navigationbar.items = @[_navigationItem];
    
    // copied from http://www.lipsum.com/
    const NSString *kTextLoremIpsum = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
    _textView = [[UITextView alloc] initWithFrame:CGRectNull];
    [_textView setText:[NSString stringWithFormat:@"copyright \u00A9 2014 marchv (Jens Schwarzer)\nmarchv\nMARCHV\n123.45\n678.90\n\n%@", kTextLoremIpsum]];
    
    _sliderFontSize = [[UISlider alloc] initWithFrame:CGRectNull];
    _sliderFontSize.minimumValue =   5.0f;
    _sliderFontSize.maximumValue = 100.0f;
    _sliderFontSize.value        =  30.0f;
    [_sliderFontSize addTarget:self action:@selector(commonHandler) forControlEvents:UIControlEventValueChanged];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(topLayoutGuide, navigationbar, _textView, _sliderFontSize, bottomLayoutGuide);

    for (id view in [viewsDictionary allValues]) {
        [[self view] addSubview:view];
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
  
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[topLayoutGuide]|" options:0 metrics:nil views:viewsDictionary]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[navigationbar]|" options:0 metrics:nil views:viewsDictionary]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_textView]-|" options:0 metrics:nil views:viewsDictionary]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_sliderFontSize]-|" options:0 metrics:nil views:viewsDictionary]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomLayoutGuide]|" options:0 metrics:nil views:viewsDictionary]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide]-[navigationbar]-[_textView]-[_sliderFontSize]-[bottomLayoutGuide]" options:0 metrics:nil views:viewsDictionary]];
    
    [self commonHandler];
}

- (void)prevButtonHandler
{
    _index--;
    [self commonHandler];
}

- (void)nextButtonHandler
{
    _index++;
    [self commonHandler];
}

- (void)commonHandler
{
    if (_index == 0)                  _index++;
    if (_index >= [_fontNames count]) _index--;
    
    [_navigationItem setTitle:[NSString stringWithFormat:@"%@ (%u/%lu)", [_fontNames objectAtIndex:_index - 1], _index, (unsigned long)[_fontNames count]]];
    [_textView setFont:[UIFont fontWithName:[_fontNames objectAtIndex:_index - 1] size:[_sliderFontSize value]]];
}

@end
