@import "MFLoginWindow.j"
@import "MFNetworkDataSource.j"
@import "MFServerSettings.j"
@import "MFApplicationViewController.j"
@import "MFOutlineDataSource.j"
@import "MFOutlineSelectedObject.j"
@import "MFCatalog.j"
@import "MFManifest.j"
@import "MFPkgsInfo.j"
@import "MFTreeModel.j"
@import "MFManifestBackgroundView.j"
@import "MFByteTransformer.j"

MF_SERVER_URI = [[[CPBundle mainBundle] infoDictionary]
	objectForKey:@"MunkiFace Server URI"];
