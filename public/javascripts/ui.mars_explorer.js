$.widget("ui.mars_tooltip", {
	_init: function() {
	},
        show: function(msg,left,top) {
	    var $el= this.element;
	    $el.find(".content").html($("<p/>").text(msg));
	    $el.css({left:left,top:top}).show();
	},
        close: function() {
	    this.element.hide();
	}
    });

$.widget("ui.rover_control", {
	_init: function() {
	    var $self= this;
	    var $el= this.element;
	    var id= $el.attr("id").split("-")[2];
	    var $rover= "#rover-"+id;
	    var label= $el.find(".label").text();
	    $($rover).rover({label:label, resource:"/rovers"});

	    // the rover was found somewhere on Mars
	    $($rover).bind("on_mars", function(e, pos) {
		    $el.find(".send-to-mars-btn").hide();
		    $el.find(".position").show();
		    $el.find(".back-to-earth-btn").show();

		    $el.find(".position .x input").val(pos[0]);
		    $el.find(".position .y input").val(pos[1]);
		});
	    // the rover was found parked on Earth
	    $($rover).bind("on_earth", function() {
		    $el.find(".send-to-mars-btn").show();
		    $el.find(".position").hide();
		    $el.find(".back-to-earth-btn").hide();
		});

	    $el.find(".send-to-mars-btn").click(function() {
		    $($rover).rover("mars_land");
		});

	    $el.find(".back-to-earth-btn").click(function() {
		    $($rover).rover("earth_land");
		});

	    $el.find(".position .go").click(function() {
		    var current_pos= $($rover).rover("position");
		    var x= $el.find(".x input").val()-current_pos[0];
		    var y= $el.find(".y input").val()-current_pos[1];
		    if (!(x==0 && y==0))
			$($rover).rover("move",x,y);
		});
	}
    });

$.widget("ui.rover", {
	_init: function() {
	    var $el= this.element;
	    var self= this;
	    this.label= this.options.label;
	    this.resource= this.options.resource;
	    // initialized with state for
	    // placing the rover on Mars
	    if (this.options.state) {
		this._state(this.options.state);
	    // find the rover
	    } else {
		this.find();
	    }

	    $el.hover(function(e) {
		    var msg= "Click on rover to transport";
		    $("#mars-tooltip").mars_tooltip("show", msg, self._x*27-38, self._y*27-80);
		}, function() {
		    $("#mars-tooltip").mars_tooltip("close");
		});
	},
	_state: function(state, render) {
	    var $el= this.element;

	    if (render==undefined)
		render= true
	    // if it's got no id is because
	    // the rover is on Earth,
	    // then send it to Mars
	    if (!this._id) {
		// append/send to Mars
		$("#mars").append($el);
	    }
	    this._id= state.id;
	    this._x= state.x;
	    this._y= state.y;
	    $el.trigger("on_mars", [[this._x,this._y]]);

	    if (render)
		this._render();
	},
        _render: function() {
	    var $el= this.element;
	    $el.css({left:this._x*27,top:this._y*27}).show();
	},
	find: function() {
	    var self= this;
	    var $el= this.element;
	    $.getJSON(this.resource+"/"+this.label, function(data) {
		    // the rover was found on Mars
		    if (data) {
			self._state(data.rover);
		    } else {
			$el.trigger("on_earth");
		    }
		});
	},
        mars_land: function(x,y) {
	    var self= this;
	    var rover= {
		label: this.label,
		x: x,
		y: y
	    };
	    var post_data= {
		data: $.toJSON(rover)
	    }
	    $.post(this.resource, post_data, function(data) {
		    self._state(JSON.parse(data).rover);
		});
	},
        earth_land: function() {
	    var $el= this.element;
	    $.post(this.resource+"/"+this._id, {_method:"delete"});
	    this._id= null;
	    this._x= null;
	    this._y= null;
	    $("#earth").append($el);
	    $el.trigger("on_earth");
	},
        move: function(x,y) {
	    var self= this;
	    var post_data= {_method:"put",
			    distance_x:x,
			    distance_y:y
	    };
	    if (!(x==0 && y==0))
		$.post(this.resource+"/"+this._id+"/move", post_data, function(data) {
			self._state(JSON.parse(data).rover);
		    });
	},
        position: function() {
	    return [this._x,this._y];
	}
    });
$.extend($.ui.rover, {getter:"position"});

jQuery(document).ready(function($) {
	$(".rover-control").rover_control();
	$("#mars-tooltip").mars_tooltip();
    });