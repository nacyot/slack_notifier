SlackNotifier::App.controllers :hook do
  post :index do
    setup_slack params
    judge_service request, params
  end
  
  define_method :judge_service do |request, params|
    case
    when request.user_agent =~ /^GitHub Hookshot/, request.host == "118.33.21.173"
      judge_github_hook(params)
    end
  end
  
  define_method :judge_github_hook do |params|
    case 
    when params[:payload]["pages"]
      github_wiki_hook(params)
    else
      return "commit"
    end
  end

  define_method :setup_slack do |params|
    Slack::Post.configure(
                          subdomain: params[:subdomain],
                          token: params[:token]
                          )
  end
  
  define_method :github_wiki_hook do |params|
    Slack::Post.configure username: 'Github'
    hook_data = JSON.parse params[:payload]
    
    title = hook_data["pages"][0]["title"]
    action = hook_data["pages"][0]["action"]
    url = hook_data["pages"][0]["html_url"]
    login = hook_data["sender"]["login"]

    case action
    when "edited"
      action = "님이 위키 페이지를 수정했습니다. : "
    when "created"
      action = "님이 위키 페이지를 생성했습니다. : "
    end
    
    Slack::Post.post "#{login}#{action} <#{url}|#{title}>", "#" + params[:room]
  end
end
