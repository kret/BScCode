/*
 * Plugin for autocomplete:
 * - request send if at least 3 letters are entered
 * - if no matching records in data base - Add new... is proposed
 * - on error blocking and showing proper alert to user
 */

(function( $, _alert ) {

			/* dialog for adding a new person */
			var _dialog = $( '#dialog' ).dialog({
					autoOpen: false,
					modal: true,
					buttons : {
						'Dodaj' : function() { 
							var name		= jQuery('#name').val(),
								lastname	= jQuery('#lastname').val();
							
							$.ajax({
								type: 'POST',
								url: '/people.json',
								data: {
									'person[first_name]':name,
									'person[last_name]':lastname
								},
								success: function( data ,x, y,z ) {
									$( "<li id=person-"+data.person.id+">" + data.person.first_name + ' ' + data.person.last_name + '<a class=delete>x</a></li>' )
										.appendTo( "#book-author-details-list" );
								},
								error: function(e) {
									_alert.alert('error', e);
								}
							});
						
							$( this ).dialog( "close" );
						}
					}
			});

		var methods = {	
			/**
			 * Get all selected autors
			 * @return {array}
			 */
			getAll : function() {
				console.log(this.data('add_autor') ? this.data('add_autor').autors : [])
				return this.data('add_autor') ? this.data('add_autor').autors : [];
			},
			
			/**
			 * Remove autor by ID
			  * @param id {number}		ID of autor
			 */
			remove : function( id ) {
				var _listOfAutors = this.data( 'add_autor' ).autors,
					_autorInDom = $( '#author-' + id );
					
				this.data( 'add_autor', { autors : _listOfAutors.remove( id ) } );
				_autorInDom.fadeOut( function() { _autorInDom.remove(); } );
			}
		};
		
		var init = function() {
				var self = this;
				
				var add_selected_autor = function(message, id) {
						var _listOfAutors 	= self.data('add_autor') ? self.data('add_autor').autors : [],
							newAutor 		= $( "<li id=author-"+id+">" + message + '<a href="#delete" class=delete>x</a></li>' )

						_listOfAutors.push(id);
						
						self.data('add_autor', {autors : _listOfAutors});
						newAutor
							.appendTo( "#book-author-details-list" )
								.find('.delete').bind('click', function() {
									self.autors('remove',id, self);
								});
					};

					self.autocomplete({
						minLength: 3,
						
						select: function( event, ui ) {
						
							if (ui.item.id) {
								add_selected_autor( ui.item.label, ui.item.id )
							} else {
								_dialog.dialog( "open" );
							}

						},
						
						close : function() {
							self.val('');
						},
						
						source: function( request, response ) {
			
							$.ajax({
								url: "/people/autocomplete_person_last_name",
								dataType: "json",
								data: { term: request.term },
								success: function(data) {
									// if no data received prepare for special solution
									if (data.length === 0) {
										response([{id: null, label: "Dodaj nową osobę..."}])
									} else {
										response(data);
									}
								},
								error: function(object, statusText, reason, m) { 
									_alert.alert('error', e); 
									self.attr('disabled', true);
								}
							});
						}
					});
					return this;
		};

		
		$.fn.autors = function(method) {
			if ( methods[method] ) {
				return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
			} else if ( typeof method === 'object' || ! method ) {
				return init.apply( this, arguments );
			}
		};  

		Array.prototype.remove = function(e) { return this.splice(this.indexOf(e),1); };

})(jQuery, alert);
    	
