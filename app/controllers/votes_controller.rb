class VotesController < ApplicationController
  cache_sweeper :vote_sweeper, :only => [:like, :dislike]

  def like
    @voteable = find_voteable
    respond_to do |format|
      unless current_user
        format.html { flash[:error] = "You must login to vote"; redirect_to @voteable }
        format.json { render :json => { :msg => "You must login" }.to_json }
      end
      error = (current_user and current_user.voted_for?(@voteable)) ? "You already voted" : false
      if !error and current_user and @voteable.present? and (vote = current_user.vote_for(@voteable))
        @voteable.expire
        if vote.voter.post_likes?
          image_url = (vote.voteable.respond_to?(:images) and vote.voteable.images.any?) ? view_context.base_url(vote.voteable.images.first.url(:thumb)) : nil
          app_caption = t('app.facebook.vote_caption', :title => get_setting('site_title').try(:value))
          vote.async_vote_messenger polymorphic_path(@voteable.item_link, :only_path => false, :canvas => iframe_facebook_request?, :format => 'html'), app_caption, image_url
        end
        success = "Thanks for your vote!"
        format.html { flash[:success] = success; redirect_to @voteable }
        #format.json { render :json => { :trigger_oauth => current_user.fb_oauth_desired?, :msg => "#{@voteable.votes_tally} likes", :canvas => iframe_facebook_request? }.to_json }
        format.json { render :json => { :msg => "#{@voteable.votes_tally} likes", :canvas => iframe_facebook_request? }.to_json }
      else
        error ||= "Vote failed"
        format.html { flash[:error] = error; redirect_to @voteable }
        format.json { render :json => { :msg => error }.to_json }
      end
    end
  end

  def dislike
    @voteable = find_voteable
    respond_to do |format|
      if current_user and @voteable.present? and current_user.vote_against(@voteable)
        @voteable.expire
        success = "Thanks for your vote!"
        format.html { flash[:success] = success; redirect_to @voteable }
        format.json { render :json => { :msg => "#{@voteable.votes_tally} likes" }.to_json }
      else
        error = "Vote failed"
        format.html { flash[:error] = error; redirect_to @voteable }
        format.json { render :json => { :msg => error }.to_json }
      end
    end
  end

  def shared_item
    if request.post? and params[:cache_id].present? and params[:action_type].present?
      item = find_item_by_cache_id(params[:cache_id])
      item_action = ItemAction.gen_user_posted_item!(current_user, item, params[:action_type], params[:url])
      NewscloudSweeper.expire_instance(item)
      render :json => {:success => "Item created successfully"}.to_json and return
    else
      render :json => {:error => "Invalid request."}.to_json and return
    end
  end

  private

  def find_voteable
    params.each do |name, value|
      next if name =~ /^fb/
      if name =~ /(.+)_id$/
        # switch story requests to use the content model
        klass = $1 == 'story' ? 'content' : $1
        return klass.classify.constantize.find(value)
      end
    end
    nil
  end

end
