(function(  ){
	
	var refreshView = {};
	
	refreshView.mouseButtonPressed = function(_self) {
		_self.toggleClass('click');
	};
	refreshView.mouseButtonReleased = function(_self) {
		_self.toggleClass('click');
	};

	refreshView.changeState = function(label, input, _state) {
		label.toggleClass('selected', _state);
		input.attr('checked', _state);
	};
	refreshView.showPreloader = function(element) {
		if (element) {
			element.append('<div class=preloader style="width: '+element.width()+'px; height: '+element.height()+'px;"></div>')
		} else {
			jQuery('.preloader').fadeIn();
		}

	};
	refreshView.hidePreloader = function() {
		jQuery('.preloader').fadeOut('slow');
	};
	refreshView.showError = function(_status, _element) {
		refreshView.hidePreloader();
		var message = ""
		switch (_status) {
			case 503:
				message = "Wystąpił błąd komunikacji."
				
		}
		if (_element) {
			_element.append('<div class=download-error style="width: '+_element.width()+'px; height: '+_element.height()+'px;">'+message+'</div>')
		}
	};


	var init = function(params) {
		var s = this;

		refreshView.showPreloader(s.parent());
					console.log('cccccc')
		$.ajax({
			type: 'POST',
			url: "/books/"+bookId+"/get_preferences",
			dataType: "json",
			success: function(data) {
					data = data.preferences
					s.each( 
						function() {
							var myLabel = jQuery(this);
							var myInput = jQuery('#'+myLabel.attr("for"));
							
							var myInputName = myInput.attr('name');
							var myInputValue = (myInput.attr('value') === 'true');
									
							
							if (data[myInputName] === myInputValue) {
								refreshView.changeState(myLabel, myInput, true);
							}
			
							
							myLabel
								.mousedown(function() { 
									refreshView.mouseButtonPressed(myLabel);
								})
								.mouseup(function() { 
									refreshView.mouseButtonReleased(myLabel);
								})
				
							myInput
								.change( function() {
									
									refreshView.showPreloader();
									var inputChecked = $(this).is(':checked');
									var theOtherLabel   = $('label[for='+myInputName+'_'+!myInputValue+']');
									var theOtherOneInput = $('input[id='+myInputName+'_'+!myInputValue+']');
									var theOtherOneInputChecked = theOtherOneInput.is(':checked');
			
									refreshView.changeState(myLabel, myInput, inputChecked);						
			
									if (inputChecked && theOtherOneInputChecked) {
										refreshView.changeState(theOtherLabel, theOtherOneInput, false);						
									}
									
									controler.saveData(myInputName, { val: myInputValue, state: inputChecked }, {val: !myInputValue, state: theOtherOneInput.is(':checked')});
									
								});
				
						}
					);
					refreshView.hidePreloader();
				},
				error: function(object, statusText, reason, m) { 
					refreshView.showError(object.status, s.parent());
				}
			});

	};
	
	controler = {};
	controler.saveData = function(name,x,y) {
			var result = null;
			console.log(name,x.val, x.state,y.val, y.state, (x.state & y.state), (x.state && y.state))
			if (x.state === true) {
				result = x.val;			
			} else if (y.state === true) {
				result = y.val;
			}
			
			var obj = {};
			obj[name] = result;
			
			$.ajax({
				type: 'POST',
				url: "/books/"+bookId+"/set_preferences",
				//dataType: "json",
				data: 'preferences='+JSON.stringify(obj),
				success: function(data) {
					refreshView.hidePreloader();

				},
				error: function(object, statusText, reason, m) { 
					
				}
			});
	}
	var methods = {};
	
	$.fn.toggleButton = function(method) {
		if ( methods[method] ) {
			return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
		} else if ( typeof method === 'object' || ! method ) {
			return init.apply( this, arguments );
		} 
  };  


})(  );


jQuery(".tag").toggleButton();