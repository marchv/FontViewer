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
    NSMutableArray *_fontNames;
    unsigned _index;
    
    UILabel    *_fontName;
    UITextView *_textView;
    UIButton   *_prevButton;
    UIButton   *_nextButton;
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
    _fontName = [[UILabel alloc] initWithFrame:CGRectNull];
    
    // copied from http://www.lipsum.com/
    const NSString *kTextLoremIpsum = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
    _textView = [[UITextView alloc] initWithFrame:CGRectNull];
    [_textView setText:[NSString stringWithFormat:@"copyright 2014 marchv (Jens Schwarzer)\nmarchv\nMARCHV\n123.45\n678.90\n\n%@", kTextLoremIpsum]];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectNull];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_fontName, _textView, toolbar);

    for (id view in [viewsDictionary allValues]) {
        [[self view] addSubview:view];
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
  
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_fontName]-|" options:0 metrics:nil views:viewsDictionary]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_textView]-|" options:0 metrics:nil views:viewsDictionary]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbar]|" options:0 metrics:nil views:viewsDictionary]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_fontName]-[_textView]-[toolbar]|" options:0 metrics:nil views:viewsDictionary]];
    
    _prevButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 100, 20)];
    [_prevButton setTitle:@"< previous" forState:UIControlStateNormal];
    [_prevButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_prevButton addTarget:self action:@selector(prevButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 100, 20)];
    [_nextButton setTitle:@"next >" forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(nextButtonHandler:) forControlEvents:UIControlEventTouchUpInside];

    [toolbar setItems:@[[[UIBarButtonItem alloc] initWithCustomView:_prevButton], [[UIBarButtonItem alloc] initWithCustomView:_nextButton]] animated:YES];
    
    [self commonButtonHandler];
}

- (void)prevButtonHandler:(UIButton*)button
{
    _index--;
    [self commonButtonHandler];
}

- (void)nextButtonHandler:(UIButton*)button
{
    _index++;
    [self commonButtonHandler];
}

- (void)commonButtonHandler
{
    if (_index == 0) [_prevButton setEnabled:NO]; else [_prevButton setEnabled:YES];
    if (_index + 1 >= [_fontNames count]) [_nextButton setEnabled:NO]; else [_nextButton setEnabled:YES];
    
    [_fontName setText:[NSString stringWithFormat:@"%@ (%u/%lu)", [_fontNames objectAtIndex:_index], _index + 1, (unsigned long)[_fontNames count]]];
    [_textView setFont:[UIFont fontWithName:[_fontNames objectAtIndex:_index] size:28.0f]];
}

@end
