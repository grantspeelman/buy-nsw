class Rack::Attack
  throttle('req/ip', limit: 300, period: 5.minutes) do |req|
    req.ip unless req.path.start_with?('/assets')
  end

  throttle('logins/ip', limit: 5, period: 20.seconds) do |req|
    if req.path == '/sign-in' && req.post?
      req.ip
    end
  end

  throttle('logins/ip', limit: 60, period: 1.hour) do |req|
    if req.path == '/sign-in' && req.post?
      req.ip
    end
  end

  throttle('logins/email', limit: 5, period: 1.minute) do |req|
    if req.path == '/sign-in' && req.post?
      req.params['user']['email']
    end
  end

  throttle('logins/email', limit: 30, period: 1.hour) do |req|
    if req.path == '/sign-in' && req.post?
      req.params['user']['email']
    end
  end

  throttle('passwords/ip', limit: 5, period: 20.seconds) do |req|
    if req.path == '/password' && req.post?
      req.ip
    end
  end

  throttle('passwords/email', limit: 5, period: 1.minute) do |req|
    if req.path == '/password' && req.post?
      req.params['user']['email']
    end
  end

  throttle('confirmations/ip', limit: 5, period: 20.seconds) do |req|
    if req.path == '/confirmations' && req.post?
      req.ip
    end
  end

  throttle('confirmations/email', limit: 5, period: 1.minute) do |req|
    if req.path == '/confirmation' && req.post?
      req.params['user']['email']
    end
  end
end

Rack::Attack.throttled_response = lambda do |env|
  error_html = File.read(Rails.root.join('public', '429.html'))
  [ 429, {}, [error_html]]
end
