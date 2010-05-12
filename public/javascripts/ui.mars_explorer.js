$.widget("ui.rover_control", {
	_init: function() {
	    var $self= this;
	    var $el= this.element;
	    $el.find(".send-to-mars-btn").click(function() {
		    var rover_label= $(this).parent().find(".label").text();
		    var rover= {
			label: rover_label,
			x: 0,
			y: 0
		    };
		    var post_data= {
			data: $.toJSON(rover)
		    };
		});
	}
    });

$.widget("ui.rover", {
	_init: function() {
	    this.label= this.options.label;
	    this.find();
	},
        _state: function() {
	    var self= this;
	    $.getJSON("/rovers/"+this.label);
	},
	find: function() {
	    this._state();
	},
	mars_land: function() {
	    var self= this;
	    $.post("/rovers", post_data, function(data) {
		    self.state= $.toJSON(data);
		});
	},
        earth_land: function() {
	    $.post(this.resource, {method:"delete"});
	}
    });

jQuery(document).ready(function($) {
	$(".rover-control").rover_control();
    });