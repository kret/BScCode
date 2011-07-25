/*
 * Global variables
 */
var alert = $( '#alertBox' ).alert();


(function( $, _alert ){

		var request_url = '/books/',
			method		= 'POST',
			form		= $('#book-details');
			aut 		= $('#autors').autors();  	
	
			submit = function(){
			
					/*
					 * Function to parse all authors data and prepare for sending
					 */
					var getAuthors = function() {
							return aut.autors('getAll');
						},
					
						books = {
							book : {
								title : $('#book_title').val(),
								original_title : $('#book_original_title').val(),
								au_ids : getAuthors()
							}
						};
					
					console.log(books.book)
					
					$.ajax({
						type: method,
						url: request_url,
						data: books,
						success: function( data ,x, y,z ) {
							_alert.alert('info', data, x,y,z);
						},
						error: function(e) {
							_alert.alert('error', e);
						}
					});
							
					
			};
	
			$( '#submit' ).bind( 'click', submit );
})( jQuery, alert );
