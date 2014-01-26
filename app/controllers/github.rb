SlackNotifier::App.controllers :github do
  # 1730177
  # curl -X POST --data 'payload={"channel": "#shomney", "username": "webhookbot", "text": "This is posted to #shomney and comes from a bot named webhookbot.", "icon_emoji": ":ghost:"}' https://remotty.slack.com/services/hooks/incoming-webhook?token=RXRetxNl5uCgtCDjQourhoic

  post :hook do
    hook_data = JSON.parse params[:payload]
    puts JSON.pretty_generate(params)

    puts "Request"
    pp request.referer
    pp request.user_agent
    pp request.host
    pp request.ip

    title = hook_data["pages"][0]["title"]
    action = hook_data["pages"][0]["action"]
    url = hook_data["pages"][0]["html_url"]
    login = hook_data["sender"]["login"]

    Slack::Post.configure(
                          subdomain: 'remotty',
                          token: 'RXRetxNl5uCgtCDjQourhoic',
                          username: 'Github'
                          )
    Slack::Post.config

    case action
    when "edited"
      action = "이(가) 위키 페이지를 수정했습니다. : "
    when "created"
      action = "이(가) 위키 페이지를 생성했습니다. : "
    end
    
    Slack::Post.post "#{login}#{action} <#{url}|#{title}>", "#shomney"
  end
end
