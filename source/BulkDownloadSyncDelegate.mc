//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Application.Storage;
import Toybox.Communications;
import Toybox.Lang;

//! Responds to sync requests
class BulkDownloadDelegate extends Communications.SyncDelegate {
    private var _colors as Array<Number>;

    private var _colorsDownloaded as Number;
    private var _colorsToDownload as Number;

    //! Constructor
    public function initialize() {
        SyncDelegate.initialize();

        var colors = Storage.getValue($.ID_COLORS_TO_DOWNLOAD);
        if (colors != null) {
             _colors = colors as Array<Number>;
        } else {
            _colors = [
                0xFFFFFF,
                0xAAAAAA,
                0x555555,
                0xFF0000,
                0xAA0000,
                0xFF5500,
                0xFFAA00,
                0x00FF00,
                0x00AA00,
                0x00AAFF,
                0x0000FF,
                0xAA00FF,
                0xFF00FF,
            ];
        }

        _colorsDownloaded = 0;
        _colorsToDownload = 0;
    }

    //! Called by the system to determine if a sync is needed
    //! @return true if sync is needed, false otherwise
    public function isSyncNeeded() as Boolean {
        return true;
    }

    //! Called by the system when starting a bulk sync.
    public function onStartSync() as Void {
        _colorsToDownload = _colors.size();
        downloadColor();
    }

    //! Called by the system when finishing a bulk sync.
    public function onStopSync() as Void {
        Communications.cancelAllRequests();
        Communications.notifySyncComplete(null);
    }

    //! Initiate a request to download an image of the given color
    //! @param colorId The id of the color to download
    private function downloadColor() as Void {
        // var params = {};

        // var options = {
        //     :dithering => Communications.IMAGE_DITHERING_NONE
        // };

        // var deviceSettings = System.getDeviceSettings();

        // var downloadUrl = Lang.format("https://dummyimage.com/$1$x$2$/$3$.png", [
        //     deviceSettings.screenWidth,
        //     deviceSettings.screenHeight,
        //     colorId.format("%06X")
        // ]);

        // create a request delegate so we can associate colorId with the
        // downloaded image
        var requestDelegate = new $.BulkDownloadRequestDelegate(self.method(:onDownloadComplete));
        // requestDelegate.makeImageRequest(downloadUrl, params, options);
        var url = "https://www.google.com";
        var params = {                                              // set the parameters
                "definedParams" => "123456789abcdefg"
        };
        var options = {                                             // set the options
            :method => Communications.HTTP_REQUEST_METHOD_GET,      // set HTTP method
            :headers => {                                           // set headers
                    "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED},
                                                                    // set response type
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_URL_ENCODED
        };
        requestDelegate.makeWebRequest(url, params, options);

    }

    //! Handle download completion
    //! @param code The server response code or BLE error
    public function onDownloadComplete(code as Number) as Void {
        if (code == 200) {
            Communications.notifySyncComplete(null);
        } else {
            Communications.notifySyncComplete(null);
        }
    }
}
