
@interface AppController : NSObject
{
    IBOutlet MFApplicationViewController* appViewController;
    IBOutlet NSView* mainView;
    IBOutlet NSWindow* theWindow;
    IBOutlet NSWindow* munkiLogo;
    IBOutlet NSOutlineView* mainOutlineView;
    IBOutlet MFManifestsOutlineDataSource* manifestsOutlineDataSource;
    IBOutlet MFPkgsInfoOutlineDataSource* pkgsInfoOutlineDataSource;
}
- (IBAction)rebuildCatalogs:(id)aSender;
- (IBAction)dismissSheet:(id)aSender;
- (IBAction)toolbarButtonClicked:(id)aSender;
@end