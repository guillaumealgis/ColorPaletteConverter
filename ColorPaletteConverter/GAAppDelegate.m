//
//  GAAppDelegate.m
//  ColorPaletteConverter
//
//  Created by Guillaume Algis on 02/05/2014.
//  Copyright (c) 2014 Guillaume Algis. All rights reserved.
//

#import "GAAppDelegate.h"

#import "GAWindowController.h"

@implementation GAAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.mainWindowController = [[GAWindowController alloc] initWithWindowNibName:@"GAWindowController"];
    [self.mainWindowController.window makeMainWindow];
    [self.mainWindowController showWindow:self];
}

@end
