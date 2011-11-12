$ = jQuery

rebuild_facebook_dom = ->
  try
    FB.XFBML.Host.parseDomTree()
shareEventHandler = (event) ->
  if event.type is "addthis.menu.share"
    data = {}
    data.cache_id = $("#addthis_item").attr("data-id")
    data.action_type = event.data.service
    data.url = event.data.url
    $.post "/shared_item", data
$(document).ajaxSend (e, xhr, options) ->
  token = $("meta[name='csrf-token']").attr("content")
  xhr.setRequestHeader "X-CSRF-Token", token

fbAppId = window.Newscloud.config.fbAppId
(($) ->
  $.fn.serializeJSON = ->
    json = {}
    jQuery.map $(this).serializeArray(), (e, i) ->
      json[e.name] = e.value

    json
) jQuery

$$ = (param) ->
  node = $(param)[0]
  id = $.data(node)
  $.cache[id] = $.cache[id] or {}
  $.cache[id].node = node
  $.cache[id]

$$$ = (key) ->
  $.cache[key] = $.cache[key] or {}
  $.cache[key]

$.ready ->
  modal_dialog_response = (title, message) ->
    $("#login-overlay .contentWrap").html message
    $("#login-overlay").overlay
      mask: "white"
      load: true
      effect: "apple"
  change_url_format = (url, format) ->
    format = ".json"  if typeof (format) is "undefined"
    url = url.replace(/\?return_to=.*$/, "")
    if url.substring(url.length - 5) is ".html"
      url = url.substring(0, url.length - 5) + format
    else
      url = url + format
    url
  $(".hide").hide()
  $(".unhide").show().removeClass "hidden"
  $.timeago.settings.strings.suffixAgo = ""
  $("abbr.timeago").timeago()
  setTimeout (->
    $(".flash").effect "fade", {}, 1000
  ), 3500
  $(".account-toggle").click (event) ->
    event.preventDefault()
    url = change_url_format($(this).attr("href")).replace(/json/, "js")
    if $(this).next().children().length is 0
      $(this).next().html "<img src=\"/images/default/spinner-tiny.gif\" />"
      $(this).next().toggle()
      $(this).next().load url, ->
        rebuild_facebook_dom()
    else
      $(this).next().toggle()

  $(".import-events-toggle").click (event) ->
    event.preventDefault()
    $("#new_event").toggle()
    $("#import-events").toggle()

  $(".update-bio").click (event) ->
    event.preventDefault()
    $(".current-bio").toggle()
    $(this).parent().next().toggle()

  $("form#new_question #question_question").focus (event) ->
    $(".fullQuestionForm").show()

  $(".refine-toggle, .flag-toggle").click (event) ->
    event.preventDefault()
    $(this).next().toggle()

  $(".refine-form").submit (event) ->
    event.preventDefault()
    $(this).parent().parent().toggle()
    url = change_url_format($(this).attr("action"))
    list = $(".list_items ul", $(this).parents().filter(".panel_2"))
    $.ajax
      url: url
      data: $(this).serializeJSON()
      dataType: "html"
      success: (data) ->
        $(list).quicksand $(data).find("li"),
          adjustHeight: false

        $.timeago.settings.strings.suffixAgo = ""
        $("abbr.timeago", $(".itemListWrap")).timeago()
        rebuild_facebook_dom()

  $(".classifieds-filter form #categories").change (event) ->
    event.preventDefault()
    category_select = $(this)
    select_parent = category_select.parent().parent().parent()
    select_parent.submit()

  $(".classifieds-filter form #listing_type").change (event) ->
    event.preventDefault()
    listing_type_select = $(this)
    select_parent = listing_type_select.parent().parent().parent()
    select_parent.submit()

  $(".classifieds-filter form").submit (event) ->
    event.preventDefault()
    $(this).after "<p class=\"status\"><i>...updating...</i></p>"
    url = change_url_format($(this).attr("action"))
    url += "?" + $(this).serialize()
    list = $("ul.classifieds")
    $.get url, ((data) ->
      $(".classifieds-filter p.status").remove()
      $(list).quicksand $(data).find("li.complexBlock"),
        adjustHeight: false

      $.timeago.settings.strings.suffixAgo = ""
      $("abbr.timeago", $("ul.classifieds")).timeago()
      rebuild_facebook_dom()
    ), "html"

  $("form.comment").submit (event) ->
    return true  if $(this).parents(".topic-form").length
    event.preventDefault()
    form = $(this)
    if $("textarea:first", form).val() is ""
      $("textarea:first", form).css "border", "1px solid red"
      return false
    submitBtn = $("input[type=submit]", this)
    submitBtn.attr "disabled", "disabled"
    submitBtn.hide()
    submitBtn.parent().append "<img style=\"float: left;\" src=\"/images/default/spinner-tiny.gif\" /><p style=\"float: left;\">&nbsp; Processing your comment...</p>"
    url = change_url_format($(this).attr("action"))
    parentForm = $(this).parents(".postComment")
    commentThread = parentForm.siblings(".commentThread")
    $.post url, $(this).serialize(), ((data) ->
      commentThread.fadeOut "normal", ->
        commentThread.html(data).fadeIn "normal"
        $.timeago.settings.strings.suffixAgo = ""
        $("abbr.timeago", commentThread).timeago()
        rebuild_facebook_dom()
        setTimeout (->
          $("html,body").animate
            scrollTop: ($(".commentThread li").last().offset().top - 50)
          ,
            duration: "slow"
            easing: "swing"

          $("li", commentThread).last().effect "highlight",
            color: "green"
          , 3000
        ), 500

      submitBtn.siblings("p, img").remove()
      submitBtn.removeAttr "disabled"
      submitBtn.show()
      $(":input", form).not(":button, :submit, :reset, :hidden").val ""
    ), "html"

  $(".flag-form").change (event) ->
    event.preventDefault()
    flag_form = $(this)
    flag_parent = flag_form.parent().parent().parent()
    unless $("[name=flag_type]", this).val() is "choose_flag"
      $(this).parent().html "<img src=\"/images/default/spinner-tiny.gif\" />"
      url = change_url_format(flag_form.attr("action"))
      $.post url, flag_form.serialize(), (data) ->
        flag_parent.html("<span class=\"flag-toggle btnComment\">" + data.msg + "</span>").fadeIn "normal"

  $(".voteLink, .voteUp, .voteDown, .thumb-up, .thumb-down").live "click", (event) ->
    event.preventDefault()
    span = $(this).parent()
    $(this).parent().html "<img src=\"/images/default/spinner-tiny.gif\" />"
    url = $(this).attr("href")
    url = url.replace(/\?return_to=.*$/, "")
    if url.substring(url.length - 5) is ".html"
      url = url.substring(0, url.length - 5) + ".json"
    else if url.match(/like.html/)
      url = url.replace(/like.html/, "like.json")
    else url = url + ".json"  unless url.match(/like.json/)
    $.ajax
      type: "POST"
      url: url
      contentType: "application/json"
      data: "foo"
      dataType: "json"
      success: (data, status) ->
        span.fadeOut "normal", ->
          span.html(data.msg).fadeIn "normal"

        if data.trigger_oauth and data.trigger_oauth is true
          if data.canvas and data.canvas is true
            window.location = "/iframe/oauth/new"
          else
            window.location = "/oauth/new"

      error: (xhr, status, errorThrown) ->
        result = $.parseJSON(xhr.responseText)
        if xhr.status is 401
          modal_dialog_response result.error, result.dialog
          span.fadeOut "normal", ->
            span.html("Please Login").fadeIn "normal"

  $(".quick_post").click (event) ->
    event.preventDefault()
    span = $(this).parent()
    $li_parent = $(this).parents().filter("li").first()
    $(this).parent().html "<img src=\"/images/default/spinner.gif\" />"
    url = $(this).attr("href")
    url = url.replace(/\?return_to=.*$/, "")
    if url.substring(url.length - 5) is ".html"
      url = url.substring(0, url.length - 5) + ".json"
    else if url.match(/quick_post.html/)
      url = url.replace(/quick_post.html/, "quick_post.json")
    else
      url = url + ".json"
    $.ajax
      type: "POST"
      url: url
      contentType: "application/json"
      data: "foo"
      dataType: "json"
      success: (data, status) ->
        span.fadeOut "normal", ->
          span.html(data.msg).fadeIn "normal"

        setTimeout (->
          $li_parent.effect "highlight",
            color: "green"
          , 2000
          $li_parent.hide "fold", {}, "slow"
        ), 1500

      error: (xhr, status, errorThrown) ->
        result = $.parseJSON(xhr.responseText)
        if xhr.status is 401
          modal_dialog_response result.error, result.dialog
          span.fadeOut "normal", ->
            span.html("Please Login").fadeIn "normal"
        else if xhr.status is 409
          span.fadeOut "normal", ->
            span.html(result.error).fadeIn "normal"

          setTimeout (->
            $li_parent.effect "highlight",
              color: "red"
            , 3000
          ), 1500

  $("a.toggle-form").click (event) ->
    event.preventDefault()
    $(this).parent().next().toggle()

  $(".answer_link").click (event) ->
    event.preventDefault()
    $("#answerForm").toggle()

  $(".commentThread, .postComment", $("#answersList")).hide()
  $(".answer_comments_link").click (event) ->
    event.preventDefault()
    $(".commentThread, .postComment", $(this).parents().filter(".answer")).toggle()

  $("form.prediction_guess").submit (event) ->
    event.preventDefault()
    form = $(this)
    if $("input:first", form).val() is ""
      $("input:first", form).css "border", "1px solid red"
      return false
    submitBtn = $("input[type=submit]", this)
    submitBtn.attr "disabled", "disabled"
    submitBtn.hide()
    submitBtn.parent().append "<img style=\"float: left;\" src=\"/images/default/spinner-tiny.gif\" /><p style=\"float: left;\">&nbsp; Processing your guess...</p>"
    url = change_url_format($(this).attr("action"))
    parentForm = $(this).parents(".prediction_question_wrapper")
    $.post url, $(this).serialize(), ((data) ->
      parentForm.fadeOut "normal", ->
        parentForm.html(data).fadeIn "normal"
        rebuild_facebook_dom()
        setTimeout (->
          $("li", parentForm).last().effect "highlight",
            color: "green"
          , 3000
        ), 500

      submitBtn.siblings("p, img").remove()
      submitBtn.removeAttr "disabled"
      submitBtn.show()
      $(":input", form).not(":button, :submit, :reset, :hidden").val ""
    ), "html"

$.ready -> 
  set_carousel = (carousel) ->
    my_carousel = carousel
  my_carousel = null
  $("form.post_story #content_url").blur ->
    unless $(this).val() is ""
      $(this).addClass "process"
      $("#content_title").addClass "process"
      $.ajax
        type: "POST"
        url: "/stories/parse_page"
        data:
          url: $(this).val()

        dataType: "json"
        success: (data, textStatus) ->
          $("#content_title").val data.title  if $("#content_title").val() is ""
          $("#content_caption").val data.description  if $("#content_caption").val() is ""  if data.description
          if data.images.length > 0
            $("#scrollbox").show()
            $(".scrollable").scrollable()
            api = $(".scrollable").data("scrollable")
            jQuery.each data.images, (i, url) ->
              api.addItem "<img src=\"" + url + "\" width=\"75\" height=\"75\" />"

            $(".items img").click ->
              if $(this).hasClass("selected-image")
                $(this).removeClass "selected-image"
              else
                $(this).addClass "selected-image"
                in_use = false
                current_src = $(this).attr("src")
                $(".image-url-input").each (i, input) ->
                  in_use = true  if $(input).val() is current_src

                unless in_use
                  $("#add_image").click()
                  $(".image-url-input").last().val $(this).attr("src")
                  $(".image-url-input").last().parent().next().remove()
                  $(".image-url-input").last().next().remove()
                  $(".image-url-input").last().after $(".delete_image").last()
          $("#content_url").removeClass "process"
          $("#content_title").removeClass "process"

        error: (xhr, status, errorThrown) ->
          result = $.parseJSON(xhr.responseText)
          alert result.error
          $("#content_url").removeClass "process"
          $("#content_title").removeClass "process"

  $("#content_url").trigger "blur"  unless $("form.post_story #content_url").val() is ""
  $("form.post_article #article_content_attributes_url").blur ->
    unless $(this).val() is ""
      $(this).addClass "process"
      $.ajax
        type: "POST"
        url: "/stories/parse_page"
        data:
          url: $(this).val()

        dataType: "json"
        success: (data, textStatus) ->
          if data.images.length > 0
            $("#scrollbox").show()
            $(".scrollable").scrollable()
            api = $(".scrollable").data("scrollable")
            jQuery.each data.images, (i, url) ->
              api.addItem "<img src=\"" + url + "\" width=\"75\" height=\"75\" />"

            $(".items img").click ->
              if $(this).hasClass("selected-image")
                $(this).removeClass "selected-image"
              else
                $(this).addClass "selected-image"
                in_use = false
                current_src = $(this).attr("src")
                $(".image-url-input").each (i, input) ->
                  in_use = true  if $(input).val() is current_src

                unless in_use
                  $("#add_image").click()
                  $(".image-url-input").last().val $(this).attr("src")
                  $(".image-url-input").last().parent().next().remove()
                  $(".image-url-input").last().next().remove()
                  $(".image-url-input").last().after $(".delete_image").last()
          $("#article_content_attributes_url").removeClass "process"

        error: (xhr, status, errorThrown) ->
          result = $.parseJSON(xhr.responseText)
          alert result.error
          $("#article_content_attributes_url").removeClass "process"

  $("#article_content_attributes_url").trigger "blur"  unless $("form.post_article #article_content_attributes_url").val() is ""
  $("form.post_resource #resource_url").blur ->
    unless $(this).val() is ""
      $(this).addClass "process"
      $("#resource_title").addClass "process"
      $.ajax
        type: "POST"
        url: "/stories/parse_page"
        data:
          url: $(this).val()

        dataType: "json"
        success: (data, textStatus) ->
          $("#resource_title").val data.title  if $("#resource_title").val() is ""
          $("#resource_details").val data.description  if $("#resource_details").val() is ""  if data.description
          if data.images.length > 0
            $("#scrollbox").show()
            $(".scrollable").scrollable()
            api = $(".scrollable").data("scrollable")
            jQuery.each data.images, (i, url) ->
              api.addItem "<img src=\"" + url + "\" width=\"75\" height=\"75\" />"

            $(".items img").click ->
              if $(this).hasClass("selected-image")
                $(this).removeClass "selected-image"
              else
                $(this).addClass "selected-image"
                in_use = false
                current_src = $(this).attr("src")
                $(".image-url-input").each (i, input) ->
                  in_use = true  if $(input).val() is current_src

                unless in_use
                  $("#add_image").click()
                  $(".image-url-input").last().val $(this).attr("src")
                  $(".image-url-input").last().parent().next().remove()
                  $(".image-url-input").last().next().remove()
                  $(".image-url-input").last().after $(".delete_image").last()
          $("#resource_url").removeClass "process"
          $("#resource_title").removeClass "process"

        error: (xhr, status, errorThrown) ->
          result = $.parseJSON(xhr.responseText)
          alert result.error
          $("#resource_url").removeClass "process"
          $("#resource_title").removeClass "process"

  $("#resource_url").trigger "blur"  unless $("form.post_resource #resource_url").val() is ""
  $(".ellipsis_text").ellipsis()

$.ready ->
  $("#thumbnails").scrollable(
    size: 3
    clickable: false
  ).find("img").each (index) ->
    $(this).overlay
      effect: "apple"
      target: "#overlay"
      mask:
        maskId: "mask"

      onBeforeLoad: ->
        wrap = @getOverlay().find(".contentWrap")
        wrap.html "<img src=\"" + @getTrigger().attr("src").replace(/thumb/, "medium") + "\"/>"

  $("#images").scrollable()

window.fbAsyncInit = ->
  FB.init
    appId: fbAppId
    status: true
    cookie: true
    xfbml: true

((d, s, id) ->
  js = undefined
  fjs = d.getElementsByTagName(s)[0]
  return  if d.getElementById(id)
  js = d.createElement(s)
  js.id = id
  js.src = "//connect.facebook.net/en_US/all.js#xfbml=1"
  fjs.parentNode.insertBefore js, fjs
) document, "script", "facebook-jssdk"

addthis.addEventListener "addthis.menu.share", shareEventHandler
