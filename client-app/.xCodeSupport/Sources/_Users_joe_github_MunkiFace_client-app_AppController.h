
@interface AppController : NSObject
{
    IBOutlet NSView* rebuildCatalogsSheet;
    IBOutlet NSView* mainView;
    IBOutlet NSWindow* theWindow;
    IBOutlet NSOutlineView* mainOutlineView;
    IBOutlet MFManifestsOutlineDataSource* manifestsOutlineDataSource;
}
- (IBAction)rebuildCatalogs:(id)aSender;
- (IBAction)dismissSheet:(id)aSender;
- (IBAction)toolbarButtonClicked:(id)aSender;
@end