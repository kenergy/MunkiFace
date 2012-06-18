\page serverInteraction Server Interaction
\tableofcontents

\section Intro Introduction
The server and its resources are available by appending /server/ to your MunkiFace URI. For example, if MunkiFace is located at http://example.com/MunkiFace, you'd access the server via http://example.com/MunkiFace/server.


\section gettingDataFromTheServer Getting Data From The Server
The server is required to provide data to any client that needs it in various forms. The topic of "polling" is the mot integral to the operation of the server as it is what provides clients with near-realtime data updates. Other methods of getting data from the server are simple request/response pairs that do not attempt to hold a connection open.

\subsection polling Polling
MunkiFace's client uses polling to provide realtime updates to its interface without the need to manually ask the server if there are any changes. The first polling request made to the server is simply made to **server/polling.php**. This really isn't a polling request at all since it immediately returns a snapshot of the catalogs/, manifests/ and /pkgsinfo/ directories. The client app uses this data to build the initial data layout for the user in its MFTreeModel data structure.

Once the initial data structure has been built, the client will then initialize a polling request to **server/polling.php?fromNow**. The **fromNow** variable tells the server that the client only wants to know about any files that get created, deleted or modified after the request was made. The server will then loop over the directory structure of each of the three aforementioned directories until either the request times out, or something changes. If something changes, such as a new file appears or an existing file disappears or is modified, it will convert the contents of the file into JSON format and return it to the client. It's then the client's responsibility to send another request to **server/polling.php?fromNow** to start the process over again. It's also the client's responsibility to restart the connection if the server or browser times the connection out.

\section movingOrRenamingResources Moving, Renaming and Deleting Resources
If an object in the outline view is renamed or moved to a new location viw drag and drop, a request is sent to the server asking if the resource may be moved or renamed. The only response that is made is a simple `YES` or `NO`. Reasons that resource might not be able to be modified or moved are

- The webserver process doesn't have sufficient rights to perform the action
- The user that is currently logged in doesn't have rights within the MunkiFace rights management system to perform the action.

To request that a resource be renamed or moved, the existing file path must be provided along with the new desired path.

###Adding a New Directory
The following creates a new directory within the pkgsinfo directory names `New Awesome Group`

    server/resource.php?action=mkdir&target=pkgsinfo/New%20Awesome%20Group

###Renaming a File or Directory
The following rename the `apps` directory in pkgsinfo to `apps-old`.

    server/resource.php?action=mv&oldTarget=pkgsinfo/apps&newTarget=pkgsinfo/apps-old

###Deleting a File or Directory
_It should be noted that a directory cannot be deleted if it is not empty. It shouldn't be easy to remove an entire directory of pkgsinfo files on accident._

The following will delete the file `pkgsinfo/apps/CoolApp`

    server/resource.php?action=rm&target=pkgsinfo/apps/CoolApp

The following will delete the `pkgsinfo/apps` directory.

    server/resource.php?action=rm&target=pkgsinfo/apps