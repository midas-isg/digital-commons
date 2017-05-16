var XSD_FORM =
(function() {
	function XSDForm() {
		return;
	}
	
	function elemVisible(elem) {
		return elem.is(":visible");
	}
	
	function camelCase2English(inputString) {
		var outputString = inputString.charAt(0),
			toInsert = '',
			i;
		
		for(i = 1; i < inputString.length; i++) {
			toInsert = inputString.charAt(i);
			
			if((toInsert >= 'A') && (toInsert <= 'Z')) {
				if((inputString.charAt(i-1) < 'A') || ((inputString.charAt(i-1) > 'Z'))) {
					toInsert = ' ' + toInsert;
				}
			}
			outputString += toInsert;
		}
		
		return outputString;
	}
	
	XSDForm.prototype.makeReadable = function() {
		var labels,
			i;
		
		labels = document.getElementsByTagName("label");
		
		for(i = 0; i < labels.length; i++) {
			labels[i].textContent = camelCase2English(labels[i].textContent);
		}
		
		return;
	};
	
	XSDForm.prototype.validate = function() {
		var previousItems = null,
			count;
		
		$('*[number]').each( function(index) {
			var thisId = this.id,
				elem = $('#' + thisId);
			
			// will do validations here
			//if elem visible then do the validation for that element
			if (elemVisible(elem))
				elem.change();
		});
		
		$('input:radio').each( function (index) {
			var elem = $('#' + this.id)
			if (elemVisible(elem))
				elem.change();
		});
		
		count = $('.item-error').filter(":visible").length
		if(count > 0) {
			$('#validation-errors').show();
			return false;
		}
		
		$('#validation-errors').hide();
		
		return true;
	};

	return new XSDForm();
})();
