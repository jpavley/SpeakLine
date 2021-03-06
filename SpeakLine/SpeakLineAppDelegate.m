//
//  SpeakLineAppDelegate.m
//  SpeakLine
//
//  Created by  John Pavley on 6/12/13.
//  Copyright (c) 2013  John Pavley. All rights reserved.
//

#import "SpeakLineAppDelegate.h"

@implementation SpeakLineAppDelegate

@synthesize window = _window;
@synthesize textField = _textField;
@synthesize speakingMode = _speakingMode;

@synthesize stopButton, startButton, pauseButton, continueButton, tableView;

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"init");
        _speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
        [_speechSynth setDelegate:self];
        _voices = [NSSpeechSynthesizer availableVoices];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSLog(@"applicationDidFinishLaunching");
    
    [self setSpeakingMode:kSpeakingModeNotStarted];
    [self mapStateToUI];
}

- (void)mapStateToUI
{
    NSLog(@"mapStateToUI");

    // four buttons to worry about: stop, speak, pause, continue
                
    switch ([self speakingMode]) {
        case kSpeakingModeNotStarted:
            [stopButton setEnabled:NO];
            [startButton setEnabled:YES];
            [pauseButton setEnabled:NO];
            [continueButton setEnabled:NO];
            [tableView setEnabled:YES];
            [_textField setEnabled:YES];
            break;
        case kSpeakingModeStopped:
            [stopButton setEnabled:NO];
            [startButton setEnabled:YES];
            [pauseButton setEnabled:NO];
            [continueButton setEnabled:NO];
            [tableView setEnabled:YES];
            [_textField setEnabled:YES];
            break;
        case kSpeakingModeSpeaking:
            [stopButton setEnabled:YES];
            [startButton setEnabled:NO];
            [pauseButton setEnabled:YES];
            [continueButton setEnabled:NO];
            [tableView setEnabled:NO];
            [_textField setEnabled:YES];
            break;
        case kSpeakingModePaused:
            [stopButton setEnabled:NO];
            [startButton setEnabled:NO];
            [pauseButton setEnabled:NO];
            [continueButton setEnabled:YES];
            [tableView setEnabled:NO];
            [_textField setEnabled:YES];
            break;
        case kSpeakingModeCompleted:
            [stopButton setEnabled:NO];
            [startButton setEnabled:YES];
            [pauseButton setEnabled:NO];
            [continueButton setEnabled:NO];
            [tableView setEnabled:YES];
            [_textField setEnabled:YES];
            break;
           
        default:
            NSLog(@"Oops! Got to default case in mapStateToUI");
            break;
    }
}

- (IBAction)stopIt:(id)sender
{
    NSLog(@"stopping speaking");
    [_speechSynth stopSpeaking];
    [self setSpeakingMode:kSpeakingModeStopped];
    [self mapStateToUI];
}

- (IBAction)speakIt:(id)sender
{
    NSString *string = [_textField stringValue];
    
    if ([string length] == 0) {
        NSLog(@"String from %@ has 0 length", _textField);
        return;
    }
    [_speechSynth startSpeakingString:string];
    NSLog(@"speaking %@", string);
    [self setSpeakingMode:kSpeakingModeSpeaking];
    [self mapStateToUI];
}

- (IBAction)pauseIt:(id)sender
{
    NSLog(@"pausing speaking");
    [_speechSynth pauseSpeakingAtBoundary:NSSpeechWordBoundary];
    [self setSpeakingMode:kSpeakingModePaused];
    [self mapStateToUI];
}

- (IBAction)continueIt:(id)sender {
    NSLog(@"continue speaking");
    [_speechSynth continueSpeaking];
    [self setSpeakingMode:kSpeakingModeSpeaking];
    [self mapStateToUI];
}

- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender didFinishSpeaking:(BOOL)finishedSpeaking
{
    NSLog(@"finished speaking = %d", finishedSpeaking);
    [self setSpeakingMode:kSpeakingModeCompleted];
    [self mapStateToUI];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tv
{
    return (NSInteger) [_voices count];
}

- (id)tableView:(NSTableView *)tv objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row
{
//    NSString *v = [_voices objectAtIndex:row];
//    NSDictionary *dict = [NSSpeechSynthesizer attributesForVoice:v];
//    return [dict objectForKey:NSVoiceName];
    
    return [[NSSpeechSynthesizer attributesForVoice:[_voices objectAtIndex:row]] objectForKey:NSVoiceName];
    
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSInteger row = [tableView selectedRow];
    if (row != -1) {
        NSString *selectedVoice = [_voices objectAtIndex:row];
        [_speechSynth setVoice:selectedVoice];
        NSLog(@"new voice = %@", selectedVoice);
    }
    
}

- (void)awakeFromNib
{
    NSString *defaultVoice = [NSSpeechSynthesizer defaultVoice];
    NSInteger defaultRow = [_voices indexOfObject:defaultVoice];
    NSIndexSet *indices = [NSIndexSet indexSetWithIndex:defaultRow];
    [tableView selectRowIndexes:indices byExtendingSelection:NO];
    [tableView scrollRowToVisible:defaultRow];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    NSString *methodName = NSStringFromSelector(aSelector);
    NSLog(@"respondsToSelector:%@", methodName);
    return [super respondsToSelector:aSelector];
}

@end
