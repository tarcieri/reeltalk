$(document).ready(function(){
  if (typeof(WebSocket) != 'undefined' || typeof(MozWebSocket)) {
    $('#ask').show();
  } else {
    $('#error').show();
  }
  
  // join on enter
  $('#ask input').keydown(function(event) {
    if (event.keyCode == 13) {
      $('#ask a').click();
    }
  })
  
  // join on click
  $('#ask a').click(function() {
    join($('#ask input').val());
    $('#ask').hide();
    $('#channel').show();
    $('input#message').focus();
  });

  function join(name) {
    var host = window.location.host.split(':')[0];

    var SocketKlass = "MozWebSocket" in window ? MozWebSocket : WebSocket;
    var ws = new SocketKlass('ws://' + window.location.host + '/websocket');

    var container = $('div#msgs');
    ws.onmessage = function(evt) {
      var obj = $.evalJSON(evt.data);
      if (typeof obj != 'object') return;

      var action = obj['action'];
      var struct = container.find('li.' + action + ':first');
      if (struct.length < 1) {
        console.log("Could not handle: " + evt.data);
        return;
      }
      
      var msg = struct.clone();
      msg.find('.time').text((new Date()).toString("HH:mm:ss"));

      if (action == 'message') {
        var matches;
        if (matches = obj['message'].match(/^\s*[\/\\]me\s(.*)/)) {
          msg.find('.user').text(obj['user'] + ' ' + matches[1]);
          msg.find('.user').css('font-weight', 'bold');
        } else {
          msg.find('.user').text(obj['user']);
          msg.find('.message').text(': ' + obj['message']);
        }
      } else if (action == 'control') {
        msg.find('.user').text(obj['user']);
        msg.find('.message').text(obj['message']);
        msg.addClass('control');
      }
      
      if (obj['user'] == name) msg.find('.user').addClass('self');
      container.find('ul').append(msg.show());
      container.scrollTop(container.find('ul').innerHeight());
    }
    
    $('#channel form').submit(function(event) {
      event.preventDefault();
      var input = $(this).find(':input');
      var msg = input.val();
      ws.send($.toJSON({ action: 'message', message: msg }));
      input.val('');
    });
    
    // send name when joining
    ws.onopen = function() {
      ws.send($.toJSON({ action: 'join', user: name }));
    }
  }
});