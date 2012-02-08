
@interface MFOutlineViewDelegate : NSObject
{
    IBOutlet NSOutlineView* _outlineView;
    IBOutlet NSTextField* _packageName;
    IBOutlet NSTextField* _packageVersion;
    IBOutlet NSTextField* _minOSVersion;
    IBOutlet NSTextField* _installerSize;
    IBOutlet NSButton* _isUninstallable;
    IBOutlet NSButton* _willAutoRemove;
    IBOutlet NSTextField* _packageDescription;
}

@end