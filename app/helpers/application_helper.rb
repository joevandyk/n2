# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include ActsAsTaggableOn::TagsHelper

  def timeago(date, options = {})
    options[:class] ||= "timeago"
    content_tag(:abbr, date.to_s, options.merge(:title => date.getutc.iso8601)) if date
  end

  def pipe_spacer
    '<span class="pipe">|</span>'.html_safe
  end

  def tab_selected?(current_tab, tab_name)
    current_tab == tab_name ? "selected" : ''
  end

  def sub_tab_selected?(current_sub_tab, sub_tab_name)
    current_sub_tab == sub_tab_name ? "selected" : ''
  end

  def default_bio(user)
    "Hi my name is #{local_linked_profile_name user} and I forgot to add my bio. Next time you see me remind me to update my bio information."
  end

  def build_feed_link(action)
    action_type = action.class.name
    if action_type == 'Content'
      base_url(story_path(action, :canvas => false, :format => 'html'))
    elsif action_type == 'Comment'
      base_url(polymorphic_path(action.commentable, :canvas => false, :format => 'html'))
    elsif action_type == 'Vote'
      base_url(story_path(action.voteable, :canvas => false, :format => 'html'))
    else
      ''
    end
  end

  def build_feed_title(action, user)
    action_type = action.class.name
    if action_type == 'Content'
      "#{user.public_name} posted #{action.title}"
    elsif action_type == 'Comment'
      "#{user.public_name} just commented on #{action.commentable.item_title}"
    elsif action_type == 'Vote'
      "#{user.public_name} liked #{action.voteable.item_title}"
    else
      ''
    end
  end

  def build_feed_blurb(action, user)
    action_type = action.class.name
    if action_type == 'Content'
      "#{user.public_name} posted #{linked_story_caption(action, 150, build_feed_link(action))}"
    elsif action_type == 'Comment'
      "#{user.public_name} just commented on #{action.commentable.item_title}: #{action.comments}"
    elsif action_type == 'Vote'
      "#{user.public_name} liked #{action.voteable.item_title}"
    else
      ''
    end
  end

  def build_feed_item(action, action_type)
    if action_type == 'Content'
      if action.is_article?
        render :partial => 'shared/feed_items/article', :locals => { :article => action }
      else
        render :partial => 'shared/feed_items/story', :locals => { :story => action }
      end
    elsif action_type == 'Comment'
      render :partial => 'shared/feed_items/comment', :locals => { :comment => action }
    elsif action_type == 'Vote'
      render :partial => 'shared/feed_items/vote', :locals => { :vote => action }
    end
  end

  def linked_story_caption(story, length = 150, url = false, options = {})
    caption = caption(story.caption.sanitize_standard, length)
    "#{caption} #{link_to 'More', (url ? url : story_path(story, options))}".html_safe
  end

  #remove this method when self.title methods created
  def linked_item_details(item, length = 150, url = false)
    return "" if item.details.nil? || item.details.empty?
    caption = caption(item.details.sanitize_standard, length)
    "#{caption} #{link_to 'More', (url ? url : item)}".html_safe
  end

  def linked_newswire_caption(newswire, length = 150)
    caption = caption(strip_tags(newswire.caption), length)
    #"#{caption} #{link_to 'More', newswire.url, :target => "_cts"}".html_safe
    caption
  end

  def linked_comment_caption(comment, length = 150)
    caption = caption(comment.comments, length)
    "#{caption} #{link_to 'More', comment.commentable, :anchor => 'commentsListTop'}".html_safe
  end

  # Adopted from http://daniel.collectiveidea.com/blog/2007/7/10/a-prettier-truncate-helper
  def caption(text, length = 150, truncate_string = "...")
    return "" if text.nil?
    l = length - truncate_string.length
    text.length > length ? text[/^.{0,#{l}}\w*\;?/m][/.*[\w\;]/m] + truncate_string : text
  end

  def pfeed_caption(text, length = 150)
    caption(strip_tags(text), length)
  end

  def voteable_type_name(vote)
    type = vote.voteable.class.name
    if type == 'Content'
      vote.voteable.is_article? ? 'article' : 'story'
    elsif type == 'Comment'
      'comment'
    elsif type == 'Idea'
      'idea'
    else
      type
    end
  end

  def voteable_type_link(vote)
    type = vote.voteable.class.name
    if type == 'Content'
      link_to vote.voteable.title, story_path(vote.voteable)
    elsif type == 'Comment'
      link_to vote.voteable.title, story_path(vote.voteable, :anchor => "commentListTop")
    elsif type == 'Idea'
      link_to 'Idea', '#'
    else
      ''
    end
  end

  def local_linked_profile_pic(user, options={})
    link_options = {}
    # TODO:: separate this into a method
    destination = user
    target = nil
    if options[:destination].present?
      destination = options.delete(:destination)
    end
    if options[:format].present?
      link_options[:format] = options[:format]
      options.delete(:format)
    end
    if options[:target].present?
      target = options.delete(:target)
    end
    unless options[:only_path].nil?
      link_options[:only_path] = options[:only_path]
      options.delete(:only_path)
    end
    unless options[:canvas].nil?
      link_options[:canvas] = options[:canvas]
      options.delete(:canvas)
    end
    destination = user_path(user, link_options) if destination.class.name == 'User'
    if user.facebook_user?
      options.merge!(:linked => false)
      options[:size] = 'square' unless options[:size].present?
      if target
        temp = link_to fb_profile_pic(user, options), destination, :target => target
      else
        temp = link_to fb_profile_pic(user, options), destination
      end
    elsif user.twitter_user? and not user.system_user?
      temp = link_to image_tag(user.profile_image || default_image), user, link_options
    elsif user.twitter_user?
      temp = link_to image_tag(twitter_image(user)), twitter_url(user), link_options
    else
      temp = link_to image_tag(default_image), user, link_options
      #link_to gravatar_image(user), user, link_options
    end
    badge = profile_pic_badge user
    unless badge.nil?
      temp += badge
    end
    return temp
  end

  def fb_profile_pic user, options = {}
    image_tag("http://graph.facebook.com/#{user.fb_user_id}/picture")
  end

  def twitter_url user
    if not user.twitter_user?
      user
    elsif user.tweet_account.present?
      base_twitter_url(user.tweet_account.screen_name)
    elsif user.authentications.for_twitter.any?
      base_twitter_url(user.authentications.for_twitter.first["nickname"])
    else
      user
    end
  end

  def base_twitter_url url
    "http://twitter.com/#{url}"
  end

  def twitter_image user
    return default_image unless user.twitter_user?
    return user.profile.profile_image if user.profile and user.profile.profile_image.present?
    user.tweet_account.profile_image_url.present? ? user.tweet_account.profile_image_url : default_image
  end

  def gravatar_image user
    gid = Digest::MD5.hexdigest(user.email.downcase)
    gurl = "http://www.gravatar.com/avatar/"
    image_tag "#{gurl}#{gid}"
  end

  def profile_pic_badge user
    if user.is_moderator?
      image_tag 'skin/icon-mod-badge.png', :class => "moderator"
    elsif user.twitter_user? and user.system_user?
      image_tag 'https://si0.twimg.com/images/dev/cms/intents/bird/bird_blue/bird_16_blue.png', :class => "moderator"
    elsif user.is_host?
      image_tag 'default/icon-host-badge.png', :class => "moderator"
    end
  end

  def local_linked_profile_name(user, options={})
    link_options = {}
    if options[:format].present?
      link_options[:format] = options[:format]
      options.delete(:format)
    end
    unless options[:only_path].nil?
      link_options[:only_path] = options[:only_path]
      options.delete(:only_path)
    end
    unless options[:canvas].nil?
      link_options[:canvas] = options[:canvas]
      options.delete(:canvas)
    end
    if options[:target].present?
      target = options.delete(:target)
    end
    if user.facebook_user?
      options.merge!(:linked => false)
      unless options[:useyou] == true
        options.merge!(:capitalize => false)
      end
      firstnameonly = get_setting('firstnameonly').try(:value) || false
      options.merge!(:firstnameonly => firstnameonly) if firstnameonly
      if target
        #link_to fb_name(user, options), user_path(user, link_options), :target => target
        link_to user.public_name, user_path(user, link_options), :target => target
      else
        #link_to fb_name(user, options), user_path(user, link_options)
        link_to user.public_name, user_path(user, link_options)
      end
    elsif user.twitter_user? and user.system_user?
      link_to user.twitter_name, twitter_url(user)
    else
      link_to user.public_name, user_path(user, link_options)
    end
  end

  def facebook_profile_url user
    "http://www.facebook.com/profile.php?id=#{user.fb_user_id}"
  end

  def external_linked_profile_name user, opts = {}
    if user.facebook_user?
      link_to user.public_name, facebook_profile_url(user)
    elsif user.twitter_user?
      link_to user.twitter_name, twitter_url(user)
    else
      link_to user.public_name, user
    end
  end

  def external_profile_link user, opts = {}
    if user.twitter_user?
      twitter_url(user)
    elsif user.facebook_user?
      facebook_profile_url(user)
    else
      user
    end
  end

  def nl2br(string)
    string.gsub(/<.?br.*?>/i,"<br />").gsub("\n\r","<br />").gsub("\r", "").gsub("\n", "<br />")
  end

  def profile_fb_name(user,linked = false,use_you = true, possessive = false)
    firstnameonly = get_setting('firstnameonly').try(:value) || false
    external_linked_profile_name(user)
  end

  def path_to_self(item, use_canvas = false)
    canvas = (use_canvas and iframe_facebook_request?) ? true : false
    url_for(send("#{item.class.to_s.underscore}_url", item, :canvas => canvas, :only_path => false))
  end

  def path_to_klass(klass, use_canvas = false)
    url_for(send("#{klass.name.tableize}_url"))
  end

  def path_to_self_no_canvas(item)
    path_to_self(item, false)
  end

  def link_to_path_to_self(item)
    link_to url_for(send("#{item.class.to_s.underscore}_url", item)), url_for(send("#{item.class.to_s.underscore}_url", item))
  end

  def path_to_self_with_anchor(item,anchor)
    canvas = iframe_facebook_request? ? true : false
    url_for(send("#{item.class.to_s.underscore}_url", item, :canvas => canvas, :only_path => false, :anchor => anchor))
  end

  def twitter_share_item_link(item,caption,button=false)
    is_bitly_configured = get_setting('oauth_key').present?
    caption =  Rack::Utils.escape(strip_tags(caption))
    url = nil
    if is_bitly_configured
      begin
        bitly_username = get_setting('bitly_username').try(:value)
        bitly_api_key = get_setting('bitly_api_key').try(:value)
        if bitly_username.present? and bitly_username != 'username'
          bitly = Bitly.new(bitly_username, bitly_api_key)
          url = bitly.shorten(path_to_self(item)).short_url
        end
      rescue Exception
        url = nil
      end
    end
    unless url
      url =  Rack::Utils.escape(path_to_self(item))
    end
    # text = "#{caption}+#{url}"
    local_twitter_url = "http://twitter.com/share?url=#{url}&text=#{caption}"

    if button == true
      link_text = image_tag('/images/default/tweet_button.gif')
    else
      link_text = t('tweet')
    end

    if is_bitly_configured
      link_to link_text, "#", :rel=>"#overlay", :link => overlay_tweet_url(:text=>caption, :link=>url), :burl=>local_twitter_url, :id=>"twitter-link", :target => "_tweet", :class => "tweet-share"
    else
      link_to link_text, local_twitter_url, :target => "_tweet", :class => "tweet-share"
    end

  end

  def base_url(path = '')
    path = "/#{path}" if path.present? and not path =~ %r{^/} and not base_site_url =~ %r{/$}
    if base_site_url.present?
      "#{base_site_url}#{path}"
    end
  end

  def fb_list_of_names(fb_user_ids)
    return false if fb_user_ids.empty?
    firstnameonly = get_setting('firstnameonly').try(:value) || false
    return fb_name(fb_user_ids.first,:firstnameonly => firstnameonly) if fb_user_ids.size == 1
    last = fb_user_ids.pop
    "#{fb_user_ids.collect { |c| fb_name c }.join ', '} and #{fb_name last}"
  end

  def flash_messages
    messages = []
    [:success, :notice, :error, :warning].each do |type|
      messages << content_tag(:div, content_tag(:p, flash[type]), :class => "flash flash_#{type}") if flash[type].present?
      flash[type] = nil
    end

    (messages.size > 0) ? messages.join.html_safe : ''
  end

  def ar_xid(record)
    "#{record.class.model_name.tableize}-#{record.id}"
  end

  def tag_list(tags, item)
    tag_list = []
    tag_cloud(tags, %w(css1 css2 css3 css4)) do |tag, css_class|
      tag_list << link_to(tag.name, tag_link(tag, item), :class => css_class)
    end

    tag_list.size > 0 ? tag_list.join(', ').html_safe : ''
  end

  def tag_link(tag, item)
    tag_name = CGI.escape(tag.name)
    if item.class.name == 'Content'
      tagged_stories_path(:tag => tag_name)
    elsif item.class.name == 'Article'
      tagged_articles_path(:tag => tag_name)
    elsif item.class.name == 'Topic'
      tagged_forum_path(item.forum, :tag => tag_name)
    elsif item.class.name == 'Event'
      tagged_events_path(item, :tag => tag_name)
    elsif item.class.name == 'Gallery'
      tagged_galleries_path(:tag => tag_name)
    elsif item.class.name == 'Resource'
      resource_tag_path(:tag => tag_name)
    elsif item.class.name == 'PredictionQuestion'
      tagged_prediction_questions_path(:tag => tag_name)
    elsif item.class.name == 'PredictionGroup'
      tagged_prediction_groups_path(:tag => tag_name)
    else
      [item.class, tag]
    end
  end

  def display_facebook_messages
    flash[:notice] = flash[:success] if flash[:notice].nil? and flash[:success].present?

    facebook_messages
  end

  def embed_video video, *args
    options = args.extract_options!
    options.merge!(:size => 'normal') unless options[:size].present?
    embed_html_video(video, options).html_safe
  end

  def embed_html_video video, options = {}
    options[:width] ||= video.get_width options[:size]
    options[:height] ||= video.get_height options[:size]
    case video.remote_video_type
      when 'brightcove_a'
        render :partial => 'shared/media/video_brightcove_alt_a', :locals => { :video => video, :options => options }
      else
        <<EMBED
<object width="#{options[:width]}" height="#{options[:height]}">
  <param name="movie" value="#{video.video_src}"></param>
  <param name="allowFullScreen" value="true"></param>
  <param name="allowscriptaccess" value="always"></param>
  <embed src="#{video.video_src}" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="#{options[:width]}" height="#{options[:height]}"></embed>
</object>
EMBED
    end
  end

  def embed_audio audio, options = {}
    #request_comes_from_facebook? ? embed_fb_audio(audio, options) : embed_html_audio(audio, options)
    if audio.url?
      embed_html_audio(audio, options).html_safe
    elsif audio.embed_code? and get_setting_value('enable_audio_embed')
      raw audio.embed_code
    end
  end

  def embed_fb_audio audio, options = {}
    fb_mp3 audio.url, :title => audio.title, :artist => audio.artist, :album => audio.album
  end

  def embed_html_audio audio, options = {}
    <<EMBED
<div class="player"><p id="audioplayer_1">#{audio.artist}</p></div>
<h3>#{audio.default_title}</h3>
<script type="text/javascript">
$(function() {
  AudioPlayer.embed("audioplayer_1", {
        soundFile: "#{audio.url}",
        titles: "#{audio.title}",
        artists: "#{audio.artist}"
  });
});
</script>
EMBED
  end

  def render_media_items item, size = 'default'
    return false unless item.media_item?
    output = []
    ['audio', 'video', 'image'].each do |media|
      next unless item.send("#{media}_item?")
      output << render(:partial => "shared/media/#{media.pluralize}", :locals => { media.pluralize.to_sym => item.send(media.pluralize.to_sym), :size => size })
    end
    output.join().html_safe
  end

  def sanitize_user_content content
    sanitize content, :tags => %w(a i b u p)
  end

  def sanitize_user_bio content
    sanitize content, :tags => %w(a i b u p fb:name), :attributes => %w(capitalize uid href linked)
  end

  def toggle_blocked_link item
    return '' unless item.moderatable? and item.blockable?
    link_to(item.blocked? ? 'UnBlock' : 'Block', toggle_blocked_path(item.class.name.foreign_key.to_sym => item))
  end

  def toggle_featured_link item
    return '' unless item.moderatable? and item.featurable?
    link_to(item.featured? ? 'UnFeature' : 'Feature', toggle_featured_path(item.class.name.foreign_key.to_sym => item))
  end

  def like_link item, options = {}
    css_class = item.is_a?(Comment) ? 'thumb-up' : 'voteUp'
    link_text = item.is_a?(Comment) ? ' ' : 'Like'
    options.merge!(:class => css_class)
    format = options.delete(:format)
    return '' unless item.respond_to? "votes_for"
    if format
      link_to(link_text, like_item_path(item.class.name.foreign_key.to_sym => item, :format => format), options)
    else
      link_to(link_text, like_item_path(item.class.name.foreign_key.to_sym => item), options)
    end
  end

  def dislike_link item, options = {}
    css_class = item.is_a?(Comment) ? 'thumb-down' : 'voteUp'
    link_text = item.is_a?(Comment) ? '' : 'Dislike'
    options.merge!(:class => css_class)
    format = options.delete(:format)
    return '' unless item.respond_to? "votes_for"
    if format
      link_to(link_text, dislike_item_path(item.class.name.foreign_key.to_sym => item, :format => format), options)
    else
      link_to(link_text, dislike_item_path(item.class.name.foreign_key.to_sym => item), options)
    end
  end

  def votes_link item, count = 0
    count_str = "#{count > 0 ? '+' : ''}#{count}"
    output = "<span class='likes-tally'>#{count_str}</span>&nbsp;#{like_link item}"
    output += "&nbsp;#{dislike_link item}" if item.downvoteable?
    raw output
  end

  def answer_translate count = 0
    count > 0 ?
      t('answers_count', :answer_string => pluralize(count, "answer")) :
      t('answer_question')
  end

  def answer_comments_translate count = 0
    count > 0 ?
      t('answer_comments', :answer_comments_string => pluralize(count, "comment")) :
      t('answer_comment')
  end

  def meta_description item
    caption h(item.item_description)
  end

  def meta_image image
    base_url image.url(:thumb)
  end

  def breadcrumbs item, initial_set = []
    [initial_set].push(item.crumb_items.flatten.inject([]) {|set,crumb| set << (set.empty? ? crumb.crumb_text : link_to(crumb.crumb_text, crumb.crumb_link)) }.reverse).flatten
  end


  def add_image(form_builder)
    link_to_function "Add Another Image", :id => "add_image" do |page|
        form_builder.fields_for :images, Image.new, :child_index => 'NEW_RECORD' do |image_form|
          html = render(:partial => 'shared/forms/image', :locals => {:f => image_form })
          page << "$('#{escape_javascript(html)}'.replace(/NEW_RECORD/g, new Date().getTime())).insertBefore('#add_image');"
        end
      end
  end

  def delete_image(form_builder)
    if form_builder.object.new_record?
      link_to_function("Remove", "$(this).parents('.image-fieldset').remove()", :class=>"delete_image")
    else
      form_builder.hidden_field(:_delete) +
      link_to_function("Remove", "$(this).parents('.image-fieldset').hide(); $(this).prev().value = '1'", :class=>"delete_image")
    end
  end

  def add_image_simple(form_builder, title = '+')
    link_to_function title, :id => "add_image" do |page|
        form_builder.fields_for :images, Image.new, :child_index => 'NEW_RECORD' do |image_form|
          html = render(:partial => 'shared/forms/image_simple', :locals => {:f => image_form })
          page << "$('#{escape_javascript(html)}'.replace(/NEW_RECORD/g, new Date().getTime())).insertBefore($('#add_image').parent());"
        end
      end
  end

  def add_gallery_item_simple(form_builder, full_form = false)
    @enable_file_uploads = Metadata::Setting.get_setting("enable_gallery_file_uploads").try(:value)
    link_to_function I18n.translate('galleries.add_additional_items'), :id => "add_gallery_item" do |page|
        form_builder.fields_for :gallery_items, GalleryItem.new, :child_index => 'NEW_RECORD' do |gallery_item_form|
          html = render(:partial => 'shared/forms/gallery_item_simple', :locals => {:gallery_form => gallery_item_form, :full_form => full_form, :enable_file_uploads => @enable_file_uploads })
          page << "$('#{escape_javascript(html)}'.replace(/NEW_RECORD/g, new Date().getTime())).insertBefore($('#add_gallery_item'));"
        end
      end
  end

  def delete_image_simple(form_builder)
    if form_builder.object.new_record?
      link_to_function("-", "$(this).parents('fieldset.inputs').remove()", :class=>"delete_image")
    else
      form_builder.hidden_field(:_delete) +
      link_to_function("-", "$(this).parents('fieldset.inputs').hide(); $(this).prev().value = '1'", :class=>"delete_image")
    end
  end

  def render_ad(ad_size, in_layout, ad_slot)
    platform = get_setting('platform').try(:value) || 'default'
    unless in_layout.nil? || platform == 'default'
      case ad_size
        when :leaderboard
          render_ad_partial(ad_slot) if in_layout.include? "Leader"
        when :banner
          render_ad_partial(ad_slot) if in_layout.include? "Banner"
        when :skyscraper
          render_ad_partial(ad_slot) if ( in_layout.include? "Leader_B" or in_layout.include? "Banner_B" or in_layout.include? "Sky_A" )
        when :small_square
          render_ad_partial(ad_slot) if ( in_layout.include? "Leader_C" or in_layout.include? "Banner_C" or in_layout.include? "Square_A" )
      end
    end
  end

  def render_ad_partial(ad_slot)
    render :partial => 'shared/ads_banner' ,:locals => { :slot_data => ad_slot }
  end

end
