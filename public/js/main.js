String.prototype.escape_html = function(){
    var span = document.createElement('span');
    var txt =  document.createTextNode('');
    span.appendChild(txt);
    txt.data = this;
    return span.innerHTML;
};

$(function(){
    $('input#btn_send').click(send_im);
    $('input#message').keydown(function(e){
        if(e.keyCode == 13) send_im();
    });
});

var send_im = function(){
    var msg = $('input#message').val();
    if(msg.length < 1) return;
    $.ajax({
        type : 'POST',
        url : app_root,
        dataType : 'text',
        data : {message : msg},
        success : function(res){
            console.log(res);
            log(res);
            $('input#message').val('');
        },
        error : function(res){
            log('error('+res.status+') : '+res.responseText);
            console.error(res);
        }
    });
};

var log = function(msg){
    var li = $('<li>');
    li.append($('<span>').addClass('message').html(msg));
    li.append(' - ');
    li.append($('<span>').addClass('time').html(new Date().toString()));
    $('ul#log').prepend(li);
};

