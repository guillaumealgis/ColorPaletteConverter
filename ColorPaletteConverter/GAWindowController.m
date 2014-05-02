//
//  GAWindowController.m
//  ColorPaletteConverter
//
//  Created by Guillaume Algis on 02/05/2014.
//  Copyright (c) 2014 Guillaume Algis. All rights reserved.
//

#import "GAWindowController.h"

static NSString * const GALibraryColorsDirectory = @"Colors";

@interface GAWindowController ()

@property (strong) IBOutlet NSArrayController *colorPalettesController;
@property (strong) IBOutlet NSArrayController *colorSpacesController;

@property (weak) IBOutlet NSPopUpButton *palettesPopupButton;
@property (weak) IBOutlet NSPopUpButton *colorSpacesPopupButton;

@property (weak) IBOutlet NSWindow *saveAsSheetWindow;

@end

@implementation GAWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadColorPalette:) name:NSColorListDidChangeNotification object:nil];

    [self.colorSpacesController addObjects:[NSColorSpace availableColorSpacesWithModel:NSUnknownColorSpaceModel]];
    [self loadColorPalettes];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadColorPalettes
{
    [self.colorPalettesController addObjects:[NSColorList availableColorLists]];
}

- (void)reloadColorPalette:(NSNotification *)notification
{
    NSUInteger replacedListIndex = [self.colorPalettesController.content indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [[obj name] isEqualToString:[notification.object name]];
    }];
    if (replacedListIndex != NSNotFound) {
        [self.colorPalettesController.content removeObjectAtIndex:replacedListIndex];
    }

    [self.colorPalettesController addObject:notification.object];
}

- (void)saveSelectedPaletteWithName:(NSString *)name
{
    NSColorSpace *targetColorSpace = [self.colorSpacesController.selectedObjects firstObject];

    NSColorList *sourceColorList = [self.colorPalettesController.selectedObjects firstObject];
    NSColorList *convertedColorList = [[NSColorList alloc] initWithName:name];

    for (NSString *colorKey in [sourceColorList allKeys]) {
        NSColor *originalColor = [sourceColorList colorWithKey:colorKey];
        NSColor *convertedColor = [originalColor colorUsingColorSpace:targetColorSpace];
        [convertedColorList setColor:convertedColor forKey:colorKey];
    }

    BOOL saved = [convertedColorList writeToFile:nil];

    if (saved) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Success" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"Saved to ~/Library/Colors/%@.clr", name];
        alert.alertStyle = NSInformationalAlertStyle;
        [alert beginSheetModalForWindow:self.window completionHandler:nil];
    }
    else {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Error" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"Unknown error while saving the new color palette. Sorry."];
        [alert beginSheetModalForWindow:self.window completionHandler:nil];
    }
}

#pragma mark - Actions

- (IBAction)saveAs:(id)sender {
    NSString *selectedPaletteName = [[self.colorPalettesController.selectedObjects firstObject] name];
    self.saveAsName = [selectedPaletteName stringByAppendingString:@" (copy)"];
    [self.window beginSheet:self.saveAsSheetWindow completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSModalResponseOK) {
            [self saveSelectedPaletteWithName:self.saveAsName];
        }
    }];
}

- (IBAction)save:(id)sender {
    NSString *selectedPaletteName = [[self.colorPalettesController.selectedObjects firstObject] name];
    [self saveSelectedPaletteWithName:selectedPaletteName];
}

- (IBAction)cancelSaveAs:(id)sender {
    [self.window endSheet:self.saveAsSheetWindow returnCode:NSModalResponseCancel];
}

- (IBAction)confirmSaveAs:(id)sender {
    [self.window endSheet:self.saveAsSheetWindow returnCode:NSModalResponseOK];
}

@end
