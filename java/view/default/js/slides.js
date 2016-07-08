/*
slides v1.0
Plugin developed by: Steven Wanderski
*/

(function($) {
  $.fn.slides = function(options) {
    var defaults = {
      move: 4,
      click_move: 0,
      display_num: 4,
      speed: 500,
      margin: 0,
      auto: false,
      auto_interval: 2000,
      pause:1000,
      auto_dir: 'next',
      auto_hover: false,
      next_text: '', // Next
      next_image: '',
      prev_text: '', // Prev
      prev_image: '',
      controls: true
    };
    
    var options = $.extend(defaults, options);
    return this.each(function() {
      var $this = $(this);
      var li = $this.find('li');
      var first = 0;
      var fe = 0;
      var last = options.display_num - 1;
      var le = options.display_num - 1;
      var is_working = false;
      var j = '';
      var clicked = false;
      var click_num = (options.click_move ? options.click_move : options.move );
      
      li.css({
        'float': 'left',
        'listStyle': 'none',
        'marginRight': options.margin
      });
      var ow = li.outerWidth(true);
      wrap_width = (ow * options.display_num);// - options.margin;
      var seg = ow * options.move;
      var seg_num = ow * click_num;
      $this.wrap('<div class="bx_container"></div>').width(999999);
      if (options.controls) {
        if (options.next_image != '' || options.prev_image != '') {
          var controls = '<a href="javascript:;" class="prev"><img src="' + options.prev_image + '"/></a><a href="javascript:;" class="next"><img src="' + options.next_image + '"/></a>';
        }
        else if ( options.next_text != '' || options.prev_text != '' ) {
          var controls = '<a href="javascript:;" class="prev">' + options.prev_text + '</a><a href="javascript:;" class="next">' + options.next_text + '</a>';
        }
        else {
          var controls = '<a href="javascript:;" class="prev" title="' + options.prev_text + '" ></a><a href="javascript:;" class="next" title="' + options.next_text + '" ></a>';
        }
        
      }
            
      $this.parent('.bx_container').wrap('<div class="bx_wrap"></div>').css({
        'position': 'relative',
        'width': wrap_width,
        'overflow': 'hidden'
      }).before(controls);
      
      var w = li.slice(0, options.display_num).clone();
      var last_appended = (options.display_num + options.move) - 1;
      $this.empty().append(w);
      get_p(false);
      get_a(false);
      $this.css({
        'position': 'relative',
        'left': -(seg)
      });
      $this.parent().siblings('.next').click(function() {
        slide_next(true);
        
        //clearInterval(j);
        pauseTimeout = setTimeout(function () {
            clearTimeout(elem.data('pause'));
            start_slide();
            elem.data('pause', pauseTimeout);
        }, option.pause);
        
        clicked = true;
        return false;
      });
      $this.parent().siblings('.prev').click(function() {
        slide_prev(true);
        
        //clearInterval(j);
        pauseTimeout = setTimeout(function () {
            clearTimeout(elem.data('pause'));
            start_slide();
            elem.data('pause', pauseTimeout);
        }, option.pause);
        
        clicked = true;
        return false;
      });
      if (options.auto) {
        start_slide();
        if (options.auto_hover && clicked != true) {
          $this.find('li').live('mouseenter',
          function() {
            if (!clicked) {
              clearInterval(j);
            }
          });
          $this.find('li').live('mouseleave',
          function() {
            if (!clicked) {
              start_slide();
            }
          });
        }
      }
      
      function start_slide() {
        if (options.auto_dir == 'next') {
          j = setInterval(function() {
            slide_next(false)
          },
          options.auto_interval);
        } else {
          j = setInterval(function() {
            slide_prev(false)
          },
          options.auto_interval);
        }
      }
      function slide_next(isClick) {
        if (!is_working) {
          is_working = true;
          set_pos('next', isClick);
          $this.animate({
            left: '-=' + (isClick ? seg_num : seg)
          },
          options.speed,
          function() {
            $this.find('li').slice(0, options.move).remove();
            $this.css('left', -((isClick ? seg_num : seg)));
            get_a(isClick);
            is_working = false;
          });
        }
      }
      function slide_prev(isClick) {
        if (!is_working) {
          is_working = true;
          set_pos('prev', isClick);
          $this.animate({
            left: '+=' + (isClick ? seg_num : seg)
          },
          options.speed,
          function() {
            $this.find('li').slice( - options.move).remove();
            $this.css('left', -((isClick ? seg_num : seg)));
            get_p(isClick);
            is_working = false;
          });
        }
      }
      function get_a(isClick) {
        var str = new Array();
        var lix = li.clone();
        le = last;
        for (i = 0; i < ( isClick ? click_num : options.move ); i++) {
          le++
          if (lix[le] != undefined) {
            str[i] = $(lix[le]);
          } else {
            le = 0;
            str[i] = $(lix[le]);
          }
        }
        $.each(str,
        function(index) {
          $this.append(str[index][0]);
        });
      }
      function get_p(isClick) {
        var str = new Array();
        var lix = li.clone();
        fe = first;
        for (i = 0; i < ( isClick ? click_num : options.move ); i++) {
          fe--
          if (lix[fe] != undefined) {
            str[i] = $(lix[fe]);
          } else {
            fe = li.length - 1;
            str[i] = $(lix[fe]);
          }
        }
        $.each(str,
        function(index) {
          $this.prepend(str[index][0]);
        });
      }
      function set_pos(dir, isClick) {
        if (dir == 'next') {
          first += ( isClick ? click_num : options.move );
          if (first >= li.length) {
            first = first % li.length;
          }
          last += ( isClick ? click_num : options.move );
          if (last >= li.length) {
            last = last % li.length;
          }
        } else if (dir == 'prev') {
          first -= ( isClick ? click_num : options.move );
          if (first < 0) {
            first = li.length + first;
          }
          last -= ( isClick ? click_num : options.move );
          if (last < 0) {
            last = li.length + last;
          }
        }
      }
    });
  }
})(jQuery);
