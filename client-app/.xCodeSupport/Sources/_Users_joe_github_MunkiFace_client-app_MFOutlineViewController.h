
@interface MFOutlineViewController : NSObject
{
    IBOutlet NSOutlineView* _outlineView;
    IBOutlet NSPopUpButton* _catalogsPopup;
}
- (IBAction)catalogSelectionDidChange:(NSPopUpButton*)aSender;
@end