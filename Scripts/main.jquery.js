/* global require, $, page_name, base, is_admin, siteName, Ladda, google, ace, ace_js_worker, jsPDF, Modernizr, History */

$('#js-resize-placeholder').css('opacity', 0); /* For users with JS enabled, we hide this until the resize function has completed */

var PX;

$(function(){

	'use strict';

	PX.init(page_name);
	PX.pageLoad();
});

PX = function() {

	/* jshint newcap:false */

	'use strict';

	var $window = $(window);
	var $document = $(document);
	var $body = $(document.body);
	var $header = $('.main-header');

	// window.getComputedStyle polfill
	if (! window.getComputedStyle) {
		window.getComputedStyle = function(el, pseudo) {
			this.el = el;
			this.getPropertyValue = function(prop) {
				var re = /(\-([a-z]){1})/g;
				if (prop == 'float') prop = 'styleFloat';
				if (re.test(prop)) {
					prop = prop.replace(re, function () {
						return arguments[2].toUpperCase();
					});
				}
				return el.currentStyle[prop] ? el.currentStyle[prop] : null;
			};

			return this;
		};
	}

	var disqus_shortname = 'parallax-web';

	var prefix = (function () {
		var styles = window.getComputedStyle(document.documentElement, '');
		var pre;
		try {
			pre = (Array.prototype.slice
				.call(styles)
				.join('')
				.match(/-(moz|webkit|ms)-/) || (styles.OLink === '' && ['', 'o'])
			)[1];
		} catch (e) {
			pre = 'ms';
		}

		var dom = ('WebKit|Moz|MS|O').match(new RegExp('(' + pre + ')', 'i'))[1];

		return {
			dom: dom,
			lowercase: pre,
			css: '-' + pre + '-',
			js: pre[0].toUpperCase() + pre.substr(1)
		};
	})();

	var work_item_heights = function() {
		$('.grid__project-item-text-overlay .v-centered__child').each(function(){
			var $el = $(this);

			/*$el.closest('.grid__project-item-text-overlay').css({
				'height' : $el.closest('.grid__item.image').height() + 'px'
			});*/

			// some code that does work, but the images don't have enough height it turns out
			if($el.height() < $el.closest('.grid__item.image').outerHeight())
			{
				$el.closest('.grid__project-item-text-overlay').css({
					'min-height' : $el.closest('.grid__item.image').outerHeight() + 'px'
				});
			}
			else
			{
				$el.closest('.grid__project-items').css({
					'min-height' : $el.outerHeight() + 'px'
				});
				$el.closest('.grid__item.image').css({
					'min-height' : $el.outerHeight() + 'px'
				});
				$el.closest('.grid__project-item-text-overlay').css({
					'min-height' : $el.outerHeight() + 'px'
				});
			}
		});

		$('.image-showcase__hover-overlay .v-centered__child').each(function(){
			var $el = $(this);

			$el.closest('.image-showcase__hover-overlay').css({
				'width' : ($el.closest('.image-showcase').width()+1) + 'px',
				'height' : $el.closest('.image-showcase').height() + 'px'
			});
			$el.css({
				'width' : ($el.closest('.image-showcase').width()+1) + 'px',
				'height' : $el.closest('.image-showcase').height() + 'px'
			});
		});

		$('.grid__project-items--wide-text').each(function(){
			var $el = $(this);

			var text_image_height = $('.grid__project-items--text-image:last');
			var image_text_height = $('.grid__project-items--image-text:last');
			var image_image_height = $('.grid__project-items--image-image:last');

			var height = Math.max(text_image_height.height(), image_text_height.height(), image_image_height.height());
			var text_height = Math.max(text_image_height.find('.grid__item.text').height(), image_text_height.find('.grid__item.text').height());

			if ($(window).width() >= 660) {
				$el.find('.grid__item.text').css({'height' : height + 'px'});
			} else {
				$el.find('.grid__item.text').css({'height' : text_height + 'px'});
			}
		});
	};

	var site_methods = {

		home: function() {

			$window.load(function(){
				$('.fade-in-intro').show().addClass('animated').addClass('fadeInDown');
			});

			require(['waypoints'], function() {

				/* Listen for trigger and then pop the toast */
				var hasToastPopped = false;
				$('#js-trigger-toast').waypoint(function(direction) {
					if (direction === 'down' && hasToastPopped === false) { // Stick the nav to top of viewport
						$('#js-toast').animate({
							marginTop: 0
						}, 240);

						 hasToastPopped = true;
					}
				}, {
					offset : 200
				});

			});

			var $banner = $('.feature-banner--home');
			var $toggle = $('.scroll-down');
			var $feature_wrapper = $('.feature-banner--home-banner');
			var $content = $('#home-content-section');
			var visible_section;
			var previousScrollPosition = 0;

			$(document).bind('pageloaded', function(){
				work_item_heights();
			});
			$window.resize(function() {
				updateContainer();
				work_item_heights();
			});

			// Borrowed easing extension from jQuery UI
			$.extend($.easing, {
				def: 'easeOutQuad',
				easeInOutQuint: function (x, t, b, c, d) {
					if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
					return c/2*((t-=2)*t*t*t*t + 2) + b;
				}
			});

			var $html = $('html');
			var $both = $html.add($body);
			var $use = (($.browser.mozilla || $.browser.msie) ?
				$html : $body
			);

			var iOS = /(iPad|iPhone|iPod)/g.test( navigator.userAgent );
			var android = /(Android)/g.test( navigator.userAgent );

			if (iOS) {
				// Fix for iOS - position: fixed
				var scrolledY = ($(window).scrollTop() > 0 ? $(window).scrollTop() : 0);
				$('.feature-banner--home-banner').css({
					'background-attachment' : 'scroll',
					'background-position' : 'left ' + scrolledY + 'px'
				});
			}

			$window.scroll(function() {
				if ($use.scrollTop() > 0) {
					$toggle.fadeOut();
				} else {
					$toggle.fadeIn();
				}
			});

			var toggleActive = false;

			$toggle.click(function() {

				toggleActive = true;

				$both.animate({
					scrollTop: $content.offset().top - 73
				}, {
					duration: 800,
					easing: 'easeInOutQuint',
					complete: function() {
						toggleActive = false;
					}
				});
			});

			setInterval(function() {
				$toggle.toggleClass('bounce');
			}, 1200);

			if (! ('ontouchstart' in window) && ! ('onmsgesturechange' in window) && ! $.browser.msie) {
				require(['mousewheel'], function() {
					var animating = false;

					var delta = function(e) {
						var evt = e.originalEvent;

						var delta = evt.detail? evt.detail*(-120) : evt.wheelDelta;

						return delta;
					};

					$window.scroll(function (e) {

						var currentScrollPosition = $use.scrollTop();

						if (animating) {
							e.preventDefault();
							return;
						}

						var deltas = [];

						var isMagicMouseFunction = function(e) {
							e.preventDefault();
							e.returnValue = false;

							var d = delta(e);

							deltas.push(d);

							return false;
						};

						if (! toggleActive && previousScrollPosition === 0 && currentScrollPosition >= 0) {

							$body.on('mousewheel', isMagicMouseFunction);

							console.log($content.offset().top);

							$both.animate({
								scrollTop: $content.offset().top - 74
							}, {
								duration: 800,
								easing: 'easeInOutQuint',
								complete: function() {
									setTimeout(function() {
										animating = false;
										$body.off('mousewheel', isMagicMouseFunction);
									}, deltas.length > 10 ? 500 : 0);
								}
							});
						}

						previousScrollPosition = currentScrollPosition;
					});
				});
			}

			var setBannerPos = function() {
				$banner.height($window.height() - $header.height());
			};

			var setTextPos = function(offset) {

				if (typeof offset == 'undefined') {
					offset = 0;
				}
				$feature_wrapper.css('height', $(window).height() - 70);
				$('.fade-in-intro').css('top', '0px');

				console.log($feature_wrapper.height());
				console.log($feature_wrapper.css('paddingTop'));

				var feature_wrapper_height = $feature_wrapper.height() + parseInt($feature_wrapper.css('paddingTop'), 0);
				var feature_wrapper_padding = ((feature_wrapper_height - $('.fade-in-intro').height()) / 2) + offset;
				$feature_wrapper.css({'padding-top' : Math.abs(feature_wrapper_padding) + 'px'});
			};

			$('.fade-in-intro').animate({'top' : '-=90px'}, 100);

			setBannerPos();
			setTextPos();

			var updateContainer = function() {
				//setBannerPos();
				if (! iOS && ! android) {
					setTextPos();
				}
			};

			$('#js-scroll-down').hover(function() {
				$(this).removeClass('animated');
			}, function() {
				$(this).addClass('animated');
			});

			fader.init();

			$('.services__tile').hover(
				function() {
					$(this).animate({
						'padding' : '38px',
						'top' : '-3px',
						'left' : '-3px'
					}, 50);
				},
				function() {
					$(this).animate({
						'padding' : '35px',
						'top' : '0',
						'left' : '0'
					}, 50);
				}
			);

			$window.resize(PX.resizeFullViewport);
			PX.resizeFullViewport();
		},

		about: function() {

			$window.load(function(){
				$('.fade-in-intro').show().addClass('animated').addClass('fadeInDown');
			});

			var _this = this;

			require(['uri', 'waypoints'], function(uri) {

				var query = uri.query(window.location);

				if (query.hammer && query.hammer === 'time') {
					_this.about_hammer_time.call(_this);
				} else {
					_this.about_real.call(_this);
				}
			});
		},

		about_real: function() {
			var stickyNav = $('#js-stick-me-to-top');
			var stickyNavParent = stickyNav.parent();
			var shadow = $('.shadow');
			var $sections = $('[id^="js-section-"]:not(#js-section-about-nav)');
			var $links = $('.js-link-scroll');
			var h = stickyNav.outerHeight();
			var animating = false;

			if (typeof waypoint !== 'undefined') {
				$sections.eq(0).waypoint(function(direction) {

					var func;

					if (direction === 'down') { // Stick the nav to top of viewport
						stickyNav.addClass('sticky sticky--about-nav--top sticky--underneath sticky--about-nav').removeClass('sticky-cover');

						stickyNavParent.css({ height: h + 'px' });
						shadow.css({ top: '+=' + h + 'px' });
						func = 'addClass';
					} else if (direction === 'up') { // Place it back in regular position
						stickyNavParent.css({ height: 'auto' });
						shadow.css({ top: '-=' + h + 'px' });
						stickyNav.removeClass('sticky sticky--about-nav--top sticky--top-animation sticky--about-nav sticky--underneath').addClass('sticky-cover');
						func = 'removeClass';
					}

					if (!animating) {
						$links.eq(0)[func]('selected');
					}
				}, { offset: '123px' });

				$sections.each(function() {
					var el = $(this);
					var sectionName = el.attr('id').split(/[\s-]/).pop();
					var link = $links.filter('#js-link-' + sectionName);
					var index = $links.index(link) - 1;
					var prev = index < 0 || index >= $links.length ? $() : $links.eq(index);

					el.waypoint(function(dir) {

						if (animating) {
							return;
						}

						if (dir === 'down') {
							prev.removeClass('selected');
							link.addClass('selected');
						} else {
							prev.addClass('selected');
							link.removeClass('selected');
						}

					}, { offset: (h + (el.outerHeight() - el.height())) + 'px' });
				});
			}

			var $both = $('html, body');
			var els = [];
			var sections = [];
			var reductions = [];

			$links.click(function(e) {
				e.preventDefault();

				var el = $(this);
				var sectionName = el.attr('id').split(/[\s-]/).pop();

				if (els.indexOf(this)) {
					els.push(this);
				}

				var index = els.indexOf(this);

				if (!sections[index]) {
					sections.push($('#js-section-' + sectionName));
				}

				if (!sections[index].length) {
					return;
				}

				var reduction = reductions[index] || (function() {
					var reduction;

					if (stickyNav.hasClass('sticky') || sectionName === 'about' || sectionName === 'team') {
						reduction = 123;
					} else {
						reduction = 176;
					}

					reductions.push(reduction);

					return reduction;
				})();

				$links.removeClass('selected');
				el.addClass('selected');
				animating = true;

				$both.animate({
					scrollTop: sections[index].offset().top - reduction + 1
				}, 600, function() {
					animating = false;
				});
			});

			$('.slides').sm_slider({
				show_next_prev: false,
				show_pagination: false
			});

			$(window).resize(PX.resizeBackgroundSize);
			PX.resizeBackgroundSize();
		},

		scores: function(mustache) {
			if (!mustache) {
				return require(['mustache', 'es5'], function(mustache) {
					site_methods.scores(mustache);
				});
			}

			var tpl = $('[type="text/template"]').html();
			var render = $('.render');
			var render_parent = render.parent();
			var heading = render_parent.children().eq(0);
			var board = [];
			var amount = 10;

			var render_loop = function() {
				render.html(mustache.render(tpl, {
					board: board.slice(0, amount)
				}));

				return setTimeout(render_loop, 1);
			};

			render_loop();

			$window.on('resize', function(e) {
				var height = render_parent.height() - heading.height();

				amount = Math.floor(height / 95);
			}).trigger('resize');

			var res = function(ajax_loop, success, result) {
				board = result.map(function(item) {
					return item.WhamScore;
				});

				return setTimeout(ajax_loop, 1000);
			};

			var ajax_loop = function() {
				$.ajax({
					url: base + 'about/scores',
					dataType: 'json',
					cache: false,
					success: res.bind(this, ajax_loop, true),
					error: res.bind(this, ajax_loop, false)
				});
			};

			ajax_loop();
		},

		about_hammer_time: function() {

			/**
			 * Keep some element references, makes it all faster.
			 */
			var $team = $('#hammer-js-section-team');
			var $overlay = $('#game-overlay', $team);
			var $ready_form = $('#play', $overlay);
			var $stage = $('#js-team-members', $team);
			var $mallet = $('.sprite--mallet', $team);
			var $timer = $('#game-timer', $team);

			/**
			 * Animate the game into view
			 */
			$('html, body').animate({
				scrollTop: $team.offset().top
			});

			/**
			 * We'll make the game an object, just makes it easier.
			 */
			var Game = (function() {

				/**
				 * Setup some variables used throughout the game
				 */
				var Game = function() {
					this._ready = false;
					this.wham = null;
					this.sounds = null;
					this.hit_sounds = [
						'Bang1',
						'Bong',
						'Boing',
						'Boing2',
						'Boing3',
						'Clang',
						'Horn',
						'Spring'
					];
				};

				/**
				 * This function is called when all our dependcies have been loaded.
				 * Assigns some events and setups up some templates
				 * @param	{WHAM} wham			Wham Module
				 * @param	{Sounds} sounds		Sounds module
				 * @param	{Moustance} mustache Moustance module
				 * @return {Game}				 Return this for chaining
				 */
				Game.prototype.ready = function(wham, sounds, mustache) {

					/**
					 * Setup some variables
					 * @type {Boolean}
					 */
					this._ready = true;
					this.wham = wham;
					this.mustache = mustache;
					this.misses = 0;
					this.hits = 0;

					/**
					 * The object used for the sounds manager
					 * @type {Object}
					 */
					var obj = {
						start: base + siteName + '/sounds/start.mp3',
						up: base + siteName + '/sounds/up.mp3',
						end: base + siteName + '/sounds/end.mp3',
						background: base + siteName + '/sounds/background.mp3'
					};

					/**
					 * Add all our hit sounds to the sound manager object
					 */
					this.hit_sounds.forEach(function(name) {
						obj[name] = base + siteName + '/sounds/' + name + '.mp3';
					});

					/**
					 * Create an instance of sounds and assign it to ourselves
					 * @type {Sounds}
					 */
					this.sounds = new sounds(obj);

					/**
					 * Setup the events for the mallet, along with
					 * setting our "hits" and "misses" variables
					 */
					$stage.parent().on('mousedown', '*', function(e) {

						/**
						 * If we're on one of the overlays,
						 * rather than the game, don't do anything
						 */
						if ($(e.srcElement).parents().hasClass('game-overlay')) {
							return;
						}

						/**
						 * Prevent the default click handler
						 */
						e.preventDefault();

						/**
						 * If we're on an img, we'll say it's a hit.
						 * Otherwise, it's a miss
						 */
						if (e.srcElement.localName === 'img') {
							this.hits++;
						} else {
							this.misses++;
						}

						/**
						 * Make the mallet appear in its "down" state
						 */
						$mallet.addClass('down');
					}.bind(this));

					/**
					 * When we mouse up, make the mallet appear in its
					 * "up" state
					 */
					$window.on('mouseup', function() {
						$mallet.removeClass('down');
					});

					/**
					 * Setup some variables
					 */
					var offset = $mallet.parent().offset();
					var focus = true;

					/**
					 * Show/hide the mallet when our mouse enters / exits the game
					 */
					$stage.on('mouseenter', function() {
						$mallet.removeClass('hide');
					}).on('mouseleave', function() {
						$mallet.addClass('hide');
					});

					/**
					 * Show/hide the mallet when the user exits/enters the window
					 */
					$window.blur(function() {
						$mallet.addClass('hide');
						focus = false;
					}).focus(function() {
						focus = true;
					});

					/**
					 * Fix the mallet to the mouse position
					 */
					$stage.on('mousemove', function(e) {
						/**
						 * If we're in the window, show the mallet
						 */
						if (focus) {
							$mallet.removeClass('hide');
						}

						/**
						 * Move the mallet to the position of the mouse
						 */
						$mallet.css({
							top: e.pageY - offset.top + 'px',
							left: e.pageX - offset.left + 'px'
						});
					});

					return this;
				};

				/**
				 * "Start" the game
				 * @param	{String} name	Name of the user playing
				 * @param	{String} company Company of the user playing
				 * @return {Game}			 Return this for chaining
				 */
				Game.prototype.start = function(name, company) {

					/**
					 * Hide the overlay
					 */
					$overlay.addClass('hide');

					/**
					 * "Preview" all the moles at the start of the game
					 * @type {[type]}
					 */
					var $moles = $stage.find('.whack-a-mole');
					$moles.addClass('selected');

					/**
					 * Assign the name and company for later use
					 * @type {Object}
					 */
					this.data = {
						name: name,
						company: company
					};

					/**
					 * Play the "start" sound, and when it finishes, start
					 * the game for real.
					 */
					this.sounds.start.on('stop', function() {

						/**
						 * Hide all the moles, we're ready to start the game
						 */
						$moles.removeClass('selected');

						/**
						 * Start the game for real
						 */
						this.play();

						/**
						 * Don't trigger this event again.
						 */
						return true;
					}.bind(this)).play();

					return this;
				};

				/**
				 * Start the game for real
				 * @return {Game} Return this for chaining
				 */
				Game.prototype.play = function() {

					/**
					 * Reset some variables
					 */
					this.misses = 0;
					this.hits = 0;

					/**
					 * Play the background music
					 */
					this.sounds.background.play();

					/**
					 * Return the current time in ms
					 * @return {Number} Current time in ms
					 */
					var now = function() {
						return (new Date()).getTime();
					};

					/**
					 * When the game should end
					 * @type {Number}
					 */
					var end = now() + (60 * 1000); // 60 seconds

					/**
					 * When the game time has surpassed, trigger the end function
					 * @param	{Condition} condition Condition module
					 */
					require(['condition'], function(condition) {
						condition.wait(function() {
							return now() >= end;
						}, function() {
							this.end();
						}.bind(this));
					}.bind(this));

					/**
					 * Create an instance of WHAM, which controls the game
					 * @type {WHAM}
					 */
					this.inst = new this.wham({
						stage: $stage,
						mole: {
							className: 'whack-a-mole',
							activeClassName: 'selected',
							hitTargetSelector: '.selected img'
						},
						appear_after_hit: false,
						delay_after_hit: 200
					});

					/**
					 * Iniate the game
					 */
					this.inst.init();

					/**
					 * On hit, show the "hit" face, and play the hit sound
					 */
					this.inst.on('hit', (function() {

						$stage.find('.selected').addClass('hit');

						setTimeout(function() {
							$stage.find('.hit').removeClass('hit');
						}, 200);

						/**
						 * Play a random hit sound
						 */
						var rand = this.inst.rand_in_range(0, this.hit_sounds.length - 1);
						this.sounds[this.hit_sounds[rand]].play();
					}).bind(this));

					/**
					 * Show the timer and render it
					 */
					var tpl = $timer.html();
					$timer.data('tpl', tpl);

					this.inst.on('tick', this.render.bind(this, $timer, tpl, function() {
						return {
							time: Math.floor((end - now()) / 1000)
						};
					}));

					$timer.removeClass('hide');

					/**
					 * Register the game with the server
					 */

					this.key = null;

					var prom = $.ajax({
						dataType: 'json',
						url: base + 'about/scores',
						cache: false,
						data: this.data,
						type: 'POST'
					}).then(function(resp) {
						this.key = resp.WhamScore.key;

						return this.key;
					}.bind(this));

					var score = 0;

					this.inst.on('tick', function() {
						prom.then(function() {
							var tmp = this.score(true, this.inst).score;
							if (tmp !== score) {
								score = tmp;

								$.ajax({
									dataType: 'json',
									cache: false,
									data: {
										score: score
									},
									type: 'POST',
									url: base + 'about/scores/' + this.key
								});
							}
						}.bind(this));
					}.bind(this));

					/**
					 * When a mole comes up, play the "up" sound
					 */
					this.inst.on('up', (function() {
						this.sounds.up.play();
					}).bind(this));

					return this;
				};

				/**
				 * Render a template to an element with data
				 * @param	{Element} ele	Element to render to
				 * @param	{string}	tpl	Template to render
				 * @param	{mixed}	 data Data to render with
				 *
				 * @return {Game}		 Return this for chaining
				 */
				Game.prototype.render = function(ele, tpl, data) {
					switch (typeof data) {
						case 'undefined':
							data = {};
						break;

						case 'function':
							data = data.apply(this);
						break;
					}

					ele.html(this.mustache.render(tpl, data));

					return this;
				};

				/**
				 * Calculate the score
				 * @param	{Boolean} retobj Return the object, or the score?
				 * @param	{WHAM}	inst	 The instance of the WHAM module
				 * @return {Number|Object}	The score, or an object representing the score
				 */
				Game.prototype.score = function(retobj, inst) {

					/**
					 * If we haven't passed in a value,
					 * assume we dont want to return the object
					 */
					if (typeof retobj === 'undefined') {
						retobj = false;
					}

					/**
					 * Default to the current instance of WHAM
					 */
					inst = inst || this.inst;

					/**
					 * Do some calculations for the score
					 */
					var score = inst.score;
					var real_score = typeof score === 'undefined' ? 0 : score * 100;
					var acc = (this.hits / (this.hits + this.misses)) || 1;

					/**
					 * Generate the object for the score
					 * @type {Object}
					 */
					var obj = {
						score: Math.floor(real_score * acc),
						accuracy: acc,
						toScore: function() {
							return Math.floor(real_score * acc);
						}
					};

					/**
					 * If we're not returning the object, generate the score
					 */
					if (!retobj) {
						obj = obj.score;
					}

					return obj;
				};

				/**
				 * This function gets triggered at the "end" of a game
				 * @return {Game} Return this for chaining
				 */
				Game.prototype.end = function() {

					/**
					 * Stop the background music and play the end music
					 */
					this.sounds.background.stop();
					this.sounds.end.play();

					/**
					 * End the WHAM game
					 */
					this.inst.stop();

					/**
					 * Hide timer
					 */
					$timer.addClass('hide').html($timer.data('tpl'));

					/**
					 * Setup some variables
					 */
					var $over = $('#game-over-overlay', $team);
					var $render = $('.render', $over);
					var obj = this.score(true, this.inst);
					var Mustache = this.mustache;
					var tpls = [];

					/**
					 * "Render" each of the templates
					 */
					$render.each(function() {
						var $this = $(this);
						var tpl = $this.html();

						$this.html(Mustache.render(tpl, {
							total: obj.score
						}));

						tpls.push(tpl);
					});

					/**
					 * Assign the score to the data object, so we can just pass that
					 * to the ajax call
					 */
					this.data.score = obj.score;
					/**
					 * Show the "GAME OVER" screen
					 */
					$over.removeClass('hide');

					/**
					 * Restart the game when the user clicks restart
					 */
					$over.one('click', '#restart', function(e) {
						/**
						 * Cancel the default click event
						 */
						e.preventDefault();

						/**
						 * Hide the "GAME OVER" overlay
						 */
						$overlay.removeClass('hide');

						/**
						 * Show the Play Game overlay
						 */
						$over.addClass('hide');

						/**
						 * Restore all templates to their original state
						 */
						$.each(tpls, function(i, tpl) {
							$render.eq(i).html(tpl);
						});
					}.bind(this));

					/**
					 * Remove the reference to the finished game
					 */
					this.inst = null;

					return this;
				};

				/**
				 * Get the data for the score board
				 * @param	{Function} callback Callback to call with the scores
				 * @return {Game}				Return this for chaining
				 */
				Game.prototype.scores = function(callback) {
					/**
					 * Wait for the score board to be allowed to
					 * show before getting the scores
					 */
					require(['condition'], function(condition) {
						condition.wait(function() {
							return !this.submitting_score;
						}.bind(this), function() {

							$.ajax({
								dataType: 'json',
								url: base + 'about/scores',
								success: callback.bind(this, false),
								error: callback.bind(this, true),
								cache: false
							});

						}.bind(this));
					}.bind(this));

					return this;
				};

				return Game;
			})();

			/**
			 * Create an instance of the game
			 */
			var game = new Game();

			/**
			 * Make sure the the data passed in is valid before starting the game
			 */
			$ready_form.validate({
				cancel: function() {

					/**
					 * Cache a variable for speed
					 */
					var $box = $ready_form.children().eq(0);

					/**
					 * Remove the classes needed for the animation,
					 * otherwise it won't animate
					 */
					$box
						.removeClass('animated')
						.removeClass('shake');

					/**
					 * Has to be in a setTimeout or it won't animate
					 */
					setTimeout(function() {
						/**
						 * Add the classes needed for animation
						 */
						$box
							.addClass('animated')
							.addClass('shake');
					});
				},
				preventSubmit: true
			});

			/**
			 * Get some variables and focus first input field
			 */
			var $inputs = $ready_form.find('input');
			var $first_input = $inputs.eq(0).focus();
			var $name_input = $inputs.filter('[name=name]');
			var $company_input = $inputs.filter('[name=company]');
			var $not_submit = $inputs.not('[type=submit]');

			/**
			 * When the form submits, start the game
			 */
			$ready_form.submit(function(e) {
				/**
				 * Prevent the default action
				 * of the page reloading
				 */
				e.preventDefault();

				/**
				 * Wait for the game to be ready before starting the game
				 */
				require(['condition'], function(condition) {
					condition.wait(function() {
						return game._ready;
					}, function() {

						/**
						 * Get some data from the data input fields
						 */
						var name = $name_input.val();
						var company = $company_input.val();
						/**
						 * Reset the state for the restart
						 */
						$not_submit.val('');
						$first_input.focus();

						/**
						 * Start the gane
						 */
						$('#js-team-members').show();
						game.start(name, company);
					});
				});
			});

			/**
			 * Setup some variables required for the high score board
			 */
			var $scoresOverlay = $('#game-scores-overlay');
			var $render = $('.render', $scoresOverlay);
			var tpl = $('[type="text/template"]', $scoresOverlay).html();

			/**
			 * When a "high score" button is pressed, start the game
			 */
			$('.high-scores').click(function(e) {

				/**
				 * Prevent the default action to avoid
				 * jumping to the top of the page
				 */
				e.preventDefault();

				/**
				 * Cache variable for speed
				 */
				var $this = $(this);
				var loader;

				/**
				 * If we haven't clicked this button before,
				 * iniate Ladda on it
				 */
				if (!$this.data('loader')) {
					$this.data('loader', loader = Ladda.create(this));
				} else {
					loader = $this.data('loader');
				}

				/**
				 * If we're already loading, no need to do anything
				 */
				if (loader.isLoading()) {
					return;
				}

				/**
				 * Show a loading spinner to the user
				 */
				loader.start();

				/**
				 * Grab the scores from the server
				 * @param	{Boolean} err	 Was there an error?
				 * @param	{Array} scores	Array of the scores, ordered by high score
				 */
				game.scores(function(err, scores) {

					/**
					 * If there isn't an error, render the scores
					 */
					if (!err) {

						/**
						 * Map the scores to the format we want
						 */
						scores = $.map(scores, function(score) {
							return score.WhamScore;
						});

						/**
						 * Render the scores and show the scores overlay
						 */
						require(['mustache'], function(m) {
							$render.html(m.render(tpl, {
								board: scores
							}));

							$scoresOverlay.removeClass('hide');

							loader.stop();
						});
					} else {
						loader.stop();
					}
				});
			});

			/**
			 * When a "back" button is hit, hide the high scores overlay
			 */
			$scoresOverlay.on('click', '#high-scores-back', function(e) {
				/**
				 * Prevent the page jump
				 */
				e.preventDefault();

				/**
				 * Hide the scores overlay
				 */
				$scoresOverlay.addClass('hide');
			});

			/**
			 * Load all our dependencies and pass them into the game
			 */
			require(['wham', 'audio', 'mustache', 'es5'], function(wham, sounds, mustache) {
				game.ready(wham, sounds, mustache);
			});
		},

		our_work: function() {

			$(document).bind('pageloaded', function(){
				work_item_heights();
			});
			$window.resize(function() {
				work_item_heights();
			});
		},

		our_work_view: function() {

			PX.initPrevNextBtns();

			var max_height = 0;
			
			function equalise_text_text_items() {
				$('.grid__project-items--text-text .grid__item.text').each(function(){

					var $el = $(this);
					var $prev = $el.prev();
					var $next = $el.next();
					if ($next.is('.grid__item.text') && $next.height() > $el.height()) {
						$el.css({'height' : $next.height() + 'px'});
					} else if ($prev.is('.grid__item.text') && $prev.height() > $el.height()) {
						$el.css({'height' : $prev.height() + 'px'});
					}
				});
			}

			$(document).bind('pageloaded', function(){
				work_item_heights();
				equalise_text_text_items();
			});
			$(window).resize(function(){
				work_item_heights();
				equalise_text_text_items();
			});
		},

		case_study_buy_yorkshire_2013: function() {

			require(['waypoints'], function() {

				var hasToastPopped = false;
				$('#js-trigger-toast').waypoint(function(direction) {
					if (direction === 'down' && hasToastPopped === false) { // Stick the nav to top of viewport
						$('.js-toast').animate({
							marginTop: 0
						}, 240);

						hasToastPopped = true;
					}
				});

				var hasTextMessageRun = false;
				$('#js-trigger-text-message').waypoint(function(direction) {
					if(direction === 'down' && hasTextMessageRun === false) { // Stick the nav to top of viewport
						$('.text-conversation__message--1').animate({
							top: '151px'
						}, 240);

						setTimeout(function() {
							$('.text-conversation__message--1').animate({
								top: '90px'
							}, 100);
							$('.text-conversation__message--2').animate({
								top: '232px'
							}, 240);
						}, 3600);

						hasTextMessageRun = true;
					}
				}, { offset: '70px' });

			});

			PX.initCarousel();
			PX.initPrevNextBtns();

		},

		case_study_tccp: function() {

			require(['waypoints'], function() {

				var havePinsDropped = false;
				$('#js-trigger-pins').waypoint(function(direction) {
					if(direction === 'down' && havePinsDropped === false) { // Stick the nav to top of viewport
						var count = 1;
						var pinPositions = [];
						pinPositions[1] = 190;
						pinPositions[2] = 297;
						pinPositions[3] = 140;
						pinPositions[4] = 229;
						pinPositions[5] = 260;

						var func = function() {
							$('.js-pin--' + count).animate({
								opacity: 1,
								top: pinPositions[count] + 'px'
							}, 300);

							count += 1;

						};

						for (var i = 1; i <= 5; i++) {

							var pinModel = '<img class="js-pin js-pin--' + i + ' pos--absolute" src="/parallax/img/case_studies/tccp/map_pin.png" />';
							$(pinModel).insertBefore('.js-map');

							setTimeout(func, (Math.random()*350+1)); // Set a random delay
						}

						havePinsDropped = true;
					}
				});

			});

			PX.initCarousel();
			PX.initPrevNextBtns();

		},

		case_study_nsfdba: function() {

			require(['waypoints'], function() {

				var hasToastPopped = false;
				$('#js-trigger-toast').waypoint(function(direction) {
					if (direction === 'down' && hasToastPopped === false) { // Stick the nav to top of viewport
						$('.js-toast').animate({
							marginTop: 0
						}, 240);

						hasToastPopped = true;
					}
				});

			});

			PX.initCarousel();
			PX.initPrevNextBtns();

		},

		blog: function() {

			$.getScript ("http://" + disqus_shortname + ".disqus.com/count.js");

			// The filters currently selected
			var current_filters = {};

			var params = getUrlParams(); // Create a params array, with identical structure to Cake's $this->params['named']

			current_filters.author = 'undefined';
			if (params.author !== void(0)) {
				current_filters.author = params.author;
			}

			// Set page to null to begin with, until we start loading more items / filtering
			// If we have a page specified in the URL, use that instead
			current_filters.pg = null;
			if (params.pg !== void(0)) {
				current_filters.pg = parseInt(params.pg);
			}

			// Do we have predefined filters set?
			var predefined_filters_exist = (params !== void(0) && (params.pg !== void(0) || params.category !== void(0) || params.date !== void(0) || params.author !== void(0)));

			// Previously chosen filters in an array, as a history of sorts
			var historic_filters = {};
			historic_filters.categories = [];
			historic_filters.dates = [];

			// Initialize History.js
			PX.initHistory();

			// If we're on the blog index & articles are present, arrange them with isotope.js
			if ($('#blog-articles').size() > 0) {
				$('#blog-articles').isotope({
					itemSelector: '.grid__item',
					getSortData : {
						date : function ($elem) {
							return parseInt($elem.attr('data-date'), 10);
						}
					},
					sortBy : 'date',
					sortAscending : false
				});
			}

			// If we need syntax highlighting, initialize it
			if (typeof hljs !== 'undefined') {
				hljs.initHighlightingOnLoad();
			}

			// Click event for a filter menu item (by Category, or by Date)
			var active_dropdown;
			$('.flyout__content-filter a').on('click', function(e, r){

				e.preventDefault();

				var el = $(this);

				if (! el.is('.selected')) {

					$("#js-load-more-articles").text('Load More');

					// Change dropdown text to use new filter
					var li = el.parent();
					var ul = li.parent();
					var lis = ul.children('li');
					var a = ul.prev();
					active_dropdown = ul.prev();
					var span = a.children("span:first");
					var new_label = el.text();

					if (ul.hasClass('months')) {
						ul = a.parent().parent();
						a = active_dropdown = ul.prev();
						span = a.children("span:first");
						var yearmonth = el.attr('data-yearmonth').split('-');
						new_label = el.text() + ' ' + yearmonth[0];

						lis.children('a').removeClass('selected');
						el.addClass('selected');
					}

					span.text(new_label);

					// Highlight it in the menu
					lis.children('a').removeClass('selected');
					el.addClass('selected');

					// We've clicked a year, show the months for that year
					if (typeof el.attr('data-year') === 'string') {

						$('.months').hide();
						el.next('ul').show();

					} else {

						// Otherwise, we've clicked a menu item that will create a filter

						if (el.attr('data-category') === 'undefined') {

							// We've clicked on a 'All Categories'
							delete current_filters.category;

						} else if (el.attr('data-yearmonth') === 'undefined') {

							// We've clicked on a 'All Dates'
							$('.months').hide().find('a').removeClass('selected');
							delete current_filters.date;

						} else if (typeof el.attr('data-category') !== 'undefined') {

							// We've clicked a category
							current_filters.category = el.attr('data-category');

						} else if (typeof el.attr('data-yearmonth') !== 'undefined') {

							// We've clicked a date
							current_filters.date = el.attr('data-yearmonth');
						}

						// Go ahead & filter...
						filter_blog(true);
					}
				}
			});

			if (params.category !== void(0) || params.date !== void(0)) {

				if (params.category !== void(0) && params.date !== void(0)) {

					$('.flyout__content-filter--categories .btn__dropdown').each(function(){
						if ($(this).attr('data-category') === params.category) {
							$(this).click();
						}
					});
					$('.flyout__content-filter--dates .btn__dropdown').each(function(){
						if ($(this).attr('data-yearmonth') === params.date) {
							$(this).click();
						}
					});

				} else if (params.category !== void(0)) {
					$('.flyout__content-filter--categories .btn__dropdown').each(function(){
						if ($(this).attr('data-category') === params.category) {
							$(this).click();
						}
					});
				} else if (params.date !== void(0)) {
					$('.flyout__content-filter--dates .btn__dropdown').each(function(){
						if ($(this).attr('data-yearmonth') === params.date) {
							$(this).click();
						}
					});
				}
			}

			// At this point we've done the .click() on the filter menus to sort the conditions passed from the URL, so
			// we'll ensure the flag is now set so that it doesn't affect any future pagination logic.
			//dealt_with_pageload_pagination = true;

			// defaults for pulling in blog posts
			var offset = 0;
			var limit = 6;

			/**
			 *	Applies a filter to the blog
			 *	@used_dropdowns: If used_dropdowns is true, we'd like to filter as normal. If false, the user clicked the 'Go Back' button on the 'No Blog Posts' page state & we want
			 *					 to reset the blog to only show 6 entries, using the last filters
			 *
			 *	- Figures out the conditions for the filter
			 *	- Posts off an AJAX request for a group of items that we definitely want on the page
			 *	- Compares those items to the items already on the page, figures out 2 distinct groups:
			 *		i) Items already on the page that are no longer relevant (removes these)
			 *		ii) New items from the query that aren't already present (adds these), note: list of items to be added gets trimmed to fill to multiples of 6
			 *	- Applies .isotope() method to add/remove/rearrange using absolute positioning & animation
			 *	- For overall history: Uses history.js to keep a track of user's decisions & keep them on the history stack
			 *	- For current page history: Creates an array of the filters chosen, so when we reach 'No blog posts found' scenario our code has the intelligence for a 'Go back' button
			 */
			function filter_blog(used_dropdowns) {
				/* jshint noempty: false */

				var filter_limit = 12;	// Bring back at least 6 non-matching, in case we're after a whole new set

				// When filters are applied and no blog posts are found as a result, users hit a 'No Blog Posts' page state. This has a back button, which needs to know what the previous state of the filters was.
				// If 'used_dropdowns' is false (the user didn't click a filter dropdown) then we're applying the filters as a result of the user clicking the 'Go Back' button on the 'No Blog Posts' page state
				if (! used_dropdowns) {
					current_filters.category = historic_filters.categories[0];
					current_filters.date = historic_filters.dates[0];
				}

				var changed_category = (current_filters.category != historic_filters.categories[0]);
				var changed_date = (current_filters.date != historic_filters.dates[0]);

				/* Figure out the limit */
				if (changed_category || changed_date || ! used_dropdowns) {

					filter_limit = 6;	 // If we've picked a new filter or used the 'Go Back' button, we want to completely start again, there's no chance of duplicates, pull 6 in.

					// If we've had a pagination page (pg:) passed in the URL, we should alter the limit accordingly
					if (typeof params.pg !== 'undefined') {
						filter_limit = current_filters.pg * 6;
					} else {
						current_filters.pg = 1;
					}
				}

				/* Figure out the offset */
				// The offset will be the amount of pages see (pages - 1), multiplied by the items per page, unless
				// we're loading the items with a predefined pagination number, when we'll want the offset to be zero.
				if (typeof current_filters.pg !== 'undefined') {
					offset = (current_filters.pg - 1) * 6; // 0 for page 1, 6 for page 2 etc.
				} else {
					offset = 0;
				}

				// If we've chosen a date from the dropdowns (rather than clicking the 'Go Back' button on the No Results page), then we want to add it to the history
				if (used_dropdowns) {
					// Set the last category & date into the history
					if (typeof historic_filters.categories !== 'undefined') historic_filters.categories.unshift(current_filters.category);
					if (typeof historic_filters.dates !== 'undefined') historic_filters.dates.unshift(current_filters.date);
				}

				// If we're using predefined filters, all the logic is done server side, otherwise, send off an AJAX request with the filters
				if (! predefined_filters_exist) {

					var url = base + 'blog/get_posts/' + offset + '/' + filter_limit + '/' + current_filters.category + '/' + current_filters.date + '/' + current_filters.author;

					active_dropdown.addClass('blog-cat-ajax').children('i').hide();

					$.ajax({
						type: 'POST',
						url: url,
						success: function(html){

							$('.flyout--blog > a').removeClass('blog-cat-ajax').children('i').show();

							var existing_items = $('#blog-articles .grid__item');

							// Look through the existing items, and find a match when the article id doesn't match up with any of the new ids
							var items_to_remove = existing_items.filter(function(existing_index){
								var match = true;
								$(html).each(function(){
									var el = $(this);
									if ($(existing_items[existing_index]).attr('data-id') === $(el[0]).attr('data-id')) {
										match = false;
									}
								});
								return match;
							});

							// Reduce the new set of articles to exclude any identical articles already on the page
							var items_to_add = $(html).filter(function(){
								var match = true;
								var el = $(this);
								existing_items.each(function(existing_index){
									if ($(existing_items[existing_index]).attr('data-id') === $(el[0]).attr('data-id')) {
										match = false;
									}
								});
								return match;
							});

							var existing_count = $('#blog-articles .grid__item').size();
							var remove_count = items_to_remove.size();

							// The fill up count is how many extra are required to fill articles up to the next bunch of 6
							var fillup_count = 6 - ((existing_count - remove_count) % 6);

							offset = existing_count - remove_count + fillup_count; // The new 'existing' count
							limit = existing_count;

							items_to_add = items_to_add.slice(0, fillup_count);

							// Any articles previously on the page, which still need to be on the page remain there
							// Any irrelevant results to the new filter get dropped
							// Any newly relevant results get added
							$("#blog-articles").isotope('remove', items_to_remove).isotope('insert', items_to_add);

							if ($("#blog-articles").data('isotope').$filteredAtoms.length === 0) {
								$('.no-posts').fadeIn('slow');
								$('#js-load-more-articles').fadeOut('fast');
							} else {
								$('.no-posts').fadeOut('fast');
								$('#js-load-more-articles').fadeIn('slow');
							}

							if ($("#js-load-more-articles").size() > 0) {
								$("input#noMoreArticles").remove();
							}

							updateHistory();
						}
					});
				}

				if ($('.rotator').size() > 0) {
					$('.rotator').hover(function() {
						$(this).removeClass('show-front').addClass('show-bottom');
					}, function() {
						$(this).removeClass('show-bottom').addClass('show-front');
					});
				}
			};

			var throbber = $('.blog-load-more-throbber');

			var loading_posts = false;

			function load_more_posts() {

				if (! loading_posts) {
					loading_posts = true;

					var $button = $('#js-load-more-articles');

					if ($button.hasClass('disabled')) {
						return;
					}

					$button.addClass('disabled');

					throbber.addClass('show');

					offset = $('#blog-articles .grid__item').size();
					limit = 6;

					var url = base + 'blog/get_posts/' + offset + '/' + limit + '/' + current_filters.category + '/' + current_filters.date + '/' + current_filters.author;
					$.ajax({
						type: 'POST',
						url: url,
						success: function(html){

							$("#blog-articles").isotope('insert', $(html));
							throbber.removeClass('show');

							$.getScript ("http://" + disqus_shortname + ".disqus.com/count.js");

							setTimeout(function() {
								$("#blog-articles > div").fadeTo(500, 1);
							}, 500);

							if ($("input#noMoreArticles").size() > 0) {
								$("#js-load-more-articles").text('All Shown').unbind('click').bind('click', function(){ return false; }).css({'cursor' : 'auto'});
								$("input#noMoreArticles").remove();
							} else {
								current_filters.pg++;

								updateHistory();
							}

							loading_posts = false;
						},
						complete: function() {
							$button.removeClass('disabled');
						}
					});
				}
			}

			$("#js-load-more-articles").css({'cursor' : 'pointer'}).attr('id', 'js-load-more-articles');
			$(document).on('click', '#js-load-more-articles', function(e){
				e.preventDefault();
			});
			$(document).on('mousedown', '#js-load-more-articles', function(e){
				e.preventDefault();

				load_more_posts();
			});

			$(window).scroll(function(e){
				var $document_height = $(document).height();
				var $window_height = $(window).height();
				var $scroll_top = $(window).scrollTop();

				var $load_point = $document_height - $window_height - 800;

				if ($scroll_top > $load_point) {
					load_more_posts();
				}
			});

			var updateHistory = function() {

				var push_url = base + 'blog/index';

				if (typeof current_filters.category !== 'undefined')
					push_url += '/category:' + current_filters.category;

				if (typeof current_filters.date !== 'undefined')
					push_url += '/date:' + current_filters.date;

				if (typeof current_filters.pg !== 'undefined')
					push_url += '/pg:' + current_filters.pg;

				History.replaceState(
					{
						state: push_url,
						url: push_url
					},
					document.title,
					push_url
				);
			}

			$(document).on('click', '#js-go-back', function(e){

				e.preventDefault();

				// Set both dropdowns to show the throbber
				$('.flyout--blog > a').addClass('blog-cat-ajax').children('i').hide();

				var category_dropdown_text = $('.flyout--blog-category > a > span');
				var date_dropdown_text = $('.flyout--blog-date > a > span');

				// If the previous category wasn't defined, set the title of the dropdown to 'All Categories'
				// Else hide & unselect all the dropdown options, then run through them all and
				// Check if it's the same as the 'previous category':
					// If so, we select that category
					// Else, we ensure that category is deselected

				if (typeof(historic_filters.categories[0]) === 'undefined') {
					category_dropdown_text.text('All Categories');
					$('.flyout__content-filter--categories a').removeClass('selected');
				} else {
					$('.flyout__content-filter--categories a').each(function(){
						var el = $(this);
						if (el.attr('data-category') == historic_filters.categories[0]) {
							category_dropdown_text.text(el.text());
							el.addClass('selected');
						} else {
							el.removeClass('selected');
						}
					});
				}


				// If the previous date wasn't defined, close & unselect all the month headings
				// Else hide & unselect all the year headings, then run through all the month headings and...
				// Check if it's the same as the 'previous date':
					// If so, we select that month and the year it belongs to
					// Else, we ensure that month is deselected

				if (typeof(historic_filters.dates[0]) === 'undefined') {
					date_dropdown_text.text('All Dates');
					$('.months').hide().find('a').removeClass('selected');
				} else {
					$('.months').hide().each(function(){
						$(this).siblings('a').removeClass('selected');
					});
					$('.months a').each(function(){
						var el = $(this);
						if (el.attr('data-yearmonth') == historic_filters.dates[0]) {
							var yearmonth = el.attr('data-yearmonth').split('-');
							date_dropdown_text.text(el.text() + ' ' + yearmonth[0]);
							el.addClass('selected').parent().parent().show().siblings('a').addClass('selected');
						} else {
							el.removeClass('selected');
						}
					});
				}

				// We pass true as we definitely want to override both values with the previous ones
				filter_blog(false);

				historic_filters.categories.shift();
				historic_filters.dates.shift();
			});

			// @todo Mayb's this needs sortin'
			setTimeout(function() {
				if (location.pathname.indexOf('pg:') > -1) {

					// Move the page to the correct area for the pagination requested
					$('html, body').animate({scrollTop : $('#blog-articles').height()-900}, 'slow');
				}

				// We don't care about predefined filters by this point, allow all AJAX from now on
				predefined_filters_exist = false;
			}, 1000);

			// Once we've done our initial page load, we'll start using pagination
			if (current_filters.pg == null) {
				current_filters.pg = 1;
			}
		},

		blog_view: function() {
			PX.initPrevNextBtns();

			if (typeof hljs !== 'undefined') {
				hljs.initHighlightingOnLoad();
			}

			$('body').on('change', '.select-author', function(e){

				var article_id = $(this).attr('data-article-id');
				var author_id = $(this).val();

				$.ajax({
					type: 'POST',
					url: base + 'admin/blog/update_author/' + article_id + '/' + author_id,
					success: function(response) {
						$('.select-author-result').css({'color' : 'green'}).text('Success').show();
						setTimeout(function(){
							window.location.href = window.location.href;
						}, 1000);
					},
					error: function(jqXHR, textStatus, errorThrown) {
						$('.select-author-result').css({'color' : 'red'}).text('Try again, error: ' + errorThrown).show();
					}
				});

				e.preventDefault();
			});

			/**
			 * Super cool mobile iframe resizing
			 *
			 */
			$(function() {

				$('.blog-article iframe').each(function() {

						// Get the current width and height
					var width = $(this).attr('width');
					var height = $(this).attr('height');

					// Get the width it's supposed to be
					var newWidth = $('.blog-article').width();

					// Get the ratio between the current width and the new width
					var ratio = newWidth / width;

					// We can now get a new height from that
					var newHeight = (newWidth < 320) ? newWidth * 1.5 : height * ratio;

					$(this).css('width', newWidth);
					$(this).css('height', newHeight);
				});
			});

			/* Tutorials */
			if ($('.blog-tutorial').size() > 0) {
				exec_view_features();
				bind_view_events();
			}

		},

		services: function() {

			$window.load(function(){
				$('.fade-in-intro').show().addClass('animated').addClass('fadeInDown');
			});

			$(window).resize(PX.resizeBackgroundSize);
			PX.resizeBackgroundSize();
		},

		careers: function() {


		},

		contact: function() {

			var initialize_map = function() {

				var latlng = new google.maps.LatLng(53.794838, -1.537548);

				var style = [
					{
						featureType: "all",
						elementType: "all",
						stylers: [
							{
								saturation: -100
							}
						]
					}
				];

				var myOptions = {
					zoom: 14,
					center: latlng,
					scrollwheel: false,
					mapTypeControlOptions: {
						mapTypeIds: [google.maps.MapTypeId.ROADMAP, 'greyThis']
					}
				};

				var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

				var mapType = new google.maps.StyledMapType(style, { name:"Grayscale" });
				map.mapTypes.set('greyThis', mapType);
				map.setMapTypeId('greyThis');

				var contentString = '<div id="content">'+
					'<div id="site_notice"></div>'+
					'<div id="body_content">'+
					'<h3 class="push-none">Parallax</h3><p>The Old Brewery,<br />Leeds,<br />LS2 7ES</p>'+
					'</div>'+
					'</div>';

				var infowindow = new google.maps.InfoWindow({
					content: contentString
				});


				var image = new google.maps.MarkerImage(base + "parallax/img/parallax_pin.png",
					new google.maps.Size(186.0, 110.0),
					new google.maps.Point(0, 0),
					new google.maps.Point(90.0, 110.0)
				);

				var marker = new google.maps.Marker({
					position: latlng,
					map: map,
					icon: image
				});

				google.maps.event.addListener(marker, 'click', function() {
					infowindow.open(map,marker);
				});

				google.maps.event.addDomListener(window, 'resize', function() {
					map.setCenter(latlng);
				});

			};

			initialize_map();

			$('#contactForm .error input, #contactForm .error textarea').focus(function() {
				var el = $(this);
				el.siblings('.error-message').animate({'right' : '30px', 'opacity' : '0'}, 300, 'linear',	function() {
					$(this).detach();
				});
			});

			$('.error-message').click(function() {
				$(this).siblings('input').focus();
			});

			$(window).resize(PX.resizeBackgroundSize);
			PX.resizeBackgroundSize();

		},

		products_expose: function() {
			require(['products/expose/slider'], function() {
				$('.sites-display__slides').sm_slider({
					show_next_prev: false,
					show_pagination: true,
					auto: !is_admin
				});
			});
		},

		products_jspdf: function() {

			$('#js-download-button').click(function() {
				$('#js-download-form').slideDown();

				var qs,js,q,s,d=document,gi=d.getElementById,ce=d.createElement,gt=d.getElementsByTagName,id='typef_orm',b='https://s3-eu-west-1.amazonaws.com/share.typeform.com/';if(!gi.call(d,id)){js=ce.call(d,'script');js.id=id;js.src=b+'widget.js';q=gt.call(d,'script')[0];q.parentNode.insertBefore(js,q)}

				return false;
			});

		},

		identify_visible_section: function() {
			var visible_section;
			$('.work-section').each(function(){
				if (parseInt($(this).css('opacity'), 10) === 1) {
					visible_section = $(this);
				}
			});

			return visible_section;
		}
	};

	var fader = function() {

		var s;

		var $ul = $('.fader ul');

		return {

			settings: {
				speed: 6000,
				fade: 500,
				ul: $ul,
				arrow: $('.fader__arrow'),
				arrow_left: 'fader__arrow--left',
				arrow_right: 'fader__arrow--right',
				timer: null,
				slides_num: $('li', $ul).length,
				selected_class: 'selected'
			},

			init: function() {
				s = this.settings;

				s.ul.children().first().addClass(s.selected_class);
				s.ul.children().not(':eq(0)').hide();

				this.bindUIActions();
				this.startTimer();
			},

			bindUIActions: function() {
				s.arrow.click(function(event) {
					fader.processFade($(this));
					event.preventDefault();
				});
			},

			startTimer: function() {
				s.timer = setInterval(function() {
					fader.processFade();
				}, s.speed);
			},

			destroyTimer: function() {
				clearInterval(s.timer);
				s.timer = false;
			},

			processFade: function(user_action) {

				var curr = s.ul.children('.' + s.selected_class).index();
				var i;

				if (user_action !== undefined) {
					fader.destroyTimer();
					if (user_action.hasClass(s.arrow_left) && curr === 0) {
						i = s.slides_num - 1;
					} else if (user_action.hasClass(s.arrow_left)) {
						i = curr - 1;
					} else if (user_action.hasClass(s.arrow_right) && curr === s.slides_num - 1) {
						i = 0;
					} else {
						i = curr + 1;
					}
				} else {
					i = (curr === s.slides_num - 1) ? 0 : curr + 1;
				}

				fader.fadePanel(i);
			},

			fadePanel: function(i) {
				s.ul.children('.' + s.selected_class).removeClass(s.selected_class).fadeOut(s.fade, function() {
					s.ul.children(':eq('+i+')').addClass(s.selected_class).fadeIn(s.fade);
				});

				if (!s.timer) {
					fader.startTimer();
				}
			}
		};
	}();

	var siteWide = {

		init: function() {
			this.adminNavBar();
			this.backToTheTop();
			this.initSearch();
			this.clearForms();
			this.equalHeightElements();
			this.blurredHeader();
			this.navDropDown();
			this.mobileOptimisation();
			this.initFlyouts();
			this.socialMediaButtons();
			this.hideFeatureText();
		},

		HOOK: function() {

			var nextButton = $('.js-next');
			var prevButton = $('.js-prev');
			var nextFullWidth = nextButton.width();
			var prevFullWidth = prevButton.width();

			$(nextButton).css('width', '48px');
			$(prevButton).css('width', '48px');


			$('.js-next').hover(function() {
				$(this).animate({
					width: nextFullWidth + 50
				}, 120);
			}, function() {
				$(this).animate({
					width: 48
				}, 340);
			});

			$('.js-prev').hover(function() {
				$(this).animate({
					width: prevFullWidth + 50
				}, 120);
			}, function() {
				$(this).animate({
					width: 48
				}, 340);
			});


		},

		adminNavBar: function() {
			if (is_admin && $('#admin_bar').size() > 0)	{
				$('header.main-header').css({'top' : $('#admin_bar').height()});
			}
		},

		backToTheTop: function() {
			// Scroll to the top
			$('#js-back-to-top').bind('mousedown', function(e) {
				e.preventDefault();
				$('html, body').animate({scrollTop : 0},'slow');
			});
		},

		clearForms: function() {

			var $forms = $('form .clear-form');

			$forms.each(function(){
				$(this).attr('data-def', $(this).val());
			});

			$forms.focus(function(){
				var el = $(this);
				var default_val = el.attr('data-def');
				if (el.val() === default_val) {
					el.val('').css({'color' : '#FFF', 'font-style': 'normal'});
				}
			});

			$forms.blur(function(){
				var el = $(this);
				var default_val = el.attr('data-def');
				if (el.val() === '') {
					el.val(default_val);
				}

				el.css({'color' : '#FFF'});
			});

		},

		initSearch: function() {
			$('#site-search-submit').toggle(function() {
				$(this).children('.sprite--generated').removeClass('sprite--search').addClass('sprite--close-button');
				$(this).closest('div').animate({'width' : '320px'}, 300);
			}, function() {
				$(this).children('.sprite--generated').removeClass('sprite--close-button').addClass('sprite--search');
				$(this).closest('div').animate({'width' : '70px'}, 300).dequeue();
			});
		},

		equalHeightElements: function() {
			// Equal Height Elements
			var el = [];
			el.push(".equal-height");
			el.push(".equal-height-sub");
			$.each(el, function(key, val){
				var maxHeight = 0;
				var $val = $(val);

				$val.each(function(){
					var el = $(this);
					var thisHeight = parseInt(el.outerHeight(), 10);
					if (thisHeight > maxHeight) {
						maxHeight = thisHeight;
					}
				});

				$val.css({ 'height':	maxHeight + 'px' });
			});
		},

		blurredHeader: function() {

			/**
			 * Disabled for now :(
			 */
			return;

			/**
			 * This is the first "non-fixed" element on the page.
			 */
			var $first = $('.first-to-show');

			/**
			 * If we're an admin, the header doesn't exist, or we can't blur things,
			 * there is no point in continuing
			 */
			if (!Modernizr.cssfilters || is_admin || !$header.length || !$first.length || !window.getComputedStyle) {
				return;
			}

			/**
			 * Account for vendor prefixes
			 */
			window.MutationObserver = window.MutationObserver || window[prefix.js + 'MutationObserver'];

			/**
			 * If the browser doesn't support Mutation Observers, no point in continuing
			 */
			if (!window.MutationObserver) {
				return;
			}

			window.getMatchedCSSRules = false;

			/**
			 * Attempt to polyfill window.getMatchedCSSRules
			 */
			window.getMatchedCSSRules = window.getMatchedCSSRules || (function() {

				/**
				 * Account for vendor prefixes and different names
				 */
				Element.prototype.matches = Element.prototype.matches ||
											Element.prototype.matchesSelector ||
											Element.prototype[prefix.lowercase + 'MatchesSelector'];

				/**
				 * We rely on Element.prototype.matches for the polyfill,
				 * if we don't have that, no point in continuing.
				 */
				if (!Element.prototype.matches) {
					return;
				}

				/**
				 * Polyfill for window.getMatchedCSSRules.
				 * It doesn't work cross origin, as it relies on document.styleSheets,
				 * and is much slower than winndow.getMatchedCSSRules. (2000x slower)
				 *
				 * @see http://jsperf.com/getmatchedcssrules-polyfill
				 *
				 * @param {Elememt} element The Element to get matched rules for.
				 * @return {Array} An array of CSSStyleRule-s
				 */
				return function(element) {

					/**
					 * Store the rules
					 * @type {Array}
					 */
					var rules = [];

					/**
					 * Loop through each of our document.styleSheets
					 */
					Array.prototype.forEach.call(document.styleSheets, function(sheet) {
						/**
						 * If we can't access the cssRules, no point in continuing
						 */
						if (!sheet.cssRules) {
							return;
						}

						/**
						 * Loop through each of the css, and append them to our rules if
						 * they match
						 */
						Array.prototype.forEach.call(sheet.cssRules, function(rule) {
							try {
								if (rule.selectorText && element.matches(rule.selectorText)) {
									rules.push(rule);
								}
							} catch (e) {}
						});
					});

					return rules;
				};
			})();

			/**
			 * If we couldn't polyfill getMatchedCSSRules, no point in continuing
			 */
			if (!window.getMatchedCSSRules) {
				return;
			}

			/**
			 * Pull in our dependencies
			 * @param	{Base64} base64	base64 encode + decode
			 * @param	{URI}	URI	 Parse URIs
			 */
			require(['base64', 'uri', 'es5'], function(base64, URI) {

				/**
				 * If we've manually triggered no blur, then don't continue
				 */
				if ('no_blur' in URI.query(window.location.search)) {
					return;
				}

				/**
				 * This is the element we'll use to hold the blurred image
				 */
				var $image = $(document.createElement('img')).css({ opacity: 0 });

				/**
				 * This is the element that will have the cached blurred image data in it,
				 * if it exists.
				 */
				var $content = $('#blur-image-content');

				/**
				 * This will be the URL for the imasge.
				 */
				var url;

				if ($content.length) {
					url = $content.attr('src');
					$content.remove();
				} else {
					url = base + 'blur_image/' + base64.encode((window.location.pathname + window.location.search).substr(base.length));
				}

				/**
				 * This will hold the top "offset" of the first non-fixed element.
				 * This is updated on window resize
				 */
				var offset;

				var onResize = function() {
					offset = $first.position().top;
				};

				onResize();

				$window.resize(onResize);

				/**
				 * This is the div that will hold the whole blur
				 */
				var $div = $(document.createElement('div'))
					.addClass('header__blur')
					.appendTo('body');

				/**
				 * This will hold the background sections for the blur
				 * It is initially hidden
				 */
				var $bg_div = $(document.createElement('div'))
					.addClass('header__blur__bg')
					.css({ opacity: 0 })
					.appendTo($div);


				/**
				 * We're going to loop through all the sections and add clones of them
				 * to the blurred background div
				 */

				/**
				 * Get all the sections
				 */
				var $nodes = $first.add($first.nextAll());

				/**
				 * Create an itial jQuery obj, as we'll be using jQuery.add
				 * to fill this
				 */
				var $divs = $();

				/**
				 * This will hold the previous section as we
				 * loop through the sections
				 */
				var $prev;

				/**
				 * Loop through the sections, clone them,
				 * and add them to the blurred background div
				 */
				$nodes.each(function() {

					/**
					 * Create a clone of this node,
					 * and create a jQuery reference to it
					 */
					var clone = this.cloneNode();
					var $clone = $(clone);

					/**
					 * Make the dimensions of this clone right,
					 * clear its contents, and add it to
					 * the background div
					 */
					$clone
						.height($(this).outerHeight())
						.html('')
						.appendTo($bg_div);

					/**
					 * We need to handle the transitions between sections too,
					 * this does that
					 */
					if ($prev) {
						/**
						 * Work out the two colours to transition to
						 */
						var colorOne = window.getComputedStyle($prev[0])['background-color'];
						var colorTwo = window.getComputedStyle($clone[0])['background-color'];

						/**
						 * If either of them were not set, default to white
						 */
						if (colorOne === 'rgba(0, 0, 0, 0)') {
							colorOne = 'rgb(255,255,255)';
						}

						if (colorTwo === 'rgba(0, 0, 0, 0)') {
							colorTwo = 'rgb(255,255,255)';
						}

						/**
						 * Create a string representing the linar background
						 */
						var bgString = 'linear-gradient(top, ' + colorOne + ',' + colorTwo + ')';

						var $gradDiv = $(document.createElement('div'))
							.insertBefore($clone)
							.css({
								position: 'absolute',
								top: $clone.position().top - 5 + 'px',
								height: '10px',
								backgroundImage: prefix.css + bgString,
								width: '100%',
								zIndex: 99999
							});

						/**
						 * Attempt to set non-prefixed linear gradient
						 */
						$gradDiv.css('backgroundImage', bgString);

						/**
						 * Add our grad div to the $divs variable
						 */
						$divs = $divs.add($gradDiv);
					}

					$prev = $clone;
				});

				/**
				 * Hide all of the transitions div
				 */
				$divs.css({ opacity: 0 });

				/**
				 * This will hold all elements blurred on the front end
				 * @type {[type]}
				 */
				var $hover_div = $(document.createElement('div')).addClass('header__blur__bg').css({
					zIndex: 99999,
					opacity: 0
				}).appendTo($div);

				/**
				 * This will generate a callback to handle events.
				 * @return {Function} Generate a callback
				 */
				var generateCb = (function() {

					/**
					 * Store all cloned elements
					 */
					var $clones = $();

					/**
					 * Generate a callback
					 * @param	{String} ev	Enter Event Name
					 * @param	{Array}	oev Pseudo-selector and exit event name
					 * @return {Function}	 Callback to handle the event
					 */
					return function(ev, oev) {

						var className = oev[0];
						oev = oev[1];

						/**
						 * This is the function to handle events
						 * @param	{$.Event} e jQuery event object
						 */
						return function(e) {

							/**
							 * Just stop this event
							 */
							e.stopPropagation();

							/**
							 * Store some variables
							 */
							var $this = $(this);
							var _this = this;

							/**
							 * Get all "applied" rules for the psuedo selector
							 * for this event
							 */
							var rules = window.getMatchedCSSRules(_this);
							var appliedRules = [];

							Array.prototype.forEach.call(rules, function(rule) {
								if (rule.selectorText.match(':' + className)) {
									appliedRules.push(rule);
								}
							});

							/**
							 * If we actually have any changed rules for this
							 * pseudo selector.
							 */
							if (appliedRules.length) {

								/**
								 * Create a clone of this element, and a jQuery
								 * reference to it
								 */
								var clone = document.createElement(_this.nodeName);
								var $clone = $(clone).html($this.html());

								/**
								 * Remove all IDs
								 */
								$clone.filter('[id]').add($clone.find('[id]')).removeAttr('id');

								/**
								 * Reset the rules array to be a key value pair
								 * object of css rules
								 * @type {Object}
								 */
								rules = {};

								/**
								 * Format the appliedRules into a key value
								 * pair object
								 */
								appliedRules.forEach(function(rule) {
									var keys = Array.prototype.slice.call(rule.style);

									keys.forEach(function(key) {
										rules[key] = rule.style[key];
									});
								});

								/**
								 * Set the initial styles to the same as the original element
								 */
								clone.setAttribute('style',	window.getComputedStyle(_this).cssText);

								/**
								 * Apply some rules that we need to in order
								 * for the element to show, and the rules
								 * we got from appliedRules, and append it to our
								 * hover_div
								 */
								$clone.css({
									zIndex: 9999,
									margin: 0
								}).css(rules).appendTo($hover_div);


								/**
								 * Blur the clone, and put it into position
								 */
								var obj = {
									position: 'absolute',
									top: $this.offset().top - offset,
									left: $this.offset().left,
									filter: 'blur(3px)'
								};

								obj[prefix.js + 'Filter'] = 'blur(3px)';

								$clone.css(obj);

								/**
								 * Add our clone to the object to keep track of clones
								 */
								$clones = $clones.add($clone);

								/**
								 * Remove all clones on the exit event
								 */
								$this.one(oev, function() {
									$clones.remove();
								});
							}
						};
					};
				})();

				/**
				 * Loop through event of the events and assign a callback
				 */
				$.each({
					'mouseenter': ['hover', 'mouseleave'],
					'focus': ['focus', 'blur']
				}, function(ev, oev) {
					$document.on(ev, 'section *', generateCb(ev, oev));
				});

				/**
				 * Find all nodes that have been assigned an
				 * "active" status. These are the only ones we'll
				 * watch for Mutation events
				 */
				var activeNodes = document.querySelectorAll('.active-node');

				/**
				 * Loop through active nodes and assign mutation observers
				 * to them
				 */
				Array.prototype.forEach.call(activeNodes, function(node) {
					var $node = $(node);
					var $clone;

					var update = function() {
						var node = $node[0];

						if ($clone) {
							$clone.remove();
						}

						$clone = $node.clone();
						$clone.html(node.innerHTML);

						$clone[0].setAttribute('style',	window.getComputedStyle(node).cssText);

						/**
						 * Blur the clone
						 */
						var obj = {
							position: 'absolute',
							top: $node.offset().top - offset,
							left: $node.offset().left,
							filter: 'blur(3px)'
						};

						obj[prefix.js + 'Filter'] = 'blur(3px)';

						$clone.css(obj);

						/**
						 * Remove all IDs
						 */
						$clone.filter('[id]').add($clone.find('[id]')).removeAttr('id');

						if ($clone.is('input, textarea')) {
							$clone.val($node.val());
						}

						/**
						 * Append the clone to the $hover_div
						 */
						$clone.appendTo($hover_div);
					};

					update();

					var observer = new MutationObserver(update);

					observer.observe(node, {
						attributes: true,
						childList: true,
						characterData: true,
						subtree: true
					});

					$node.on('change keydown keyup', update);
				});

				/**
				 * We don't want to show anything until our
				 * blurred image has loaded.
				 *
				 * Wait for that
				 */
				$image.on('load', function() {

					/**
					 * Create the container for image
					 * @type {[type]}
					 */
					var $image_container = $(document.createElement('div'))
						.addClass('header__blur__image');

					/**
					 * Append our image to the container
					 */
					$image.appendTo($image_container);

					/**
					 * Setup some variables for the scroll event
					 */
					var $pair = $bg_div.add($hover_div);
					var hidden = true;

					/**
					 * This callback will device if the blurred image should be shown or not
					 */
					var onScroll = function() {
						if (document.body.scrollTop >= (offset - 70)) {
							if (hidden) {
								$div.children().css({ opacity: 1 });
								hidden = false;
							}
							$image_container[0].scrollTop = document.body.scrollTop - (offset) + 70;
							$pair.css({ top: 0 - ((document.body.scrollTop - (offset))) + 'px' });
						} else if (!hidden) {
							$div.children().css({ opacity: 0 });
							hidden = true;
						}
					};

					onScroll();
					setInterval(onScroll, 100);
					$document.scroll(onScroll).resize(onScroll);

					/**
					 * Append to $image_container to our container div
					 */
					$image_container.appendTo($div);

					/**
					 * Show the bg div
					 */
					$bg_div.css({ opacity: 1 });

					/**
					 * Fade everything else in
					 */
					$image.add($divs).add($hover_div).animate({ opacity: 1 }, 5000);

					/**
					 * Allow the blurred header to be seen through
					 */
					$header.addClass('main-header--blurred');
				});

				if (!$content.length) {
					$.get(url, function(res) {
						$image.attr({
							src: 'data:image/jpeg;base64,' + res
						});
					});
				} else {
					$image.attr({
						src: url
					});
				}
			});
		},

		initFlyouts: function() {

			$(document).on('keydown', function(e) {

				var $this = $(e.srcElement);

				if ($this.hasClass('flyout') && $this.hasClass('flyout--keyboard-ctrl')) {
					e.preventDefault();

					var dir;

					switch (e.which) {
						case 38:
							dir = 'prev';
						break;

						case 40:
							dir = 'next';
						break;
					}

					if (dir) {
						var selected = $this.find('.selected');
						var val;

						if (selected.parent().is('li:first') && dir === 'prev') {
							val = $this.find('li:last a').text();
						} else {
							val = selected.parent()[dir].call(selected.parent()).text();

							if (!val) {
								val = $this.find('li:first a').text();
							}
						}

						$this.val(val);
					}
				}
			});

			$('.flyout').each(function() {
				var $this = $(this);
				var selector = $this.hasClass('.flyout--auto-hide') ? '.flyout a' : '.flyout > a';

				if ($this.hasClass('flyout--keyboard-ctrl') && !$this.attr('tabindex')) {
					$this.attr('tabindex', -1);
				}

				$this
					.on('click', selector, function(e) {
						e.preventDefault();
						$this.toggleClass('visible');
					})
					.on('mouseleave', function() {
						$this.removeClass('visible').blur();
					})
					.on('click', '.flyout ul a', function(e) {
						var el = $(this);

						if (!el.hasClass('selected')) {

							var li = el.parent();
							var ul = li.parent();
							var lis = ul.children('li');
							var a = ul.prev();
							var span = a.children("span:first");
							var new_label = el.text();

							$this.val(new_label);
						}
					});
			});

			$.fn.val = (function() {

				var value = $.fn.val;

				return function(val) {

					if (this.hasClass('flyout')) {

						var as = this.find('li a');
						var ul = this.find('ul');

						if (typeof val !== 'undefined') {
							as.removeClass('selected');

							var a = as.filter(function() {
								return $(this).text() === val;
							});

							a.addClass('selected');

							ul.prev().find('span:first').text(val);

						} else {
							return as.filter('.selected').text();
						}

						// /this.find('li a').removeClass('selected');
					} else {
						return value.apply(this, arguments);
					}
				}

			})();
		},

		navDropDown: function() {
			// $('#js-popout-parent').click(function(e) {
			//	 e.preventDefault();
			// });
		},

		formatCommas: function(x) {
			return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		},

		mobileOptimisation: function() {

		},

		socialMediaButtons: function() {
			if ($('.social-button-container').size() > 0) {

				$('body').on('mouseenter', '.social-button-container', function(e) {
					$(this).find('.social-door').addClass('open');
				});

				$('body').on('mouseleave', '.social-button-container', function(e) {
					$(this).find('.social-door').removeClass('open');
				});
			}
		},

		hideFeatureText: function() {
			// featured text is visible on any background except white, this hides it
			$(window).scroll(function() {
				if($(window).scrollTop() > 750)
				{
					$('.feature-banner--about__text').hide();
				}
				else
				{
					$('.feature-banner--about__text').show();
				}
			});
		}
	};

	/* Tutorials */
	var reposition_reveals = function() {
		setTimeout(function(){
			$('.reveal-button').each(function(){
				var el = $(this);
				var button = el.next('.reveal');
				var pos = el.position();

				var width = parseInt(el.width()) + parseInt(el.css('paddingLeft')) + parseInt(el.css('paddingRight'));
				var button_width = parseInt(button.width()) + parseInt(button.css('paddingLeft')) + parseInt(button.css('paddingRight'));

				var diff = (width - button_width) / 2;

				button.css({'left' : (pos.left + diff) + 'px'});
			});
		}, 20);
	}

	var exec_view_features = function() {
		reposition_reveals();

		// Interval timer for FB dash & nav images on the right
		setInterval(function(){
			$('.fb-dash-nav img:visible').fadeOut();
			$('.fb-dash-nav img:hidden').fadeIn();
		}, 6000);
	};

	var bind_view_events = function() {
		// When the window is resized, reposition reveals
		$(window).resize(function(){
			reposition_reveals();
		});

		// On hovering the reveal buttons, show the reveal area
		$('.reveal-button').hover(
			function() {
				$(this).next('.reveal').show();
			},
			function() {
				$(this).next('.reveal').hide();
			}
		);
	};

	var current_page_name;

	return {

		init: function(page_name) {
			current_page_name = page_name;
		},

		pageLoad: function() {
			/* jshint noempty: false */

			console.log('So, you like looking under the hood? Why not come work for us? http://parall.ax/careers');

			var property_name = current_page_name.replace(/-/g, '_').toLowerCase();

			$('.touch-nav').hammer({ prevent_default: true }).bind('touchstart swipe mousedown', function(e){

				$(this).parent().toggleClass('open');

				e.preventDefault();
				e.stopPropagation();

				return;
			});

			$('.touch-nav').hammer({ prevent_default: true }).bind('touch click', function(e){
				return false;
			});

			if ($header.length) {
				$('.nav .contact a').mouseenter(function(){
					var el = $(this);
					var li = el.parent();
					li.addClass('hover');
					$header.css({'zIndex' : '50'});
				}).mouseleave(function(){
					var el = $(this);
					var li = el.parent();
					li.removeClass('hover');
					$header.css({'zIndex' : '99'});
				});
			}

			if (site_methods.hasOwnProperty(property_name)) {
				site_methods[property_name]();
			}

			// Run sitewide functions
			siteWide.init();
		},

		initPrevNextBtns: function() {
			var nextButton = $('.js-next');
			var prevButton = $('.js-prev');

			var nextFullWidth = nextButton.width();
			var prevFullWidth = prevButton.width();

			nextButton.css('width', '48px');
			prevButton.css('width', '48px');

			nextButton.hover(function() {
				nextButton.animate({
					width: nextFullWidth + 50
				}, 120);
			}, function() {
				nextButton.animate({
					width: 48
				}, 340);
			});

			prevButton.hover(function() {
				prevButton.animate({
					width: prevFullWidth + 50
				}, 120);
			}, function() {
				prevButton.animate({
					width: 48
				}, 340);
			});
		},

		initHistory: function() {

			/**
			 * Initialize History.js
			 */
			var History = window.History; // Note: We are using a capital H instead of a lower h
			if (! History.enabled) {
				// History.js is disabled for this browser.
				// This is because we can optionally choose to support HTML4 browsers or not.
				return false;
			}

			// Bind to StateChange Event
			var last_state = '';
			History.Adapter.bind(window, 'statechange', function(){ // Note: We are using statechange instead of popstate
				var State = History.getState(); // Note: We are using History.getState() instead of event.state

				// if (State.data.state === undefined) {
				//	close_modal();
				// }

				// if (last_state != '' && typeof State.data.url !== 'undefined' && State.data.url != last_state) {
				//	 State.data.url
				// }
				last_state = State.data.url;

				History.log(State.data, State.title, State.url);
			});

		},

		initCarousel: function() {

			var $carousel = $('#carousel');

			if ($carousel.length) {
				var carousel_options = {
					responsive: false,
					circular: true,
					infinite: false,
					width: '100%',
					height: 700,
					align: "center",
					padding: [0],
					auto: false,
					pagination	: "#carousel-pagination",
					scroll: 1,
					items: {
						width: 1010,
						height: 700,
						visible: {
							 min: 3
							// max: 3
						}
					},
					prev: '#carousel-prev',
					next: '#carousel-next',
					mousewheel: false,
					swipe: {
						onMouse: true,
						onTouch: true
					}
				};

				$carousel.carouFredSel(carousel_options);
			}

		},

		resizeFullViewport: function() {

			var viewportWidth = $window.width();
			var viewportHeight = $window.height();
			var reqWidth;
			var reqHeight;

			if(viewportWidth > viewportHeight) { // Explicitly set background size for iOS
				reqHeight = 0.64 * viewportWidth;

				if(reqHeight < viewportHeight) {
					reqWidth = 1.5625 * viewportHeight;

					$('#js-resize-placeholder').css({
						'height': $window.height(),
						'background-size': reqWidth + 'px ' + viewportHeight + 'px'
					});
				} else {
					$('#js-resize-placeholder').css({
						'height': $window.height(),
						'background-size': viewportWidth + 'px ' + reqHeight + 'px'
					});
				}
			} else {
				reqWidth = 1.5625 * viewportHeight;

				if(reqWidth < viewportWidth) {
					reqHeight = 0.64 * viewportHeight;
					$('#js-resize-placeholder').css({
						'height': $window.height(),
						'background-size': viewportWidth + 'px ' + reqHeight + 'px'
					});
				} else {
					$('#js-resize-placeholder').css({
						'height': $window.height(),
						'background-size': reqWidth + 'px ' + viewportHeight + 'px'
					});
				}
			}

			$('#js-resize-placeholder').css('opacity', 1);
		},

		resizeBackgroundSize: function() {
			var viewportWidth = $window.width();
			var viewportHeight = $('#js-resize-placeholder').height() + 74; /* removed the offest on the bg iamegs to prevent blank chunks on the intial page load; requires +80 here to account for header height */

			var reqWidth;
			var reqHeight;
			var aspectY;
			var aspectX;

			if (current_page_name == 'about') {
				aspectY = 0.3444444444;
				aspectX = 2.9032258065;
			} else {
				aspectY = 0.3333333333;
				aspectX = 3;
			}

			if(viewportWidth > viewportHeight) {

				reqHeight = aspectY * viewportWidth;

				if(reqHeight < viewportHeight) {
					reqWidth = aspectX * viewportHeight;

					$('#js-resize-placeholder').css({
						'background-size': reqWidth + 'px ' + viewportHeight + 'px'
					});
				} else {
					$('#js-resize-placeholder').css({
						'background-size': viewportWidth + 'px ' + reqHeight + 'px'
					});
				}
			} else {
				reqWidth = aspectX * viewportHeight;

				if(reqWidth < viewportWidth) {
					reqHeight = aspectY * viewportHeight;
					$('#js-resize-placeholder').css({
						'background-size': viewportWidth + 'px ' + reqHeight + 'px'
					});
				} else {
					$('#js-resize-placeholder').css({
						'background-size': reqWidth + 'px ' + viewportHeight + 'px'
					});
				}
			}

			$('#js-resize-placeholder').css('opacity', 1);
		},

	};

	// General JS helper functions
	function getUrlParams() {

		var parts = window.location.toString().split('/');
		var params = {};

		$.each(parts, function(key, val){
			if (val.indexOf('http') < 0 && val.indexOf(':') > -1) {
				var keyval = val.split(':');
				params[keyval[0]] = keyval[1];
			}
		});

		return params;
	}
}();
