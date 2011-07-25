/*
 * Alert plugin
 */
(function(  ){
	var domElement = null;
	
	var methods = {
		init : function() {
			domElement = this;
			return this;
		},
		error : function(a) {
			domElement.html(a.responseText).addClass('error').removeClass('info');
		},
		info : function(a) {
			domElement.html(a).addClass('info').removeClass('error');
		
		},
    	hide : function() {}
	};

	$.fn.alert = function(method) {
		if ( methods[method] ) {
			return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
		} else if ( typeof method === 'object' || ! method ) {
			return methods.init.apply( this, arguments );
		} 
  };  
    	
    	
})(  );