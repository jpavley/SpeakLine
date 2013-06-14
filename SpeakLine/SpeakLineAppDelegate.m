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

@synthesize stopButton, startButton, pauseButton, continueButton;

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"init");
        _speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
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
            break;
        case kSpeakingModeStopped:
            [stopButton setEnabled:NO];
            [startButton setEnabled:YES];
            [pauseButton setEnabled:NO];
            [continueButton setEnabled:NO];
            break;
        case kSpeakingModeSpeaking:
            [stopButton setEnabled:YES];
            [startButton setEnabled:NO];
            [pauseButton setEnabled:YES];
            [continueButton setEnabled:NO];
            break;
        case kSpeakingModePaused:
            [stopButton setEnabled:NO];
            [startButton setEnabled:NO];
            [pauseButton setEnabled:NO];
            [continueButton setEnabled:YES];
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

// TODO: Add callback so that when the text is fully spoken the UI is reset
// TODO: If text is changed while speaking stop speaking an reset

@end
