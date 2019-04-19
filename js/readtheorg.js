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

// == Add copy to clipboard and pytutor links for all source boxes ======================== 
$(document).ready(function() {
    $("div.source-group").each(function (){
        /// Urlencoded string with source code
        var rawSource = $(this).children("pre.raw-source")
        /// Div enclosing all the elements of this source box
        var sourceContainer = $(this).children("div.org-src-container")
        /// The formatted source
        var source = sourceContainer.children("pre")

        var id = $(this).attr('id');

        /// Determine what is the code style of the snippet, save in codeStyle
        var codeStyle;
        if (source.hasClass("src src-java")) {
            codeStyle = "java";
        }
        else if (source.hasClass("src src-python")) {
            codeStyle = "2";
        }
        else {
            codeStyle = "c";
        }

        /// Unless opting out using no-copy, add copy to clipboard button
        if (rawSource.hasClass("no-copy") == false) {
            var cButtonText = '<i class="fas fa-copy"></i>'
            source.after('<button id="c' + id + '" type="button" class="btn btn-primary btn-sm btn-right" data-toggle="tooltip" data-placement="left" title="Copy to clipboard">' + cButtonText + '</button>');
            $(document.body).on('click', '#c' + id, function() {
                copyTextToClipboard(decodeURIComponent(rawSource.html()));
                $('#c' + id).html('   Copied!   ');
                setTimeout(function(){
                    $('#c' + id).html(cButtonText);
                }, 2000);
            });
        }

        /// Unless opting out using no-tutor, add tutor button
        if (rawSource.hasClass("no-tutor") == false) {
            source.after('<button id="p' + id + '" type="button" class="btn btn-secondary btn-sm btn-right" data-toggle="tooltip" data-placement="bottom" title="Open in Pytutor"><i class="fas fa-chalkboard-teacher"></i></button>');
            $(document.body).on('click', '#p' + id, function() {
                window.open('http://pythontutor.com/visualize.html#code=' + rawSource.html() + '&mode=edit&origin=opt-frontend.js&py=' + codeStyle + '&rawInputLstJSON=%5B%5D', '_blank');
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


function copyTextToClipboard(text) {
  var textArea = document.createElement("textarea");

  //
  // *** This styling is an extra step which is likely not required. ***
  //
  // Why is it here? To ensure:
  // 1. the element is able to have focus and selection.
  // 2. if element was to flash render it has minimal visual impact.
  // 3. less flakyness with selection and copying which **might** occur if
  //    the textarea element is not visible.
  //
  // The likelihood is the element won't even render, not even a flash,
  // so some of these are just precautions. However in IE the element
  // is visible whilst the popup box asking the user for permission for
  // the web page to copy to the clipboard.
  //

  // Place in top-left corner of screen regardless of scroll position.
  textArea.style.position = 'fixed';
  textArea.style.top = 0;
  textArea.style.left = 0;

  // Ensure it has a small width and height. Setting to 1px / 1em
  // doesn't work as this gives a negative w/h on some browsers.
  textArea.style.width = '2em';
  textArea.style.height = '2em';

  // We don't need padding, reducing the size if it does flash render.
  textArea.style.padding = 0;

  // Clean up any borders.
  textArea.style.border = 'none';
  textArea.style.outline = 'none';
  textArea.style.boxShadow = 'none';

  // Avoid flash of white box if rendered for any reason.
  textArea.style.background = 'transparent';


  textArea.value = text;

  document.body.appendChild(textArea);
  textArea.focus();
  textArea.select();

  try {
    var successful = document.execCommand('copy');
    var msg = successful ? 'successful' : 'unsuccessful';
    console.log('Copying text command was ' + msg);
  } catch (err) {
    console.log('Oops, unable to copy');
  }

  document.body.removeChild(textArea);
}

