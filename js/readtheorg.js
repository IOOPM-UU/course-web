$(function() {
    $('.note').before("<p class='admonition-title note'>Note</p>");
    $('.seealso').before("<p class='admonition-title seealso'>See also</p>");
    $('.warning').before("<p class='admonition-title warning'>Warning</p>");
    $('.caution').before("<p class='admonition-title caution'>Caution</p>");
    $('.attention').before("<p class='admonition-title attention'>Attention</p>");
    $('.tip').before("<p class='admonition-title tip'>Tip</p>");
    $('.important').before("<p class='admonition-title important'>Important</p>");
    $('.hint').before("<p class='admonition-title hint'>Hint</p>");
    $('.error').before("<p class='admonition-title error'>Error</p>");
    $('.danger').before("<p class='admonition-title danger'>Danger</p>");
});

$( document ).ready(function() {

    // Shift nav in mobile when clicking the menu.
    $(document).on('click', "[data-toggle='wy-nav-top']", function() {
      $("[data-toggle='wy-nav-shift']").toggleClass("shift");
      $("[data-toggle='rst-versions']").toggleClass("shift");
    });
    // Close menu when you click a link.
    $(document).on('click', ".wy-menu-vertical .current ul li a", function() {
      $("[data-toggle='wy-nav-shift']").removeClass("shift");
      $("[data-toggle='rst-versions']").toggleClass("shift");
    });
    $(document).on('click', "[data-toggle='rst-current-version']", function() {
      $("[data-toggle='rst-versions']").toggleClass("shift-up");
    });
    // Make tables responsive
    $("table.docutils:not(.field-list)").wrap("<div class='wy-table-responsive'></div>");
});

$( document ).ready(function() {
    $('#text-table-of-contents ul').addClass('nav');
    $('#text-table-of-contents ul li').addClass('nav-item');
    $('#text-table-of-contents ul li a').addClass('nav-link');
                                        // ScrollSpy also requires that we use
                                        // a Bootstrap nav component.
    $('body').scrollspy({target: '#text-table-of-contents'});
    // add sticky table headers
    $('table').stickyTableHeaders();

    // set the height of tableOfContents
    var $postamble = $('#postamble');
    var $tableOfContents = $('#table-of-contents');
    $tableOfContents.css({paddingBottom: $postamble.outerHeight()});

    // add TOC button
    var title = document.title;
    if (title.length > 24) { title = title.substr(0,20) + "..."; }
    
    var toggleSidebar = $('<div id="toggle-sidebar"><a href="#table-of-contents"><h2>' + title + ' &nbsp;|&nbsp; Table of Contents</h2></a></div>');
    $('#content').prepend(toggleSidebar);

    // add close button when sidebar showed in mobile screen
    var closeBtn = $('<a class="close-sidebar" href="#">Close</a>');
    var tocTitle = $('#table-of-contents').find('h2');
    tocTitle.append(closeBtn);
});

window.SphinxRtdTheme = (function (jquery) {
    var stickyNav = (function () {
        var navBar,
            win,
            stickyNavCssClass = 'stickynav',
            applyStickNav = function () {
                if (navBar.height() <= win.height()) {
                    navBar.addClass(stickyNavCssClass);
                } else {
                    navBar.removeClass(stickyNavCssClass);
                }
            },
            enable = function () {
                applyStickNav();
                win.on('resize', applyStickNav);
            },
            init = function () {
                navBar = jquery('nav.wy-nav-side:first');
                win    = jquery(window);
            };
        jquery(init);
        return {
            enable : enable
        };
    }());
    return {
        StickyNav : stickyNav
    };
}($));

function tw_hide_show(h) {
    if (h.next().is(':visible')) {
        h.siblings("div").each(function (){
            var c = $(this);
            c.hide(100);
        });
        h.addClass("expandable");
        h.removeClass("is-collapsable-hint");
    } else {
        h.siblings("div").each(function (){
            var c = $(this);
            c.show(100);
        });
        h.removeClass("expandable");
        h.addClass("is-collapsable-hint");
    }
}

$(document).ready(function() {
    $("h2, h3, h4").each(function () {
        var h = $(this);
        if (h.parent().parent().attr("id") != "toggle-sidebar" && h.parent().attr("id") != "table-of-contents") {
            h.addClass("is-collapsable-hint");
            h.click(function() {
                tw_hide_show(h);
            });
        }
    });
});

// == Make footnotes also hover ======================== 
// $(document).ready(function() {
//     $(".footref").tooltip({
//         items: "a[id]",
//         content: function () {
//             var id = $(this).attr("id");
//             var tip = $('a[href="#' + id + '"]').parent().next().html();
//             return tip;
//         }
//     });
// });

$(document).ready(function() {
    $(".footref").each(function () {
        $(this).attr("data-toggle", "tooltip");
        $(this).attr("data-html", "true");
        var id = $(this).attr("id");
        var tip = $('a[href="#' + id + '"]').parent().next().html();
        $(this).attr("title", tip);
    });
});


// == Add top menu ======================== 
$(document).ready(function() {
    var topMenu = $('#top-menu');
    topMenu.insertBefore($('.title'));
});

// == Add page title to TOC ======================== 
$(document).ready(function() {
    if ($('#table-of-contents').length ) {
      $('#table-of-contents').first().html("<h2>" + document.title + "<hr>" + $('#table-of-contents').first().html().substr(5));
    }
});

/// If text in a P is selected -- offer bug reporting button 
$(document).ready(function () {
    $("p").each(function () {
        var p = $(this);
        p.select(function () {
            
        });
    });
});

// == for quiz:links ======================== 
$(document).ready(function() {
    $('[data-toggle="tooltip"]').tooltip();
});

// $(document).ready(function() {
//     $("a[quiz]").tooltip({
//         content: function () {
//             return $(this).attr("title");
//         }
//     });
// });


// == Bug report hotkey ================
function getSelectionText() {
    var text = "";
    if (window.getSelection) {
        text = window.getSelection().toString();
    } else if (document.selection && document.selection.type != "Control") {
        text = document.selection.createRange().text;
    }
    return text;
}

document.onkeydown = function(evt) {
    evt = evt || window.event;
    if (evt.ctrlKey && evt.keyCode == 90) {  // Ctrl+Z
        window.location.href = "http://wrigstad.com/ioopm18";
    } else
    if (evt.ctrlKey && evt.keyCode == 88) {  // Ctrl+X
        var text = getSelectionText();
        if (text.length > 0)
            {
                var url = escape(window.location);
                var esc_text = escape(text.replace(/(\r\n\t|\n|\r\t)/gm,""));
                window.location.href = "https://github.com/IOOPM-UU/course-web/issues/new?title=Descriptive Title&body=(Location: " + url + ")%0A%0APlease describe the issue clearly, help me locate it on the page, and if possible suggest a fix.%0A%0ASelected text:%0A>" + esc_text + "&assignee=TobiasWrigstad";
            }
    }
};

var id_inc = 0;

$(document).ready(function() {
    $(".hidden").each(function (){
        var d = $(this);
        id_inc += 1;
        var id = "foo-bar-id-" + id_inc;
        d.before('<button id="' + id + '" type="button" class="btn btn-info">Click to reveal answer!</button>');
        $(document.body).on('click', '#' + id, function() {
            d.show(300);
            $("#" + id).hide();
        });
    });
});
