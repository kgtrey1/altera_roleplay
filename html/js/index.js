/*
** ALTERA PROJECT, 2020
** ARP_bank (forked from NewWayRP/new_banking)
** File description:
** JavaScript API.
*/

function LoadFleeca() 
{
    $('#waiting-logo').addClass('waiting-logo-fleeca');
    $('#bg-waiting').addClass('bg-waiting-fleeca');
    $('#fingerprint-content').addClass('fingerprint-content-fleeca');
    $('#fingerprint-default').addClass('fingerprint-default-fleeca');
    $('#topbar').addClass('topbar-fleeca');
    $('#logo-topbar').addClass('logo-topbar-fleeca');
    $('#balance').addClass('balance-fleeca');
    $('#circle-confiance').addClass('circle-confiance-fleeca');
}

function LoadMaze()
{
    $('#waiting-logo').addClass('waiting-logo-maze');
    $('#bg-waiting').addClass('bg-waiting-maze');
    $('#fingerprint-content').addClass('fingerprint-content-maze');
    $('#fingerprint-default').addClass('fingerprint-default-maze');
    $('#topbar').addClass('topbar-maze');
    $('#logo-topbar').addClass('logo-topbar-maze');
    $('#balance').addClass('balance-maze');
    $('#circle-confiance').addClass('circle-confiance-maze');
}

function LoadBankTheme(theme)
{
    if (event.theme == 'fleeca')
        LoadFleeca()
    else if(theme == 'maze')
        LoadMaze()
    else {
        $.post('http://arp_bank/NUIFocusOff', JSON.stringify({}));
        return (false);
    }
    return (true);
}

$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type === "openGeneral") {
            if (!LoadBankTheme(event.data.bank))
                return
            $('#waiting').show();
            $('body').addClass("active");
        }
        else if(event.data.type === "balanceHUD") {
            $('.username1').html(event.data.player);
            $('.curbalance').html(event.data.balance);
        }
        else if (event.data.type === "BalanceUpdate")
            $('.curbalance').html(event.data.balance);
        else if (event.data.type === "closeAll") {
            $('#waiting, #general, #transferUI, #withdrawUI, #depositUI, #topbar').hide();
            $('body').removeClass("active");
        }
        else if (event.data.type === "result") {
            if (event.data.t == "success")
                $("#result").attr('class', 'alert-green');
            else
                $("#result").attr('class', 'alert-orange');
            $("#result").html(event.data.m).show().delay(5000).fadeOut();
        }
    });
});

$('.btn-sign-out').click(function() {
    $('#general, #waiting, #transferUI, #withdrawUI, #depositUI, #topbar').hide();
    $('body').removeClass("active");
    $.post('http://arp_bank/NUIFocusOff', JSON.stringify({}));
});

$('.back').click(function(){
    $('#depositUI, #withdrawUI, #transferUI').hide();
    $('#general').show();
});

$('#deposit').click(function(){
    $('#general').hide();
    $('#depositUI').show();
});

$('#withdraw').click(function(){
    $('#general').hide();
    $('#withdrawUI').show();
});

$('#transfer').click(function(){
    $('#general').hide();
    $('#transferUI').show();
});

$('#fingerprint-content').click(function() {
    $('.fingerprint-active, .fingerprint-bar').addClass("active")
    setTimeout(function() {
        $('#general').css('display', 'block')
        $('#topbar').css('display', 'flex')
        $('#waiting').css('display', 'none')
        $('.fingerprint-active, .fingerprint-bar').removeClass("active")
    }, 1400);
});

$("#deposit1").submit(function(e) {
    e.preventDefault(); // Prevent form from submitting
    $.post('http://arp_bank/deposit', JSON.stringify({
        amount: $("#amount").val()
    }));
    $('#depositUI').hide();
    $('#general').show();
    $("#amount").val('');
});

$("#transfer1").submit(function(e) {
    e.preventDefault(); // Prevent form from submitting
    $.post('http://arp_bank/transfer', JSON.stringify({
        to: $("#to").val(),
        amount: $("#amountt").val()
    }));
    $('#transferUI').hide();
    $('#general').show();
    $("#amountt").val('');
});

$("#withdraw1").submit(function(e) {
    e.preventDefault(); // Prevent form from submitting
    $.post('http://arp_bank/withdraw', JSON.stringify({
        amount: $("#amountW").val()
    }));
    $('#withdrawUI').hide();
    $('#general').show();
    $("#amountw").val('');
});

document.onkeyup = function(data) {
    if (data.which == 27) {
        $('#general, #waiting, #transferUI, #withdrawUI, #depositUI, #topbar').hide();
        $('body').removeClass("active");
        $.post('http://arp_bank/NUIFocusOff', JSON.stringify({}));
    }
}