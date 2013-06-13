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
}

- (void)mapStateToUI
{
    // four buttons to worry about: stop, speak, pause, continue
                
    switch ([self speakingMode]) {
        case kSpeakingModeNotStarted:
            break;
        case kSpeakingModeStopped:
            break;
        case kSpeakingModeSpeaking:
            break;
        case kSpeakingModePaused:
            break;
           
        default:
            break;
    }
}

- (IBAction)stopIt:(id)sender
{
    NSLog(@"stopping speaking");
    [_speechSynth stopSpeaking];
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
}

- (IBAction)pauseIt:(id)sender
{
    NSLog(@"pausing speaking");
    [_speechSynth pauseSpeakingAtBoundary:NSSpeechWordBoundary];
    
}

- (IBAction)continueIt:(id)sender {
    NSLog(@"continue speaking");
    [_speechSynth continueSpeaking];
}

@end
