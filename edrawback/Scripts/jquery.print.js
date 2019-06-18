// http://www.bennadel.com/blog/1591-ask-ben-print-part-of-a-web-page-with-jquery.htm
// Create a jquery plugin that prints the given element.
    (function($) {
    	$.fn.print = function(){
	// NOTE: We are trimming the jQuery collection down to the
	// first element in the collection.
	if (this.size() > 1){
		this.eq( 0 ).print();
		return;
	} else if (!this.size()){
		return;
	}

	// ASSERT: At this point, we know that the current jQuery
	// collection (as defined by THIS), contains only one
	// printable element.

	// Create a random name for the print frame.
	var strFrameName = ("printer-" + (new Date()).getTime());

	// Create an iFrame with the new name.
	var jFrame = $( "<iframe name='" + strFrameName + "'>" );

	// Hide the frame (sort of) and attach to the body.
	jFrame
		.css( "width", "1px" )
		.css( "height", "1px" )
		.css( "position", "absolute" )
		.css( "left", "-9999px" )
		.appendTo( $( "body:first" ) )
	;

	// Get a FRAMES reference to the new frame.
	var objFrame = window.frames[ strFrameName ];

	// Get a reference to the DOM in the new frame.
	var objDoc = objFrame.document;

	// Grab all the style tags and copy to the new
	// document so that we capture look and feel of
	// the current document.

	// Create a temp document DIV to hold the style tags.
	// This is the only way I could find to get the style
	// tags into IE.
	var jStyleDiv = $( "<div>" ).append(
		$( "style" ).clone()
		);

	// Write the HTML for the document. In this, we will
	// write out the HTML of the current element.
	objDoc.open();
	 var printContents = "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">" +
"<html>" +
"<head><title>" + document.title + "</title>" +
jStyleDiv.html() +
"</head>" +
this.html() +
"</body></html>";

objDoc.write(printContents);
//	objDoc.write( "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">" );
//	objDoc.write( "<html>" );
//	objDoc.write( "<body>" );
//	objDoc.write( "<head>" );
//	objDoc.write( "<title>" );
//	objDoc.write( document.title );
//	objDoc.write( "</title>" );
//	objDoc.write( jStyleDiv.html() );
//	objDoc.write( "</head>" );
//	objDoc.write( this.html() );
//	objDoc.write( "</body>" );
//	objDoc.write( "</html>" );
	objDoc.close();

	// Print the document.
	objFrame.focus();
	objFrame.print();

	// Have the frame remove itself in about a minute so that
	// we don't build up too many of these frames.
	setTimeout(
		function(){
			jFrame.remove();
		},
		(60 * 1000)
		);
    	};
    })(jQuery);